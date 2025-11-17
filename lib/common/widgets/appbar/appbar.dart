import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:tea/utils/constants/colors.dart';
import 'package:tea/utils/constants/sizes.dart';
import 'package:tea/utils/device/device_utility.dart';
import 'package:tea/utils/helpers/exports.dart';

// class TAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const TAppBar({
//     super.key,
//     this.title,
//     this.leadingIcon,
//     this.action,
//     this.leadingOnPressed,
//     required this.showBackArrow,
//   });
//
//   final Widget? title;
//   final bool showBackArrow;
//   final IconData? leadingIcon;
//   final List<Widget>? action;
//   final VoidCallback? leadingOnPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     final dark = THelperFunctions.isDarkMode(context);
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
//       child:
//        AppBar(
//       centerTitle: true,        // 🔥 Center the title
//       automaticallyImplyLeading: false,
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//
//       leading: showBackArrow
//           ? IconButton(
//         onPressed: () => Get.back(),
//         icon: Icon(
//           Iconsax.arrow_left,
//           color: dark ? TColors.white : TColors.dark,
//         ),
//       )
//           : null,
//
//       title: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
//         child: title,
//       ),
//
//       actions: action,
//     ),
//
//     );
//   }
//
//   @override
//   // TODO: implement preferredSize
//   Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
// }
class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TAppBar({
    super.key,
    this.title,
    this.leadingIcon,
    this.action,
    this.leadingOnPressed,
    required this.showBackArrow,
    this.centerTitle = false,     // 🔥 NEW PARAMETER
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? action;
  final VoidCallback? leadingOnPressed;
  final bool centerTitle;           // 🔥

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,

      centerTitle: centerTitle,    // 🔥 now controlled by param

      leading: showBackArrow
          ? IconButton(
        onPressed: () => Get.back(),
        icon: Icon(
          Iconsax.arrow_left,
          color: dark ? TColors.white : TColors.dark,
        ),
      )
          : leadingIcon != null
          ? IconButton(
        onPressed: leadingOnPressed,
        icon: Icon(
          leadingIcon,
          color: dark ? TColors.white : TColors.dark,
        ),
      )
          : null,

      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: title,

      ),

      actions: action,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}

// class TAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const TAppBar({
//     super.key,
//     this.title,
//     this.leadingIcon,
//     this.action,
//     this.leadingOnPressed,
//     required this.showBackArrow,
//   });
//
//   final Widget? title;
//   final bool showBackArrow;
//   final IconData? leadingIcon;
//   final List<Widget>? action;
//   final VoidCallback? leadingOnPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     final dark = THelperFunctions.isDarkMode(context);
//
//     return AppBar(
//       backgroundColor: Colors.transparent,  // ensure background
//       automaticallyImplyLeading: false,
//       elevation: 0,
//
//       // Add padding **inside**, not outside
//       flexibleSpace: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
//         child: Container(),
//       ),
//
//       leading: showBackArrow
//           ? IconButton(
//         onPressed: () => Get.back(),
//         icon: Icon(Iconsax.arrow_left,
//             color: dark ? TColors.white : TColors.dark),
//       )
//           : leadingIcon != null
//           ? IconButton(
//           onPressed: leadingOnPressed, icon: Icon(leadingIcon))
//           : null,
//
//       title: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
//         child: title,
//       ),
//
//       titleSpacing: 0,
//       actions: action,
//     );
//   }
//
//   @override
//   Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
// }
