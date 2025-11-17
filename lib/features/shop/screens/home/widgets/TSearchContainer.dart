import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:tea/utils/constants/colors.dart';
import 'package:tea/utils/constants/sizes.dart';
import 'package:tea/utils/device/device_utility.dart';
import 'package:tea/utils/helpers/exports.dart';

// class TSearchContainer extends StatefulWidget {
//   const TSearchContainer({
//     super.key,
//     required this.text,
//     this.icon = Iconsax.search_normal_1_copy,
//     this.showBackground = true,
//     this.showBorder = true,
//     required this.onSearch,
//   });
//
//   final String text;
//   final IconData? icon;
//   final bool showBackground, showBorder;
//   final Function(String query) onSearch;
//
//   @override
//   _TSearchContainerState createState() => _TSearchContainerState();
// }
//
// class _TSearchContainerState extends State<TSearchContainer> {
//   TextEditingController _controller = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller.text = widget.text;
//   }
//
//   void _handleSearch(String query) {
//
//     widget.onSearch(query);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final dark = THelperFunctions.isDarkMode(context);
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 0),
//       child: Container(
//         width: TDeviceUtils.getScreenWidth(context),
//         padding: const EdgeInsets.all(TSizes.md),
//         decoration: BoxDecoration(
//           color: widget.showBackground
//               ? dark
//               ? TColors.dark
//               : TColors.white
//               : Colors.transparent,
//           borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
//           border: widget.showBorder ? Border.all(color: TColors.grey) : null,
//         ),
//         child: Row(
//           children: [
//             Icon(widget.icon, color: TColors.darkGrey),
//             const SizedBox(width: TSizes.spaceBtwItems),
//
//             Expanded(
//               child: TextField(
//                 controller: _controller,
//                 onChanged: (query) => _handleSearch(query),
//                 decoration: InputDecoration(
//                   hintText: widget.text,
//                   border: InputBorder.none,
//                   hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: TColors.grey,
//                   ),
//                 ),
//               ),
//             ),
//
//             if (_controller.text.isNotEmpty)
//               IconButton(
//                 icon: Icon(Icons.clear, color: TColors.darkGrey),
//                 onPressed: () {
//                   setState(() {
//                     _controller.clear();
//                   });
//                   widget.onSearch('');
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:tea/utils/constants/colors.dart';
import 'package:tea/utils/constants/sizes.dart';
import 'package:tea/utils/device/device_utility.dart';
import 'package:tea/utils/helpers/exports.dart';

class TSearchContainer extends StatefulWidget {
  const TSearchContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.search_normal_1_copy,
    this.showBackground = true,
    this.showBorder = true,
    required this.onSearch,
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final Function(String query) onSearch;

  @override
  _TSearchContainerState createState() => _TSearchContainerState();
}

class _TSearchContainerState extends State<TSearchContainer> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.text;
  }

  void _handleSearch(String query) {
    widget.onSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        width: TDeviceUtils.getScreenWidth(context),
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          color: widget.showBackground
              ? (dark ? TColors.dark : TColors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          border: widget.showBorder ? Border.all(color: TColors.grey) : null,
        ),
        child: Row(
          children: [
            Icon(widget.icon, color: TColors.darkGrey),
            const SizedBox(width: TSizes.spaceBtwItems),
            Expanded(
              child: SizedBox(
                height: 40,
                child: Center(
                  child: TextField(
                    controller: _controller,
                    cursorColor: TColors.darkGrey,
                    onChanged: _handleSearch,
                    style: Theme.of(context).textTheme.bodySmall,
                    decoration: InputDecoration(
                      hintText: widget.text,
                      hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: TColors.grey,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,

                      isCollapsed: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),

            if (_controller.text.isNotEmpty)
              IconButton(
                icon: Icon(Icons.clear, color: TColors.darkGrey),
                onPressed: () {
                  setState(() {
                    _controller.clear();
                  });
                  widget.onSearch('');
                },
              ),
          ],
        ),
      ),
    );
  }
}
