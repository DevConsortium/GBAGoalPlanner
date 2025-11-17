import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tea/navigation_menu.dart';
import 'package:tea/utils/constants/image_strings.dart';
import 'package:tea/utils/popups/full_screen_loader.dart';
import 'package:tea/utils/popups/loaders.dart';


class GoalController extends GetxController {
  static GoalController get instance => Get.find();

  Future<void> submitGoals(Map<String, dynamic> payload) async {
    try {
      TFullScreenLoader.openLoadingDialog('Submitting goals...', TImages.docerAnimation);

      final response = await http.post(
        Uri.parse('https://todo.jpsofttechnologies.tech/api/createGoals'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      TFullScreenLoader.stopLoading();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        TLoaders.successSnackBar(
          title: "Success",
          message: data['message'] ?? 'Goals submitted successfully.',
        );

        Get.off(() => const NavigationMenu());
      }
      else {
        final error = jsonDecode(response.body);
        TLoaders.errorSnackBar(
          title: "Error",
          message: error['message'] ?? 'Something went wrong.',
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "Exception", message: e.toString());
    }
  }

  Future<Map<String, dynamic>?> getUserDetails(int userId) async {
    final url = "https://todo.jpsofttechnologies.tech/api/getUserById/$userId";

    final response = await http.get(Uri.parse(url));
    print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<Map<String, dynamic>?> generateAISuggestions(Map<String, dynamic> user) async {
    final aiUrl = "https://todo.jpsofttechnologies.tech/api/aigoals";

    final response = await http.post(
      Uri.parse(aiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "firstName": user['firstName'],
        "lastName": user['lastName'],
        "userName": user['userName'],
        "email": user['email'],
        "phone": user['phone'],
        "domain": user['domain'],
        "post": user['post'],
        "industry": user['industry'],
        "income": user['income'],
        "priority": user['priority'],
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['goals'];
    }

    return null;
  }



}