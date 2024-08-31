import 'package:flutter/material.dart';
import '../services/api_service.dart';

class NotesBelowThresholdScreen extends StatefulWidget {
  final String studentId;

  NotesBelowThresholdScreen({required this.studentId});

  @override
  _NotesBelowThresholdScreenState createState() => _NotesBelowThresholdScreenState();
}

class _NotesBelowThresholdScreenState extends State<NotesBelowThresholdScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Map<String, dynamic>>> notesBelowThreshold;

  @override
  void initState() {
    super.initState();
    notesBelowThreshold = apiService.fetchNotesBelowThreshold(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Credit List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: notesBelowThreshold,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return SingleChildScrollView(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.redAccent, size: 60),
                            SizedBox(height: 10),
                            Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(color: Colors.black54, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return SingleChildScrollView(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline, color: Colors.grey, size: 60),
                            SizedBox(height: 10),
                            Text(
                              'No notes found below the threshold',
                              style: TextStyle(color: Colors.black54, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    final notes = snapshot.data!;
                    return ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            leading: Image.asset(
                              'assets/credit.png',
                              width: 40,
                              height: 40,
                            ),
                            title: Text(
                              'UE: ${note['LIB_UE']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              'Year: ${note['ANNEE_DEB']}',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            trailing: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Note: ${note['NOTE']}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
