import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tea/utils/popups/loaders.dart';
import 'package:tea/utils/popups/full_screen_loader.dart';
import 'package:tea/utils/constants/image_strings.dart';

class ReviewController extends GetxController {
  static ReviewController get instance => Get.find();

  // Function to save the review data to the server
  Future<void> submitReview({
    required int weekNumber,
    required String question1,
    required String question2,
    required String question3,
    required String question4,
    required int rating,
    required String comment,
  }) async {
    final box = GetStorage();
    final userId = box.read('userId'); // Get userId from storage

    // Prepare the payload for the API request
    Map<String, dynamic> payload = {
      'userId': userId,
      'weekNumber': weekNumber,
      'question1': question1,
      'question2': question2,
      'question3': question3,
      'question4': question4,
      'rating': rating,
      'comment': comment,
    };

    try {
      // Show loading indicator while the request is being processed
      TFullScreenLoader.openLoadingDialog(
        'Submitting Review...',
        TImages.docerAnimation,
      );

      final response = await http.post(
        Uri.parse('https://todo.jpsofttechnologies.tech/api/createReview'),
        // Replace with your actual API endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      TFullScreenLoader.stopLoading(); // Stop the loader once the request is done

      // Check for a successful response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Display success message
        TLoaders.successSnackBar(
          title: "Success",
          message: data['message'] ?? 'Review submitted successfully.',
        );
      } else {
        // If the server responds with an error
        final error = jsonDecode(response.body);
        TLoaders.errorSnackBar(
          title: "Error",
          message:
              error['message'] ??
              'An error occurred while submitting the review.',
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading(); // Stop the loader if an error occurs
      TLoaders.errorSnackBar(title: "Exception", message: e.toString());
    }
  }

  // Delete Review
  Future<void> deleteReviewById(int eventId) async {
    try {
      // Show loading indicator
      TFullScreenLoader.openLoadingDialog(
        'Deleting Events...',
        TImages.docerAnimation,
      );

      // Make the DELETE request
      final response = await http.delete(
        Uri.parse('https://todo.jpsofttechnologies.tech/api/deleteReviewById/$eventId'),
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



// Reset Form
  void resetForm() {
    // Reset all form fields to their default values
    question1.value = '';
    question2.value = '';
    question3.value = '';
    question4.value = '';
    comment.value = '';
    selectedRating.value = 0;
  }

  // Reactive variables for the form fields (These should match your form structure)
  var question1 = ''.obs;
  var question2 = ''.obs;
  var question3 = ''.obs;
  var question4 = ''.obs;
  var comment = ''.obs;
  var selectedRating = 0.obs;


}
