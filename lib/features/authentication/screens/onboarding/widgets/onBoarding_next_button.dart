import 'package:flutter/material.dart';
import 'package:tea/features/authentication/controller/onboarding_controller.dart';
import 'package:tea/utils/constants/colors.dart';
import 'package:tea/utils/constants/sizes.dart';
import 'package:tea/utils/device/device_utility.dart';
import 'package:tea/utils/helpers/helper_functions.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
      right: TSizes.defaultSpace,
      bottom: TDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: ()=> OnBoardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: dark ? TColors.primary : Colors.black,
        ),
        child: const Icon(Iconsax.arrow_right_3_copy,
        size: 25.0,),
      ),
    );
  }
}
