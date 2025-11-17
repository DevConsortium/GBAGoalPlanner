import 'package:flutter/material.dart';


class GoalListSection extends StatelessWidget {
  final bool loading;
  final Map<String, List<Map<String, dynamic>>> groupedGoals;
  final Widget Function(Map<String, dynamic>) buildGoalTile;

  const GoalListSection({
    super.key,
    required this.loading,
    required this.groupedGoals,
    required this.buildGoalTile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        const SizedBox(height: 8),

        if (loading)
          const Center(child: CircularProgressIndicator())
        else if (groupedGoals.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("No goals found."),
            ),
          )
        else
        // Loop through each group (e.g., LEG, LTG, etc.)
          for (var groupType in groupedGoals.keys)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 7),
                  child: Text(
                    _getGroupName(groupType), // Function to get the full group name
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: groupedGoals[groupType]!.length,
                  itemBuilder: (context, index) {
                    return buildGoalTile(groupedGoals[groupType]![index]);
                  },
                ),
              ],
            ),
      ],
    );
  }

  String _getGroupName(String groupType) {
    switch (groupType) {

      case 'LTG':
        return 'Long-term Goals';
      case 'MTG':
        return 'Medium-term Goals';
      case 'STG':
        return 'Short-term Goals';
      case 'LEG':
        return 'Legacy Goals';
      default:
        return 'Goals';
    }
  }
}
