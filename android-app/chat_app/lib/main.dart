// ignore_for_file: unused_import, prefer_const_constructors

import 'package:chat_app/src/component/accessControl/access_control.dart';
import 'package:chat_app/src/component/blinking_logo.dart';
import 'package:chat_app/src/pages/homePage/home_page.dart';
import 'package:chat_app/src/pages/loginPage/login_page.dart';
import 'package:chat_app/src/pages/registerPage/registration_page.dart';
import 'package:chat_app/src/providers/auth_provider.dart';
import 'package:chat_app/src/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

void main() async {
  //initialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //permission for push notification
  requestNotificationPermission();

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    NotificationService(authProvider, context).initialize();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 7, 15, 58)),
          useMaterial3: true,
        ),
        home: AuthCheck(child: HomePage()),
        routes: {
          '/home': (context) => AuthCheck(child: HomePage()),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegistrationPage(),
          // '/settings': (context) => AccountSetting(),
        });
  }
}
