// import 'package:flutter/material.dart';
// import 'package:tea/common/widgets/appbar/appbar.dart';
// import 'package:tea/common/widgets/custom_shapes/containers/primary_header_container.dart';
// import 'package:tea/features/shop/screens/goalform/widget/goalform.dart';
// import 'package:tea/utils/constants/colors.dart';
//
//
//
// class Maingoal extends StatelessWidget {
//   const Maingoal({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             TPrimaryHeaderContainer(
//               child: Column(
//                 children: [
//                   TAppBar(
//                     showBackArrow: false,
//                     title: Text(
//                       'Add Your Goals',
//                       style: Theme.of(
//                         context,
//                       ).textTheme.headlineMedium!.apply(color: TColors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             GoalForm(),
//
//
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:tea/common/widgets/appbar/appbar.dart';
import 'package:tea/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:tea/features/shop/screens/goalform/widget/goalTile.dart';
import 'package:tea/features/shop/screens/goalform/widget/goalform.dart';
import 'package:tea/utils/constants/colors.dart';

class Maingoal extends StatefulWidget {
  const Maingoal({super.key});

  @override
  State<Maingoal> createState() => _MaingoalState();
}

class _MaingoalState extends State<Maingoal> {
  List<Map<String, dynamic>> _goals = [];
  bool _loading = false;

  final userId = GetStorage().read('userId');

  @override
  void initState() {
    super.initState();
    _fetchGoals();
  }

  Future<void> _fetchGoals() async {
    setState(() => _loading = true);

    final url = Uri.parse('https://todo.jpsofttechnologies.tech/api/getGoals/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(jsonDecode(response.body));

      setState(() {
        _goals = data.entries.map<Map<String, dynamic>>((entry) {
          final Map<String, dynamic> goal = Map<String, dynamic>.from(entry.value);
          return {
            'fieldName': entry.key,
            ...goal,
          };
        }).toList();

      });
    } else {
      // Handle error
    }

    setState(() => _loading = false);
  }

  Future<void> _markAsCompleted(int id) async {
    final url = Uri.parse('https://todo.jpsofttechnologies.tech/api/goals/$id/complete');
    final response = await http.put(url);

    if (response.statusCode == 200) {
      await _fetchGoals();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal marked as completed')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to mark goal as complete')),
      );
    }
  }

  Widget _buildGoalTile(Map<String, dynamic> goal) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(goal['goal'] ?? ''),
        subtitle: Text("Category: ${goal['category'] ?? ''}"),
        trailing: goal['completed'] == true
            ? const Icon(Icons.check_circle, color: Colors.green)
            : ElevatedButton(
          onPressed: () => _markAsCompleted(goal['id']),
          child: const Text('Complete'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _fetchGoals,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TPrimaryHeaderContainer(
                child: Column(
                  children: [
                    TAppBar(
                      title: Text(
                        'Add Your Goals',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .apply(
                          color: TColors.white,
                          fontSizeFactor: 1.3,
                        ),
                      ),
                      showBackArrow: false,
                      centerTitle: true,
                    ),
                  ],
                ),
              ),

              // Form Widget
              const GoalForm(),

              // const SizedBox(height: 24),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   child: Text(
              //     'Your Goals',
              //     style: Theme.of(context).textTheme.titleLarge,
              //   ),
              // ),
              //
              // const SizedBox(height: 8),
              //
              // if (_loading)
              //   const Center(child: CircularProgressIndicator())
              // else if (_goals.isEmpty)
              //   const Center(child: Padding(
              //     padding: EdgeInsets.all(20.0),
              //     child: Text("No goals found."),
              //   ))
              // else
              //   ListView.builder(
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     itemCount: _goals.length,
              //     itemBuilder: (context, index) {
              //       return _buildGoalTile(_goals[index]);
              //     },
              //   ),


              // GoalListSection(
              //   loading: _loading,
              //   goals: _goals,
              //   buildGoalTile: _buildGoalTile,
              // ),

            ],
          ),
        ),
      ),
    );
  }
}
