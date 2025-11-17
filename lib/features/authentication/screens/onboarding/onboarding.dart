import 'package:flutter/material.dart';
import 'package:tea/features/authentication/controller/onboarding_controller.dart';
import 'package:tea/features/authentication/screens/onboarding/widgets/onBoarding_next_button.dart';
import 'package:tea/features/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:tea/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:tea/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';

import 'package:tea/utils/constants/image_strings.dart';
import 'package:tea/utils/constants/text_strings.dart';
import 'package:get/get.dart';



class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          // Horizontal Scrollable Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: TImages.tOnBoardingImage1,
                title: TTexts.tOnBoardingTitle1,
                subtitle: TTexts.tOnBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: TImages.tOnBoardingImage2,
                title: TTexts.tOnBoardingTitle2,
                subtitle: TTexts.tOnBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: TImages.tOnBoardingImage3,
                title: TTexts.tOnBoardingTitle3,
                subtitle: TTexts.tOnBoardingSubTitle3,
              ),
            ],
          ),
          // Skip Button
          const OnBoardingSkip(),

          // Dot Navigation SmoothIndicator
          const OnBoardingDotNavigation(),

          // Circular Button
          const OnBoardingNextButton(),
        ],
      ),
    );

  }
}

