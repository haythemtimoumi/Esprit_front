import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/api_service.dart'; // For Clipboard

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> enseignants = [];
  List<dynamic> filteredEnseignants = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchEnseignants();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchEnseignants() async {
    try {
      List<dynamic> enseignantsData = await apiService.fetchEnseignants();
      setState(() {
        enseignants = enseignantsData;
        filteredEnseignants = enseignants;
      });
    } catch (e) {
      // Handle error
    }
  }

  void _filterEnseignants(String query) {
    setState(() {
      searchQuery = query;
      filteredEnseignants = enseignants
          .where((enseignant) =>
      enseignant[9].toLowerCase().contains(query.toLowerCase()) ||
          enseignant[27].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Colors.red.shade700,
        elevation: 6,

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  _filterEnseignants(query);
                  searchQuery = query;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  hintText: 'Search by name or email',
                  hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                  prefixIcon: Icon(Icons.search, color: Colors.red.shade700),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.red.shade700),
                    onPressed: () {
                      _searchController.clear();
                      _filterEnseignants('');
                    },
                  )
                      : null,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEnseignants.length,
              itemBuilder: (context, index) {
                final enseignant = filteredEnseignants[index];
                return AnimatedCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    title: Text(
                      enseignant[1], // Assuming 9th index is the 'name'
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: enseignant[27])); // Assuming 27th index is the 'email'
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Email copied to clipboard')),
                        );
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/enss.png', // Replace the email icon with the custom image
                            width: 35,
                            height: 35,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              enseignant[27], // Assuming 27th index is the 'email'
                              style: TextStyle(
                                color: Colors.black54,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Text(
                      'Service: ${enseignant[5]}', // Assuming 5th index is the 'service'
                      style: TextStyle(color: Colors.black87 ,fontWeight: FontWeight.bold ),
                    ),
                    onTap: () {
                      // Handle card tap if needed
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedCard extends StatelessWidget {
  final Widget child;

  AnimatedCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
