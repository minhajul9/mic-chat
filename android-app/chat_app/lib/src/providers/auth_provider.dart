import 'dart:convert';

import 'package:chat_app/backendConfig/config.dart';
import 'package:chat_app/src/encryption/encryption.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  //backend address
  String serverUrl = Config.baseUrl;

  Map<String, dynamic>? user;
  bool isLoading = true;
  List users = [];

  Map<String, dynamic>? selectedConversation;
  List conversations = [];
  List messages = [];

  AuthProvider() {
    loadUser();
  }

  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('adda-access-token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('$serverUrl/api/auth/user'),
        headers: {
          'Authorization': 'Bearer $token',
          "ngrok-skip-browser-warning": "69420",
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['error'] != null && data['error']) {
          // logOut();
          // _showAlert('Session Timed Out. Please, login again.', 'warning');
        } else {
          final decryptedData = decryptData(data['encryptedData']);
          user = decryptedData;
          isLoading = false;
          // createJWT(decryptedData);
          notifyListeners();
        }
      }
    } else {
      user = null;
    }

    isLoading = false;

    notifyListeners();
  }

  Future<void> handleRegistration(Map<String, dynamic> values) async {
    final response = await http.post(Uri.parse('$serverUrl/api/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
          "ngrok-skip-browser-warning": "69420",
        },
        body: json.encode(values));
  }
  // body: json.encode({"encryptedData": encryptedData}));
}

class AuthProviderWidget extends StatelessWidget {
  final Widget child;

  const AuthProviderWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: child,
    );
  }
}
