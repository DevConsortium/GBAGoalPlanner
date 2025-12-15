import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:tea/common/widgets/appbar/appbar.dart';
import 'package:tea/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:tea/features/shop/controllers/ActionPlan/ActionPlanController.dart';
import 'package:tea/features/shop/controllers/Events/EventsController.dart';
import 'package:tea/features/shop/controllers/Review/ReviewController.dart';
import 'package:tea/features/shop/screens/actionplan/addactionplan.dart';
import 'package:tea/features/shop/screens/event/addweekevent.dart';
import 'package:tea/features/shop/screens/review/addreview.dart';
import 'package:http/http.dart' as http;
import 'package:tea/utils/constants/colors.dart';

class WeekNavigationScreen extends StatefulWidget {
  final int weekNumber;

  const WeekNavigationScreen(this.weekNumber, {super.key});

  @override
  _WeekNavigationScreenState createState() => _WeekNavigationScreenState();
}

// Utility to build readable ListTile rows
Widget _buildActionRow(String label, String? value) {
  return Card(
    color: Colors.grey[50],
    margin: const EdgeInsets.symmetric(vertical: 4),
    child: ListTile(
      dense: true,
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value?.isNotEmpty == true ? value! : 'Not specified'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    ),
  );
}



class _WeekNavigationScreenState extends State<WeekNavigationScreen>
    with SingleTickerProviderStateMixin {
  late Future<Map<String, dynamic>> _actionPlanFuture;
  late Future<Map<String, dynamic>> _actionEvents;
  late Future<Map<String, dynamic>> _actionReview;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    final userId = box.read('userId');

    _actionPlanFuture = fetchActionPlan(userId, widget.weekNumber);
    _actionEvents = fetchEvents(userId, widget.weekNumber);
    _actionReview = fetchReview(userId, widget.weekNumber);

    _tabController = TabController(length: 3, vsync: this);
  }

  Widget _buildActionPlanRow(BuildContext context,
      String label,
      Map<String, dynamic> data,
      int weekNumber,
      int userId,) {
    final key = label.toLowerCase();
    final value = data[key];
    final progress = data['${key}Progress'] ?? 0;

    final step = {
      'title': label,
      'value': value,
      'progress': progress,
      'weekNumber': weekNumber,
      'userId': userId,
      'key': key,
      'id': data['id'],
    };

    return Card(
      color: Colors.grey[50],
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        dense: true,
        onTap: () => _showStepDetails(context, step, widget.weekNumber),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value?.isNotEmpty == true ? value! : 'Not specified'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon for completion status
            (step['progress'] ?? 0) == 100
                ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                : GestureDetector(
              onTap: () => _markActionCompleted(step, context, weekNumber),
              child: const Icon(
                Icons.check_circle_outline,
                color: Colors.blue,
                size: 20,
              ),
            ),
            const SizedBox(height: 4),
            // Show progress percentage below the icon
            Text(
              '${step['progress'] ?? 0}%',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );

  }


  void _showStepDetails(BuildContext context, Map<String, dynamic> step,
      int currentWeek) {
    double currentProgress = (step['progress'] ?? 0).toDouble();

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
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [TColors.primary, Colors.black87],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    controller: controller,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        Row(
                          children: [
                            const Icon(Icons.check_circle_outline, size: 26,
                                color: Colors.white),
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
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
                              setModalState(() => currentProgress = value);
                            },
                          ),
                        ),
                        const SizedBox(height: 25),
                        ElevatedButton.icon(
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
                            final userId = GetStorage().read('userId');
                            final success = await _updateActionPlanProgress(
                              step,
                              currentProgress.toInt(),
                              currentWeek,
                            );

                            if (success) {
                              setState(() {
                                _actionPlanFuture =
                                    fetchActionPlan(userId, widget.weekNumber);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      '✓ Progress updated successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pop(context);
                              setState(() {}); // Refresh UI
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('❌ Failed to update progress'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close', style: TextStyle(
                              color: Colors.white70, fontSize: 16)),
                        ),
                        const SizedBox(height: 20),
                      ],
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

  Future<bool> _updateActionPlanProgress(Map<String, dynamic> step,
      int newProgress,
      int currentWeek,) async {
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

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {});
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchActionPlan(int userId,
      int weekNumber) async {
    final url = Uri.parse(
        'https://todo.jpsofttechnologies.tech/api/getActionPlan?userId=$userId&weekNumber=$weekNumber');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'message': 'Action Plan not found'};
      }
    } catch (error) {
      throw Exception('Error fetching action plan: $error');
    }
  }

  Future<Map<String, dynamic>> fetchEvents(int userId, int weekNumber) async {
    final url = Uri.parse(
        'https://todo.jpsofttechnologies.tech/api/getEvents?userId=$userId&weekNumber=$weekNumber');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'message': 'Events not found'};
      }
    } catch (error) {
      throw Exception('Error fetching events: $error');
    }
  }

  Future<Map<String, dynamic>> fetchReview(int userId, int weekNumber) async {
    final url = Uri.parse(
        'https://todo.jpsofttechnologies.tech/api/getReview?userId=$userId&weekNumber=$weekNumber');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'message': 'Review not found'};
      }
    } catch (error) {
      throw Exception('Error fetching review: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = GetStorage().read('userId');

    return Scaffold(
      body: Column(
        children: [
          TPrimaryHeaderContainer(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),

              child: Column(
                children: [
                  TAppBar(
                    title: Text(
                      "GBA Goal Planner",
                      textAlign: TextAlign.center,
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(
                        color: TColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    showBackArrow: false,
                    centerTitle: true,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Week ${widget.weekNumber}',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tab Bar
          TabBar(
            controller: _tabController,
            indicatorColor: TColors.primary,
            labelColor: TColors.primary,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "Action Plan"),
              Tab(text: "Events"),
              Tab(text: "Review"),
            ],
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // -------- Action Plan Tab --------
                FutureBuilder<Map<String, dynamic>>(
                  future: _actionPlanFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data!['message'] ==
                          'Action Plan not found') {
                        return _buildEmptyState(
                          context,
                          title: 'No Action Plan',
                          buttonText: 'Add Action Plan',
                          onPressed: () =>
                              Get.to(
                                    () =>
                                    AddActionPlan(
                                        weekNumber: widget.weekNumber),
                              ),
                        );
                      } else {
                        final actionPlan = snapshot.data!['actionPlan'];
                        return _buildActionPlanCard(
                            context, actionPlan, userId);
                      }
                    }
                    return const Center(child: Text('No data available'));
                  },
                ),

                // -------- Events Tab --------
                FutureBuilder<Map<String, dynamic>>(
                  future: _actionEvents,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data!['message'] == 'Events not found') {
                        return _buildEmptyState(
                          context,
                          title: 'No Events',
                          buttonText: 'Add Events',
                          onPressed: () =>
                              Get.to(
                                    () =>
                                    AddWeekScreen(
                                        weekNumber: widget.weekNumber),
                              ),
                        );
                      } else {
                        final events = snapshot.data!['actionPlan'];
                        return _buildEventsCard(context, events, userId);
                      }
                    }
                    return const Center(child: Text('No data available'));
                  },
                ),

                // -------- Review Tab --------
                FutureBuilder<Map<String, dynamic>>(
                  future: _actionReview,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data!['message'] == 'Review not found') {
                        return _buildEmptyState(
                          context,
                          title: 'No Review',
                          buttonText: 'Add Review',
                          onPressed: () =>
                              Get.to(
                                    () =>
                                    AddReviewScreen(
                                        weekNumber: widget.weekNumber),
                              ),
                        );
                      } else {
                        final review = snapshot.data!['actionPlan'];
                        return _buildReviewCard(context, review, userId);
                      }
                    }
                    return const Center(child: Text('No data available'));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context,
      {required String title, required String buttonText, required VoidCallback onPressed}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/images/animations/task.json',
              height: 120,
              repeat: true,
              animate: true,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
                width: double.infinity,
                child:
                FilledButton.icon(
                  onPressed: onPressed,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3, // subtle shadow
                  ),
                )

            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionPlanCard(BuildContext context, Map<String, dynamic> data,
      int userId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.track_changes, color: TColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Weekly Action Plan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Short-Term
                  Text('Short-Term Actions', style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
                  _buildActionPlanRow(
                      context, 'STA1', data, widget.weekNumber, userId),
                  _buildActionPlanRow(
                      context, 'STA2', data, widget.weekNumber, userId),
                  const Divider(height: 24),
                  // Mid-Term
                  Text('Mid-Term Actions', style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
                  _buildActionPlanRow(
                      context, 'MTA1', data, widget.weekNumber, userId),
                  _buildActionPlanRow(
                      context, 'MTA2', data, widget.weekNumber, userId),
                  _buildActionPlanRow(
                      context, 'MTA3', data, widget.weekNumber, userId),
                  _buildActionPlanRow(
                      context, 'MTA4', data, widget.weekNumber, userId),
                  const Divider(height: 24),
                  // Long-Term
                  Text('Long-Term Actions', style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
                  _buildActionPlanRow(
                      context, 'LTA1', data, widget.weekNumber, userId),
                  _buildActionPlanRow(
                      context, 'LTA2', data, widget.weekNumber, userId),
                  const Divider(height: 24),
                  // Legacy
                  Text('Legacy Goals', style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
                  _buildActionPlanRow(
                      context, 'LEG1', data, widget.weekNumber, userId),
                  _buildActionPlanRow(
                      context, 'LEG2', data, widget.weekNumber, userId),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child:
                    FilledButton.icon(
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete Action Plan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,

                      ),
                      onPressed: () async {
                        final confirmed = await showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: const Text(
                                    'Are you sure you want to delete this action plan?'),
                                actions: [
                                  TextButton(onPressed: () =>
                                      Navigator.pop(context, false),
                                      child: const Text('Cancel')),
                                  TextButton(onPressed: () =>
                                      Navigator.pop(context, true),
                                      child: const Text('Delete')),
                                ],
                              ),
                        );
                        if (confirmed == true) {
                          await ActionPlanController.instance
                              .deleteActionPlanById(data['id']);
                          setState(() {
                            _actionPlanFuture =
                                fetchActionPlan(userId, widget.weekNumber);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsCard(BuildContext context, Map<String, dynamic> data,
      int userId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: const [
                  Icon(Icons.event, color: TColors.primary),
                  SizedBox(width: 8),
                  Text('Weekly Important Events', style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 12),
              _buildActionRow('Monday', data['monday']),
              _buildActionRow('Tuesday', data['tuesday']),
              _buildActionRow('Wednesday', data['wednesday']),
              _buildActionRow('Thursday', data['thursday']),
              _buildActionRow('Friday', data['friday']),
              _buildActionRow('Saturday', data['saturday']),
              _buildActionRow('Sunday', data['sunday']),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child:
                FilledButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Events'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,

                  ),
                  onPressed: () async {
                    final confirmed = await showDialog(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text(
                                'Are you sure you want to delete these events?'),
                            actions: [
                              TextButton(onPressed: () =>
                                  Navigator.pop(context, false),
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete')),
                            ],
                          ),
                    );
                    if (confirmed == true) {
                      await EventController.instance.deleteEventById(
                          data['id']);
                      setState(() {
                        _actionEvents = fetchEvents(userId, widget.weekNumber);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, Map<String, dynamic> data,
      int userId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.rate_review, color: TColors.primary),
                  SizedBox(width: 8),
                  Text('Review this week', style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 12),
              _buildActionRow('What went right this week?', data['question1']),
              _buildActionRow('What went wrong this week?', data['question2']),
              _buildActionRow(
                  'What to do more of next week?', data['question3']),
              _buildActionRow(
                  'What to do less of next week?', data['question4']),
              const SizedBox(height: 12),
              _buildActionRow('Overall Rating (1–10) for this week?',
                  data['rating'].toString()),
              _buildActionRow(
                  'What would have made it a ten?', data['comment']),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Review'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,

                  ),
                  onPressed: () async {
                    final confirmed = await showDialog(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text(
                                'Are you sure you want to delete this Review?'),
                            actions: [
                              TextButton(onPressed: () =>
                                  Navigator.pop(context, false),
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete')),
                            ],
                          ),
                    );
                    if (confirmed == true) {
                      await ReviewController.instance.deleteReviewById(
                          data['id']);
                      setState(() {
                        _actionReview = fetchReview(userId, widget.weekNumber);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  Future<void> _markActionCompleted(Map<String, dynamic> step,
      BuildContext context, int weekNumber) async {

    bool confirmed = await _showConfirmationDialog(context);

    if (confirmed) {
      final week = weekNumber;
      final updated = await _updateActionPlanProgress(step, 100, week);

      if (updated) {
        // Navigator.of(context).pop();

        setState(() {
          final userId = GetStorage().read('userId');
          _actionPlanFuture = fetchActionPlan(userId, weekNumber);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Progress updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update progress'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

}