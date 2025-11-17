import 'package:flutter/material.dart';
import 'package:tea/common/widgets/appbar/appbar.dart';
import 'package:tea/utils/constants/colors.dart';
import 'package:tea/utils/constants/text_strings.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            TTexts.homeAppbarTitle,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.apply(color: TColors.white, fontSizeDelta: 10),
          ),
          Text(
            TTexts.homeAppbarSubTitle,
            style: Theme.of(
              context,
            ).textTheme.labelMedium!.apply(color: TColors.white),
          ),
        ],
      ), showBackArrow: false,

    );
  }
}
