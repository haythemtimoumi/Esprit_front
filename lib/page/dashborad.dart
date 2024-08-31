import 'package:esprit/page/parentSD.dart';
import 'package:esprit/page/stat.dart';
import 'package:flutter/material.dart';

import 'absence.dart';
import 'contactUs.dart';
import 'event.dart';
import 'motivation.dart';
import 'result.dart';
import 'settingG.dart';
import '../services/api_service.dart';

class DashboardPage extends StatefulWidget {
  final String studentId;

  DashboardPage({required this.studentId});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentData;

  @override
  void initState() {
    super.initState();
    ApiService apiService = ApiService();
    studentData = apiService.studentStudyHours(widget.studentId); // Fetch the data using your API service
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
                color: Color(0xFFF0F0F1),
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    SizedBox(height: 74),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            'Hi, Mr & Mrs',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${data['prenom']}', // Replace "Timoumi" with the student's first name
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SettingsPage(),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  'assets/settingg.png',
                                  width: 27,
                                  height: 27,
                                  color: Colors.red.shade700,
                                ),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventPage(),
                                        //builder: (context) => MotivationalMessageWidget(),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                'assets/calendar.png',
                                width: 27,
                                height: 27,
                                color: Colors.red.shade700,
                              ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 200,
                      margin: EdgeInsets.fromLTRB(20, 50, 20, 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Statistical',
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StatPage(studentId: widget.studentId),
                                      ),
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/seemore.png',
                                    width: 24,
                                    height: 24,
                                    color: Colors.red.shade700,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: MotivationalMessageWidget(studentId: widget.studentId),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 200,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red.shade700,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Payment',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/seemore.png',
                                          width: 24,
                                          height: 24,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Center(
                                    child: Text(
                                      '5655446',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '#',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Valid',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Contact',
                                          style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => FacultyContactPage(studentId: widget.studentId),
                                              ),
                                            );
                                          },
                                          child: Image.asset(
                                            'assets/seemore.png',
                                            width: 24,
                                            height: 24,
                                            color: Colors.red.shade700,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Expanded(
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Positioned(
                                          left: 10,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.red.shade900.withOpacity(0.5),
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.red.shade700,
                                              radius: 25,
                                              child: Text(
                                                'A',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 55,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.red.shade900.withOpacity(0.5),
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.red.shade700,
                                              radius: 25,
                                              child: Text(
                                                'C',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 100,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.red.shade900.withOpacity(0.5),
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.red.shade700,
                                              radius: 25,
                                              child: Text(
                                                'S',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 40),
                        child: Row(
                          children: [
                            /////////
                            Expanded(
                              child: Container(

                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Absence',
                                            style: TextStyle(
                                              color: Colors.red.shade700,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => AbsencePage(studentId: widget.studentId),
                                                ),
                                              );
                                            },
                                            child: Image.asset(
                                              'assets/seemore.png',
                                              width: 24,
                                              height: 24,
                                              color: Colors.red.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              // Modern CircularProgressIndicator with gradient and shadow
                                              Container(
                                                decoration: BoxDecoration(
                                                  gradient: RadialGradient(
                                                    colors: [
                                                      Colors.white,
                                                      Colors.white,
                                                    ],
                                                    center: Alignment.topLeft,
                                                    radius: 1.0,
                                                  ),
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.2),
                                                      spreadRadius: 3,
                                                      blurRadius: 5,
                                                      offset: Offset(0, 3), // Shadow position
                                                    ),
                                                  ],
                                                ),
                                                child: CircularProgressIndicator(
                                                  value: double.tryParse(data['percentage_present']?.replaceAll('%', '')) ?? 0.0 / 100.0,
                                                  strokeWidth: 6, // Adjust stroke width for a more modern look
                                                  backgroundColor: Colors.transparent, // Transparent background to use gradient
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade700),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  '${data['percentage_present']}%',
                                                  style: TextStyle(
                                                    color: Colors.red.shade700,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total Absence:',
                                            style: TextStyle(
                                              color: Colors.red.shade700,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '${data['total_absences']}',
                                            style: TextStyle(
                                              color: Colors.red.shade700,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ///////////

                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Result',
                                            style: TextStyle(
                                              color: Colors.red.shade700,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(

                                                  //builder: (context) => LineChartPage(),
                                              builder: (context) => ResultPage(studentId: widget.studentId),
                                                ),
                                              );
                                            },
                                            child: Image.asset(
                                              'assets/seemore.png',
                                              width: 24,
                                              height: 24,
                                              color: Colors.red.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Image.asset(
                                          'assets/img_2.png', // Keeping the original photo
                                          width: 150,
                                          height: 150,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}


