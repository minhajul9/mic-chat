import 'dart:convert';

import 'package:chat_app/backendConfig/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AuthProvider with ChangeNotifier {
  //backend address
  String serverUrl = Config.baseUrl;

  Map<String, dynamic>? user;
  bool isLoading = true;
  List users = [];

  Map<String, dynamic>? selectedConversation;
  List conversations = [];
  List messages = [];

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
