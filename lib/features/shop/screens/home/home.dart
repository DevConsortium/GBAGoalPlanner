import 'dart:convert';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tea/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:tea/features/shop/controllers/Events/EventsController.dart';
import 'package:tea/features/shop/screens/actionplan/addactionplan.dart';
import 'package:tea/features/shop/screens/goalform/maingoal.dart';
import 'package:tea/features/shop/screens/home/services/notification_services.dart';
import 'package:tea/features/shop/screens/home/widgets/HealthBox.dart';
import 'package:tea/features/shop/screens/home/widgets/PercentageProgress.dart';
import 'package:tea/features/shop/screens/home/widgets/ProgressSlider.dart';
import 'package:tea/features/shop/screens/home/widgets/THomeAppBar.dart';
import 'package:tea/features/shop/screens/home/widgets/TPromoSlider.dart';
import 'package:tea/features/shop/screens/home/widgets/TSearchContainer.dart';
import 'package:tea/features/shop/screens/home/widgets/TSectionHeading.dart';
import 'package:tea/features/shop/screens/home/widgets/Tag.dart';
import 'package:tea/features/shop/screens/week/weeknavigation.dart';
import 'package:http/http.dart' as http;
import 'package:tea/main.dart';
import 'package:tea/utils/constants/colors.dart';
import 'package:tea/utils/constants/sizes.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<Map<String, dynamic>>> _goals = {};
  Map<String, dynamic> _actionPlan = {};
  String _selectedGoalType = 'All';
  bool _loading = false;
  bool _loadingActionPlan = true;
  int currentWeek = 0;
  String todayDayName = '';
  String? todayEvent;
  String _searchQuery = '';
  bool _showGoals = false;
  final userId = GetStorage().read('userId');
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    currentWeek = getCurrentWeekNumber();
    todayDayName = getTodayDayName();
    loadTodayEvent();
    _fetchGoals();
    // _fetchActionPlan();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchActionPlan();
    });
  }

  Future<bool> _updateActionPlanProgress(
    Map<String, dynamic> step,
    int newProgress,
    int currentWeek,
  ) async {
    try {
      final stepKey = step['title']
          ?.split(':')
          .first
          ?.trim()
          ?.toLowerCase()
          ?.replaceAll(' ', '');

      final url = Uri.parse(
        'https://todo.jpsofttechnologies.tech/api/updateProgress',
      );

      final body = jsonEncode({
        'userId': GetStorage().read('userId'),
        'weekNumber': currentWeek,
        'staName': stepKey,
        'progress': newProgress,
      });

      print('📤 Sending PUT → $url');
      print('📦 Body → $body');

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('📥 Response Code: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print("✅ Action plan progress updated: $stepKey -> $newProgress%");
        await _fetchActionPlan();
        return true;
      } else {
        print("❌ Failed to update: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("⚠️ Error updating action plan: $e");
      return false;
    }
  }

  // void schedulePlanNotification(DateTime reminderTime, String message) async {
  //   if (reminderTime.isAfter(DateTime.now())) {
  //     await scheduleAlarm(
  //       reminderTime.millisecondsSinceEpoch ~/ 1000, // unique ID
  //       reminderTime,
  //       message,
  //     );
  //     debugPrint("🔔 Scheduled reminder for $reminderTime");
  //   } else {
  //     debugPrint("⚠️ Reminder time is in the past, not scheduling.");
  //   }
  // }

  // Fetching Action Plan
  Future<void> _fetchActionPlan() async {
    setState(() => _loadingActionPlan = true);

    try {
      final url = Uri.parse(
        'https://todo.jpsofttechnologies.tech/api/getActionPlan?userId=$userId&weekNumber=$currentWeek',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['message'] == 'Action Plan retrieved successfully') {
          setState(() {
            _actionPlan = data['actionPlan'];
          });
        } else {
          print("❌ Action plan not found.");
          setState(() {
            _actionPlan = {};
          });
        }
      } else {
        print("⚠️ Failed to fetch action plan: ${response.statusCode}");
        setState(() {
          _actionPlan = {};
        });
      }
    } catch (e) {
      print("⚠️ Error fetching action plan: $e");
      setState(() {
        _actionPlan = {};
      });
    }

    setState(() => _loadingActionPlan = false);
  }

  List<Map<String, dynamic>> _getFilteredGoal() {
    List<Map<String, dynamic>> allGoals;

    // Filter by goal type
    if (_selectedGoalType == 'All') {
      allGoals = _goals.values.expand((x) => x).toList();
    } else {
      allGoals = _goals[_selectedGoalType] ?? [];
    }

    // Further filter by search query
    if (_searchQuery.isNotEmpty) {
      return allGoals.where((goal) {
        final goalTitle = (goal['goal'] ?? '').toLowerCase();
        final goalCategory = (goal['category'] ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();

        return goalTitle.contains(query) || goalCategory.contains(query);
      }).toList();
    }

    return allGoals;
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Action'),
          content: const Text(
            'Are you sure you want to mark this goal as completed?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  Future<void> _markAsCompleted(int id, BuildContext context) async {
    // Show the confirmation dialog
    bool confirmed = await _showConfirmationDialog(context);

    // If the user confirms the action, proceed
    if (confirmed) {
      final url = Uri.parse(
        'https://todo.jpsofttechnologies.tech/api/goals/$id/complete',
      );
      final response = await http.put(url);

      if (response.statusCode == 200) {
        // After successful completion, reload the list of goals
        await _fetchGoals(); // Reload the list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Goal marked as completed')),
        );
      } else {
        // Show an error if the API call fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to mark goal as complete')),
        );
      }
    }
  }

  int getCurrentWeekNumber() {
    final now = DateTime.now();
    final beginningOfYear = DateTime(now.year, 1, 1);
    final daysPassed = now.difference(beginningOfYear).inDays;
    return ((daysPassed + beginningOfYear.weekday) / 7).ceil();
  }

  String getTodayDayName() {
    final now = DateTime.now();
    const dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return dayNames[now.weekday - 1];
  }

  Future<void> loadTodayEvent() async {
    final today = getTodayDayName().toLowerCase();
    final weekNumber = getCurrentWeekNumber();
    final eventValue = await EventController.instance.fetchEventValue(
      userId: userId,
      weekNumber: weekNumber,
      day: today,
    );
    setState(() {
      todayEvent = eventValue;
    });
  }

  Future<void> _fetchGoals() async {
    setState(() => _loading = true);

    final url = Uri.parse(
      'https://todo.jpsofttechnologies.tech/api/getGoals/$userId',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(
        jsonDecode(response.body),
      );
      Map<String, List<Map<String, dynamic>>> groupedGoals = {};

      data.forEach((key, value) {
        final goal = Map<String, dynamic>.from(value);
        final groupType = key.substring(0, 3);
        if (!groupedGoals.containsKey(groupType)) {
          groupedGoals[groupType] = [];
        }
        groupedGoals[groupType]!.add({'type': groupType, ...goal});
      });

      setState(() {
        _goals = groupedGoals;
      });
    }
    setState(() => _loading = false);
  }

  @pragma('vm:entry-point')
  void alarmCallback() async {
    final FlutterLocalNotificationsPlugin plugin =
        FlutterLocalNotificationsPlugin();

    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    await plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    await plugin.show(
      0,
      'Reminder',
      'This was triggered by AlarmManager',
      platformDetails,
    );

    debugPrint('✅ Alarm callback executed!');
  }

  int getGoalTypeValue(String goalType) {
    switch (goalType.toUpperCase()) {
      case 'STG':
        return 2;
      case 'MTG':
        return 4;
      case 'LTG':
        return 8;
      case 'LEG':
        return 12;
      default:
        return 0;
    }
  }

  void _showGoalDetails(Map<String, dynamic> goal) async {
    final updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [TColors.primary, Colors.black87],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: controller,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Goal title
                    Text(
                      goal['goal'] ?? 'No Title',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.1,
                      ),
                    ),

                    const SizedBox(height: 8),
                    Divider(color: Colors.white30, thickness: 1),
                    const SizedBox(height: 8),

                    // Category ribbon
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.deepPurpleAccent),
                      ),
                      child: Text(
                        '🏷 Category: ${goal['category'] ?? 'Uncategorized'}',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Points
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amberAccent,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Points: ${getGoalTypeValue(goal['type'] ?? '')}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Progress Section
                    if (goal['completed'] == true)
                      Column(
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: Colors.greenAccent,
                            size: 60,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Goal Completed!',
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          // Text(
                          //   'Progress',
                          //   style: TextStyle(
                          //     color: Colors.white70,
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: DefaultTextStyle(
                              style: const TextStyle(color: Colors.white),
                              child: ProgressSlider(
                                initialProgress:
                                    (goal['percentage']?.toDouble() ?? 10) /
                                    100,
                                goalId: goal['id'],
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (updated == true) {
      _fetchGoals();
    }
  }

  // void _showStepDetails(BuildContext context, Map<String, dynamic> step) {
  //   double currentProgress = (step['progress'] ?? 0).toDouble();
  //   int getCurrentWeekNumber() {
  //     final now = DateTime.now();
  //     final beginningOfYear = DateTime(now.year, 1, 1);
  //     final daysPassed = now.difference(beginningOfYear).inDays;
  //     return ((daysPassed + beginningOfYear.weekday) / 7).ceil();
  //   }
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (_) {
  //       return StatefulBuilder(
  //         builder: (context, setModalState) {
  //           return DraggableScrollableSheet(
  //             expand: false,
  //             initialChildSize: 0.6,
  //             minChildSize: 0.3,
  //             maxChildSize: 0.9,
  //             builder: (_, controller) {
  //               return Container(
  //                 width: double.infinity,
  //                 padding: const EdgeInsets.all(16),
  //                 child: SingleChildScrollView(
  //                   controller: controller,
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         step['title'] ?? '',
  //                         style: const TextStyle(
  //                           fontSize: 20,
  //
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10),
  //                       Text('Progress: ${currentProgress.toInt()}%'),
  //                       const SizedBox(height: 20),
  //
  //                       Slider(
  //                         min: 0,
  //                         max: 100,
  //                         divisions: 100,
  //                         value: currentProgress,
  //                         label: "${currentProgress.toInt()}%",
  //                         activeColor: Colors.blueAccent,
  //                         onChanged: (value) {
  //                           setModalState(() {
  //                             currentProgress = value;
  //                           });
  //                         },
  //                       ),
  //
  //                       const SizedBox(height: 10),
  //
  //                       ElevatedButton.icon(
  //                         icon: const Icon(Icons.save),
  //                         label: const Text('Update Progress'),
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: Colors.green,
  //                           minimumSize: const Size(double.infinity, 45),
  //                         ),
  //                         onPressed: () async {
  //                           // Call your API
  //                           final updated = await _updateActionPlanProgress(
  //                             step,
  //                             currentProgress.toInt(),
  //                             getCurrentWeekNumber(),
  //                           );
  //
  //                           // bool updated=true;
  //                           if (updated) {
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                               const SnackBar(
  //                                 content: Text(
  //                                   '✅ Progress updated successfully!',
  //                                 ),
  //                                 backgroundColor: Colors.green,
  //                               ),
  //                             );
  //                             Navigator.pop(context);
  //                           } else {
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                               const SnackBar(
  //                                 content: Text('❌ Failed to update progress'),
  //                                 backgroundColor: Colors.red,
  //                               ),
  //                             );
  //                           }
  //                         },
  //                       ),
  //
  //                       const SizedBox(height: 20),
  //
  //                       // ✅ Set Reminder button
  //                       ElevatedButton.icon(
  //                         icon: const Icon(Icons.alarm),
  //                         label: const Text('Set Reminder'),
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: Colors.blue,
  //                           minimumSize: const Size(double.infinity, 45),
  //                         ),
  //                         onPressed: () async {
  //                           // Step 1: Pick date
  //                           final pickedDate = await showDatePicker(
  //                             context: context,
  //                             initialDate: DateTime.now(),
  //                             firstDate: DateTime.now(),
  //                             lastDate: DateTime(2100),
  //                           );
  //                           if (pickedDate == null) return;
  //
  //                           // Step 2: Pick time
  //                           final pickedTime = await showTimePicker(
  //                             context: context,
  //                             initialTime: TimeOfDay.now(),
  //                           );
  //                           if (pickedTime == null) return;
  //
  //                           // Step 3: Combine date + time
  //                           final scheduledDateTime = DateTime(
  //                             pickedDate.year,
  //                             pickedDate.month,
  //                             pickedDate.day,
  //                             pickedTime.hour,
  //                             pickedTime.minute,
  //                           );
  //
  //                           // Step 4: Prevent scheduling in the past
  //                           if (scheduledDateTime.isBefore(DateTime.now())) {
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                               const SnackBar(
  //                                 content: Text('❌ Cannot schedule a reminder in the past!'),
  //                                 backgroundColor: Colors.red,
  //                                 duration: Duration(seconds: 2),
  //                               ),
  //                             );
  //                             return;
  //                           }
  //
  //
  //                           print(scheduledDateTime);
  //                           // Step 4 — 🔥 SCHEDULE THE NOTIFICATION
  //                           await NotificationService.scheduleNotification(
  //                             title: step['title'] ?? "Reminder",
  //                             body: "You have an upcoming task.",
  //                             scheduledDateTime: scheduledDateTime,
  //                             payload: {"stepTitle": step['title'] ?? ""},
  //                           );
  //                           print("Close");
  //
  //
  //                           // ✅ Optional: save in SharedPreferences to show in your notification screen
  //                           final prefs = await SharedPreferences.getInstance();
  //                           final existing = prefs.getStringList('notifications') ?? [];
  //                           existing.add('${step['title']}|${scheduledDateTime.toIso8601String()}');
  //                           await prefs.setStringList('notifications', existing);
  //
  //                           // ✅ Step 6: Show confirmation
  //                           ScaffoldMessenger.of(context).showSnackBar(
  //                             const SnackBar(
  //                               content: Text('✅ Reminder added successfully!'),
  //                               backgroundColor: Colors.green,
  //                               duration: Duration(seconds: 2),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //
  //
  //                       const SizedBox(height: 10),
  //
  //
  //                       const SizedBox(height: 10),
  //                       ElevatedButton(
  //                         onPressed: () => Navigator.pop(context),
  //                         child: const Text('Close'),
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: Colors.black,
  //                           minimumSize: const Size(double.infinity, 45),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             },
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  void _showStepDetails(BuildContext context, Map<String, dynamic> step) {
    double currentProgress = (step['progress'] ?? 0).toDouble();

    int getCurrentWeekNumber() {
      final now = DateTime.now();
      final beginningOfYear = DateTime(now.year, 1, 1);
      final daysPassed = now.difference(beginningOfYear).inDays;
      return ((daysPassed + beginningOfYear.weekday) / 7).ceil();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.65,
              minChildSize: 0.4,
              maxChildSize: 0.95,
              builder: (_, controller) {
                return SafeArea(
                  top: false,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [TColors.primary, Colors.black87],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: controller,
                      padding: const EdgeInsets.all(20),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Drag Handle
                          Center(
                            child: Container(
                              width: 50,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.white38,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Step Title
                          Text(
                            step['title'] ?? '',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 10),
                          Divider(color: Colors.white30),

                          const SizedBox(height: 16),

                          // Progress Percentage Tag
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 26,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Progress: ${currentProgress.toInt()}%',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Slider
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Slider(
                              min: 0,
                              max: 100,
                              divisions: 100,
                              value: currentProgress,
                              label: "${currentProgress.toInt()}%",
                              activeColor: Colors.white,
                              inactiveColor: Colors.white30,
                              onChanged: (value) {
                                setModalState(() {
                                  currentProgress = value;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Update Progress Button
                          ElevatedButton.icon(
                            // icon: const Icon(Icons.save),
                            label: const Text('Update Progress'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent.shade400,
                              foregroundColor: Colors.black,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () async {
                              final updated = await _updateActionPlanProgress(
                                step,
                                currentProgress.toInt(),
                                getCurrentWeekNumber(),
                              );

                              if (updated) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      '✓ Progress updated successfully!',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to update progress'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),

                          const SizedBox(height: 18),

                          // Set Reminder Button
                          ElevatedButton.icon(
                            icon: const Icon(Icons.alarm, color: Colors.white),
                            label: const Text(
                              'Set Reminder',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate == null) return;

                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime == null) return;

                              final scheduledDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );

                              // if (scheduledDateTime.isBefore(DateTime.now())) {
                              //   return ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(
                              //       content: Text('Cannot schedule in the past'),
                              //       backgroundColor: Colors.red,
                              //     ),
                              //   );
                              // }

                              await NotificationService.scheduleNotification(
                                title: step['title'] ?? "Reminder",
                                body: "You have an upcoming task.",
                                scheduledDateTime: scheduledDateTime,
                              );

                              final prefs =
                                  await SharedPreferences.getInstance();
                              final existing =
                                  prefs.getStringList('notifications') ?? [];
                              existing.add(
                                '${step['title']}|${scheduledDateTime.toIso8601String()}',
                              );
                              await prefs.setStringList(
                                'notifications',
                                existing,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Reminder added successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // Close Button
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildGoalTile(Map<String, dynamic> goal) {
    return GestureDetector(
      onTap: () => _showGoalDetails(goal),
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          leading: SizedBox(
            height: 40,
            width: 40,
            child: PercentageProgress(
              percentage: (goal['percentage'] ?? 10).toDouble(),
            ),
          ),
          title: Text(
            goal['goal'] ?? '',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Category: ${goal['category'] ?? ''}",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          trailing: goal['completed'] == true
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 30),
                    SizedBox(height: 8),
                    Text('🏆 Earned'),
                  ],
                )
              : GestureDetector(
                  onTap: () => _markAsCompleted(goal['id'], context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildWeekView() {
    DateTime currentDate = DateTime.now();
    DateTime startOfYear = DateTime(currentDate.year, 1, 1);
    int currentWeekNumber = getCurrentWeekNumber();
    final weeksInYear =
        (DateTime(currentDate.year, 12, 31).difference(startOfYear).inDays / 7)
            .ceil();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      double targetOffset = (currentWeekNumber - 1) * 120.0;
      _scrollController.animateTo(
        targetOffset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Row(
        children: List.generate(weeksInYear, (index) {
          DateTime weekStartDate = startOfYear.add(Duration(days: index * 7));
          bool isCurrentWeek = index + 1 == currentWeekNumber;

          return GestureDetector(
            onTap: () {
              print('Week ${index + 1} tapped');
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCurrentWeek ? Colors.green : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCurrentWeek ? Colors.green : Colors.grey,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Week ${index + 1}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCurrentWeek ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    '${DateFormat('MMM dd').format(weekStartDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isCurrentWeek ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [TColors.iconPrimary2Light, Colors.white],
            ),
          ),
          child: Column(
            children: [
              TPrimaryHeaderContainer(
                child: Column(
                  children: [
                    const THomeAppBar(),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    // Search bar
                    TSearchContainer(
                      text: 'Search Here',
                      onSearch: (String query) {
                        setState(() {
                          _searchQuery = query;
                        });
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    const TSectionHeading(
                      title: 'GBA Goal Planner',
                      showActionButton: false,
                      textColor: TColors.white,
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                  ],
                ),
              ),

              // Slidder Banner
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TPromoSlider(),
              ),

              // Today's Event
              if (!_loading && todayEvent != null)
                HealthBox(
                  color: Colors.blue.shade400,
                  icon: Icons.ac_unit,
                  title: 'Today\'s Event',
                  event: '$todayEvent',
                ),

              // Add your Goals Button
              if (!_loading && _goals.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.to(() => const Maingoal());
                      },
                      icon: const Icon(Icons.add_task_rounded),
                      label: const Text(
                        "Add your Goals",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.black,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.black45),
                        ),
                      ),
                    ),
                  ),
                ),

              // In your build method
              Column(
                children: [
                  // condition for toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              setState(() {
                                _showGoals = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _showGoals
                                  ? Colors.blue
                                  : Colors.grey[300],
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                // side: const BorderSide(color: Colors.white, width: 2),
                              ),
                              elevation: _showGoals ? 5 : 0,
                            ),
                            child: Text(
                              'Goals',
                              style: TextStyle(
                                color: _showGoals ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              setState(() {
                                _showGoals = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !_showGoals
                                  ? Colors.blue
                                  : Colors.grey[300],
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: _showGoals ? 0 : 5,
                            ),
                            child: Text(
                              'Action Plans',
                              style: TextStyle(
                                color: !_showGoals
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content based on toggle
                  if (_showGoals)
                    Column(
                      children: [
                        SizedBox(height: 10),
                        // Goals Section
                        Padding(
                          padding: const EdgeInsets.only(right: 25, left: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Your Goals',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                              ),

                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButton<String>(
                                      value: _selectedGoalType,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedGoalType = newValue ?? 'All';
                                        });
                                      },
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.blue,
                                      ),
                                      items: ['All', 'STG', 'MTG', 'LTG', 'LEG']
                                          .map<DropdownMenuItem<String>>((
                                            String value,
                                          ) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                  fontSize: 14,

                                                  color: Colors.black,

                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            );
                                          })
                                          .toList(),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            print("Icon tapped!");
                                            Get.to(
                                              () => WeekNavigationScreen(
                                                currentWeek,
                                              ),
                                            );
                                          },
                                          child: Icon(
                                            Icons.edit_calendar,
                                            color: Colors.black45,
                                            size: 35,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 10,
                          endIndent: 40,
                          indent: 40,
                          thickness: 1,
                        ),
                        SizedBox(height: 15),
                        if (_loading)
                          Center(child: CircularProgressIndicator())
                        else
                          GoalListSection(
                            loading: _loading,
                            groupedGoals: _getFilteredGoal(),
                            buildGoalTile: _buildGoalTile,
                          ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Action Plans - This week',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                          ),
                        ),
                        // ✅ Correct
                        // _buildActionPlanTile(context, _actionPlan),
                        ActionListSection(
                          loading: _loadingActionPlan,
                          actionPlan: _actionPlan,
                          onStepTap: (step) => _showStepDetails(context, step),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showTestNotification() async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'test_channel',
    'Test Notifications',
    channelDescription: 'Instant test notification',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    999,
    '🔔 Test Notification',
    'Your notification setup works perfectly!',
    platformDetails,
  );
}

Future<void> showTestNotificationAt(DateTime scheduledTime) async {
  const androidDetails = AndroidNotificationDetails(
    'test_channel',
    'Test Notifications',
    channelDescription: 'Scheduled test notification',
    importance: Importance.max,
    priority: Priority.high,
  );

  const platformDetails = NotificationDetails(android: androidDetails);

  final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

  try {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      999,
      '🔔 Test Notification',
      'Your scheduled notification works perfectly!',
      tzScheduledTime,
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    debugPrint("✅ Test notification scheduled at: $tzScheduledTime");
  } on PlatformException catch (e) {
    debugPrint("❌ Notification failed: ${e.message}");
    // Fallback: use immediate show as a backup
    await flutterLocalNotificationsPlugin.show(
      999,
      '🔔 Test Notification',
      'Could not schedule exact alarm; showing immediately.',
      platformDetails,
    );
  }
}

class GoalListSection extends StatelessWidget {
  final bool loading;
  final List<Map<String, dynamic>> groupedGoals;
  final Function(Map<String, dynamic>) buildGoalTile;

  GoalListSection({
    required this.loading,
    required this.groupedGoals,
    required this.buildGoalTile,
  });

  String getGoalCategoryHeading(String type) {
    switch (type) {
      case 'STG':
        return 'Short-term Goals';
      case 'MTG':
        return 'Medium-term Goals';
      case 'LTG':
        return 'Long-term Goals';
      case 'LEG':
        return 'Legacy Goals';
      default:
        return 'Goals';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    Map<String, List<Map<String, dynamic>>> categorizedGoals = {};

    for (var goal in groupedGoals) {
      String category = goal['type'];
      if (!categorizedGoals.containsKey(category)) {
        categorizedGoals[category] = [];
      }
      categorizedGoals[category]!.add(goal);
    }

    return Column(
      children: categorizedGoals.entries.map<Widget>((entry) {
        String category = entry.key;
        List<Map<String, dynamic>> goals = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 26.0,
              ),
              child: Center(
                child: Text(
                  getGoalCategoryHeading(category),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            ...goals.map<Widget>((goal) => buildGoalTile(goal)).toList(),
          ],
        );
      }).toList(),
    );
  }
}

class ActionListSection extends StatelessWidget {
  final Map<String, dynamic> actionPlan;
  final bool loading;
  final Function(Map<String, dynamic> step) onStepTap;

  int getCurrentWeekNumber() {
    final now = DateTime.now();
    final beginningOfYear = DateTime(now.year, 1, 1);
    final daysPassed = now.difference(beginningOfYear).inDays;
    return ((daysPassed + beginningOfYear.weekday) / 7).ceil();
  }

  const ActionListSection({
    super.key,
    required this.actionPlan,
    required this.loading,
    required this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (actionPlan.isEmpty ||
        actionPlan['message'] == "Action Plan not found" ||
        (actionPlan.values.every(
          (value) => value == null || value.toString().isEmpty,
        ))) {
      return _buildEmptyState(context);
    }

    final steps = [
      {
        'title': 'STA 1 : ${actionPlan['sta1']}',
        'progress': actionPlan['sta1Progress'],
      },
      {
        'title': 'STA 2 : ${actionPlan['sta2']}',
        'progress': actionPlan['sta2Progress'],
      },
      {
        'title': 'MTA 1 : ${actionPlan['mta1']}',
        'progress': actionPlan['mta1Progress'],
      },
      {
        'title': 'MTA 2 : ${actionPlan['mta2']}',
        'progress': actionPlan['mta2Progress'],
      },
      {
        'title': 'MTA 3 : ${actionPlan['mta3']}',
        'progress': actionPlan['mta3Progress'],
      },
      {
        'title': 'MTA 4 : ${actionPlan['mta4']}',
        'progress': actionPlan['mta4Progress'],
      },
      {
        'title': 'LTA 1 : ${actionPlan['lta1']}',
        'progress': actionPlan['lta1Progress'],
      },
      {
        'title': 'LTA 2 : ${actionPlan['lta2']}',
        'progress': actionPlan['lta2Progress'],
      },
      {
        'title': 'LEG 1 : ${actionPlan['leg1']}',
        'progress': actionPlan['leg1Progress'],
      },
      {
        'title': 'LEG 2 : ${actionPlan['leg2']}',
        'progress': actionPlan['leg2Progress'],
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
          child: Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              leading: SizedBox(
                height: 40,
                width: 40,
                child: PercentageProgress(
                  percentage: (step['progress'] ?? 0).toDouble(),
                ),
              ),
              title: Text(
                step['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text('Progress: ${step['progress']}%'),
              onTap: () => onStepTap(step),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_task, size: 60, color: Colors.grey),
            const SizedBox(height: 10),
            const Text(
              'No Action Plan Added Yet.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap below to create one.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            // ElevatedButton.icon(
            //   icon: const Icon(Icons.add, color: Colors.white),
            //   label: const Text(
            //     'Add Action Plan',
            //     style: TextStyle(color: Colors.white),
            //   ),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.blue,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //       side: BorderSide.none, // 🔥 removes border completely
            //     ),
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 24,
            //       vertical: 12,
            //     ),
            //   ),
            //   onPressed: () {
            //     int currentWeekNumber = getCurrentWeekNumber();
            //     Get.to(() => WeekNavigationScreen(currentWeekNumber));
            //   },
            // ),
            FilledButton.icon(
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Add Action Plan',
                style: TextStyle(color: Colors.white),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                int currentWeekNumber = getCurrentWeekNumber();
                Get.to(() => WeekNavigationScreen(currentWeekNumber));
              },
            )

          ],
        ),
      ),
    );
  }
}
