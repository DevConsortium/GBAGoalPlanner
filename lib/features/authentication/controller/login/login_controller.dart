import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tea/features/authentication/screens/login/login.dart';
import 'package:tea/features/shop/screens/goalform/maingoal.dart';
import 'package:tea/navigation_menu.dart';
import 'package:tea/utils/constants/image_strings.dart';
import 'package:tea/utils/popups/full_screen_loader.dart';
import 'package:tea/utils/popups/loaders.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  // Form key
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  // Text controllers
  final email = TextEditingController();
  final password = TextEditingController();

  // Observables
  final hidePassword = true.obs;
  final rememberMe = false.obs;

  // Future<void> loginUser() async {
  //   try {
  //     // Start loader
  //     TFullScreenLoader.openLoadingDialog(
  //       'Logging in...',
  //       TImages.docerAnimation,
  //     );
  //
  //     // Validate form
  //     if (!loginFormKey.currentState!.validate()) {
  //       TFullScreenLoader.stopLoading();
  //       return;
  //     }
  //
  //     // Prepare data
  //     final body = {
  //       'email': email.text.trim(),
  //       'password': password.text.trim(),
  //     };
  //
  //     final response = await http.post(
  //       Uri.parse('https://todo.jpsofttechnologies.tech/api/login'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(body),
  //     );
  //
  //     // Success
  //     if (response.statusCode == 200) {
  //
  //       final data = jsonDecode(response.body);
  //       final user = data['user'];
  //
  //       final box = GetStorage();
  //       box.write('isLoggedIn', true);
  //       box.write('userId', user['id']);
  //       box.write('userName', user['userName']);
  //       box.write('userEmail', user['email']);
  //
  //       box.write('isLoggedIn', true);
  //
  //       // ✅ Stop loader BEFORE showing Snackbar
  //       TFullScreenLoader.stopLoading();
  //
  //       // ✅ Show success Snackbar
  //       await Future.delayed(Duration(milliseconds: 100));
  //       TLoaders.successSnackBar(
  //         title: "Login Successful",
  //         message: "Welcome back!",
  //       );
  //
  //       // ✅ Delay navigation slightly to allow snackbar to finish animating
  //       await Future.delayed(Duration(milliseconds: 300));
  //
  //       // ✅ Navigate
  //       Get.offAll(() => const NavigationMenu());
  //
  //     } else {
  //       // ❌ Don't forget to stop loader on failure
  //       TFullScreenLoader.stopLoading();
  //
  //       final error = jsonDecode(response.body);
  //       TLoaders.errorSnackBar(
  //         title: "Login Failed",
  //         message: error['message'] ?? "Invalid credentials.",
  //       );
  //     }
  //   } catch (e) {
  //     // Stop loader and show error
  //     TFullScreenLoader.stopLoading();
  //
  //     TLoaders.errorSnackBar(
  //       title: 'Error',
  //       message: e.toString(),
  //     );
  //   }
  // }
  Future<void> loginUser() async {
    try {
      // Start loader
      TFullScreenLoader.openLoadingDialog(
        'Logging in...',
        TImages.docerAnimation,
      );

      // Validate form
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Prepare data
      final body = {
        'email': email.text.trim(),
        'password': password.text.trim(),
      };

      final response = await http.post(
        Uri.parse('https://todo.jpsofttechnologies.tech/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['user'];

        final box = GetStorage();
        box.write('isLoggedIn', true);
        box.write('userId', user['id']);
        box.write('userName', user['userName']);
        box.write('userEmail', user['email']);

        // Stop loader before showing snackbar
        TFullScreenLoader.stopLoading();

        // Show success snackbar
        await Future.delayed(const Duration(milliseconds: 100));
        TLoaders.successSnackBar(
          title: "Login Successful",
          message: "Welcome back!",
        );

        // Small delay for snackbar animation
        await Future.delayed(const Duration(milliseconds: 300));

        // ✅ Check if user has goals
        final goalsResponse = await http.get(
          Uri.parse(
            'https://todo.jpsofttechnologies.tech/api/getGoals/${user['id']}',
          ),
        );

        if (goalsResponse.statusCode == 200) {
          final goalsData = jsonDecode(goalsResponse.body);

          if (goalsData != null && goalsData.isNotEmpty) {
            // User has goals → go to NavigationMenu
            Get.offAll(() => const NavigationMenu());
          } else {
            // No goals → go to AddGoalsScreen (replace with your actual screen)
            Get.offAll(() => const Maingoal());
          }
        } else {
          // If API fails, fallback to NavigationMenu
          Get.offAll(() => const NavigationMenu());
        }

      } else {
        TFullScreenLoader.stopLoading();
        final error = jsonDecode(response.body);
        TLoaders.errorSnackBar(
          title: "Login Failed",
          message: error['message'] ?? "Invalid credentials.",
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  // Logout function
  Future<void> logoutUser() async {
    try {
      // Remove all user-related data from GetStorage
      final box = GetStorage();
      await box.remove('isLoggedIn');
      await box.remove('userId');
      await box.remove('userName');
      await box.remove('userEmail');

      // Optionally show a success snack bar
      TLoaders.successSnackBar(
        title: "Logout Successful",
        message: "You have been logged out.",
      );

      // Navigate to login screen (or wherever you need)
      Get.offAll(() => const LoginScreen()); // Replace LoginPage with your actual login page
    } catch (e) {
      // Handle any errors if needed
      TLoaders.errorSnackBar(
        title: 'Logout Failed',
        message: 'An error occurred while logging out.',
      );
    }
  }

}
