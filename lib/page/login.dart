import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboardTT.dart';
import 'dashborad.dart'; // Import the DashboardPage for parent role

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formSignInKey = GlobalKey<FormState>();
  final TextEditingController _studentIdController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  bool rememberPassword = false;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberPassword = prefs.getBool('rememberPassword') ?? false;
      if (rememberPassword) {
        _studentIdController.text = prefs.getString('studentId') ?? '';
      }
    });
  }

  Future<void> _saveUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberPassword) {
      await prefs.setBool('rememberPassword', true);
      await prefs.setString('studentId', _studentIdController.text);
    } else {
      await prefs.setBool('rememberPassword', false);
      await prefs.remove('studentId');
    }
  }

  Future<void> _login() async {
    if (!_formSignInKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    String studentId = _studentIdController.text.trim();

    try {
      print('Attempting login with studentId: $studentId'); // Debug

      final response = await http.post(
        Uri.parse('http://192.168.56.1:3000/login'), // Replace with your login endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'studentId': studentId}),
      );

      print('Response status: ${response.statusCode}'); // Debug
      print('Response body: ${response.body}'); // Debug

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        print('Response data: $responseData'); // Debug

        if (responseData['message'] == 'Login successful') {
          String userRole = responseData['role'];
          List<dynamic>? userList = responseData['user'];

          if (userList != null && userList.isNotEmpty) {
            String studentId = userList[0]; // Extract the student ID for both student and parent roles
            String studentName = userList.length > 1 ? userList[1] : 'Unknown'; // Safely access list element

            print('User role: $userRole'); // Debug
            print('Student ID: $studentId'); // Debug
            print('Student name: $studentName'); // Debug

            await _saveUserPreferences();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => userRole == 'student'
                    ? DashboardTT(
                  studentId: studentId,
                  studentName: studentName,
                )
                    : DashboardPage(
                  studentId: studentId, // Pass the student ID to DashboardPage for parent role
                ),
              ),
            );
          } else {
            setState(() {
              _errorMessage = 'User data is empty or missing.';
            });
          }
        } else {
          setState(() {
            _errorMessage = 'Unexpected response format or login failed.';
          });
        }
      } else {
        final errorData = json.decode(response.body);
        print('Error response: $errorData'); // Debug
        setState(() {
          _errorMessage = errorData['message'] ?? 'Login failed. Please try again.';
        });
      }
    } catch (e) {
      print('Exception occurred: $e'); // Debug
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/bg1.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content on top of the background
          Column(
            children: [
              const Expanded(
                flex: 4,
                child: SizedBox(
                  height: 10,
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formSignInKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          TextFormField(
                            controller: _studentIdController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter ID Etudiant';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text('ID Etudiant'),
                              hintText: 'Enter ID Etudiant',
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: rememberPassword,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        rememberPassword = value!;
                                      });
                                    },
                                    activeColor: Colors.red,
                                  ),
                                  const Text(
                                    'Remember me',
                                    style: TextStyle(
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                child: const Text(
                                  'Forget password?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: _isLoading
                                    ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                    : const Text(
                                  'Sign in',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          if (_errorMessage.isNotEmpty)
                            Text(
                              _errorMessage,
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
