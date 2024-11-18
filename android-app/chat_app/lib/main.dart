import 'package:chat_app/src/component/blinking_logo.dart';
import 'package:chat_app/src/pages/homePage/home_page.dart';
import 'package:chat_app/src/pages/loginPage/login_page.dart';
import 'package:chat_app/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 7, 15, 58)),
          useMaterial3: true,
        ),
        home: Consumer<AuthProvider>(
            builder: (context, authProvider, child) => HomePage()
            // authProvider.isLoading
            //     ? const BlinkingLogoPage()
            //     : authProvider.user != null
            //         ? HomePage()
            //         : LoginPage(),
            ));
  }
}
