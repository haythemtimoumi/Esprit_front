import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProfilePage extends StatefulWidget {
  final String studentId;

  ProfilePage({required this.studentId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<dynamic>> studentData;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    studentData = apiService.fetchStudentById(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.grey.shade200,
            child: FutureBuilder<List<dynamic>>(
              future: studentData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data found'));
                }

                final student = snapshot.data!;
                return SingleChildScrollView(
                  padding: EdgeInsets.only(top: 150, left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(student),
                      SizedBox(height: 20),
                      _buildProfileDetailsContainer(student),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.red.shade600,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Image.asset('assets/back.png'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Image.asset('assets/edit.png'),color: Colors.white,
                      onPressed: () {
                        // Navigate to edit page or perform an action
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(List<dynamic> student) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.red.shade100,
            child: Icon(Icons.person, size: 50, color: Colors.red.shade600),
          ),
          SizedBox(height: 16),
          Text(
            '${student[1]} ${student[2]}',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'ID: ${student[0]}',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailsContainer(List<dynamic> student) {
    final details = <Map<String, dynamic>>[
      {'title': 'ID', 'value': student[0], 'image': 'assets/idp.png'},
      {'title': 'Last Name', 'value': student[1], 'image': 'assets/lname.png'},
      {'title': 'First Name', 'value': student[2], 'image': 'assets/name.png'},
      {'title': 'Birth Date', 'value': student[3], 'image': 'assets/birthday.png'},
      {'title': 'Birth Place', 'value': student[4], 'image': 'assets/place.png'},
      {'title': 'Email', 'value': student[10], 'image': 'assets/email.png'},
      {'title': 'Phone', 'value': student[8], 'image': 'assets/phone.png'},
      {'title': 'Address', 'value': student[7], 'image': 'assets/adress.png'},
      {'title': 'Nationality', 'value': student[27], 'image': 'assets/national.png'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: details.map((detail) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Image(
                image: AssetImage(detail['image']),
                width: 24,
                height: 24,
                color: Colors.red.shade600,
              ),
              title: Text(detail['title'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(detail['value']?.toString() ?? 'Not Available'),
            ),
          );
        }).toList(),
      ),
    );
  }
}
