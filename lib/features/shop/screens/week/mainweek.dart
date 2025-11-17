import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tea/common/widgets/appbar/appbar.dart';
import 'package:tea/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:tea/features/shop/screens/week/weeknavigation.dart';
import 'package:tea/utils/constants/colors.dart';

class MainWeekScreen extends StatefulWidget {
  const MainWeekScreen({super.key});

  @override
  _MainWeekScreenState createState() => _MainWeekScreenState();
}

class _MainWeekScreenState extends State<MainWeekScreen> {
  bool isTileView = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  TAppBar(
                    title: Text(
                      'Weekly Goal Planner',
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
                  const SizedBox(height: 4),
                  Text(
                    'Your Goals',
                    style: Theme.of(context).textTheme.labelMedium!.apply(
                      color: TColors.lightGrey,
                      fontSizeDelta: 10,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 12),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isTileView = !isTileView;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          height: 30,
                          width: 80,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            gradient: LinearGradient(
                              colors: [
                                isTileView ? const Color(0xFF0072FF) : const Color(0xFF6D6D6D),
                                isTileView ? const Color(0xFF00C6FF) : const Color(0xFFB0B0B0),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Labels
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "Tile",
                                        style: TextStyle(
                                          color: isTileView ? Colors.white : Colors.white70,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "Box",
                                        style: TextStyle(
                                          color: !isTileView ? Colors.white : Colors.white70,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Moving toggle circle
                              AnimatedAlign(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                                alignment:
                                isTileView ? Alignment.centerLeft : Alignment.centerRight,
                                child: Container(
                                  width: 35,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Icon(
                                      isTileView
                                          ? Icons.grid_view_rounded
                                          : Icons.view_agenda_rounded,
                                      color: isTileView
                                          ? const Color(0xFF0072FF)
                                          : const Color(0xFF6D6D6D),
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
            isTileView ? WeekTile(theme: theme) : WeekBox(theme: theme),
          ],
        ),
      ),
    );
  }
}

class WeekTile extends StatelessWidget {
  const WeekTile({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 52,
        itemBuilder: (context, index) {
          final weekNumber = index + 1;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Material(
              color: TColors.primary,
              borderRadius: BorderRadius.circular(12),
              elevation: 4,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Get.to(() => WeekNavigationScreen(weekNumber)),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: TColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: TColors.white,
                        size: 24.0,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Week $weekNumber",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: TColors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class WeekBox extends StatelessWidget {
  const WeekBox({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 30,
            childAspectRatio: 1,
          ),
          itemCount: 52,
          itemBuilder: (context, index) {
            final weekNumber = index + 1;
            return Material(
              color: TColors.primary,
              borderRadius: BorderRadius.circular(12),
              elevation: 4,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Get.to(() => WeekNavigationScreen(weekNumber)),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: TColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: TColors.white,
                        size: 20.0,
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Week $weekNumber",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: TColors.white,
                            fontSize: 10.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
