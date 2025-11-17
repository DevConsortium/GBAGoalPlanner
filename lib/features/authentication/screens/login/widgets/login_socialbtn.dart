import 'package:flutter/material.dart';
import 'package:tea/utils/constants/colors.dart';
import 'package:tea/utils/constants/sizes.dart';
import 'package:tea/utils/constants/image_strings.dart';

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: TColors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              width: TSizes.iconLg,
              height: TSizes.iconMd,
              image: AssetImage(TImages.tGoogleLogo),
            ),
          ),
        ),
      ],
    );
  }
}
