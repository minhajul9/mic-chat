// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool searching = false;

  List<Map<String, dynamic>> searchedUsers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 78,
          title: !searching
              ?
              //conversation navbar
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.menu,
                              size: 35,
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image(
                            image: AssetImage('assets/images/logo.png'),
                            width: 70,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            searching = true;
                          });
                        },
                        icon: Icon(
                          Icons.search,
                          size: 35,
                          color: Colors.white,
                        ))
                  ],
                )
              :
              //searching navbar

              Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            searching = false;
                          });
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 35,
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: 10,
                    ),

                    //
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        // controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter something.";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            // filled: true,
                            // fillColor: Colors.white,
                            hintText: "Search",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 83, 92,
                                      145)), // Border color when enabled
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {},
                            )),
                      ),
                    )
                  ],
                ),
          backgroundColor: Color.fromARGB(255, 146, 144, 195),
        ),
        backgroundColor: Color.fromARGB(255, 7, 15, 43),
        body: SingleChildScrollView(
          child: !searching
              ? Container(
                  child: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) =>
                          ListView.builder(
                              itemCount: authProvider.conversations.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final conversation =
                                    authProvider.conversations[index];
                                return InkWell();
                              })),
                )
              : Container(
                  child: ListView.builder(
                      itemCount: searchedUsers.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final user = searchedUsers[index];
                        return InkWell();
                      }),
                ),
        ));
  }
}
