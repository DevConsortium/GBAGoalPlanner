import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tea/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:tea/common/widgets/images/t_rounded_image.dart';
import 'package:tea/features/shop/controllers/home/HomeController.dart';
import 'package:tea/utils/constants/colors.dart';
import 'package:tea/utils/constants/image_strings.dart';
import 'package:tea/utils/constants/sizes.dart';

class TPromoSlider extends StatelessWidget {
  const TPromoSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Column(
      children: [
        CarouselSlider(
          items: [
            // TRoundedImage(imageUrl: TImages.promoBanner7),
            TRoundedImage(imageUrl: TImages.promoBanner6),
            TRoundedImage(imageUrl: TImages.promoBanner4),
            TRoundedImage(imageUrl: TImages.promoBanner5),

            // TRoundedImage(imageUrl: TImages.promoBanner2),
            // TRoundedImage(imageUrl: TImages.promoBanner3),
          ],
          options: CarouselOptions(
            viewportFraction: 1,
            onPageChanged: (index, _) => controller.updatePageIndicator(index)
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Center(
          child: Obx(
            ()=> Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for(int i =0; i<3; i++)
                  TCircularContainer(
                    width: 20,
                    height: 4,
                    margin: EdgeInsets.only(right: 10),
                    backgroundColor: controller.carouselCurrentIndex.value == i ? TColors.primary : TColors.grey,
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
