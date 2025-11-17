// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:lottie/lottie.dart';
// import 'package:tea/common/widgets/appbar/appbar.dart';
// import 'package:tea/common/widgets/custom_shapes/containers/primary_header_container.dart';
// import 'package:tea/features/shop/controllers/ActionPlan/ActionPlanController.dart';
// import 'package:tea/features/shop/controllers/Events/EventsController.dart';
// import 'package:tea/features/shop/controllers/Review/ReviewController.dart';
// import 'package:tea/features/shop/screens/actionplan/addactionplan.dart';
// import 'package:tea/features/shop/screens/event/addweekevent.dart';
// import 'package:tea/features/shop/screens/review/addreview.dart';
// import 'package:http/http.dart' as http;
// import 'package:tea/utils/constants/colors.dart';
// import 'package:tea/utils/constants/text_strings.dart';
//
// class WeekNavigationScreen extends StatefulWidget {
//   final int weekNumber;
//
//   const WeekNavigationScreen(this.weekNumber, {super.key});
//
//   @override
//   _WeekNavigationScreenState createState() => _WeekNavigationScreenState();
// }
//
// Widget _buildActionRow(String label, String? value) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 4.0),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
//         Expanded(
//           child: Text(value?.isNotEmpty == true ? value! : 'Not specified'),
//         ),
//       ],
//     ),
//   );
// }
//
// class _WeekNavigationScreenState extends State<WeekNavigationScreen> {
//   late Future<Map<String, dynamic>> _actionPlanFuture;
//   late Future<Map<String, dynamic>> _actionEvents;
//   late Future<Map<String, dynamic>> _actionReview;
//
//   @override
//   void initState() {
//     super.initState();
//     final box = GetStorage();
//     final userId = box.read('userId');
//
//     // Fetch the action plan when the screen loads
//     _actionPlanFuture = fetchActionPlan(userId, widget.weekNumber);
//     _actionEvents = fetchEvents(userId, widget.weekNumber);
//     _actionReview = fetchReview(userId, widget.weekNumber);
//   }
//
//   Future<Map<String, dynamic>> fetchActionPlan(
//     int userId,
//     int weekNumber,
//   ) async {
//     final url = Uri.parse(
//       'https://todo.jpsofttechnologies.tech/api/getActionPlan?userId=$userId&weekNumber=$weekNumber',
//     );
//
//     try {
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data;
//       } else {
//         return {'message': 'Action Plan not found'};
//       }
//     } catch (error) {
//       throw Exception('Error fetching action plan: $error');
//     }
//   }
//
//   Future<Map<String, dynamic>> fetchEvents(int userId, int weekNumber) async {
//     final url = Uri.parse(
//       'https://todo.jpsofttechnologies.tech/api/getEvents?userId=$userId&weekNumber=$weekNumber',
//     );
//
//     try {
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data;
//       } else {
//         // If Action Plan is not found, return a custom message
//         return {'message': 'Events not found'};
//       }
//     } catch (error) {
//       throw Exception('Error fetching Events: $error');
//     }
//   }
//
//   Future<Map<String, dynamic>> fetchReview(int userId, int weekNumber) async {
//     final url = Uri.parse(
//       'https://todo.jpsofttechnologies.tech/api/getReview?userId=$userId&weekNumber=$weekNumber',
//     );
//
//     try {
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data;
//       } else {
//         // If Action Plan is not found, return a custom message
//         return {'message': 'Review not found'};
//       }
//     } catch (error) {
//       throw Exception('Error fetching Review: $error');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final userId = GetStorage().read('userId');
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             TPrimaryHeaderContainer(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 25),
//                   TAppBar(
//                     title: Text(
//                       'Scalling with GB Goal Planner',
//                       textAlign: TextAlign.center,
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleLarge!              // 🔥 smaller than headlineMedium
//                           .apply(
//                         color: TColors.white,
//                         fontSizeFactor: 0.9,    // 🔥 make it even smaller
//                       ),
//                     ),
//                     showBackArrow: false,
//                     centerTitle: true,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Week ${widget.weekNumber}',
//                     style: Theme.of(context).textTheme.labelMedium!.apply(
//                       color: TColors.white,
//                       fontSizeDelta: 10,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // FutureBuilder to load the data
//             FutureBuilder<Map<String, dynamic>>(
//               future: _actionPlanFuture, // Trigger the API request
//
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }
//
//                 if (snapshot.hasData) {
//                   if (snapshot.data!['message'] == 'Action Plan not found') {
//                     return Container(
//                       width: double.infinity,
//                       // height: 250,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Card(
//                         // color: Colors.black45,
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         margin: const EdgeInsets.all(16),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//
//                                 children: [
//                                   Text(
//                                     'Weekly Action Plan',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleLarge
//                                         ?.copyWith(fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//
//                               // SizedBox(height: 16),
//                               Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Lottie.asset(
//                                       'assets/images/animations/task.json',
//                                       // width: 200,
//                                       height: 110,
//                                       fit: BoxFit.contain,
//                                       repeat: true, // Repeat animation
//                                       animate: true,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Center(
//                                 child: Text(
//                                   'Action Plan not added for this week.',
//                                   style: Theme.of(context).textTheme.bodyMedium
//                                       ?.copyWith(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.red,
//                                       ),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               SizedBox(
//                                 width: double.infinity,
//                                 child: ElevatedButton(
//                                   onPressed: () => Get.to(
//                                     () => AddActionPlan(
//                                       weekNumber: widget.weekNumber,
//                                     ),
//                                   ),
//                                   child: const Text('Add Action Plan'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   } else {
//                     final actionPlan = snapshot.data!['actionPlan'];
//                     return Container(
//                       width: double.infinity,
//                       // height: 250,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Card(
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         margin: const EdgeInsets.all(16),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Center(
//                                     child: Text(
//                                       'Weekly Action Plan',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .titleLarge
//                                           ?.copyWith(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 8),
//                               // --- Short-Term Actions ---
//                               Text(
//                                 'Short-Term Actions',
//                                 style: Theme.of(context).textTheme.titleSmall
//                                     ?.copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 8),
//                               _buildActionRow('STA1', actionPlan['sta1']),
//                               _buildActionRow('STA2', actionPlan['sta2']),
//                               const Divider(height: 24),
//
//                               // --- Mid-Term Actions ---
//                               Text(
//                                 'Mid-Term Actions',
//                                 style: Theme.of(context).textTheme.titleSmall
//                                     ?.copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 8),
//                               _buildActionRow('MTA1', actionPlan['mta1']),
//                               _buildActionRow('MTA2', actionPlan['mta2']),
//                               _buildActionRow('MTA3', actionPlan['mta3']),
//                               _buildActionRow('MTA4', actionPlan['mta4']),
//                               const Divider(height: 24),
//
//                               // --- Long-Term Actions ---
//                               Text(
//                                 'Long-Term Actions',
//                                 style: Theme.of(context).textTheme.titleSmall
//                                     ?.copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 8),
//                               _buildActionRow('LTA1', actionPlan['lta1']),
//                               _buildActionRow('LTA2', actionPlan['lta2']),
//                               const Divider(height: 24),
//
//                               // --- Legacy Goals ---
//                               Text(
//                                 'Legacy Goals',
//                                 style: Theme.of(context).textTheme.titleSmall
//                                     ?.copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 8),
//                               _buildActionRow('LEG1', actionPlan['leg1']),
//                               _buildActionRow('LEG2', actionPlan['leg2']),
//
//                               SizedBox(height: 10),
//                               // Button at the bottom
//
//                               // SizedBox(
//                               //   width: double.infinity,
//                               //   child: ElevatedButton(
//                               //     onPressed: () => Get.to(
//                               //       () => AddActionPlan(
//                               //         weekNumber: widget.weekNumber,
//                               //       ),
//                               //     ),
//                               //     child: const Text('Delete Action Plan'),
//                               //   ),
//                               // ),
//                               SizedBox(
//                                 width: double.infinity,
//                                 child: ElevatedButton(
//                                   onPressed: () async {
//                                     final confirmed = await showDialog(
//                                       context: context,
//                                       builder: (context) => AlertDialog(
//                                         title: const Text('Confirm Deletion'),
//                                         content: const Text(
//                                           'Are you sure you want to delete this action plan?',
//                                         ),
//                                         actions: [
//                                           TextButton(
//                                             onPressed: () =>
//                                                 Navigator.pop(context, false),
//                                             child: const Text('Cancel'),
//                                           ),
//                                           TextButton(
//                                             onPressed: () =>
//                                                 Navigator.pop(context, true),
//                                             child: const Text('Delete'),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//
//                                     if (confirmed == true) {
//                                       await ActionPlanController.instance
//                                           .deleteActionPlanById(
//                                             actionPlan['id'],
//                                           );
//                                       // Optionally refresh screen or navigate away
//                                       setState(() {
//                                         _actionEvents = fetchEvents(
//                                           userId,
//                                           widget.weekNumber,
//                                         );
//                                       });
//                                     }
//                                   },
//
//                                   child: const Text('Delete Action Plan'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }
//                 }
//
//                 return Center(child: Text('No data available'));
//               },
//             ),
//
//             // Big move towards Events
//             FutureBuilder<Map<String, dynamic>>(
//               future: _actionEvents, // Trigger the API request
//
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }
//
//                 if (snapshot.hasData) {
//                   if (snapshot.data!['message'] == 'Events not found') {
//                     return Container(
//                       width: double.infinity,
//                       // height: 250,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Card(
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         margin: const EdgeInsets.all(16),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//
//                                 children: [
//                                   Text(
//                                     'Important Events',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleLarge
//                                         ?.copyWith(fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//
//                               // SizedBox(height: 16),
//                               Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Lottie.asset(
//                                       'assets/images/animations/task.json',
//                                       // width: 200,
//                                       height: 110,
//                                       fit: BoxFit.contain,
//                                       repeat: true, // Repeat animation
//                                       animate: true,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Center(
//                                 child: Text(
//                                   'Events not added for this week.',
//                                   style: Theme.of(context).textTheme.bodyMedium
//                                       ?.copyWith(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.red,
//                                       ),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               SizedBox(
//                                 width: double.infinity,
//                                 child: ElevatedButton(
//                                   onPressed: () => Get.to(
//                                     () => AddWeekScreen(
//                                       weekNumber: widget.weekNumber,
//                                     ),
//                                   ),
//                                   child: const Text('Add Events'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   } else {
//                     final actionPlan = snapshot.data!['actionPlan'];
//                     return Container(
//                       width: double.infinity,
//                       // height: 250,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Card(
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         margin: const EdgeInsets.all(16),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Center(
//                                     child: Text(
//                                       'Weekly Important Events',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .titleLarge
//                                           ?.copyWith(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 8),
//                               // --- Short-Term Actions ---
//                               Text(
//                                 'Week',
//                                 style: Theme.of(context).textTheme.titleSmall
//                                     ?.copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 8),
//                               _buildActionRow('Monday', actionPlan['monday']),
//                               _buildActionRow('Tuesday', actionPlan['tuesday']),
//                               _buildActionRow(
//                                 'Wednesday',
//                                 actionPlan['wednesday'],
//                               ),
//                               _buildActionRow(
//                                 'Thursday',
//                                 actionPlan['thursday'],
//                               ),
//                               _buildActionRow('Friday', actionPlan['friday']),
//                               _buildActionRow(
//                                 'Saturday',
//                                 actionPlan['saturday'],
//                               ),
//                               _buildActionRow('Sunday', actionPlan['sunday']),
//                               const Divider(height: 24),
//
//                               SizedBox(height: 10),
//
//                               SizedBox(
//                                 width: double.infinity,
//                                 child: ElevatedButton(
//                                   onPressed: () async {
//                                     final confirmed = await showDialog(
//                                       context: context,
//                                       builder: (context) => AlertDialog(
//                                         title: const Text('Confirm Deletion'),
//                                         content: const Text(
//                                           'Are you sure you want to delete these events?',
//                                         ),
//                                         actions: [
//                                           TextButton(
//                                             onPressed: () =>
//                                                 Navigator.pop(context, false),
//                                             child: const Text('Cancel'),
//                                           ),
//                                           TextButton(
//                                             onPressed: () =>
//                                                 Navigator.pop(context, true),
//                                             child: const Text('Delete'),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//
//                                     if (confirmed == true) {
//                                       await EventController.instance
//                                           .deleteEventById(actionPlan['id']);
//                                       // Optionally refresh screen or navigate away
//                                       setState(() {
//                                         _actionEvents = fetchEvents(
//                                           userId,
//                                           widget.weekNumber,
//                                         );
//                                       });
//                                     }
//                                   },
//
//                                   child: const Text('Delete Events'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }
//                 }
//
//                 return Center(child: Text('No data available'));
//               },
//             ),
//
//             // Events section
//
//             // Weekly Review section
//             FutureBuilder<Map<String, dynamic>>(
//               future: _actionReview, // Trigger the API request
//
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }
//
//                 if (snapshot.hasData) {
//                   if (snapshot.data!['message'] == 'Review not found') {
//                     return Container(
//                       width: double.infinity,
//                       // height: 250,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Card(
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         margin: const EdgeInsets.all(16),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//
//                                 children: [
//                                   Text(
//                                     'Review',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleLarge
//                                         ?.copyWith(fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//
//                               // SizedBox(height: 16),
//                               Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Lottie.asset(
//                                       'assets/images/animations/task.json',
//                                       // width: 200,
//                                       height: 110,
//                                       fit: BoxFit.contain,
//                                       repeat: true, // Repeat animation
//                                       animate: true,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Center(
//                                 child: Text(
//                                   'Review not added for this week.',
//                                   style: Theme.of(context).textTheme.bodyMedium
//                                       ?.copyWith(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.red,
//                                       ),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               SizedBox(
//                                 width: double.infinity,
//                                 child: ElevatedButton(
//                                   onPressed: () => Get.to(
//                                     () => AddReviewScreen(
//                                       weekNumber: widget.weekNumber,
//                                     ),
//                                   ),
//                                   child: const Text('Add Review'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   } else {
//                     final actionPlan = snapshot.data!['actionPlan'];
//                     return Container(
//                       width: double.infinity,
//                       // height: 250,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Card(
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         margin: const EdgeInsets.all(16),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Center(
//                                     child: Text(
//                                       'Review this week',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .titleLarge
//                                           ?.copyWith(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 16),
//                               // --- Questions ---
//                               Text(
//                                 TTexts.weekQuesFirst,
//                                 style: Theme.of(context).textTheme.titleSmall
//                                     ?.copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 8),
//                               _buildActionRow(
//                                 'Answer: ',
//                                 actionPlan['question1'],
//                               ),
//                               const Divider(height: 24),
//                               Text(
//                                 TTexts.weekQuesSecond,
//                                 style: Theme.of(context).textTheme.titleSmall
//                                     ?.copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 8),
//                               _buildActionRow(
//                                 'Answer: ',
//                                 actionPlan['question2'],
//                               ),
//                               const Divider(height: 24),
//                               Text(
//                                 TTexts.weekQuesThird,
//                                 style: Theme.of(context).textTheme.titleSmall
//                                     ?.copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 8),
//                               _buildActionRow(
//                                 'Answer: ',
//                                 actionPlan['question3'],
//                               ),
//                               const Divider(height: 24),
//                               Text(
//                                 TTexts.weekQuesFourth,
//                                 style: Theme.of(context).textTheme.titleSmall
//                                     ?.copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 8),
//                               _buildActionRow(
//                                 'Answer: ',
//                                 actionPlan['question4'],
//                               ),
//                               const Divider(height: 24),
//                               Text(
//                                 TTexts.ratingText,
//                                 style: Theme.of(context).textTheme.titleSmall
//                                     ?.copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(actionPlan['rating'].toString()),
//                               const Divider(height: 24),
//                               Text(
//                                 TTexts.whatMade10,
//                                 style: Theme.of(context).textTheme.titleSmall
//                                     ?.copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 8),
//                               _buildActionRow(
//                                 'Answer: ',
//                                 actionPlan['comment'],
//                               ),
//                               const Divider(height: 24),
//
//                               SizedBox(height: 10),
//
//                               SizedBox(
//                                 width: double.infinity,
//                                 child: ElevatedButton(
//                                   onPressed: () async {
//                                     final confirmed = await showDialog(
//                                       context: context,
//                                       builder: (context) => AlertDialog(
//                                         title: const Text('Confirm Deletion'),
//                                         content: const Text(
//                                           'Are you sure you want to delete this Review?',
//                                         ),
//                                         actions: [
//                                           TextButton(
//                                             onPressed: () =>
//                                                 Navigator.pop(context, false),
//                                             child: const Text('Cancel'),
//                                           ),
//                                           TextButton(
//                                             onPressed: () =>
//                                                 Navigator.pop(context, true),
//                                             child: const Text('Delete'),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//
//                                     if (confirmed == true) {
//                                       await ReviewController.instance
//                                           .deleteReviewById(actionPlan['id']);
//                                       // Optionally refresh screen or navigate away
//                                       setState(() {
//                                         _actionReview = fetchReview(
//                                           userId,
//                                           widget.weekNumber,
//                                         );
//                                       });
//                                     }
//                                   },
//
//                                   child: const Text('Delete Review'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }
//                 }
//
//                 return Center(child: Text('No data available'));
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
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
import 'package:tea/utils/constants/text_strings.dart';

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

  Future<Map<String, dynamic>> fetchActionPlan(int userId, int weekNumber) async {
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
          // Gradient Header with centered AppBar & Week subtitle
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
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
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
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                      if (snapshot.data!['message'] == 'Action Plan not found') {
                        return _buildEmptyState(
                          context,
                          title: 'No Action Plan',
                          buttonText: 'Add Action Plan',
                          onPressed: () => Get.to(
                                () => AddActionPlan(weekNumber: widget.weekNumber),
                          ),
                        );
                      } else {
                        final actionPlan = snapshot.data!['actionPlan'];
                        return _buildActionPlanCard(context, actionPlan, userId);
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
                          onPressed: () => Get.to(
                                () => AddWeekScreen(weekNumber: widget.weekNumber),
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
                          onPressed: () => Get.to(
                                () => AddReviewScreen(weekNumber: widget.weekNumber),
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

  // =================== Helper Widgets ===================

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
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child:
              // FilledButton.icon(
              //   icon: const Icon(Icons.add),
              //   label: Text(buttonText),
              //
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.blue,
              //     foregroundColor: Colors.white,
              //
              //   ),
              //   onPressed: onPressed,
              // ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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

  Widget _buildActionPlanCard(BuildContext context, Map<String, dynamic> data, int userId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Short-Term
                  Text('Short-Term Actions', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                  _buildActionRow('STA1', data['sta1']),
                  _buildActionRow('STA2', data['sta2']),
                  const Divider(height: 24),
                  // Mid-Term
                  Text('Mid-Term Actions', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                  _buildActionRow('MTA1', data['mta1']),
                  _buildActionRow('MTA2', data['mta2']),
                  _buildActionRow('MTA3', data['mta3']),
                  _buildActionRow('MTA4', data['mta4']),
                  const Divider(height: 24),
                  // Long-Term
                  Text('Long-Term Actions', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                  _buildActionRow('LTA1', data['lta1']),
                  _buildActionRow('LTA2', data['lta2']),
                  const Divider(height: 24),
                  // Legacy
                  Text('Legacy Goals', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                  _buildActionRow('LEG1', data['leg1']),
                  _buildActionRow('LEG2', data['leg2']),
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
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text('Are you sure you want to delete this action plan?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await ActionPlanController.instance.deleteActionPlanById(data['id']);
                          setState(() {
                            _actionPlanFuture = fetchActionPlan(userId, widget.weekNumber);
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

  Widget _buildEventsCard(BuildContext context, Map<String, dynamic> data, int userId) {
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
                  Text('Weekly Important Events', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: const Text('Are you sure you want to delete these events?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      await EventController.instance.deleteEventById(data['id']);
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

  Widget _buildReviewCard(BuildContext context, Map<String, dynamic> data, int userId) {
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
                  Text('Review this week', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 12),
              _buildActionRow('What went right this week?', data['question1']),
              _buildActionRow('What went wrong this week?', data['question2']),
              _buildActionRow('What to do more of next week?', data['question3']),
              _buildActionRow('What to do less of next week?', data['question4']),
              const SizedBox(height: 12),
              _buildActionRow('Overall Rating (1–10) for this week?', data['rating'].toString()),
              _buildActionRow('What would have made it a ten?', data['comment']),
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
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: const Text('Are you sure you want to delete this Review?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      await ReviewController.instance.deleteReviewById(data['id']);
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
}
