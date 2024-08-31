import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

import '../services/api_service.dart';

class FacultyContactPage extends StatefulWidget {
  final String studentId;

  FacultyContactPage({required this.studentId});

  @override
  _FacultyContactPageState createState() => _FacultyContactPageState();
}

class _FacultyContactPageState extends State<FacultyContactPage> {
  final ApiService apiService = ApiService();
  late Future<Map<String, dynamic>> facultyData;

  @override
  void initState() {
    super.initState();
    facultyData = apiService.fetchSocieteByStudent(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
        title: Text(
          'Faculty Contact',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: facultyData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselHeader(imageUrls: [
                  'https://esprit.tn/uploads/Banni%C3%A9re%20Web-01-c0510.webp',
                  'https://esprit.tn/uploads/Web%20Banner-01-d553.webp',
                  'https://esprit.tn/uploads/BANNER-%20CDIO-second%20version-635d.webp',
                ]),
                SizedBox(height: 16.0),
                SectionTitle(title: 'Faculty Information'),
                InfoCard(
                  image: AssetImage('assets/fac.png'),
                  title: 'Faculty Name',
                  subtitle: data['NOM_SOC'] ?? 'N/A',
                  isDarkMode: isDarkMode,
                ),
                InfoCard(
                  image: AssetImage('assets/adressF.png'),
                  title: 'Address',
                  subtitle: data['ADR_SOC'] ?? 'N/A',
                  isDarkMode: isDarkMode,
                ),
                InfoCard(
                  image: AssetImage('assets/webF.png'),
                  title: 'Website',
                  subtitle: data['LIAISON_SITE'] ?? 'N/A',
                  isDarkMode: isDarkMode,
                ),
                SizedBox(height: 24.0),
                SectionTitle(title: 'Contact Us'),
                CopyableCard(
                  image: AssetImage('assets/phoneF.png'),
                  title: 'Phone',
                  subtitle: data['TEL_SOC'] ?? 'N/A',
                  isDarkMode: isDarkMode,
                ),
                CopyableCard(
                  image: AssetImage('assets/emailF.png'),
                  title: 'Email',
                  subtitle: data['E_MAIL'] ?? 'N/A',
                  isDarkMode: isDarkMode,
                ),
                CopyableCard(
                  image: AssetImage('assets/faxF.png'),
                  title: 'Fax',
                  subtitle: data['FAX_SOC'] ?? 'N/A',
                  isDarkMode: isDarkMode,
                ),
                SizedBox(height: 24.0),
                SectionTitle(title: 'Bank Details'),
                CopyableCard(
                  image: AssetImage('assets/ribF.png'),
                  title: 'RIB',
                  subtitle: data['RIB'] ?? 'N/A',
                  isDarkMode: isDarkMode,
                ),
                CopyableCard(
                  image: AssetImage('assets/bankF.png'),
                  title: 'Bank Name',
                  subtitle: data['BANQUE'] ?? 'N/A',
                  isDarkMode: isDarkMode,
                ),
                SizedBox(height: 24.0),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement navigation or functionality
        },
        backgroundColor: Colors.red.shade700,
        child: Icon(Icons.navigation, color: Colors.white),
      ),
    );
  }
}

class CarouselHeader extends StatelessWidget {
  final List<String> imageUrls;

  CarouselHeader({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: screenHeight * 0.35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade700, Colors.red.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: imageUrls.length,
            itemBuilder: (context, index, realIndex) {
              return Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: screenHeight * 0.35,
              );
            },
            options: CarouselOptions(
              height: screenHeight * 0.35,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 4),
              autoPlayAnimationDuration: Duration(milliseconds: 600),
              enlargeCenterPage: true,
              viewportFraction: 0.85,
              initialPage: 0,
              enableInfiniteScroll: true,
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imageUrls.map((url) {
                int index = imageUrls.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.9),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final ImageProvider image;
  final String title;
  final String subtitle;
  final bool isDarkMode;

  InfoCard({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.grey[800]!, Colors.grey[700]!]
              : [Colors.white, Colors.grey[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Image(
            image: image,
            color: isDarkMode ? Colors.white.withOpacity(0.7) : Colors.red.shade700,
            width: 36,
            height: 36,
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CopyableCard extends StatelessWidget {
  final ImageProvider image;
  final String title;
  final String subtitle;
  final bool isDarkMode;

  CopyableCard({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: subtitle)).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title copied to clipboard')),
          );
        });
      },
      child: InfoCard(
        image: image,
        title: title,
        subtitle: subtitle,
        isDarkMode: isDarkMode,
      ),
    );
  }
}
