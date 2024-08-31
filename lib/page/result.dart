import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../model/module.dart';
import 'resultDt.dart';

class ResultPage extends StatefulWidget {
  final String studentId;

  ResultPage({required this.studentId});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String selectedOption = 'Resultat Principale';
  late Future<List<StudentModule>> _modulesFuture;

  @override
  void initState() {
    super.initState();
    _modulesFuture = _fetchModules();
  }

  Future<List<StudentModule>> _fetchModules() async {
    final apiService = ApiService();
    if (selectedOption == 'Resultat Principale') {
      return await apiService.fetchStudentModules(widget.studentId);
    } else {
      return await apiService.fetchStudentModulesR(widget.studentId);
    }
  }

  void _onDropdownChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedOption = newValue;
        _modulesFuture = _fetchModules();
      });
    }
  }

  void _onMoreIconTapped() {
    // Navigate to StudentNotesPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentNotesPage(studentId: widget.studentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light grey background for modern look
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
        elevation: 0,
        title: Text(
          'Modules',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icons8-search-128.png',
              width: 24,
              height: 24,
              color: Colors.white,
            ),
            onPressed: _onMoreIconTapped,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedOption,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                    dropdownColor: Colors.white,
                    items: <String>['Resultat Principale', 'Controle'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: _onDropdownChanged,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<StudentModule>>(
              future: _modulesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No modules found', style: TextStyle(color: Colors.grey)));
                }

                final modules = snapshot.data!;

                final groupedModules = <String, List<StudentModule>>{};
                for (var module in modules) {
                  if (!groupedModules.containsKey(module.libUE)) {
                    groupedModules[module.libUE] = [];
                  }
                  groupedModules[module.libUE]!.add(module);
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  itemCount: groupedModules.length,
                  itemBuilder: (context, index) {
                    final libUE = groupedModules.keys.elementAt(index);
                    final moduleList = groupedModules[libUE]!;
                    final averageGrade = moduleList.fold<double>(0, (sum, module) => sum + module.moyenneModule) / moduleList.length;

                    final bool isHighAverage = averageGrade > 8;

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: isHighAverage ? Colors.green[50] : Colors.red[50], // Background color based on average grade
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lib U.E: $libUE',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Divider(color: Colors.grey[300]),
                            ...moduleList.map((module) {
                              final isHighGrade = module.moyenneModule > 8;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${module.designationModule.split('\r')[0]}',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${module.moyenneModule.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: isHighGrade ? Colors.green : Colors.red, // Green for >8, Red for <=8
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            Divider(color: Colors.grey[300]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Average Grade: ${averageGrade.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  isHighAverage ? Icons.thumb_up : Icons.thumb_down,
                                  color: isHighAverage ? Colors.green : Colors.red,
                                ), // Icon based on average grade
                              ],
                            ),
                            if (!isHighAverage)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Needs Improvement',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ), // Additional message for low average grade
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
