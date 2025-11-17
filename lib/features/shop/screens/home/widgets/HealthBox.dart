import 'package:flutter/material.dart';

class HealthBox extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String event;

  HealthBox({
    required this.color,
    required this.icon,
    required this.title,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        // height: 170,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon at the top of the box
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(icon, color: color, size: 30),
                radius: 25,
              ),
              SizedBox(width: 12),
              // Title of the box (e.g., Physical Health)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$event',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),

              Spacer(),
              // Arrow icon pointing up-right
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.access_alarm,
                  size: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
