import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tea/features/authentication/controller/onboarding_controller.dart';
import 'package:tea/utils/constants/colors.dart';
import 'package:tea/utils/constants/sizes.dart';
import 'package:tea/utils/device/device_utility.dart';
import 'package:tea/utils/helpers/helper_functions.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = THelperFunctions.isDarkMode(context);

    return Positioned(
      bottom: TDeviceUtils.getBottomNavigationBarHeight() + 25,
      left: TSizes.defaultSpace,

      child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        count: 3,
        effect: ExpandingDotsEffect(
          activeDotColor: dark ? TColors.lightGrey : TColors.dark,
          dotHeight: 6,
        ),
      ),
    );
  }
}
