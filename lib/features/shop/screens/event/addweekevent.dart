//
// import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
// import 'package:tea/features/shop/controllers/Events/EventsController.dart';
// import 'package:tea/utils/constants/sizes.dart';
// import 'package:tea/utils/constants/text_strings.dart';
// import 'package:tea/utils/helpers/exports.dart';
//
// class AddWeekScreen extends StatelessWidget {
//   final int weekNumber;
//   const AddWeekScreen({required this.weekNumber, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final box = GetStorage();
//     final int? userId = box.read('userId');
//
//     // Controllers for the input fields
//     final TextEditingController mondayController = TextEditingController();
//     final TextEditingController tuesdayController = TextEditingController();
//     final TextEditingController wednesdayController = TextEditingController();
//     final TextEditingController thursdayController = TextEditingController();
//     final TextEditingController fridayController = TextEditingController();
//     final TextEditingController saturdayController = TextEditingController();
//     final TextEditingController sundayController = TextEditingController();
//
//     // Get the EventController instance
//     final EventController _eventController = EventController.instance;
//
//     // Function to handle form submission
//     void _submitForm() {
//       final monday = mondayController.text;
//       final tuesday = tuesdayController.text;
//       final wednesday = wednesdayController.text;
//       final thursday = thursdayController.text;
//       final friday = fridayController.text;
//       final saturday = saturdayController.text;
//       final sunday = sundayController.text;
//
//       // Call saveEvent method to save the event
//       _eventController.saveEvent(
//         weekNumber: weekNumber,
//         monday: monday,
//         tuesday: tuesday,
//         wednesday: wednesday,
//         thursday: thursday,
//         friday: friday,
//         saturday: saturday,
//         sunday: sunday,
//       );
//
//       // Clear the form after saving the event
//       mondayController.clear();
//       tuesdayController.clear();
//       wednesdayController.clear();
//       thursdayController.clear();
//       fridayController.clear();
//       saturdayController.clear();
//       sundayController.clear();
//     }
//
//     final dark = THelperFunctions.isDarkMode(context);
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(
//             top: 100.0, // Adds top margin
//             left: TSizes.defaultSpace, // Optional: Adds left padding
//             right: TSizes.defaultSpace, // Optional: Adds right padding
//             bottom: TSizes.defaultSpace, // Optional: Adds bottom padding
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 TTexts.weekPlan + '$weekNumber',
//                 style: Theme.of(context).textTheme.headlineMedium,
//               ),
//               const SizedBox(height: TSizes.spaceBtwSections),
//               const Divider(),
//
//               // Form
//               Form(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     TextFormField(
//                       controller: mondayController,
//                       decoration: const InputDecoration(
//                         labelText: TTexts.monday,
//                         prefixIcon: Icon(Iconsax.alarm),
//                       ),
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     TextFormField(
//                       controller: tuesdayController,
//                       decoration: const InputDecoration(
//                         labelText: TTexts.tuesday,
//                         prefixIcon: Icon(Iconsax.alarm),
//                       ),
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     TextFormField(
//                       controller: wednesdayController,
//                       decoration: const InputDecoration(
//                         labelText: TTexts.wednesday,
//                         prefixIcon: Icon(Iconsax.alarm),
//                       ),
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     TextFormField(
//                       controller: thursdayController,
//                       decoration: const InputDecoration(
//                         labelText: TTexts.thursday,
//                         prefixIcon: Icon(Iconsax.alarm),
//                       ),
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     TextFormField(
//                       controller: fridayController,
//                       decoration: const InputDecoration(
//                         labelText: TTexts.friday,
//                         prefixIcon: Icon(Iconsax.alarm),
//                       ),
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     TextFormField(
//                       controller: saturdayController,
//                       decoration: const InputDecoration(
//                         labelText: TTexts.saturday,
//                         prefixIcon: Icon(Iconsax.alarm),
//                       ),
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     TextFormField(
//                       controller: sundayController,
//                       decoration: const InputDecoration(
//                         labelText: TTexts.sunday,
//                         prefixIcon: Icon(Iconsax.alarm),
//                       ),
//                     ),
//
//                     // Submit Button
//                     const SizedBox(height: TSizes.spaceBtwSections),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _submitForm, // Call the submit function
//                         child: Text(TTexts.add),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           foregroundColor: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: TSizes.spaceBtwSections),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:tea/navigation_menu.dart';
import 'package:tea/utils/constants/sizes.dart';
import 'package:tea/utils/constants/text_strings.dart';
import 'package:tea/features/shop/controllers/Events/EventsController.dart';

class AddWeekScreen extends StatelessWidget {
  final int weekNumber;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AddWeekScreen({required this.weekNumber, super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();

    // Controllers Map (cleaner and consistent)
    final controllers = {
      'Monday': TextEditingController(),
      'Tuesday': TextEditingController(),
      'Wednesday': TextEditingController(),
      'Thursday': TextEditingController(),
      'Friday': TextEditingController(),
      'Saturday': TextEditingController(),
      'Sunday': TextEditingController(),
    };

    final EventController eventController = EventController.instance;

    // Submit Logic
    Future<void> _submitForm() async {
      try {
        await eventController.saveEvent(
          weekNumber: weekNumber,
          monday: controllers['Monday']!.text,
          tuesday: controllers['Tuesday']!.text,
          wednesday: controllers['Wednesday']!.text,
          thursday: controllers['Thursday']!.text,
          friday: controllers['Friday']!.text,
          saturday: controllers['Saturday']!.text,
          sunday: controllers['Sunday']!.text,
        );

        // Clear all fields
        controllers.forEach((key, controller) => controller.clear());

        Get.offAll(() => const NavigationMenu());

      } catch (e) {
        print("ERROR WHILE SAVING WEEK PLAN: $e");

        Get.snackbar(
          "Error",
          "Failed to save week plan!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }

    // void _submitForm() {
    //   eventController.saveEvent(
    //     weekNumber: weekNumber,
    //     monday: controllers['Monday']!.text,
    //     tuesday: controllers['Tuesday']!.text,
    //     wednesday: controllers['Wednesday']!.text,
    //     thursday: controllers['Thursday']!.text,
    //     friday: controllers['Friday']!.text,
    //     saturday: controllers['Saturday']!.text,
    //     sunday: controllers['Sunday']!.text,
    //   );
    //
    //   // Clear all fields
    //   controllers.forEach((key, controller) => controller.clear());
    //
    //   Get.offAll(() => NavigationMenu());
    // }

    Widget _buildSection(String title, List<String> days, Color color) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Days input fields
          ...days.map(
            (day) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: TextFormField(
                controller: controllers[day],
                decoration: InputDecoration(
                  labelText: day,
                  prefixIcon: const Icon(Iconsax.calendar_1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Row(
                children: [

                  const SizedBox(width: 25),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Week Plan - Week $weekNumber',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 45),
                ],
              ),
            ),
          ),
        ),
      ),

      // BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildSection('Weekly Plan', [
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday',
                'Saturday',
                'Sunday',
              ], Colors.blue),

              const SizedBox(height: 10),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  // icon: const Icon(Icons.check_circle),
                  label: const Text(
                    TTexts.submit,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _submitForm,
                  style: FilledButton.styleFrom(
                    elevation: 3,
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
