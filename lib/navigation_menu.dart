import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:tea/features/shop/screens/home/home.dart';
import 'package:tea/features/shop/screens/notifications/notification.dart';
import 'package:tea/features/shop/screens/profile/profile.dart';
import 'package:tea/features/shop/screens/score/score.dart';
import 'package:tea/features/shop/screens/week/mainweek.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  Future<bool> _onExitConfirmation() async {
    return await Get.dialog(
      AlertDialog(
        title: const Text("Exit App"),
        content: const Text("Are you sure you want to exit?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text("Exit"),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        if (controller.selectedIndex.value > 0) {
          controller.selectedIndex.value--;
          return;
        }

        final shouldExit = await _onExitConfirmation();
        if (shouldExit) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        bottomNavigationBar: Obx(
              () => NavigationBar(
            height: 80,
            elevation: 0,
            backgroundColor: Colors.white,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
            controller.selectedIndex.value = index,
            destinations: const [
              NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
              NavigationDestination(icon: Icon(Iconsax.wallet), label: 'Score'),
              NavigationDestination(icon: Icon(Iconsax.task), label: 'Week'),
              NavigationDestination(icon: Icon(Iconsax.alarm), label: 'Notification'),
              NavigationDestination(
                icon: Icon(Iconsax.profile_2user),
                label: 'Profile',
              ),
            ],
          ),
        ),
        body: Obx(() => controller.screens[controller.selectedIndex.value]),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const ScoreScreen(),
    const MainWeekScreen(),
    const Notifications(),
    const Profile(),
  ];
}
