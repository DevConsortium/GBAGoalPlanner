import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:tea/utils/constants/colors.dart';
import 'package:tea/utils/constants/image_strings.dart';

import 'package:tea/utils/constants/sizes.dart';
import 'package:tea/utils/constants/text_strings.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(height: 150, image: AssetImage(TImages.tLogoImage)),
        Text(
          TTexts.tLoginTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: TSizes.fontSizeSm),
        Text(
          TTexts.tLoginSubTitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
