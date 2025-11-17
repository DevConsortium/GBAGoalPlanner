import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tea/features/shop/screens/score/widget/Premiumbg.dart';

class Badge {
  final int id;
  final String name;
  final String icon;
  final String description;
  final int unlocked;

  Badge({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.unlocked,
  });

  String getAssetPath() {
    return "assets/images/brands/$icon.png";
  }

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      description: json['description'],
      unlocked: json['unlocked'] ?? 0,
    );
  }
}

Future<List<Badge>> fetchBadges(String userId) async {
  final url = Uri.parse('https://todo.jpsofttechnologies.tech/api/badges');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    List<dynamic> badgesList = jsonData['badges'] ?? [];

    return badgesList.map((e) => Badge.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load badges');
  }
}

class AllbadgesScreen extends StatelessWidget {
  final String userId;
  final int score;
  const AllbadgesScreen({super.key, required this.userId, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Title Box
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your Badges',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Badge Grid Box
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2C2C2C), Color(0xFF1C1C1C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 15,
                        offset: Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child:
                  FutureBuilder<List<Badge>>(
                    future: fetchBadges(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                'Error: ${snapshot.error}',
                                style: TextStyle(color: Colors.white)));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No badges yet.',
                                style: TextStyle(color: Colors.white)));
                      }

                      final badges = snapshot.data!;

                      return GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: badges.length,
                        itemBuilder: (context, index) {
                          final badge = badges[index];
                          return GestureDetector(
                            onTap: () {
                              if (score >= badge.unlocked ) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PremiumBadgeBackgroundScreen(icon: badge.icon),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${badge.name}: ${badge.description}",
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: score >= badge.unlocked
                                    ? Colors.grey
                                    : Colors.grey[800],
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: score >= badge.unlocked
                                          ? null
                                          : Border.all(color: Colors.grey),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            badge.getAssetPath()),
                                        fit: BoxFit.cover,
                                        colorFilter: score >= badge.unlocked
                                            ? null
                                            : ColorFilter.mode(
                                          Colors.grey,
                                          BlendMode.saturation,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    badge.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: score >= badge.unlocked
                                          ? Colors.black
                                          : Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
