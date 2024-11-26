import 'dart:convert';

import 'package:chat_app/src/providers/auth_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class NotificationService {
  final AuthProvider authProvider;
  final BuildContext context;
  NotificationService(this.authProvider, this.context);

  void initialize() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotificationInAPP(
          message); // Show toast notification in the foreground
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });
  }

  void showNotificationInAPP(RemoteMessage message) {
    // RemoteNotification? notification = message.notification;

    print("got notification");

    String? notificationType = message.data['type'];

    if (notificationType == 'newMessage') {
      final data = json.decode(message.data['message']);
      print(data);

      final newConversation = data['conversation'];

      print(newConversation);

      authProvider.setConversations([newConversation, ...authProvider.conversations]);
    } else {
      authProvider.handleNewMessage(message.data['message']);
    }

    // authProvider.handleNewMessage(message.data['message']);
  }

  void _handleNotificationTap(RemoteMessage message) {
    // Handle notification tap when the app is opened from a background state
    String? notificationType = message.data['type'];

    if (notificationType == 'message') {
      // Navigate to a specific page, if needed
      Future.delayed(const Duration(seconds: 1), () {
        // navigatorKey.currentState?.push(MaterialPageRoute(
        //   builder: (context) => ConversationPage(authProvider: authProvider),
        // ));
      });
    }
    // Handle other types if needed
  }
}
