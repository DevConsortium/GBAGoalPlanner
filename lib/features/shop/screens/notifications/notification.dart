import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tea/common/widgets/appbar/appbar.dart';
import 'package:tea/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:tea/utils/constants/colors.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> with RouteAware {
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  /// Load notifications from SharedPreferences
  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList('notifications') ?? [];

    final parsed = saved.map((item) {
      final parts = item.split('|');
      final title = parts[0];
      final date = DateTime.tryParse(parts.length > 1 ? parts[1] : '') ?? DateTime.now();
      return {'title': title, 'date': date};
    }).toList();

// ✅ Fix: prevent null crash in sorting
    parsed.sort((a, b) =>
        (a['date'] as DateTime? ?? DateTime.now())
            .compareTo(b['date'] as DateTime? ?? DateTime.now()));


    setState(() => _notifications = parsed);
  }

  /// Clear all saved notifications
  Future<void> _clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications');

    // Also cancel all scheduled local notifications
    await flutterLocalNotificationsPlugin.cancelAll();

    setState(() => _notifications = []);
  }

  /// BONUS: Load pending scheduled notifications directly from plugin
  Future<void> _showPendingDebugDialog() async {
    final pending = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Pending Notifications"),
        content: Text(pending.map((e) => "${e.id} → ${e.title}").join("\n")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                    title: Text(
                      'Notification',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!              // 🔥 smaller than headlineMedium
                          .apply(
                        color: TColors.white,
                        fontSizeFactor: 1.3,    // 🔥 make it even smaller
                      ),
                    ),
                    showBackArrow: false,
                    centerTitle: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 🔹 Clear and Debug buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ElevatedButton.icon(
                  //
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: TColors.primary,
                  //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  //
                  //   ),
                  //   icon: const Icon(Icons.delete, color: Colors.white),
                  //   label: const Text('Clear All',
                  //       style: TextStyle(color: Colors.white)),
                  //   onPressed: _clearNotifications,
                  // ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: _clearNotifications,
                  )
                ],
              ),
            ),

            // 🔹 Notification List
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: _notifications.isEmpty
            //       ? const Center(
            //     child: Text(
            //       'No New Notifications',
            //       style: TextStyle(
            //           fontSize: 16, fontWeight: FontWeight.w500),
            //     ),
            //   )
            //       : ListView.builder(
            //     shrinkWrap: true,
            //     physics: const NeverScrollableScrollPhysics(),
            //     itemCount: _notifications.length,
            //     itemBuilder: (context, index) {
            //       final item = _notifications[index];
            //       final formattedDate =
            //           "${item['date'].day}/${item['date'].month}/${item['date'].year}  "
            //           "${item['date'].hour.toString().padLeft(2, '0')}:${item['date'].minute.toString().padLeft(2, '0')}";
            //
            //       return Card(
            //         margin: const EdgeInsets.symmetric(vertical: 6),
            //         child: ListTile(
            //           leading: const Icon(Icons.notifications,
            //               color: TColors.primary),
            //           title: Text(item['title']),
            //           subtitle: Text(
            //             'Scheduled for: $formattedDate',
            //             style: const TextStyle(fontSize: 12),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _notifications.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off,
                        size: 50, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text(
                      'No New Notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final item = _notifications[index];
                  final formattedDate =
                      "${item['date'].day}/${item['date'].month}/${item['date'].year}  "
                      "${item['date'].hour.toString().padLeft(2, '0')}:${item['date'].minute.toString().padLeft(2, '0')}";

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Left colored bar
                        Container(
                          width: 6,
                          height: 70,
                          decoration: BoxDecoration(
                            color: TColors.primary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(14),
                              bottomLeft: Radius.circular(14),
                            ),
                          ),
                        ),

                        Expanded(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 22,
                              backgroundColor: TColors.primary.withOpacity(0.1),
                              child: const Icon(Icons.notifications,
                                  color: TColors.primary),
                            ),
                            title: Text(
                              item['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              "Scheduled • $formattedDate",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )

          ],
        ),
      ),
    );
  }
}

