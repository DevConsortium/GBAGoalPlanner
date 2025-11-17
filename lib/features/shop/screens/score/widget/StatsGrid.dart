import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key});

  // 🔹 Replace this with your actual API call
  Future<Map<String, dynamic>?> fetchCompletedGoals() async {
    final userId = GetStorage().read('userId');
    final url = Uri.parse(
      'https://todo.jpsofttechnologies.tech/api/countCompletedGoals/$userId',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null) {
        return data;
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load completed goals');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchCompletedGoals(), // Fetch API data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available.'));
        }

        final data = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
            children: [
              StatCard(
                icon: Icons.directions_run,
                label: "Short Term Goals",
                value: "${data['STG'] ?? 0}/2",
                unit: "Completed",
                color1: const Color(0xFF6A85B6),
                color2: const Color(0xFFBAC8E0),
              ),
              StatCard(
                icon: Icons.ac_unit,
                label: "Medium Term Goals",
                value: "${data['MTG'] ?? 0}/6",
                unit: "Completed",
                color1: const Color(0xFFFC5C7D),
                color2: const Color(0xFF6A82FB),
              ),
              StatCard(
                icon: Icons.calendar_today,
                label: "Long Term Goals ",
                value: "${data['LTG'] ?? 0}/6",
                unit: "Completed",
                color1: const Color(0xFF56CCF2),
                color2: const Color(0xFF2F80ED),
              ),
              StatCard(
                icon: Icons.timer,
                label: "Legacy Goals ",
                value: "${data['LEG'] ?? 0}/2",
                unit: "Completed",
                color1: const Color(0xFFF2994A),
                color2: const Color(0xFFF2C94C),
              ),
            ],
          ),
        );
      },
    );
  }
}

// class StatCard extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   final String unit;
//   final Color color1;
//   final Color color2;
//
//   const StatCard({
//     super.key,
//     required this.icon,
//     required this.label,
//     required this.value,
//     required this.unit,
//     required this.color1,
//     required this.color2,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [color1, color2],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 6,
//             offset: Offset(2, 3),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, color: Colors.white, size: 28),
//             const SizedBox(height: 10),
//             Flexible(
//               child: Text(
//                 label,
//                 style: const TextStyle(
//                   color: Colors.white70,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w400,
//                 ),
//                 overflow: TextOverflow.visible,
//                 maxLines: 2,
//                 softWrap: true,
//               ),
//             ),
//             // Text(
//             //   label,
//             //   style: const TextStyle(
//             //     color: Colors.white70,
//             //     fontSize: 13,
//             //     fontWeight: FontWeight.w400,
//             //   ),
//             // ),
//             const SizedBox(height: 5),
//             RichText(
//               text: TextSpan(
//                 children: [
//                   TextSpan(
//                     text: value,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   TextSpan(
//                     text: " $unit",
//                     style: const TextStyle(
//                       color: Colors.white70,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color1;
  final Color color2;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adjust sizes dynamically
    final cardWidth = screenWidth * 0.42; // fits 2 per row
    final cardHeight = screenHeight * 0.18;

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: screenWidth * 0.07),
          const SizedBox(height: 10),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.visible,
              softWrap: true,
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " $unit",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: screenWidth * 0.045,
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
}