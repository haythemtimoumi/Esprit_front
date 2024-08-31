import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/module_performance.dart';
import '../services/api_service.dart';

class StudentStatsChart extends StatefulWidget {
  final String studentId;

  const StudentStatsChart({Key? key, required this.studentId}) : super(key: key);

  @override
  _StudentStatsChartState createState() => _StudentStatsChartState();
}

class _StudentStatsChartState extends State<StudentStatsChart> {
  late Future<List<ModulePerformance>> _studentStats;
  String selectedTypeMoyenne = 'P'; // Default to 'P'

  @override
  void initState() {
    super.initState();
    _studentStats = ApiService().fetchStudentStats(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background for a clean look
      appBar: AppBar(
        title: const Text('Student Stats'),
        backgroundColor: Colors.red.shade700, // Modern red color for the app bar
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ToggleButtons(
              isSelected: [selectedTypeMoyenne == 'P', selectedTypeMoyenne == 'R'],
              onPressed: (index) {
                setState(() {
                  selectedTypeMoyenne = index == 0 ? 'P' : 'R';
                });
              },
              borderRadius: BorderRadius.circular(12),
              selectedColor: Colors.white,
              fillColor: Colors.red.shade700, // Use the modern red color for the fill
              color: Colors.red.shade700,
              constraints: BoxConstraints(minHeight: 40, minWidth: 100),
              children: const [
                Text('P', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('R', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Add a legend for color reference
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.red.shade700, "Student Moyenne"),
                const SizedBox(width: 20),
                _buildLegendItem(Colors.blue.shade700, "Class Average Moyenne"),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ModulePerformance>>(
              future: _studentStats,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text('No stats found for this student.'));
                } else {
                  final stats = snapshot.data!
                      .where((stat) => stat.typeMoyenne == selectedTypeMoyenne)
                      .toList();
                  return _buildChart(stats);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildChart(List<ModulePerformance> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: BarChart(
        BarChartData(
          maxY: data.map((e) => e.classAverageMoyenne).reduce((a, b) => a > b ? a : b) + 5,
          barGroups: data.map((stat) {
            return BarChartGroupData(
              x: data.indexOf(stat),
              barsSpace: 16, // Space between bars
              barRods: [
                BarChartRodData(
                  toY: stat.studentMoyenne,
                  gradient: LinearGradient(
                    colors: [Colors.red.shade700, Colors.red.shade400],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 22, // Wider bars
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 0, // Base background for the bars
                    color: Colors.transparent, // Background color for bars
                  ),
                  rodStackItems: [
                    BarChartRodStackItem(
                      0,
                      stat.studentMoyenne,
                      Colors.red.shade700,
                    ),
                  ],
                ),
                BarChartRodData(
                  toY: stat.classAverageMoyenne,
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.shade400],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 22,
                  borderRadius: BorderRadius.circular(12),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 0,
                    color: Colors.transparent,
                  ),
                  rodStackItems: [
                    BarChartRodStackItem(
                      0,
                      stat.classAverageMoyenne,
                      Colors.blue.shade700,
                    ),
                  ],
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false), // Hide left axis numbers
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      data[value.toInt()].module,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false), // Hide grid lines
          borderData: FlBorderData(show: false), // Hide border around the chart
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipRoundedRadius: 12,
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              tooltipMargin: 12,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String moduleName = data[group.x].module;
                String value = rod.toY.toStringAsFixed(2);
                return BarTooltipItem(
                  '$moduleName\n$value',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              // Optional: Handle interactions here if needed.
            },
            allowTouchBarBackDraw: true,
          ),
        ),
      ),
    );
  }
}
