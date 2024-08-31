import 'package:esprit/page/weather/empoi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';


class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  int? selectedDayIndex;
  late List<DateTime> weekDates;
  final ApiService apiService = ApiService();
  List<List<dynamic>> emploiData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    selectedDayIndex = now.weekday - 1;
    weekDates = List.generate(5, (index) => now.subtract(Duration(days: now.weekday - 1 - index)));
    weekDates.sort((a, b) => a.compareTo(b));
    _fetchEmploiDataForSelectedDay(); // Fetch data for the current day initially
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width - 35;
    double itemWidth = (containerWidth - 6 * 12) / 5;
    double itemHeight = itemWidth * 1.2;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(); // Go back to the previous page
                      },
                      child: Image.asset(
                        'assets/sort.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : emploiData.isEmpty
                      ? Center(child: Text('No data available for this day'))
                      : ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: emploiData.length,
                    itemBuilder: (context, index) {
                      final item = emploiData[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.red.shade700,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Module: ${item[5]}',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Enseignant: ${item[1]}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Time: ${item[6]} - ${item[7]}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.10,
            left: 20.0,
            right: 20.0,
            child: Container(
              width: containerWidth,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('EEEE, MMM dd').format(DateTime.now()),
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EmploiPage(className: '5sleam1'), // Pass className here
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/umbrella.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: itemHeight + 20,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (int i = 0; i < weekDates.length; i++)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDayIndex = i;
                                });
                                _fetchEmploiDataForSelectedDay();
                              },
                              child: Container(
                                width: itemWidth,
                                height: itemHeight,
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  color: selectedDayIndex == i ? Colors.red.shade700 : Colors.white,
                                  borderRadius: BorderRadius.circular(17.0),
                                  border: Border.all(
                                    color: selectedDayIndex == i ? Colors.white : Colors.red.shade700,
                                    width: 2.0,
                                  ),
                                  boxShadow: selectedDayIndex == i
                                      ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.7),
                                      offset: Offset(0, 9),
                                      blurRadius: 6,
                                    ),
                                  ]
                                      : [],
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat('E').format(weekDates[i]),
                                      style: TextStyle(
                                        color: selectedDayIndex == i ? Colors.white : Colors.red.shade700,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      DateFormat('dd').format(weekDates[i]),
                                      style: TextStyle(
                                        color: selectedDayIndex == i ? Colors.white : Colors.red.shade700,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
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
          ),
        ],
      ),
    );
  }

  void _fetchEmploiDataForSelectedDay() async {
    if (selectedDayIndex == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      String date = DateFormat('yyyy-MM-dd').format(weekDates[selectedDayIndex!]);
      List<List<dynamic>> data = await apiService.fetchEmploiByClasseAndDate('5sleam1', date: date);

      setState(() {
        emploiData = data;
      });
    } catch (e) {
      print('Error fetching emploi data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load emploi data')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
