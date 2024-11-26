// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:chat_app/src/component/blinking_logo.dart';
import 'package:chat_app/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatelessWidget {
  final Widget child;
  const AuthCheck({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
        builder: (context, authProvider, childWidget) {
      if (authProvider.isLoading) {
        return BlinkingLogoPage();
      }

      if (!authProvider.isLoading && authProvider.user == null) {
        Future.microtask(() {
          Navigator.pushReplacementNamed(context, '/login');
        });
        return const SizedBox.shrink(); // Prevent rendering invalid content
      }

      return child;
    });
  }
}
