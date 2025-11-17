import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tea/features/authentication/screens/onboarding/onboarding.dart';
import 'package:tea/navigation_menu.dart';

class EntryPoint extends StatelessWidget {
  EntryPoint({Key? key}) : super(key: key);

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = box.read('isLoggedIn') ?? false;

    if (isLoggedIn) {
      return const NavigationMenu();
    } else {
      return OnBoardingScreen();
    }
  }
}
