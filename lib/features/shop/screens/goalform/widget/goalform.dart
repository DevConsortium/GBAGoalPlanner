import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tea/features/shop/controllers/Goal/GoalController.dart';
import 'package:tea/navigation_menu.dart';

class GoalForm extends StatefulWidget {
  const GoalForm({super.key});

  @override
  State<GoalForm> createState() => _GoalFormState();
}

class _GoalFormState extends State<GoalForm> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _generateSuggestions() async {
    final box = GetStorage();
    final int? userId = box.read('userId');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found. Please log in again.')),
      );
      return;
    }

    try {
      // 1️⃣ Fetch user information
      final userResponse = await GoalController.instance.getUserDetails(userId);

      if (userResponse == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch user details.')),
        );
        return;
      }

      // 2️⃣ Call AI suggestion API
      final suggestions = await GoalController.instance.generateAISuggestions(userResponse);

      if (suggestions == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate suggestions.')),
        );
        return;
      }

      // 3️⃣ Fill the form automatically
      for (final field in goalFields) {
        final data = suggestions[field];
        if (data != null) {
          _controllers[field]!.text = data['goal'] ?? '';
          _selectedCategories[field] = data['category'];
        }
      }

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('AI Suggestions Applied!')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _clearForm() {
    for (final controller in _controllers.values) {
      controller.clear();
    }

    // Reset dropdowns
    for (final field in goalFields) {
      _selectedCategories[field] = null;
    }

    setState(() {});
  }


  // Categories
  final List<String> categories = [
    'Work',
    'Finance Goal',
    'Lifestyle Goal',
    'Mental Goal',
    'Health Goal',
    'Family and Relationship Goal',
  ];

// Declare and initialize goalFields first
  final List<String> goalFields = [
    'STG1', 'STG2',
    'MTG1', 'MTG2', 'MTG3', 'MTG4', 'MTG5', 'MTG6',
    'LTG1', 'LTG2', 'LTG3', 'LTG4', 'LTG5', 'LTG6',
    'LEG1', 'LEG2',
  ];


// Then use goalFields to initialize controllers and categories
  late final Map<String, TextEditingController> _controllers;
  late final Map<String, String?> _selectedCategories;

  @override
  void initState() {
    super.initState();

    _controllers = {
      for (var field in goalFields) field: TextEditingController()
    };

    _selectedCategories = {
      for (var field in goalFields) field: null
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
  void _submitForm(){
    if (_formKey.currentState!.validate()) {
      final box = GetStorage();
      final int? userId = box.read('userId');

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User ID not found. Please log in again.')),
        );
        return;
      }

      final goalData = {
        for (final field in goalFields)
          field: {
            'goal': _controllers[field]!.text.trim(),
            'category': _selectedCategories[field],
          }
      };

      final payload = {
        'userId': userId,
        'goals': goalData,
      };

      // Send to API
      GoalController.instance.submitGoals(payload);
      _clearForm();
    }
  }



  Widget _buildGoalInput(String fieldName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(fieldName, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controllers[fieldName],
          decoration: const InputDecoration(
            hintText: "Enter goal",
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
          value == null || value.isEmpty ? 'Goal is required' : null,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCategories[fieldName],
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Select category",
          ),
          items: categories
              .map((cat) => DropdownMenuItem(
            value: cat,
            child: Text(cat),
          ))
              .toList(),
          onChanged: (val) {
            setState(() {
              _selectedCategories[fieldName] = val;
            });
          },
          validator: (value) =>
          value == null ? 'Please select a category' : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _generateSuggestions,
                icon: const Icon(Icons.auto_awesome, size: 20, color: Colors.white),
                label: const Text(
                  "Generate AI Suggestions",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: Colors.greenAccent.withOpacity(0.4),
                ),
              ),
            ),

            // ElevatedButton(
            //   onPressed: _generateSuggestions,
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.green,
            //     foregroundColor: Colors.white,
            //   ),
            //   child: const Text("Generate AI Suggestions"),
            // ),
            const SizedBox(height: 16),

            ...goalFields.map(_buildGoalInput),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(

                onPressed: _submitForm,
                child: const Text("Submit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}