import 'package:flutter/material.dart';

class PercentageProgress extends StatelessWidget {
  final double percentage;

  PercentageProgress({required this.percentage});

  @override
  Widget build(BuildContext context) {

    Color progressColor;
    if (percentage > 75) {
      progressColor = Colors.green;
    }
    else if (percentage > 50) {
      progressColor = Colors.blue;
    }
    // else if (percentage > 45) {
    //   progressColor = Colors.yellow;
    // }
    else {
      progressColor = Colors.red;
    }

    return Center(
      child: Container(
        width: 150,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
           CircularProgressIndicator(
              value: percentage / 100,
              strokeWidth: 5.0,
              valueColor: AlwaysStoppedAnimation(progressColor),
            ),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: progressColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
