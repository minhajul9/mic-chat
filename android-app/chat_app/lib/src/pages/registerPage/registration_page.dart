// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:chat_app/backendConfig/config.dart';
import 'package:chat_app/src/pages/loginPage/login_page.dart';
import 'package:chat_app/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  //
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String baseUrl = Config.baseUrl;
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isLoading = false;
  String? gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 7, 15, 43),
        body: Center(
          child: SingleChildScrollView(
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
                              //
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
                                controller: nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter Full name.";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Enter your Full name",
                                  prefixIcon: Icon(Icons.perm_identity),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),

                              //username
                              TextFormField(
                                controller: usernameController,
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

                              //confirm password
                              TextFormField(
                                controller: confirmPasswordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your password.";
                                  } else if (value != passwordController.text) {
                                    return "Password did not matched.";
                                  }
                                  return null;
                                },
                                obscureText: !showConfirmPassword,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: "Confirm your password",
                                    prefixIcon: Icon(Icons.lock_outline),
                                    border: OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: Icon(showConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          showConfirmPassword =
                                              !showConfirmPassword;
                                        });
                                      },
                                    )),
                              ),
                              SizedBox(
                                height: 15,
                              ),

                              //gender
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //male
                                    Flexible(
                                      child: CheckboxListTile(
                                        value: gender == 'male',
                                        onChanged: (value) {
                                          setState(() {
                                            gender = 'male';
                                          });
                                        },
                                        title: Text("Male"),
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        dense: true,
                                        contentPadding: EdgeInsets.all(0),
                                      ),
                                    ),

                                    //female
                                    Flexible(
                                      child: CheckboxListTile(
                                        value: gender == 'female',
                                        onChanged: (value) {
                                          setState(() {
                                            gender = 'female';
                                          });
                                        },
                                        title: Text("Female"),
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        dense: true,
                                        contentPadding: EdgeInsets.all(0),
                                      ),
                                    )
                                  ],
                                ),
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
                                    bool status =
                                        await authProvider.handleRegistration({
                                      'fullName': nameController.text,
                                      'username': usernameController.text,
                                      'password': passwordController.text,
                                      'gender': gender,
                                      'fcmToken': ''
                                    });
                                    if (status) {
                                      Navigator.pushReplacementNamed(
                                          context, '/home');
                                    } else {
                                      isLoading = false;
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
                                    : Text("Register",
                                        style: TextStyle(color: Colors.white)),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              //link to login page
                              InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
                                    );
                                  },
                                  child: Row(
                                    children: const [
                                      Text("Already have an account?"),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        "Login",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                            ],
                          ))),
            ),
          ),
        ));
  }
}
