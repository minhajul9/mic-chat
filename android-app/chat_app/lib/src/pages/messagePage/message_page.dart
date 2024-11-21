// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

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

    String encryptedId = encryptData(widget.authProvider.user['_id'], true);
    String conversationId =
        encryptData(widget.authProvider.selectedConversation['_id'], true);

    final response = await http.get(
        Uri.parse(
            '$baseUrl/api/message/getMessages/$encryptedId/$conversationId'),
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
        final decrypted = decryptData(data['encryptedData']);
        setState(() {
          loading = false;
          widget.authProvider.messages = decrypted;
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

    print('check message\n\n\n\n\n\n\n\n\n');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('adda-access-token');

    // String encryptedId = encryptData(widget.authProvider.user['_id'], true);
    // String conversationId =
    //     encryptData(widget.authProvider.selectedConversation['_id'], true);

    final response = await http.get(
        Uri.parse('$baseUrl/api/messages/check/${widget.receiver['_id']}'),
        headers: {
          'authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': '49420'
        });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("data");
      print(data);
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
          // widget.authProvider.messages = decrypted;
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   _scrollToBottom();
          // });
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
              // widget.authProvider.setSelectedConversation(null, -1),
              // widget.authProvider.setMessages([]),
              // widget.authProvider.updateUser({
              //   'unreadMessageCount':
              //       widget.authProvider.user['unreadMessageCount'] - readCount
              // }),
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
                                            widget.authProvider.user['id'] ==
                                                message['senderId'];

                                        return Container(
                                          child: BubbleSpecialThree(
                                            text: message['message'],
                                            color: Color.fromARGB(
                                                207, 42, 128, 226),
                                            tail: true,
                                            isSender: isSender,
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        );
                                      }),
                                ),

                                //
                                SizedBox(
                                  height: 20,
                                ),

                                //
                                TextFormField(
                                  controller: messageController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Message can't be empty.";
                                    }
                                    return null;
                                  },
                                  // obscureText: !showPassword,
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
                                            String? token = prefs.getString(
                                                'blood-bank-access-token');

                                            String encryptedId = encryptData(
                                                widget.authProvider.user['id'],
                                                true);
                                            String conversationId = encryptData(
                                                widget.authProvider
                                                    .selectedConversation['id'],
                                                true);

                                            String donorId;

                                            if (widget.authProvider
                                                        .selectedConversation[
                                                    'user1Id'] ==
                                                widget
                                                    .authProvider.user['id']) {
                                              donorId = widget
                                                  .authProvider
                                                  .selectedConversation[
                                                      'user2Id']
                                                  .toString();
                                            } else {
                                              donorId = widget
                                                  .authProvider
                                                  .selectedConversation[
                                                      'user1Id']
                                                  .toString();
                                            }

                                            final messageData = {
                                              'message': messageController.text,
                                              'senderId': widget
                                                  .authProvider.user['id'],
                                              'receiverId': donorId,
                                              'conversationId': widget
                                                  .authProvider
                                                  .selectedConversation['id'],
                                              'senderName': widget
                                                  .authProvider.user['name']
                                            };

                                            String encryptedData =
                                                encryptData(messageData, false);

                                            // final body = {'encryptedData': encryptedData}

                                            // print(messageData);

                                            final response = await http.post(
                                                Uri.parse(
                                                    '$baseUrl/api/message/sendMessage/$encryptedId/$conversationId'),
                                                headers: {
                                                  'authorization':
                                                      'Bearer $token',
                                                  'ngrok-skip-browser-warning':
                                                      '49420',
                                                  'content-type':
                                                      'application/json'
                                                },
                                                body: json.encode({
                                                  'encryptedData': encryptedData
                                                }));

                                            if (response.statusCode == 200) {
                                              final data =
                                                  json.decode(response.body);
                                              if (!data['error']) {
                                                final decryptedData =
                                                    decryptData(
                                                        data['encryptedData']);
                                                setState(() {
                                                  // messages.insert(0, decryptedData);
                                                  widget.authProvider
                                                      .setMessages([
                                                    decryptedData,
                                                    ...widget
                                                        .authProvider.messages
                                                  ]);
                                                  messageController.text = '';
                                                });
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  _scrollToBottom();
                                                });
                                              }
                                            }

                                            setState(() {
                                              // showPassword = !showPassword;
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
