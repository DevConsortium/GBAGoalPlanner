import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tea/features/authentication/screens/login/login.dart';
import 'package:tea/utils/constants/image_strings.dart';
import 'package:tea/utils/popups/full_screen_loader.dart';
import 'package:tea/utils/popups/loaders.dart';

class SignupController extends GetxController{
  static SignupController get instance => Get.find();

  // varialbles
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
final email = TextEditingController();
final lastName = TextEditingController();
final userName = TextEditingController();
final password = TextEditingController();
final firstName = TextEditingController();
final phoneNumber = TextEditingController();
  final domain = TextEditingController();
  final post = TextEditingController();
  final industry = TextEditingController();
  final income = TextEditingController();
  final priority = TextEditingController();

GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();


  Future<void> signup() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog('We are processing your information...', TImages.docerAnimation);

      // Form Validation
      if(!signupFormKey.currentState!.validate()) return;

      // Privacy Policy Check
      if(!privacyPolicy.value){
        TLoaders.warningSnackBar(
            title: 'Accept Privacy Policy',
            message: 'In order to create account, you must have accept the Privacy Policy & Terms of Use.'
        );
        return;

      }

      // Simulate signup processing delay (e.g., calling API)
      // await Future.delayed(const Duration(seconds: 2));

      // Register user
      // Prepare payload
      final Map<String, String> userData = {
        "firstName": firstName.text.trim(),
        "lastName": lastName.text.trim(),
        "userName": userName.text.trim(),
        "email": email.text.trim(),
        "phone": phoneNumber.text.trim(),
        "password": password.text.trim(),
        "domain": domain.text.trim(),
        "post": post.text.trim(),
        "industry": industry.text.trim(),
        "income": income.text.trim(),
        "priority": priority.text.trim()

      };

      // Make HTTP POST request
      final response = await http.post(
        Uri.parse('https://todo.jpsofttechnologies.tech/api/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      );

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final data = jsonDecode(response.body);
          TLoaders.successSnackBar(
            title: "Signup Successful",
            message: data['message'] ?? 'Account created successfully.',
          );
          clearForm();
          Future.delayed(Duration(seconds: 1), () {
            Get.off(() => const LoginScreen()); // or Get.to() if you want to keep previous screen in stack
          });
        } catch (e) {
          TLoaders.errorSnackBar(
            title: "Parse Error",
            message: "Invalid response format: ${response.body}",
          );
        }
      } else {
        try {
          final error = jsonDecode(response.body);
          TLoaders.errorSnackBar(
            title: "Signup Failed",
            message: error['message'] ?? 'Something went wrong.',
          );
        } catch (e) {
          TLoaders.errorSnackBar(
            title: "Error",
            message: "Unexpected error: ${response.body}",
          );
        }
      }



      // Save Authentication

      // Show Success Message



    }catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());

    } finally {
      TFullScreenLoader.stopLoading();
    }
  }
  // domain, post, industry, income, priority
  void clearForm() {
    firstName.clear();
    lastName.clear();
    userName.clear();
    email.clear();
    phoneNumber.clear();
    password.clear();
    domain.clear();
    post.clear();
    industry.clear();
    income.clear();
    priority.clear();
    privacyPolicy.value = false;
  }

}