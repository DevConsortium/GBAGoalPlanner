import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tea/features/shop/screens/home/home.dart';
import 'package:tea/navigation_menu.dart';
import 'package:tea/utils/constants/colors.dart';


class ProgressSlider extends StatefulWidget {
  final double initialProgress;
  final int goalId;

  const ProgressSlider({Key? key, required this.initialProgress, required this.goalId}) : super(key: key);

  @override
  _ProgressSliderState createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<ProgressSlider> {
  double _progress = 0.0;
  int _goalId = 0;

  final userId = GetStorage().read('userId');

  @override
  void initState() {
    super.initState();
    _progress = widget.initialProgress;
    _goalId = widget.goalId;
  }

  void _handleSubmit() async {
    final percentage = (_progress * 100).toStringAsFixed(0);
    final url = Uri.parse('https://todo.jpsofttechnologies.tech/api/goals/$userId/$_goalId');
    final controller = Get.put(NavigationController());

    print('Progress Submitted: $percentage%');
    print('User ID: $userId');
    print('Goal ID: $_goalId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'percentage': double.parse(percentage),
        }),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop(true);


        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Progress updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print('Failed to update: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update progress'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating progress')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Progress: ${(_progress * 100).toStringAsFixed(0)}%',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,           // Color of the filled portion
              inactiveTrackColor: Colors.white.withOpacity(0.3), // Unfilled portion
              thumbColor: Colors.blueAccent,                 // Circle color
              overlayColor: Colors.deepPurple.withOpacity(0.2), // Ripple effect when sliding
              valueIndicatorColor: Colors.blue,        // Tooltip background
            ),
            child: Slider(
              value: _progress,
              min: 0.0,
              max: 1.0,
              divisions: 100,
              label: '${(_progress * 100).toStringAsFixed(0)}%',
              onChanged: (double value) {
                setState(() {
                  _progress = value;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: InkWell(
              onTap: _handleSubmit,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C4DFF), Color(0xFF651FFF)], // Deep purple tones
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurpleAccent.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Update Progress',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
