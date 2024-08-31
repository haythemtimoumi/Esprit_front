// lib/pages/absence_page.dart

import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AbsencePage extends StatelessWidget {
  final String studentId;

  AbsencePage({required this.studentId});

  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0), // Adjust the padding if needed
          child: IconButton(
            icon: Image.asset('assets/back.png'),
            onPressed: () {
              Navigator.of(context).pop(); // Navigate back when the icon is tapped
            },
          ),
        ),
        title: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Absence',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        elevation: 4, // Slight elevation for a shadow effect
        toolbarHeight: 60, // Adjust the height if needed
      ),
      body: FutureBuilder<List<List<dynamic>>>(
        future: apiService.fetchStudentAbsences(studentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.red.shade700));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No absence records found'));
          }

          final absences = snapshot.data!;
          print(absences); // Debugging output to check the data

          return ListView.builder(
            itemCount: absences.length,
            itemBuilder: (context, index) {
              final absence = absences[index];
              return Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners for modern look
                ),
                elevation: 6, // Softer shadow for a modern feel
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12), // Rounded image corners
                            child: Image.asset(
                              'assets/ask.png',
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              'Module: ${absence.length > 1 ? absence[5] : 'N/A'}', // Display module code
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700, // Bolder text for emphasis
                                color: Colors.red.shade700, // Main color
                              ),
                              overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18),
                      Divider(
                        color: Colors.red.shade100,
                        thickness: 1,
                      ),
                      SizedBox(height: 18),
                      _buildAbsenceDetail('Name & Last Name', '${absence[0] ?? 'N/A'} ${absence[1] ?? 'N/A'}'),
                      _buildAbsenceDetail('Teacher Name', '${absence[2] ?? 'N/A'} ${absence[4] ?? 'N/A'}'),
                      _buildAbsenceDetail('date', absence.length > 6 ? absence[6] : null),
                      _buildAbsenceDetail('Justifaction', absence.length > 12 ? absence[12] : null),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAbsenceDetail(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade700,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A', // Provide a default value if `value` is null
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800], // Neutral text color for contrast
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
