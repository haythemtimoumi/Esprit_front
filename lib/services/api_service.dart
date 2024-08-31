// lib/services/api_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/module.dart';
import '../model/module_performance.dart';

class ApiService {
  final String baseUrl = 'http://192.168.56.1:3000'; // Update this to your IP

  Future<List<dynamic>> fetchStudentById(String studentId) async {
    final response = await http.get(Uri.parse('$baseUrl/studentById/$studentId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data; // Assuming the response is a list of student details
    } else {
      throw Exception('Failed to load student data');
    }
  }

  Future<List<List<dynamic>>> fetchStudentAbsences(String studentId) async {
    final url = Uri.parse('$baseUrl/studentAbsences/$studentId');
    try {
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map<List<dynamic>>((json) => List<dynamic>.from(json)).toList();
      } else {
        throw Exception('Failed to load absences, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching absences: $e');
      throw Exception('Failed to fetch absences: $e');
    }
  }

  Future<List<StudentModule>> fetchStudentModules(String studentId) async {
    final response = await http.get(Uri.parse('$baseUrl/studentModules/$studentId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map<StudentModule>((json) => StudentModule.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load student modules');
    }
  }

  Future<List<StudentModule>> fetchStudentModulesR(String studentId) async {
    final response = await http.get(Uri.parse('$baseUrl/studentModulesR/$studentId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map<StudentModule>((json) => StudentModule.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load student modules');
    }
  }

  Future<List<dynamic>> fetchAbsencesById(String studentId) async {
    final response = await http.get(Uri.parse('$baseUrl/absenceById/$studentId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load absences');
    }
  }

  Future<List<dynamic>> fetchEnseignants() async {
    final response = await http.get(Uri.parse('$baseUrl/enseignantActive'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load enseignants data');
    }
  }

  Future<Map<String, dynamic>> studentStudyHours(String studentId) async {
    final url = Uri.parse('$baseUrl/studentStudyHours/$studentId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load student study hours');
      }
    } catch (e) {
      print('Error fetching student study hours: $e');
      throw Exception('Failed to fetch student study hours: $e');
    }
  }
  Future<List<List<dynamic>>> fetchStudentModulesSt(String studentId) async {
    final url = Uri.parse('$baseUrl/studentModulesSt/$studentId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map<List<dynamic>>((json) => List<dynamic>.from(json)).toList();
      } else {
        throw Exception('Failed to load student modules');
      }
    } catch (e) {
      print('Error fetching student modules: $e');
      throw Exception('Failed to fetch student modules: $e');
    }
  }



  Future<Map<String, dynamic>> fetchSocieteByStudent(String studentId) async {
    final response = await http.get(Uri.parse('$baseUrl/societeByStudent/$studentId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return {
          'NOM_SOC': data[0][0],
          'ADR_SOC': data[0][1],
          'TEL_SOC': data[0][2],
          'FAX_SOC': data[0][3],
          'E_MAIL': data[0][4],
          'LIAISON_SITE': data[0][5],
          'VILLE': data[0][6],
          'RIB': data[0][7],
          'BANQUE': data[0][8],
        };
      } else {
        throw Exception('No data found for this student');
      }
    } else {
      throw Exception('Failed to load societe data');
    }
  }



  Future<List<Map<String, dynamic>>> fetchNotesBelowThreshold(String studentId) async {
    final response = await http.get(Uri.parse('$baseUrl/notesBelowThreshold/$studentId'));

    if (response.statusCode == 200) {
      final rawData = response.body;
      print('Raw JSON response: $rawData'); // Debugging: print the raw JSON

      final List<dynamic> data = json.decode(rawData);

      // Debugging: print the first element in the list to check its structure
      if (data.isNotEmpty) {
        print('First element in the list: ${data.first}');
      }

      // Check the type of elements in the list and parse accordingly
      if (data.first is List<dynamic>) {
        // If the JSON is a List<List<dynamic>>, convert it accordingly
        return data.map((e) => Map<String, dynamic>.from({
          'ANNEE_DEB': e[1],
          'LIB_UE': e[0],
          'NOTE': e[2],
        })).toList();
      } else if (data.first is Map<String, dynamic>) {
        // If the JSON is already a List<Map<String, dynamic>>, just cast it
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Unexpected JSON format');
      }
    } else {
      throw Exception('Failed to load notes below threshold');
    }
  }

  Future<Map<String, dynamic>> fetchMotivationalMessages(String studentId) async {
    final url = Uri.parse('$baseUrl/studentMsg/$studentId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load motivational messages');
      }
    } catch (e) {
      print('Error fetching motivational messages: $e');
      throw Exception('Failed to fetch motivational messages: $e');
    }
  }



  Future<List<List<dynamic>>> fetchEmploiByClasseAndDate(String classeId, {String? date}) async {
    // Construct the URL with optional date parameter
    final url = Uri.parse('$baseUrl/emploi/$classeId${date != null ? '?date=$date' : ''}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Convert List<dynamic> to List<List<dynamic>>
        return data.map<List<dynamic>>((item) => List<dynamic>.from(item)).toList();
      } else {
        throw Exception('Failed to load emploi data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching emploi data: $e');
      throw Exception('Failed to fetch emploi data: $e');
    }
  }


  Future<List<ModulePerformance>> fetchStudentStats(String studentId) async {
    final url = Uri.parse('$baseUrl/studentstats/$studentId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Map data to a List of ModulePerformance objects
        return (data['modules'] as List<dynamic>).map((module) {
          return ModulePerformance(
            module['module'],
            module['typeMoyenne'], // Parse typeMoyenne here
            module['studentMoyenne'],
            module['classAverageMoyenne'],
          );
        }).toList();
      } else {
        throw Exception('Failed to load student stats');
      }
    } catch (e) {
      print('Error fetching student stats: $e');
      throw Exception('Failed to fetch student stats: $e');
    }
  }
  Future<List<Map<String, dynamic>>> fetchStudentNotesById(String studentId) async {
    final response = await http.get(Uri.parse('$baseUrl/studentNotesById/$studentId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map<Map<String, dynamic>>((json) => {
        'CODE_MODULE': json[0],
        'NOTE_EXAM': json[1],
        'NOTE_CC': json[2],
        'NOTE_TP': json[3],
        'SEMESTRE': json[4],
        'TYPE_MOY': json[5],
        'ANNEE_DEB': json[6],
        'MOYENNE': json[7],
      }).toList();
    } else {
      throw Exception('Failed to load student notes');
    }
  }


}







