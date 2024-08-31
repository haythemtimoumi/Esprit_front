import 'package:esprit/page/student_stats_chart.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../services/api_service.dart';
import '../stats/radar_chart_widget.dart';

class StatPage extends StatefulWidget {
  final String studentId;

  StatPage({required this.studentId});

  @override
  _StatPageState createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  String selectedModuleCode = '';
  Map<String, double> chartData = {};
  List<String> moduleCodes = [];
  bool isLoading = true;
  double totalHours = 0;
  int absenceCount = 0;
  List<RadarData> radarData = []; // To hold radar chart data

  @override
  void initState() {
    super.initState();
    fetchModules();
  }

  void fetchModules() async {
    try {
      ApiService apiService = ApiService();
      List<List<dynamic>> modules = await apiService.fetchStudentModulesSt(widget.studentId);

      setState(() {
        moduleCodes = modules.map((module) => module[7].toString()).toList();
        selectedModuleCode = moduleCodes.isNotEmpty ? moduleCodes[0] : '';
        isLoading = false;
      });

      fetchChartData();
    } catch (e) {
      print('Error fetching modules: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchChartData() async {
    if (selectedModuleCode.isEmpty) return;

    try {
      ApiService apiService = ApiService();
      List<List<dynamic>> modules = await apiService.fetchStudentModulesSt(widget.studentId);

      List<dynamic> selectedModuleData = modules.firstWhere((module) => module[7] == selectedModuleCode);

      setState(() {
        totalHours = double.parse(selectedModuleData[4].toString());
        absenceCount = int.parse(selectedModuleData[8].toString());
      });

      double absentHours = absenceCount * 1.5;
      double presentHours = totalHours - absentHours;

      double presentPercentage = (presentHours / totalHours) * 100;
      double absentPercentage = (absentHours / totalHours) * 100;

      setState(() {
        chartData = {
          "Present": presentPercentage,
          "Absent": absentPercentage,
        };

        // Prepare data for radar chart
        radarData = modules.map((module) {
          final moduleName = module[7].toString();
          final moduleTotalHours = double.parse(module[4].toString());
          final moduleAbsenceCount = int.parse(module[8].toString());
          final moduleAbsentHours = moduleAbsenceCount * 1.5;
          final moduleRequiredHours = moduleTotalHours - moduleAbsentHours;
          return RadarData(
            moduleName: moduleName,
            value: moduleRequiredHours,
          );
        }).toList();
      });
    } catch (e) {
      print('Error calculating chart data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Statistical',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'Roboto', // Replace with your preferred font
          ),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0), // Adjust the padding if needed
          child: IconButton(
            icon: Image.asset('assets/back.png'),
            onPressed: () {
              Navigator.of(context).pop(); // Navigate back when the icon is tapped
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // Adjust the padding if needed
            child: IconButton(
              icon: Icon(Icons.notifications, color: Colors.white), // Replace with your desired icon
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentStatsChart(studentId: widget.studentId),
                  ),
                );
              },
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.red.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

        body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.redAccent))
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: DropdownButton<String>(
                      value: selectedModuleCode,
                      dropdownColor: Colors.redAccent,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      iconEnabledColor: Colors.white,
                      items: moduleCodes.map((code) {
                        return DropdownMenuItem(
                          value: code,
                          child: Text(
                            code,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedModuleCode = value!;
                          fetchChartData();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  chartData.isNotEmpty
                      ? PieChart(
                    dataMap: chartData,
                    chartType: ChartType.ring,
                    colorList: [Colors.green.shade400, Colors.red.shade400],
                    chartRadius: MediaQuery.of(context).size.width / 2,
                    animationDuration: Duration(milliseconds: 1500),
                    chartLegendSpacing: 40,
                    centerText: "Attendance",
                    centerTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 22,
                    ),
                    legendOptions: LegendOptions(
                      showLegends: true,
                      legendPosition: LegendPosition.bottom,
                      legendShape: BoxShape.rectangle,
                      legendTextStyle: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValuesInPercentage: true,
                      showChartValuesOutside: true,
                      chartValueStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ringStrokeWidth: 30,
                  )
                      : Center(
                    child: Text(
                      "No data available",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total Hours: ${totalHours.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Number of Absences: $absenceCount',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: RadarChartWidget(
                data: radarData,
                title: 'Power and Weakness',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
