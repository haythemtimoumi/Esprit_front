import 'package:flutter/material.dart';
import '../services/api_service.dart';

class StudentNotesPage extends StatefulWidget {
  final String studentId;

  StudentNotesPage({required this.studentId});

  @override
  _StudentNotesPageState createState() => _StudentNotesPageState();
}

class _StudentNotesPageState extends State<StudentNotesPage> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> notesP = [];
  List<Map<String, dynamic>> notesR = [];
  bool isLoading = true;
  String selectedType = 'P'; // Default to 'P'

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  void fetchNotes() async {
    try {
      List<Map<String, dynamic>> notes = await apiService.fetchStudentNotesById(widget.studentId);
      setState(() {
        notesP = notes.where((note) => note['TYPE_MOY'] == 'P').toList();
        notesR = notes.where((note) => note['TYPE_MOY'] == 'R').toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching notes: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background color for a modern look
      appBar: AppBar(
        title: Text(
          'Student Notes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.red.shade700,
        elevation: 0, // Flat app bar for a clean look
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.red.shade700,
        ),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text(
                    'TYPE_MOY P',
                    style: TextStyle(
                      color: selectedType == 'P' ? Colors.white : Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: selectedType == 'P',
                  selectedColor: Colors.red.shade700,
                  backgroundColor: Colors.white,
                  shape: StadiumBorder(side: BorderSide(color: Colors.red.shade700)),
                  onSelected: (bool selected) {
                    setState(() {
                      selectedType = 'P';
                    });
                  },
                ),
                SizedBox(width: 10),
                ChoiceChip(
                  label: Text(
                    'TYPE_MOY R',
                    style: TextStyle(
                      color: selectedType == 'R' ? Colors.white : Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: selectedType == 'R',
                  selectedColor: Colors.red.shade700,
                  backgroundColor: Colors.white,
                  shape: StadiumBorder(side: BorderSide(color: Colors.red.shade700)),
                  onSelected: (bool selected) {
                    setState(() {
                      selectedType = 'R';
                    });
                  },
                ),
              ],
            ),
          ),
          // Display notes based on the selected TYPE_MOY in a DataTable
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => Colors.red.shade700),
                  headingTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  columnSpacing: 20,
                  columns: const [
                    DataColumn(label: Text('Module')),
                    DataColumn(label: Text('Exam')),
                    DataColumn(label: Text('CC')),
                    DataColumn(label: Text('TP')),
                    DataColumn(label: Text('Semestre')),
                    DataColumn(label: Text('Année')),
                    DataColumn(label: Text('Moyenne')),
                  ],
                  rows: (selectedType == 'P' ? notesP : notesR)
                      .map(
                        (note) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            note['CODE_MODULE'].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ),
                        DataCell(
                          Text(
                            note['NOTE_EXAM'].toString(),
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        DataCell(
                          Text(
                            note['NOTE_CC'].toString(),
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        DataCell(
                          Text(
                            note['NOTE_TP'].toString(),
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        DataCell(
                          Text(
                            note['SEMESTRE'].toString(),
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        DataCell(
                          Text(
                            note['ANNEE_DEB'].toString(),
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        DataCell(
                          Text(
                            note['MOYENNE'].toString(),
                            style: TextStyle(
                              color: double.tryParse(note['MOYENNE'].toString())! > 8
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      .toList(),
                  dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                  dataTextStyle: TextStyle(fontSize: 14, color: Colors.black87),
                  border: TableBorder.all(color: Colors.red.shade700, width: 1.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
