// import 'package:flutter/material.dart';
// import 'package:tea/features/shop/screens/score/widget/Allbadges.dart';
// import 'package:tea/features/shop/screens/score/widget/badgesScreen.dart';
//
// class PremiumBadgeBackgroundScreen extends StatelessWidget {
//   final String icon;
//
//   const PremiumBadgeBackgroundScreen({super.key, required this.icon});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: BoxDecoration(
//             gradient: RadialGradient(
//               center: Alignment(0.0, -0.5),
//               radius: 1.2,
//               colors: [
//                 Color(0xFF2C2C2C),
//                 Color(0xFF1C1C1C),
//
//               ],
//             ),
//
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.3),
//                 spreadRadius: 10,
//                 blurRadius: 35,
//                 offset: Offset(0, 10),
//               ),
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.3),
//                 spreadRadius: -5,
//                 blurRadius: 20,
//                 offset: Offset(0, -5),
//               ),
//             ],
//           ),
//           child:
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               FlipScrollImage(icon: icon),
//               Text(
//                 'Congrats!',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'You have just earned a Premium Badge',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white70,
//                 ),
//               ),
//               SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () {
//
//                 },
//                 child: Text("Share"),
//                 style: ElevatedButton.styleFrom(
//
//                   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   elevation: 5,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:tea/features/shop/screens/score/widget/badgesScreen.dart';

class PremiumBadgeBackgroundScreen extends StatefulWidget {
  final String icon;

  const PremiumBadgeBackgroundScreen({super.key, required this.icon});

  @override
  State<PremiumBadgeBackgroundScreen> createState() => _PremiumBadgeBackgroundScreenState();
}

class _PremiumBadgeBackgroundScreenState extends State<PremiumBadgeBackgroundScreen> {
  final GlobalKey _globalKey = GlobalKey();

  Future<void> _captureAndShare() async {
    try {
      // Get render object
      RenderRepaintBoundary boundary =
      _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Capture the image
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save image temporarily
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/shared_badge.png';
      final file = File(imagePath);
      await file.writeAsBytes(pngBytes);

      // Share image
      await Share.shareXFiles([XFile(imagePath)], text: '🎉 I just earned a Premium Badge!');
    } catch (e) {
      debugPrint('Error capturing and sharing: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepaintBoundary(
        key: _globalKey,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              center: Alignment(0.0, -0.5),
              radius: 1.2,
              colors: [
                Color(0xFF2C2C2C),
                Color(0xFF1C1C1C),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 10,
                blurRadius: 35,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlipScrollImage(icon: widget.icon),
              const SizedBox(height: 20),
              const Text(
                'Congrats!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'You have just earned a Premium Badge',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _captureAndShare,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                ),
                child: const Text("Share"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

