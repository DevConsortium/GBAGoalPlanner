import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:tea/common/widgets/appbar/appbar.dart';
import 'package:tea/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:tea/features/shop/screens/home/widgets/PercentageProgress.dart';
import 'package:tea/features/shop/screens/score/widget/Allbadges.dart';
import 'package:tea/features/shop/screens/score/widget/Premiumbg.dart';
import 'package:tea/features/shop/screens/score/widget/StatsGrid.dart';
import 'package:tea/features/shop/screens/score/widget/badgesScreen.dart';
import 'package:tea/utils/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  Future<Map<String, dynamic>?> fetchCompletedGoals() async {
    final userId = GetStorage().read('userId');
    final url = Uri.parse(
      'https://todo.jpsofttechnologies.tech/api/countCompletedGoals/$userId',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null) {
        return data;
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load completed goals');
    }
  }

  Future<Map<String, dynamic>?> fetchTopGoalCategory() async {
    final userId = GetStorage().read('userId');
    final url = Uri.parse(
      'https://todo.jpsofttechnologies.tech/api/getTopGoalCategory?userId=$userId',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return {
          'category': data['data']['category'],
          'count': data['data']['count'],
        };
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load top goal category');
    }
  }

  Future<Map<String, dynamic>?> fetchTotalScore() async {
    final userId = GetStorage().read('userId');
    final url = Uri.parse(
      'https://todo.jpsofttechnologies.tech/api/getTotalScore?userId=$userId',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return {
          'score': data['data']['score'],
          'completedGoals': data['data']['completedGoals'],
        };
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load top goal score');
    }
  }

  Future<List<Map<String, dynamic>>> fetchGoalCategoryCounts() async {
    final userId = GetStorage().read('userId');
    final url = Uri.parse(
      'https://todo.jpsofttechnologies.tech/api/getGoalCategoryCounts?userId=$userId',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true && data['data'].isNotEmpty) {
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load goal category counts');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = GetStorage().read('userId').toString();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.white, TColors.iconPrimaryLight],
            ),
          ),
          child: Column(
            children: [
              TPrimaryHeaderContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TAppBar(

                      title: Text(
                        'Check Your Score',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!              // 🔥 smaller than headlineMedium
                            .apply(
                          color: TColors.white,
                          fontSizeFactor: 1.3,    // 🔥 make it even smaller
                        ),
                      ),
                      showBackArrow: false,
                      centerTitle: true,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'GBA Goal Planner',
                      style: Theme.of(context).textTheme.bodySmall!.apply(
                        color: TColors.grey10,
                        fontSizeDelta: 10,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // just this
                    FutureBuilder<Map<String, dynamic>?>(
                      future: fetchTotalScore(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error loading score'));
                        } else if (snapshot.hasData && snapshot.data != null) {
                          final score = snapshot.data!['score'] ?? 0;

                          // Pass the score to FuelCard as targetProgress
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: FuelCard(targetProgress: score / 100),
                          );
                        } else {
                          return Center(child: Text('No data available'));
                        }
                      },
                    ),
                    // card ends

                    // Score Section
                    FutureBuilder<Map<String, dynamic>?>(
                      future: fetchTotalScore(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('Error loading your Score'),
                          );
                        } else if (snapshot.hasData && snapshot.data != null) {
                          final score = snapshot.data!['score'];
                          final completedGoals =
                              snapshot.data!['completedGoals'];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8,
                            ),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.indigo.shade500,
                                      Colors.blue.shade400,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: PercentageProgress(
                                            percentage:
                                                completedGoals * 100 / 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'You have achieved $completedGoals of 16 goals',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'Total Score: $score',
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('No top category yet.'),
                          );
                        }
                      },
                    ),

                    // Top Category Section
                    FutureBuilder<Map<String, dynamic>?>(
                      future: fetchTopGoalCategory(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('Error loading top category'),
                          );
                        } else if (snapshot.hasData && snapshot.data != null) {
                          final category = snapshot.data!['category'];
                          final count = snapshot.data!['count'];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.indigo.shade500,
                                    Colors.blue.shade400,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.ac_unit,
                                        color: TColors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Your Goals are oriented towards:',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '$category: $count',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),

                                          SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('No top category yet.'),
                          );
                        }
                      },
                    ),

                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              Colors.indigo.shade500,
                              Colors.blue.shade400,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child:
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              // important for gradient
                              shadowColor: Colors.transparent,
                              // remove default shadow
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.blue[900]!,
                                  width: 1,
                                ),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                            onPressed: ()async {
                              final result = await fetchTotalScore();
                              final score = result?['score'] ?? 0;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AllbadgesScreen(userId: userId, score: score),
                                ),
                              );
                            },
                            child: const Text("View Badges"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


class FuelCard extends StatefulWidget {
  final double targetProgress;

  FuelCard({required this.targetProgress});

  @override
  _FuelCardState createState() => _FuelCardState();
}

class _FuelCardState extends State<FuelCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late double targetProgress;
  GlobalKey _repaintKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    targetProgress = (widget.targetProgress * 100).toInt().toDouble() / 100;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: targetProgress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _repaintKey,
      child: Card(
        color: Colors.white,
        // color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('mark start'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 30,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Score: ${(widget.targetProgress * 100).toInt()}/100',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Center(
                child: SizedBox(
                  height: 150,
                  width: 250,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: FuelMeterPainter(_animation.value),
                      );
                    },
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${(widget.targetProgress * 100).toInt()}% Achieved',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Keep Going',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NutrientInfo(label: 'STA', total: 2),
                  NutrientInfo(label: 'MTA', total: 6),
                  NutrientInfo(label: 'LTA', total: 6),
                  NutrientInfo(label: 'LEG', total: 2),
                ],
              ),
              StatsGrid(),
              // Text('mark end'),

              SizedBox(height: 16),

              // Share Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Colors.indigo.shade500,
                        Colors.blue.shade400,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child:
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        // important for gradient
                        shadowColor: Colors.transparent,
                        // remove default shadow
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.blue[900]!,
                            width: 1,
                          ),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      onPressed: _captureAndShare,
                      child: const Text("Share Score"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Capture screenshot and share functionality
  // void _captureAndShare() async {
  //   try {
  //     // Wait for the current frame to finish rendering
  //     await Future.delayed(const Duration(milliseconds: 100));
  //     await WidgetsBinding.instance.endOfFrame;
  //
  //     // Now capture the image safely
  //     RenderRepaintBoundary boundary =
  //     _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //
  //     // Ensure it's painted before capturing
  //     if (boundary.debugNeedsPaint) {
  //       await Future.delayed(const Duration(milliseconds: 20));
  //       return _captureAndShare(); // try again after painting
  //     }
  //
  //     var image = await boundary.toImage(pixelRatio: 3.0);
  //     ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
  //     Uint8List uint8List = byteData!.buffer.asUint8List();
  //
  //     final directory = await getApplicationDocumentsDirectory();
  //     final file = File('${directory.path}/screenshot.png');
  //     await file.writeAsBytes(uint8List);
  //
  //     // Share.shareFiles([file.path], text: 'Check out my progress!');
  //     Share.shareXFiles([XFile(file.path)], text: 'Check out my progress!');
  //
  //   } catch (e) {
  //     print('Error capturing screenshot: $e');
  //   }
  // }
  void _captureAndShare() async {
    try {
      // Wait for the UI frame to finish rendering
      await Future.delayed(const Duration(milliseconds: 300));
      await WidgetsBinding.instance.endOfFrame;

      RenderRepaintBoundary boundary =
      _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Use temp directory (works on all devices)
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/share_score.png';
      final file = File(filePath);

      await file.writeAsBytes(pngBytes, flush: true);

      final xfile = XFile(
        file.path,
        mimeType: 'image/png',
      );

      await Share.shareXFiles([xfile], text: "Check out my progress!");

    } catch (e) {
      print("Share Error: $e");
    }
  }


}


class FuelMeterPainter extends CustomPainter {
  final double progress;

  FuelMeterPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trackPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 30
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 30
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height);
    double radius = size.width / 2;

    Rect rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = math.pi;
    double sweepAngle = math.pi;

    canvas.drawArc(rect, startAngle, sweepAngle, false, trackPaint);

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


class NutrientInfo extends StatelessWidget {
  final String label;
  final int total;

  NutrientInfo({required this.label, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              children: [

                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Optional Banner on top-right
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$total',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class HealthBox extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String progress;
  final int goal;

  HealthBox({
    required this.color,
    required this.icon,
    required this.title,
    required this.progress,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(icon, color: color, size: 25),
              radius: 20,
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              '$progress/$goal',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
