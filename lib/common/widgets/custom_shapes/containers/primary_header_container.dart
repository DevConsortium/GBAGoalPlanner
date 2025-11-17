import 'package:flutter/material.dart';
import 'package:tea/utils/constants/sizes.dart';
import '../../../../../utils/constants/colors.dart';
import '../curved_edges/curved_edges_widget.dart';
import 'circular_container.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key,
    required this.child,
    // this.height = 380,
  });

  final Widget child;
  // final double height;

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgesWidget(
      child: Container(
        // height: height, // ✅ Fixed height to prevent unbounded Stack issues
        width: double.infinity,
        decoration: BoxDecoration(
          color: TColors.dashboardAppbarBackground,
        ),
        child: Stack(
          children: [
            /// -- Background Custom Shapes
            Positioned(
              top: -200,
              left: -100,
              child: TCircularContainer(
                backgroundColor: TColors.textWhite.withOpacity(0.1), // ✅ Fixed
              ),
            ),
            Positioned(
              top: 100,
              right: -200,
              child: TCircularContainer(
                backgroundColor: TColors.textWhite.withOpacity(0.1),
              ),
            ),

            /// -- Child Widget (Text, AppBar, etc.)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: child,
            ),

            const SizedBox(height: TSizes.spaceBtwItems,)
          ],
        ),
      ),
    );
  }
}
