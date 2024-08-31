import 'package:esprit/page/settingG.dart';
import 'package:esprit/page/stat.dart';
import 'package:esprit/page/student_stats_chart.dart';
import 'package:esprit/page/tessssst.dart';
import 'package:esprit/page/test.dart';
import 'package:esprit/page/contactUs.dart';
import 'package:esprit/page/weather/empoi.dart';
import 'package:flutter/material.dart';
import 'certifCrd.dart';
import 'credit.dart';
import 'event.dart';
import 'login.dart';
import 'maps/mapFac.dart';
import 'profile.dart';
import 'absence.dart';
import 'chatbot.dart';
import 'contact.dart';
import 'map.dart';
import 'result.dart';
class DashboardTT extends StatefulWidget {
  final String studentId;
  final String studentName;

  DashboardTT({required this.studentId, required this.studentName});

  @override
  _DashboardTTState createState() => _DashboardTTState();
}

class _DashboardTTState extends State<DashboardTT> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              Container(

                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(27),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                height: 250,
                child: Row(
                  children: [
                    SizedBox(width: 40),
                    Text(
                      "Hello,",
                      style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.studentName, // Display the student's name
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),
                    SizedBox(width: 30),
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      child: Image.asset('assets/student.png', width: 55, height: 55),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60),
              Expanded(
                child: GridView(
                  padding: EdgeInsets.all(38),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  children: [
                    _buildGridItem(context, 'Absence', AssetImage('assets/absence.png'), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AbsencePage(studentId: widget.studentId),
                        ),
                      );
                    }),
                    _buildGridItem(context, 'Resultat', AssetImage('assets/resultat.png'), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultPage(studentId: widget.studentId),
                        ),
                      );
                    }),


                    _buildGridItem(context, 'Timetable', AssetImage('assets/timetable.png'), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                         builder: (context) => EventPage(),
                           // builder: (context) => EmploiScreen(),

                        ),
                      );
                    }),
                    _buildGridItem(context, 'Map', AssetImage('assets/map.png'), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapScreen(),
                            //builder: (context) => StudentStatsChart(studentId: widget.studentId),

                        ),
                      );
                    }),

                    _buildGridItem(context, 'Statistical', AssetImage('assets/stats.png'), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StatPage(studentId: widget.studentId),
                        ),
                      );
                    }),
                   // _buildGridItem(context, 'Certif', AssetImage('assets/certificate.png',)),
                    _buildGridItem(context, 'Certif', AssetImage('assets/certificate.png'), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreditPage(studentId: widget.studentId),
                        ),
                      );
                    }),


                    //ScrollableLayout()
                   // StatPage()
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              color: Colors.red.shade700,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Image.asset('assets/menu.png', width: 24, height: 24, color: Colors.white),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/bell.png', width: 24, height: 24, color: Colors.white),
                        onPressed: () {
                          // Handle bell icon press
                        },
                      ),
                      SizedBox(width: 20),
                      // ChatBot icon already present in the body
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 185,
            child: Container(
              width: 350,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Pack :", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("CHAT BOT :", style: TextStyle(color: Colors.red.shade700, fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(width: 30),
                      GestureDetector(


                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Chatbot(),
                            ),
                          );
                        },
                        child: Image.asset('assets/chatbot.png', width: 44, height: 44, color: Colors.red.shade700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String title, AssetImage image, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: image, width: 50, height: 50),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
/////////////////////
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
              image: DecorationImage(
                image: AssetImage('assets/logo-esprit.png'), // Replace with your photo asset
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 20),
              children: [
                _buildDrawerItem(
                  imagePath: 'assets/studentRed.png',
                  text: 'Profile',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(studentId: widget.studentId),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  imagePath: 'assets/teacher.png',
                  text: 'Teacher',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Contact(), // Navigate to ContactPage
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  imagePath: 'assets/settingred.png',
                  text: 'Setting',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(), // Navigate to ContactPage
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  imagePath: 'assets/phoneF.png',
                  text: 'Contact Us',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FacultyContactPage(studentId: widget.studentId), // Navigate to ContactPage
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  imagePath: 'assets/logout.png',
                  text: 'Log out',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required String imagePath,
    required String text,
    required Function() onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.red.shade100,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 24,
                height: 24,
              ),
              SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



}
