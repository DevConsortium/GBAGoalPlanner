import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tea/utils/popups/loaders.dart';
import 'package:tea/utils/constants/image_strings.dart';
import 'package:tea/utils/popups/full_screen_loader.dart';

class EventController extends GetxController {
  static EventController get instance => Get.find();

  // Function to save the event to the server
  Future<void> saveEvent({
    required int weekNumber,
    required String monday,
    required String tuesday,
    required String wednesday,
    required String thursday,
    required String friday,
    required String saturday,
    required String sunday,
  }) async {
    final box = GetStorage();
    final userId = box.read('userId'); // Get userId from storage

    // Prepare the payload for the API request
    Map<String, dynamic> payload = {
      'userId': userId,
      'weekNumber': weekNumber,
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
    };

    try {
      // Show loading indicator while the request is being processed
      TFullScreenLoader.openLoadingDialog('Saving Event...', TImages.docerAnimation);

      final response = await http.post(
        Uri.parse('https://todo.jpsofttechnologies.tech/api/saveEvent'), // Replace with your actual API endpoint
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
          message: data['message'] ?? 'Event saved successfully.',
        );
      } else {
        // If the server responds with an error
        final error = jsonDecode(response.body);
        TLoaders.errorSnackBar(
          title: "Error",
          message: error['message'] ?? 'An error occurred while saving the event.',
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading(); // Stop the loader if an error occurs
      TLoaders.errorSnackBar(
        title: "Exception",
        message: e.toString(),
      );
    }
  }

  // Delete Event
  Future<void> deleteEventById(int eventId) async {
    try {
      // Show loading indicator
      TFullScreenLoader.openLoadingDialog(
        'Deleting Events...',
        TImages.docerAnimation,
      );

      // Make the DELETE request
      final response = await http.delete(
        Uri.parse('https://todo.jpsofttechnologies.tech/api/deleteEventsById/$eventId'),
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

  // Get Today's Event
  Future<String?> fetchEventValue({
    required int userId,
    required int weekNumber,
    required String day,
  }) async {
    final uri = Uri.parse('https://todo.jpsofttechnologies.tech/api/$weekNumber/$day?userId=$userId');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['value']; // This is the actual value of the event for the day
      } else {
        print('Failed to fetch event: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching event: $e');
      return null;
    }
  }
}
