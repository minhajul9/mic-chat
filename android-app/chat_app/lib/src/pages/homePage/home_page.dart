// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/pages/messagePage/message_page.dart';
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
  AuthProvider authProvider = AuthProvider();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List users = [];

  List searchedUsers = [];
  final List<Map<String, dynamic>> menuItems = [
    {'title': '', 'route': 'logout', 'icon': Icons.logout},
  ];

  void searchUsersFromLoaded(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        searchedUsers = [];
      });
    } else {
      setState(() {
        searchedUsers = users
            .where((item) => item['fullName']
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      users = authProvider.users;
      return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            toolbarHeight: 78,
            leading: !searching
                ? IconButton(
                    onPressed: () => scaffoldKey.currentState?.openDrawer(),
                    color: Colors.white,
                    icon: Icon(
                      Icons.menu,
                    ))
                : IconButton(
                    onPressed: () {
                      setState(() {
                        searching = false;
                        searchedUsers = [];
                      });
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 35,
                      color: Colors.white,
                    )),
            title: !searching
                ?
                //conversation navbar
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
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
                      SizedBox(
                        width: 10,
                      ),

                      //
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          onChanged: (value) {
                            searchUsersFromLoaded(value);
                          },
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
          drawer: Drawer(
            child: ListView(children: [
              DrawerHeader(
                  child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: authProvider.user != null
                        ? NetworkImage(
                            authProvider.user?['profilePic'] ??
                                Icon(Icons.account_circle, size: 40),
                          )
                        : null,
                  ),
                  SizedBox(width: 8),
                  Text(
                    authProvider.user!['fullName'],
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
                ],
              )),
              ...menuItems
                  .map((item) => ListTile(
                        leading: Icon(item['icon']),
                        onTap: () async {
                          if (item['route'] == 'logout') {
                            await authProvider.logOut();
                          } else {
                            scaffoldKey.currentState?.openEndDrawer();
                            // Navigator.pushNamed(context, item['route']!);
                          }
                        },
                        title: Text(item['title']!),
                      ))
                  .toList(),
            ]),
          ),
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

                                  // print(conversation);
                                  return InkWell(
                                    onTap: () {
                                      authProvider.setSelectedConversation(
                                          conversation);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MessagePage(
                                                    authProvider: authProvider,
                                                    from: "home",
                                                    receiver: conversation[
                                                        "participants"][0],
                                                    conversation: conversation,
                                                  )));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Color.fromARGB(
                                                      164, 83, 92, 145),
                                                  width: 1))),
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            padding: EdgeInsets.all(2),
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  conversation["participants"]
                                                      [0]['profilePic']),
                                              radius: 24,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            conversation["participants"][0]
                                                ['fullName'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                })),
                  )
                : Container(
                    child: ListView.builder(
                        itemCount: searchedUsers.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final receiver = searchedUsers[index];
                          return InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MessagePage(
                                            authProvider: authProvider,
                                            from: "search",
                                            receiver: receiver,
                                            conversation: {
                                              'participants': [
                                                receiver["_id"],
                                                authProvider.user!['_id']
                                              ],
                                            },
                                          )));
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color:
                                              Color.fromARGB(164, 83, 92, 145),
                                          width: 1))),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    padding: EdgeInsets.all(2),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(receiver['profilePic']),
                                      radius: 24,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    receiver['fullName'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
          ));
    });
  }
}
