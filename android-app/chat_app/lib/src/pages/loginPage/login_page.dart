// ignore_for_file: prefer_const_constructors

import 'package:chat_app/backendConfig/config.dart';
import 'package:chat_app/src/pages/homePage/home_page.dart';
import 'package:chat_app/src/pages/registerPage/registration_page.dart';
import 'package:chat_app/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String baseUrl = Config.baseUrl;
  bool showPassword = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 15, 43),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 660),
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 146, 144, 195),
              borderRadius: BorderRadius.circular(10)),
          child: Form(
              key: _formKey,
              child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //logo
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image(
                              image: AssetImage('assets/images/logo.png'),
                              width: 200,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),

                          //
                          //username
                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter username.";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Enter your username",
                              prefixIcon: Icon(Icons.perm_identity),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          //password
                          TextFormField(
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your password.";
                              }
                              return null;
                            },
                            obscureText: !showPassword,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Enter your password",
                                prefixIcon: Icon(Icons.lock_outline),
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(showPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                )),
                          ),
                          SizedBox(
                            height: 15,
                          ),

                          //
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });

                              if (_formKey.currentState!.validate()) {
                                print('object');
                                bool status = await authProvider.handleLogin({
                                  'username': emailController.text,
                                  'password': passwordController.text
                                });

                                if (status) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  );
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 27, 26, 85)),
                            child: isLoading
                                ? CircularProgressIndicator()
                                : Text("Login",
                                    style: TextStyle(color: Colors.white)),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //link to register page
                          InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegistrationPage()),
                                );
                              },
                              child: Row(
                                children: const [
                                  Text("Don't have an account?"),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 27, 26, 85)),
                                  ),
                                ],
                              )),
                        ],
                      ))),
        ),
      ),
    );
  }
}
