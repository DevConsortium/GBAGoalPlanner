// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
// import 'package:tea/utils/constants/sizes.dart';
// import 'package:tea/utils/constants/text_strings.dart';
// import 'package:tea/features/shop/controllers/ActionPlan/ActionPlanController.dart';
// import 'package:tea/utils/popups/loaders.dart';
//
// class AddActionPlan extends StatelessWidget {
//   final int weekNumber;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   AddActionPlan({required this.weekNumber, super.key});
//
//   // Function to clear the form and reset controllers
//   void clearForm(
//       TextEditingController sta1Controller,
//       TextEditingController sta2Controller,
//       TextEditingController mta1Controller,
//       TextEditingController mta2Controller,
//       TextEditingController mta3Controller,
//       TextEditingController mta4Controller,
//       TextEditingController lta1Controller,
//       TextEditingController lta2Controller,
//       TextEditingController leg1Controller,
//       TextEditingController leg2Controller,
//       ) {
//     // Reset the form and clear all controllers
//     _formKey.currentState?.reset();
//     sta1Controller.clear();
//     sta2Controller.clear();
//     mta1Controller.clear();
//     mta2Controller.clear();
//     mta3Controller.clear();
//     mta4Controller.clear();
//     lta1Controller.clear();
//     lta2Controller.clear();
//     leg1Controller.clear();
//     leg2Controller.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final box = GetStorage();
//     final int? userId = box.read('userId');
//
//     // TextEditingControllers for each input field
//     final TextEditingController sta1Controller = TextEditingController();
//     final TextEditingController sta2Controller = TextEditingController();
//     final TextEditingController mta1Controller = TextEditingController();
//     final TextEditingController mta2Controller = TextEditingController();
//     final TextEditingController mta3Controller = TextEditingController();
//     final TextEditingController mta4Controller = TextEditingController();
//     final TextEditingController lta1Controller = TextEditingController();
//     final TextEditingController lta2Controller = TextEditingController();
//     final TextEditingController leg1Controller = TextEditingController();
//     final TextEditingController leg2Controller = TextEditingController();
//
//     // Get the controller instance
//     final ActionPlanController _actionPlanController = ActionPlanController.instance;
//
//     // Submit form function
//     void _submitForm() {
//       final sta1 = sta1Controller.text;
//       final sta2 = sta2Controller.text;
//       final mta1 = mta1Controller.text;
//       final mta2 = mta2Controller.text;
//       final mta3 = mta3Controller.text;
//       final mta4 = mta4Controller.text;
//       final lta1 = lta1Controller.text;
//       final lta2 = lta2Controller.text;
//       final leg1 = leg1Controller.text;
//       final leg2 = leg2Controller.text;
//
//       // Call the saveActionPlan method from the controller
//       _actionPlanController.saveActionPlan(
//         weekNumber: weekNumber,
//         sta1: sta1,
//         sta2: sta2,
//         mta1: mta1,
//         mta2: mta2,
//         mta3: mta3,
//         mta4: mta4,
//         lta1: lta1,
//         lta2: lta2,
//         leg1: leg1,
//         leg2: leg2,
//       ).then((_) {
//         // Call clearForm after the action plan is saved successfully
//         clearForm(
//           sta1Controller,
//           sta2Controller,
//           mta1Controller,
//           mta2Controller,
//           mta3Controller,
//           mta4Controller,
//           lta1Controller,
//           lta2Controller,
//           leg1Controller,
//           leg2Controller,
//         );
//       });
//     }
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(
//             top: 100.0,
//             left: TSizes.defaultSpace,
//             right: TSizes.defaultSpace,
//             bottom: TSizes.defaultSpace,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 TTexts.actionPlan + ' $weekNumber',
//                 style: TextStyle(
//                   fontSize: 20
//                 ),
//               ),
//               const SizedBox(height: TSizes.spaceBtwSections),
//               const Divider(),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     Textinput(controller: sta1Controller, text: 'STA-1'),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     Textinput(controller: sta2Controller, text: 'STA-2'),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     Textinput(controller: mta1Controller, text: 'MTA-1'),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     Textinput(controller: mta2Controller, text: 'MTA-2'),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     Textinput(controller: mta3Controller, text: 'MTA-3'),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     Textinput(controller: mta4Controller, text: 'MTA-4'),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     Textinput(controller: lta1Controller, text: 'LTA-1'),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     Textinput(controller: lta2Controller, text: 'LTA-2'),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     Textinput(controller: leg1Controller, text: 'LEG-1'),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     Textinput(controller: leg2Controller, text: 'LEG-2'),
//                     const SizedBox(height: TSizes.spaceBtwInputFields),
//                     const SizedBox(height: TSizes.spaceBtwSections),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _submitForm, // Call the submit function
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           foregroundColor: Colors.white,
//                         ),
//                         child: Text(TTexts.submit),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: TSizes.spaceBtwSections),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Textinput extends StatelessWidget {
//   const Textinput({super.key, required this.text, required this.controller});
//
//   final String text;
//   final TextEditingController controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: text,
//         prefixIcon: const Icon(Iconsax.direct_right),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:tea/features/shop/screens/home/home.dart';
import 'package:tea/navigation_menu.dart';
import 'package:tea/utils/constants/sizes.dart';
import 'package:tea/utils/constants/text_strings.dart';
import 'package:tea/features/shop/controllers/ActionPlan/ActionPlanController.dart';
import 'package:tea/utils/popups/loaders.dart';

class AddActionPlan extends StatelessWidget {
  final int weekNumber;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AddActionPlan({required this.weekNumber, super.key});

  void clearForm(List<TextEditingController> controllers) {
    _formKey.currentState?.reset();
    for (var controller in controllers) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final int? userId = box.read('userId');

    final controllers = {
      'STA1': TextEditingController(),
      'STA2': TextEditingController(),
      'MTA1': TextEditingController(),
      'MTA2': TextEditingController(),
      'MTA3': TextEditingController(),
      'MTA4': TextEditingController(),
      'LTA1': TextEditingController(),
      'LTA2': TextEditingController(),
      'LEG1': TextEditingController(),
      'LEG2': TextEditingController(),
    };

    final ActionPlanController _actionPlanController =
        ActionPlanController.instance;

    void _submitForm() {
      _actionPlanController
          .saveActionPlan(
        weekNumber: weekNumber,
        sta1: controllers['STA1']!.text,
        sta2: controllers['STA2']!.text,
        mta1: controllers['MTA1']!.text,
        mta2: controllers['MTA2']!.text,
        mta3: controllers['MTA3']!.text,
        mta4: controllers['MTA4']!.text,
        lta1: controllers['LTA1']!.text,
        lta2: controllers['LTA2']!.text,
        leg1: controllers['LEG1']!.text,
        leg2: controllers['LEG2']!.text,
      )
          .then((_) {
        clearForm(controllers.values.toList());
        Get.offAll(() => NavigationMenu());

      });
    }

    Widget _buildSection(String title, List<String> keys, Color color) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: color),
            ),
          ),
          const SizedBox(height: 8),
          ...keys.map((key) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: TextFormField(
              controller: controllers[key],
              decoration: InputDecoration(
                labelText: key,
                prefixIcon: const Icon(Iconsax.direct_right),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 12),
              ),
            ),
          )),
          const SizedBox(height: 16),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  // GestureDetector(
                  //   onTap: () => Navigator.pop(context),
                  //   child: Container(
                  //     padding: const EdgeInsets.all(8),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white.withOpacity(0.2),
                  //       shape: BoxShape.circle,
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.black26,
                  //           blurRadius: 4,
                  //           offset: Offset(0, 2),
                  //         ),
                  //       ],
                  //     ),
                  //     child: const Icon(
                  //       Icons.arrow_back,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Action Plan - Week $weekNumber',
                        textAlign: TextAlign.center,
                        style: const TextStyle(

                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Space to balance the back button
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildSection('Short-Term Actions', ['STA1', 'STA2'], Colors.blue),
              _buildSection(
                  'Mid-Term Actions', ['MTA1', 'MTA2', 'MTA3', 'MTA4'], Colors.blue),
              _buildSection('Long-Term Actions', ['LTA1', 'LTA2'], Colors.blue),
              _buildSection('Legacy Actions', ['LEG1', 'LEG2'], Colors.blue),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  // icon: const Icon(Icons.save),
                  label: const Text(
                    TTexts.submit,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _submitForm,

                  style:
                  FilledButton.styleFrom(
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
