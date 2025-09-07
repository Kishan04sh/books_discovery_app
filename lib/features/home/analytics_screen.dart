import 'package:auto_route/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../../core/app_colors.dart';

@RoutePage()
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  /// **********************************************

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// ********************************************************

  Widget _animatedCard({required Widget child, int delay = 0}) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(delay / 10, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: child,
      ),
    );
  }

  /// *********************************************************

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: ListView(
        children: [
          StickyHeader(
            header: _buildHeader(),
            content: Column(
              children: [
                _animatedCard(child: _buildGenreDistribution(), delay: 1),
                _animatedCard(child: _buildBookPublishingTrend(), delay: 2),
                _animatedCard(child: _buildSalesOverview(), delay: 3),
                _animatedCard(child: _buildMeetupCard(), delay: 4),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ***********************************************Top Sticky Header
  Widget _buildHeader() {
    final user = FirebaseAuth.instance.currentUser;
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, ${user?.displayName ?? "No name"}",
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Let's start learning",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          CircleAvatar(
            radius: 35,
            backgroundColor:AppColors.primary,
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL!)
                : null,
            child: user?.photoURL == null
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),

        ],
      ),
    );
  }

  ///************************************** Genre Distribution (Pie/Donut Chart)
  // Widget _buildGenreDistribution() {
  //   return _cardWrapper(
  //     bgColor: AppColors.offWhite,
  //     title: "Genre Distribution",
  //     child: SizedBox(
  //       height: 180,
  //       child: PieChart(
  //         PieChartData(
  //           sectionsSpace: 4,
  //           centerSpaceRadius: 40,
  //           startDegreeOffset: 270,
  //           sections: [
  //             PieChartSectionData(value: 25, color: Colors.indigo, radius: 40, title: "Fiction"),
  //             PieChartSectionData(value: 20, color: Colors.blue, radius: 40, title: "Non-fiction"),
  //             PieChartSectionData(value: 15, color: Colors.greenAccent, radius: 40, title: "Romance"),
  //             PieChartSectionData(value: 20, color: Colors.orange, radius: 40, title: "Sci-fi"),
  //             PieChartSectionData(value: 10, color: Colors.purple, radius: 40, title: "Thriller"),
  //             PieChartSectionData(value: 10, color: Colors.teal, radius: 40, title: "Biography"),
  //           ],
  //         ),
  //         swapAnimationDuration: const Duration(milliseconds: 800),
  //         swapAnimationCurve: Curves.easeInOut,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildGenreDistribution() {
    final sections = [
      {"value": 25.0, "color": Colors.indigo, "label": "Fiction"},
      {"value": 20.0, "color": Colors.blue, "label": "Non-fiction"},
      {"value": 15.0, "color": Colors.greenAccent, "label": "Romance"},
      {"value": 20.0, "color": Colors.orange, "label": "Sci-fi"},
      {"value": 10.0, "color": Colors.purple, "label": "Thriller"},
      {"value": 10.0, "color": Colors.teal, "label": "Biography"},
    ];

    return _cardWrapper(
      bgColor: AppColors.offWhite,
      title: "Genre Distribution",
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                  startDegreeOffset: 270,
                  sections: sections
                      .map(
                        (e) => PieChartSectionData(
                      value: e["value"] as double,
                      color: e["color"] as Color,
                      radius: 40,
                      title: "",
                    ),
                  )
                      .toList(),
                ),
                swapAnimationDuration: const Duration(milliseconds: 800),
                swapAnimationCurve: Curves.easeInOut,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Custom legend
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: sections.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: e["color"] as Color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      e["label"] as String,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }


  /// Book Publishing Trend (Line Chart) **********************************
  Widget _buildBookPublishingTrend() {
    return _cardWrapper(
      title: "Book Publishing Trend (2021–2025)",
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const years = ["", "2021", "2022", "2023", "2024", "2025"];
                    return Text(years[value.toInt()]);
                  },
                ),
              ),
            ),
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(1, 3),
                  FlSpot(2, 4),
                  FlSpot(3, 3.5),
                  FlSpot(4, 5),
                  FlSpot(5, 4.8),
                ],
                isCurved: true,
                color: Colors.teal,
                barWidth: 3,
              ),
              LineChartBarData(
                spots: const [
                  FlSpot(1, 2.5),
                  FlSpot(2, 3),
                  FlSpot(3, 3.8),
                  FlSpot(4, 4),
                  FlSpot(5, 4.5),
                ],
                isCurved: true,
                color: Colors.pink,
                barWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Sales Overview (Bar Chart) ************************************************
  Widget _buildSalesOverview() {
    return _cardWrapper(
      title: "Sales Overview",
      child: SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            barGroups: List.generate(6, (index) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: (index + 1) * 2.0,
                    color: Colors.blueAccent,
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                  )
                ],
              );
            }),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"];
                    return Text(months[value.toInt() % months.length]);
                  },
                ),
              ),
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true)),
            ),
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: true),
          ),
          swapAnimationDuration: const Duration(milliseconds: 800),
          swapAnimationCurve: Curves.easeInOut,
        ),
      ),
    );
  }

  /// Meetup Card **********************************************************

  Widget _buildMeetupCard() {
    return _cardWrapper(
      bgColor: Colors.purple.shade50,
      title: "Meetup",
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Off-line exchange of learning experiences",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          Image.network(
            "https://www.mgt-commerce.com/astatic/assets/images/article/2024/475/dc16c7c308836142d28b05464ce13a01.png",
            height: 60,
            width: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Agar image load nahi hoti to fallback icon show kare
              return Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image_not_supported,
                    color: Colors.white),
              );
            },
          ),
        ],
      ),
    );
  }


  /// Card Wrapper ******************************************************
  Widget _cardWrapper({
    required Widget child,
    Color bgColor = Colors.white,
    String? title,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (bgColor == Colors.white)
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          child
        ],
      ),
    );
  }

 /// **********************************************************************

}
