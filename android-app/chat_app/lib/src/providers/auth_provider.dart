import 'dart:convert';

import 'package:chat_app/backendConfig/config.dart';
import 'package:chat_app/src/encryption/encryption.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
          // final decryptedData = decryptData(data['encryptedData']);
          user = data;

          await loadInitialUsers();

          await loadConversations();
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

  // Future<void> handleRegistration(Map<String, dynamic> values) async {
  //   final response = await http.post(Uri.parse('$serverUrl/api/auth/signup'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         "ngrok-skip-browser-warning": "69420",
  //       },
  //       body: json.encode(values));
  // }

  Future<void> loadInitialUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('adda-access-token');

    final response =
        await http.get(Uri.parse('$serverUrl/api/users'), headers: {
      "Authorization": "Bearer $token",
      "ngrok-skip-browser-warning": "69420",
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      users = data;

      notifyListeners();
    }
  }

  Future<bool> handleLogin(Map<String, dynamic> values) async {
    final response = await http.post(
      Uri.parse('$serverUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(values),
    );

    if (response.statusCode == 200) {
      //
      final data = json.decode(response.body);

      if (data['error'] != null && data['error']) {
        //
        _showAlert(data['message'], 'error');
      } else {
        user = data;
        await createJWT(data);
        await loadConversations();
        await loadInitialUsers();

        notifyListeners();
        return true;
      }
    }

    return false;
  }

  Future<void> loadConversations() async {
    final response = await http.get(
      Uri.parse('$serverUrl/api/users/conversations/${user!["_id"]}'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      conversations = data;

      notifyListeners();
    }
  }

  Future<void> createJWT(Map<String, dynamic> data) async {
    // String encryptedData = encryptData({
    //   '_id': data['_id'],
    //   'username': data['username'],
    // }, false);

    print("creating jwt");

    final response = await http.put(
      Uri.parse('$serverUrl/api/jwt/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        '_id': data['_id'],
        'username': data['username'],
      }),
    );

    if (response.statusCode == 200) {
      final jwtData = await jsonDecode(response.body);

      // final decrypted = decryptData(jwtData['encryptedData']);
      print(jwtData);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('adda-access-token', jwtData['token']);
    }
  }

  void setSelectedConversation(Map<String, dynamic>? data) {
    selectedConversation = data;

    notifyListeners();
  }

  void setConversations(List data) {
    conversations = data;
    notifyListeners();
  }

  void setMessages(List data) {
    messages = data;
    notifyListeners();
  }

  void _showAlert(String message, String type) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: type == 'success'
            ? Colors.green
            : type == 'warning'
                ? Colors.yellow
                : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void logOut() async {
    final response = 
  }
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
