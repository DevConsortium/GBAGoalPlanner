import 'package:flutter/material.dart';

class RibbonBanner extends StatelessWidget {
  final String text;

  const RibbonBanner({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -20,
            top: 20,
            child: TriangleWidget(isLeft: true),
          ),
          Positioned(
            right: -20,
            top: 20,
            child: TriangleWidget(isLeft: false),
          ),
          Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TriangleWidget extends StatelessWidget {
  final bool isLeft;
  const TriangleWidget({required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(20, 20),
      painter: TrianglePainter(isLeft: isLeft),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final bool isLeft;
  TrianglePainter({required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final path = Path();
    if (isLeft) {
      path.moveTo(0, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(0, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}