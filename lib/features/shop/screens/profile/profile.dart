import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:tea/common/widgets/appbar/appbar.dart';
import 'package:tea/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:tea/features/authentication/controller/login/login_controller.dart';
import 'package:tea/features/shop/screens/home/widgets/TSectionHeading.dart';
import 'package:tea/features/shop/screens/profile/widget/TSettingMenuTile.dart';
import 'package:tea/features/shop/screens/profile/widget/TUserProfile.dart';
import 'package:tea/features/shop/screens/score/score.dart';
import 'package:tea/navigation_menu.dart';
import 'package:tea/utils/constants/colors.dart';
import 'package:tea/utils/constants/sizes.dart';
import 'package:url_launcher/url_launcher.dart';


class Profile extends StatelessWidget {
  const Profile({super.key});

  Future<void> openWhatsApp(String phoneNumber, {String message = ""}) async {
    final url = Uri.parse("https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw "Could not launch WhatsApp";
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final box = GetStorage();
    final int? userId = box.read('userId');
    final String? userName = box.read('userName');
    final String? userEmail = box.read('userEmail');
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                    title: Text(
                      'Account',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!              // 🔥 smaller than headlineMedium
                          .apply(
                        color: TColors.white,
                        fontSizeFactor: 1.3,    // 🔥 make it even smaller
                      ),
                    ),
                    showBackArrow: false,
                    centerTitle: true,
                  ),

                  // User Profile
                  TUserProfileTile(userName: userName, userEmail: userEmail),
                  const SizedBox(height: TSizes.spaceBtwItems),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  const TSectionHeading(
                    title: 'Account Settings',
                    showActionButton: false,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  TSettingsMenuTile(
                    icon: Iconsax.discount_shape_copy,
                    title: 'My Score',
                    subtitle: 'List of all discounted coupons',
                    onTap: () {
                      Get.find<NavigationController>().selectedIndex.value = 1;
                    },
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.notification_copy,
                    title: 'Notifications',
                    subtitle: 'See all notifications message',
                    onTap: () {
                      Get.find<NavigationController>().selectedIndex.value = 3;
                    },
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.security_card_copy,
                    title: 'Chat With Experts',
                    subtitle: 'Manage and Achive with Expertise Suggestion',
                    onTap: () => openWhatsApp("918979244576", message: "Hello"),

                  ),

                  SizedBox(height: TSizes.spaceBtwSections),
                  TSectionHeading(
                    title: 'App Settings',
                    showActionButton: false,
                  ),
                  SizedBox(height: TSizes.spaceBtwItems),
                  TSettingsMenuTile(
                    icon: Iconsax.document_upload_copy,
                    title: 'Weeks data',
                    subtitle: 'Recheck your weeks data',
                    onTap: () {
                      Get.find<NavigationController>().selectedIndex.value = 2;
                    },
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.location_copy,
                    title: 'Geo Location',
                    subtitle: 'Allow app to fetch user location',
                    // trailing: Switch(value: false, onChanged: (value) {}),
                  ),

                  // logout Button
                  const SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child:
                    FilledButton.icon(
                      onPressed: () => controller.logoutUser(),
                      icon: const Icon(Icons.logout, size: 20, color: Colors.white),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3, // Gives a subtle modern shadow
                      ),
                    )


                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
