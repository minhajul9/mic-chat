// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, avoid_unnecessary_containers

import 'dart:convert';

import 'package:chat_app/backendConfig/config.dart';
import 'package:chat_app/src/encryption/encryption.dart';
import 'package:chat_app/src/pages/homePage/home_page.dart';
import 'package:chat_app/src/providers/auth_provider.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MessagePage extends StatefulWidget {
  final authProvider;
  final from;
  final receiver;
  final conversation;
  const MessagePage(
      {super.key,
      required this.authProvider,
      required this.from,
      this.receiver,
      required this.conversation});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  String baseUrl = Config.baseUrl;

  final ScrollController _scrollController = ScrollController();
  // List<dynamic> messages = [];
  bool loading = false;
  bool sendingMessage = false;

  final messageController = TextEditingController();

  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  getMessages() async {
    setState(() {
      loading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('adda-access-token');

    // String encryptedId = encryptData(widget.authProvider.user['_id'], true);
    // String conversationId =
    //     encryptData(widget.authProvider.selectedConversation['_id'], true);

    final response = await http.get(
        Uri.parse(
            '$baseUrl/api/messages/getMessages/${widget.authProvider.selectedConversation['_id']}'),
        headers: {
          'authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': '49420'
        });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['error'] != null && data['error']) {
        Fluttertoast.showToast(
            msg: data['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        // final decrypted = decryptData(data['encryptedData']);

        setState(() {
          loading = false;
          widget.authProvider.messages = data['messages'];
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        });
      }
    }
  }

  checkMessages() async {
    setState(() {
      loading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('adda-access-token');

    final response = await http.get(
        Uri.parse('$baseUrl/api/messages/check/${widget.receiver['_id']}'),
        headers: {
          'authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': '49420'
        });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['error'] != null && data['error']) {
        Fluttertoast.showToast(
            msg: data['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        widget.authProvider.setMessages(data['messages']);
        widget.authProvider.setSelectedConversation(data['conversation']);
        setState(() {
          loading = false;
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   _scrollToBottom();
          // });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.from == 'search') {
      checkMessages();
    } else {
      getMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 146, 144, 195),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => {
              widget.authProvider.setSelectedConversation(null),
              widget.authProvider.setMessages([]),
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()))
            },
          ),
          toolbarHeight: 78,
          title: Container(
            margin: EdgeInsets.fromLTRB(0, 5, 3, 5),
            height: 70,
            // width: MediaQuery.of(context).size.width *.7,
            child: Row(
              children: [
                // Circular image or default icon when the image is null
                Container(
                  width: 40,
                  padding: EdgeInsets.all(2),
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(widget.receiver['profilePic']),
                    radius: 24,
                  ),
                ),
                SizedBox(width: 10), // Space between image and name

                // Display name with overflow handling
                Expanded(
                  child: Text(
                    widget.receiver['fullName'],
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.clip, // Handle text overflow
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 7, 15, 43),
        body: SingleChildScrollView(
            controller: _scrollController,
            child: loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.85,
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.bottomCenter,
                    child: Consumer<AuthProvider>(
                        builder: (context, authProvider, child) => Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: ListView.builder(
                                      reverse: true,
                                      itemCount:
                                          widget.authProvider.messages.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        //

                                        final message =
                                            widget.authProvider.messages[index];
                                        bool isSender =
                                            widget.authProvider.user['_id'] ==
                                                message['senderId'];

                                        return Container(
                                          child: BubbleSpecialThree(
                                            text: message['message'],
                                            color: isSender
                                                ? Color.fromARGB(
                                                    207, 83, 92, 145)
                                                : Color.fromARGB(
                                                    207, 27, 26, 85),
                                            tail: true,
                                            isSender: isSender,
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        );
                                      }),
                                ),

                                //
                                SizedBox(
                                  height: 20,
                                ),

                                //send message
                                TextFormField(
                                  controller: messageController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Message can't be empty.";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: "Enter your Message",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(18)),
                                      suffixIcon: IconButton(
                                        icon: sendingMessage
                                            ? CircularProgressIndicator()
                                            : Icon(Icons.send),
                                        onPressed: () async {
                                          if (messageController
                                              .text.isNotEmpty) {
                                            setState(() {
                                              sendingMessage = true;
                                            });

                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            String? token = prefs
                                                .getString('adda-access-token');

                                            final messageData = {
                                              'message': messageController.text,
                                              'senderId': widget
                                                  .authProvider.user['_id'],
                                              'receiverId':
                                                  widget.receiver['_id'],
                                              'conversationId': widget
                                                  .authProvider
                                                  .selectedConversation?['_id'],
                                              'senderName': widget
                                                  .authProvider.user['fullName']
                                            };

                                            // if no conversation found
                                            if (authProvider
                                                    .selectedConversation ==
                                                null) {
                                              final response = await http.post(
                                                  Uri.parse(
                                                      '$baseUrl/api/messages/sendFirst'),
                                                  headers: {
                                                    'authorization':
                                                        'Bearer $token',
                                                    'ngrok-skip-browser-warning':
                                                        '49420',
                                                    'content-type':
                                                        'application/json'
                                                  },
                                                  body:
                                                      json.encode(messageData));

                                              if (response.statusCode == 200) {
                                                final data =
                                                    json.decode(response.body);

                                                if (!data['error']) {
                                                  widget.authProvider
                                                      .setMessages([
                                                    data['message'],
                                                    ...widget
                                                        .authProvider.messages
                                                  ]);

                                                  final newConversation =
                                                      data['conversation'];
                                                  newConversation[
                                                      "participants"] = [
                                                    widget.receiver
                                                  ];

                                                  authProvider
                                                      .setConversations([
                                                    newConversation,
                                                    ...authProvider
                                                        .conversations
                                                  ]);

                                                  authProvider
                                                      .setSelectedConversation(
                                                          newConversation);
                                                  messageController.text = '';

                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    _scrollToBottom();
                                                  });
                                                }
                                              }
                                            }

                                            //if conversation exist
                                            else {
                                              final response = await http.post(
                                                  Uri.parse(
                                                      '$baseUrl/api/messages/send/${authProvider.selectedConversation!["_id"]}'),
                                                  headers: {
                                                    'authorization':
                                                        'Bearer $token',
                                                    'ngrok-skip-browser-warning':
                                                        '49420',
                                                    'content-type':
                                                        'application/json'
                                                  },
                                                  body:
                                                      json.encode(messageData));

                                              if (response.statusCode == 200) {
                                                final data =
                                                    json.decode(response.body);

                                                if (!data['error']) {
                                                  //
                                                  //
                                                  widget.authProvider
                                                      .setMessages([
                                                    data['message'],
                                                    ...widget
                                                        .authProvider.messages
                                                  ]);

                                                  //
                                                  final index = authProvider
                                                      .conversations
                                                      .indexWhere((item) =>
                                                          item['_id']
                                                              .toString() ==
                                                          data['message'][
                                                              'conversationId']);

                                                  authProvider.conversations
                                                      .removeAt(index);

                                                  //
                                                  final updatedConversation =
                                                      authProvider
                                                          .selectedConversation;

                                                  updatedConversation![
                                                          'isRead'] =
                                                      data["conversation"]
                                                          ['isRead'];
                                                  updatedConversation[
                                                          "lastMessageTime"] =
                                                      data["conversation"]
                                                          ["lastMessageTime"];
                                                  updatedConversation[
                                                          "lastMessage"] =
                                                      data["conversation"]
                                                          ["lastMessage"];

                                                  authProvider
                                                      .setSelectedConversation(
                                                          updatedConversation);
                                                  messageController.text = '';

                                                  authProvider
                                                      .setConversations([
                                                    updatedConversation,
                                                    ...authProvider
                                                        .conversations
                                                  ]);

                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    _scrollToBottom();
                                                  });
                                                }
                                              }
                                            }

                                            setState(() {
                                              sendingMessage = false;
                                            });
                                          }
                                        },
                                      )),
                                )
                              ],
                            )))));
  }
}
