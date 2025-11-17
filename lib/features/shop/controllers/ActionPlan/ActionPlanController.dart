import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tea/utils/popups/full_screen_loader.dart';
import 'package:tea/utils/popups/loaders.dart';
import 'package:tea/utils/constants/image_strings.dart';

class ActionPlanController extends GetxController {
  static ActionPlanController get instance => Get.find();

  Future<void> saveActionPlan({
    required int weekNumber,
    required String sta1,
    required String sta2,
    required String mta1,
    required String mta2,
    required String mta3,
    required String mta4,
    required String lta1,
    required String lta2,
    required String leg1,
    required String leg2,
  }) async {
    final box = GetStorage();
    final userId = box.read('userId');

    // Prepare payload for the API request
    Map<String, dynamic> payload = {
      'userId': userId,
      'weekNumber': weekNumber,
      'sta1': sta1,
      'sta2': sta2,
      'mta1': mta1,
      'mta2': mta2,
      'mta3': mta3,
      'mta4': mta4,
      'lta1': lta1,
      'lta2': lta2,
      'leg1': leg1,
      'leg2': leg2,
    };

    try {
      // Show loading indicator while the request is being processed
      TFullScreenLoader.openLoadingDialog(
        'Saving Action Plan...',
        TImages.docerAnimation,
      );

      final response = await http.post(
        Uri.parse('https://todo.jpsofttechnologies.tech/api/saveActionPlan'),
        // Replace with your actual API endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      TFullScreenLoader.stopLoading();

      // Check for a successful response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Display success message
        TLoaders.successSnackBar(
          title: "Success",
          message: data['message'] ?? 'Action plan saved successfully.',
        );
      } else {
        // If the server responds with an error
        final error = jsonDecode(response.body);
        TLoaders.errorSnackBar(
          title: "Error",
          message:
              error['message'] ??
              'An error occurred while saving the action plan.',
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading(); // Stop the loader if an error occurs
      TLoaders.errorSnackBar(title: "Exception", message: e.toString());
    }
  }


  Future<void> deleteActionPlanById(int actionPlanId) async {
    try {
      // Show loading indicator
      TFullScreenLoader.openLoadingDialog(
        'Deleting Action Plan...',
        TImages.docerAnimation,
      );

      // Make the DELETE request
      final response = await http.delete(
        Uri.parse('https://todo.jpsofttechnologies.tech/api/deleteActionPlan/$actionPlanId'),
      );

      // Stop loader
      TFullScreenLoader.stopLoading();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ Show success message
        TLoaders.successSnackBar(
          title: "Success",
          message: data['message'] ?? 'Action plan deleted successfully.',
        );
      } else {
        final error = jsonDecode(response.body);

        // ❌ Show error from server
        TLoaders.errorSnackBar(
          title: "Error",
          message: error['message'] ?? 'Failed to delete action plan.',
        );
      }
    } catch (e) {
      // Stop loader if exception occurs
      TFullScreenLoader.stopLoading();

      // ❌ Handle unexpected errors
      TLoaders.errorSnackBar(title: "Exception", message: e.toString());
    }
  }

}
