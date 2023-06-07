import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reapers_app/logins/firsttry.dart';
import 'package:reapers_app/view/add_member.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import '../logins/api_calls.dart';
import '../notifications/notify.dart';
import 'add_mem.dart';
import 'add_mentor.dart';
import 'admin_mentor.dart';
import 'all_members.dart';
import 'unassigned_members.dart';

class Home extends StatefulWidget {
  final String token;
  final dynamic admin;
  const Home({Key? key, required this.token, this.admin}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ApiCalls api = ApiCalls();
  NotificationService notificationService = NotificationService();
  List<Map<String, dynamic>> _data = [];
  int dataRange = 0;

  List<Map<String, dynamic>> _data2 = [];
  int dataRange2 = 0;

  
  List<Map<String, dynamic>> _data3 = [];
  int dataRange3 = 0;

  int total = 0;
  late String token;
  late Timer _timer;
  late dynamic admin;

  @override
  void initState() {
    super.initState();
    token = widget.token;
    admin = widget.admin;
    _fetchData();
    // Start a timer to call fetchData every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _fetchData());
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      List<Map<String, dynamic>> result = await api.streamFuture(
          widget.token, "https://rcc-discipleship.up.railway.app/api/members/");

      List<Map<String, dynamic>> result2 = await api.streamFuture(
          widget.token, "https://rcc-discipleship.up.railway.app/api/mentors/");
          
      List<Map<String, dynamic>> result3 = await api.streamFuture(
          widget.token, "https://rcc-discipleship.up.railway.app/api/mentors/");
      setState(() {
        _data = result;
        dataRange = _data.length;

        _data2 = result2;
        dataRange2 = _data2.length;

         _data3 = result3;
        dataRange3 = _data3.length;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // String phoneNumber = '+1234567890';
  void makePhoneCall(String phoneNumber) async {
    // ignore: deprecated_member_use
    if (await canLaunch('tel:$phoneNumber')) {
      // ignore: deprecated_member_use
      await launch('tel:$phoneNumber');
    } else {
      //   throw 'Could not launch $phoneNumber';
    }
  }

  void sendSMS(String phoneNumber) async {
    // ignore: deprecated_member_use
    if (await canLaunch('sms:$phoneNumber')) {
      // ignore: deprecated_member_use
      await launch('sms:$phoneNumber');
    } else {
      //   throw 'Could not launch $phoneNumber';
    }
  }

// adding notification
  void showNotification() {
    final now = DateTime.now();
    DateTime newDate = DateTime(2023, 05, 28, 20, 03, 00, 922, 879);
    final currentMonth = now.month;
    final current = now.month;
    // if (currentMonth == current) {
    //   notificationService.showNotification(
    //       title: "first test", body: "this is body");
    // }

    //print(now);
  }

  @override
  Widget build(BuildContext context) {
    // showNotification();
    return Scaffold(
        body: Column(children: [
          CustomPaint(
              painter: LogoPainter(),
              size: const Size(400, 195),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 25,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'https://res.cloudinary.com/dekhxk5wg/image/upload/v1681573495/logo_tkpxbk.jpg'),
                    ),
                    title: Text(
                      'Welcome, ${admin['user']['first_name'] != null && admin['user']['first_name'].isNotEmpty ? '${admin['user']['first_name'][0].toUpperCase()}${admin['user']['first_name'].substring(1)}' : " "}',
                      style: const TextStyle(color: Colors.white),
                    ),

                    subtitle: const Text(
                      "Administrator",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    trailing: PopupMenuButton<int>(
                      icon: const Icon(Icons.more_vert_rounded,
                          color: Colors.white),

                      itemBuilder: (context) => [
                        // PopupMenuItem 1
                        PopupMenuItem(
                          value: 1,
                          // row with 2 children
                          child: Row(
                            children: const [
                              Icon(Icons.admin_panel_settings_rounded,
                                  color: Colors.green),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Add Discipler",
                                style: TextStyle(color: Colors.green),
                              )
                            ],
                          ),
                        ),
                        // PopupMenuItem 2
                        PopupMenuItem(
                          value: 2,
                          // row with two children
                          child: Row(
                            children: const [
                              Icon(Icons.login_outlined),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Logout")
                            ],
                          ),
                        ),
                      ],
                      // offset: Offset(0, 100),
                      // color: Colors.grey,
                      elevation: 2,
                      // on selected we show the dialog box
                      onSelected: (value) {
                        // if value 1 show dialog
                        if (value == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddMentorPage(token: token),
                            ),
                          );
                          // _showDialog(context);
                          // if value 2 show dialog
                        } else if (value == 2) {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginForm(),
                            ),
                          );
                          //  _showDialog(context);
                        }
                      },
                    ),

                    // InkWell(
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => AddMentorPage(token: token),
                    //       ),
                    //     );
                    //   },
                    //   child: const Icon(Icons.admin_panel_settings_rounded,
                    //       color: Colors.white, size: 40),
                    // ),
                  ),
                ),

                //_appBarContent(dataRange2)
              )),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  const Text(
                    'Disciplers',
                    style: TextStyle(
                      fontSize: 18,
                      //fontFamily: 'Alto',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 87, 204, 91),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        ' ${dataRange2} ',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          FutureBuilder<List<dynamic>>(
            future: api.streamFuture(
                token, "https://rcc-discipleship.up.railway.app/api/mentors/"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<dynamic> data = snapshot.data!;
                final int dataLength = data.length;

                return Expanded(
                  child: SizedBox(
                    height: 500,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final mentor = data[index];
                        final String firstName =
                            mentor['member']['first_name'] ?? "Name";
                        final String lastName =
                            mentor['member']['last_name'] ?? "Not updated";

                        final String capitalizedFirstName = firstName.isNotEmpty
                            ? '${firstName[0].toUpperCase()}${firstName.substring(1)}'
                            : firstName;

                        final String capitalizedLastName = lastName.isNotEmpty
                            ? '${lastName[0].toUpperCase()}${lastName.substring(1)}'
                            : lastName;

                        return Slidable(
                          key: Key(index.toString()),
                          startActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                backgroundColor: Colors.green,
                                onPressed: (context) {
                                  makePhoneCall(
                                      mentor['member']['phone_number']);
                                },
                                icon: Icons.call,
                              ),
                              SlidableAction(
                                backgroundColor: Colors.blue,
                                onPressed: (context) {
                                  sendSMS(mentor['member']['phone_number']);
                                },
                                icon: Icons.message,
                              )
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MentorManagementPage(
                                      token: token, mentor: mentor),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 8, top: 2),
                              child: Card(
                                elevation: 3,
                                child: ListTile(
                                  tileColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  title: Text(
                                      "$capitalizedFirstName $capitalizedLastName"),
                                  subtitle: Row(
                                    children: [
                                      const Icon(
                                        Icons.call,
                                        color: Colors.green,
                                        size: 15,
                                      ),
                                      Text(
                                        mentor['member']['phone_number'] ??
                                            "not updates",
                                      ),
                                    ],
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(mentor[
                                            'member']['photo'] ??
                                        "https://res.cloudinary.com/dekhxk5wg/image/upload/v1681630522/placeholder_ewiwh7.png"),
                                  ),
                                  trailing: Column(
                                    children: [
                                      // const Text("Disciplers"),
                                      // const Icon(Icons.arrow_forward_rounded,
                                      //     color: Colors.green),
                                      const SizedBox(height: 10),
                                      const Icon(Icons.people_outline,
                                          color: Colors.green, size: 15),
                                      // adding number of disciplers
                                      StreamBuilder<List<dynamic>>(
                                        stream: api.stream(token,
                                            'https://rcc-discipleship.up.railway.app/api/mentors/${mentor['id']}/mentees/'),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final List<dynamic> data =
                                                snapshot.data!;
                                            final int dataLength = data.length;

                                            return Text(dataLength.toString(),
                                                style: const TextStyle(
                                                    fontSize: 10));
                                          } else {
                                            return const Text(
                                              "0",
                                              style: TextStyle(fontSize: 10),
                                            );
                                            // CircularProgressIndicator();
                                          }
                                        },
                                      ),
                                      //
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("lost connection, double check network")
                  //  Text('Error: ${snapshot.error}')
                  ,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ]),

        // FutureBuilder<List<dynamic>>(
        //   future: api.streamFuture(
        //       token, "https://rcc-discipleship1.up.railway.app/api/mentors/"),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       final List<dynamic> data = snapshot.data!;
        //       final int dataLength = data.length;

        //       return Column(
        //         children: [
        //           CustomPaint(
        //               painter: LogoPainter(),
        //               size: const Size(400, 195),
        //               child: _appBarContent(dataLength)),
        //           const Align(
        //             alignment: Alignment.topLeft,
        //             child: Padding(
        //               padding: EdgeInsets.only(left: 20),
        //               child: Text(
        //                 "Disciplers List",
        //                 style: TextStyle(
        //                   fontSize: 18,
        //                   fontFamily: 'Lato',
        //                   fontWeight: FontWeight.w700,
        //                 ),
        //               ),
        //             ),
        //           ),
        //           Expanded(
        //             child: SizedBox(
        //               height: 500,
        //               child: ListView.builder(
        //                 itemCount: data.length,
        //                 itemBuilder: (context, index) {
        //                   final mentor = data[index];
        //                   final String firstName =
        //                       mentor['member']['first_name'] ?? "Name";
        //                   final String lastName =
        //                       mentor['member']['last_name'] ?? "Not updated";
        //                   return InkWell(
        //                     onTap: () {
        //                       Navigator.push(
        //                         context,
        //                         MaterialPageRoute(
        //                           builder: (context) => MentorManagementPage(
        //                               token: token, mentor: mentor),
        //                         ),
        //                       );
        //                     },
        //                     child: Padding(
        //                       padding: const EdgeInsets.only(
        //                           left: 15, right: 15, bottom: 8, top: 2),
        //                       child: Card(
        //                         elevation: 3,
        //                         child: ListTile(
        //                           tileColor:
        //                               const Color.fromARGB(255, 255, 255, 255),
        //                           title: Text("$firstName $lastName"),
        //                           subtitle: Row(
        //                             children: [
        //                               const Icon(
        //                                 Icons.call,
        //                                 color: Colors.green,
        //                                 size: 15,
        //                               ),
        //                               Text(
        //                                 mentor['member']['phone_number'] ??
        //                                     "not updates",
        //                               ),
        //                             ],
        //                           ),
        //                           leading: CircleAvatar(
        //                             backgroundImage: NetworkImage(mentor[
        //                                     'member']['photo'] ??
        //                                 "https://res.cloudinary.com/dekhxk5wg/image/upload/v1681630522/placeholder_ewiwh7.png"),
        //                           ),
        //                           trailing: Column(
        //                             children: [
        //                               // const Text("Disciplers"),
        //                               // const Icon(Icons.arrow_forward_rounded,
        //                               //     color: Colors.green),
        //                               const SizedBox(height: 10),
        //                               const Icon(Icons.people_outline,
        //                                   color: Colors.green, size: 15),
        //                               // adding number of disciplers
        //                               StreamBuilder<List<dynamic>>(
        //                                 stream: api.stream(token,
        //                                     'https://rcc-discipleship1.up.railway.app/api/mentors/${mentor['id']}/mentees/'),
        //                                 builder: (context, snapshot) {
        //                                   if (snapshot.hasData) {
        //                                     final List<dynamic> data =
        //                                         snapshot.data!;
        //                                     final int dataLength = data.length;

        //                                     return Text(dataLength.toString(),
        //                                         style: const TextStyle(
        //                                             fontSize: 10));
        //                                   } else {
        //                                     return const Text(
        //                                       "0",
        //                                       style: TextStyle(fontSize: 10),
        //                                     );
        //                                     // CircularProgressIndicator();
        //                                   }
        //                                 },
        //                               ),
        //                               //
        //                             ],
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   );
        //                 },
        //               ),
        //             ),
        //           ),
        //         ],
        //       );
        //     } else if (snapshot.hasError) {
        //       return Center(
        //         child: Text('Error: ${snapshot.error}'),
        //       );
        //     } else {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //   },
        // ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 10,
          shape: const CircularNotchedRectangle(),
          child: Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.group_rounded, color: Colors.green),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AllMembersPage(
                        token: token,
                      );
                    }));
                  }),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AllMembersPage(
                        token: token,
                      );
                    }));
                  },
                  child: Row(
                    children: [
                      const Text(
                        'All members',
                        style: const TextStyle(fontSize: 10),
                      ),
                      const SizedBox(width: 4),
                      DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 87, 204, 91),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            ' ${dataRange} ',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                        ),
                      )
                    ],
                  )),
              const Spacer(),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return UnassignedMembersPage(
                        token: token,
                      );
                    }));
                  },
                  child:
                      const Text("Unassigned", style: TextStyle(fontSize: 10))),
              IconButton(
                  icon: const Icon(
                    Icons.person_add_disabled,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return UnassignedMembersPage(
                        token: token,
                      );
                    }));
                  }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigator.of(context).pop();
            // print('this is admin--------- $admin');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        // AddMember()
                        // AddMemberPage(token: token),
                        AddMemberPage(
                          token: token,
                        )));
          },
          tooltip: 'Unassigned Members',
          //insert_chart
          child: const Icon(Icons.add),
          // backgroundColor: Colors.blue,
          // splashColor: Colors.lightGreenAccent,
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }

  Widget _appBarContent(int dataLength) {
    return Container(
      height: 130,
      width: 400,
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [
          // _header(),
          const SizedBox(
            height: 20,
          ),
          _userInfo(dataLength)
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 30,
        ),
        Icon(
          Icons.menu,
          color: Colors.white,
          size: 30,
        )
      ],
    );
  }

  Widget _userInfo(int dataLength) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        //  _userAvatar(),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              _userPersonalInfo(),
              const SizedBox(
                height: 25,
              ),
              // Row(
              //   children: [
              //     const SizedBox(
              //       width: 4,
              //     ),
              //     Card(
              //       color: const Color.fromARGB(199, 6, 146, 60),
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Row(children: [
              //           const Text(
              //             "Disciplers",
              //             style: TextStyle(color: Colors.white),
              //           ),
              //           const SizedBox(
              //             width: 4,
              //           ),
              //           DecoratedBox(
              //             decoration: const BoxDecoration(
              //               color: Color.fromARGB(255, 87, 204, 91),
              //               borderRadius: BorderRadius.all(Radius.circular(2)),
              //             ),
              //             child: Padding(
              //               padding: const EdgeInsets.only(left: 2),
              //               child: Text(
              //                 "$dataLength ",
              //                 style: const TextStyle(
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.w500,
              //                     fontSize: 17),
              //               ),
              //             ),
              //           ),
              //         ]),
              //       ),
              //     ),
              //     Expanded(
              //         child: InkWell(
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => AllMembersPage(token: token),
              //           ),
              //         );
              //       },
              //       child: Column(
              //         // crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.only(right: 50, left: 10),
              //             child: Card(
              //               color: const Color.fromARGB(199, 6, 146, 60),
              //               child: Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Row(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     children: [
              //                       const Text(
              //                         "Members",
              //                         style: TextStyle(color: Colors.white),
              //                       ),
              //                       const SizedBox(
              //                         width: 4,
              //                       ),
              //                       DecoratedBox(
              //                         decoration: const BoxDecoration(
              //                           color: Color.fromARGB(255, 87, 204, 91),
              //                           borderRadius: BorderRadius.all(
              //                               Radius.circular(2)),
              //                         ),
              //                         child: Padding(
              //                           padding: const EdgeInsets.only(left: 2),
              //                           child: Text(
              //                             " $dataRange ",
              //                             style: const TextStyle(
              //                                 color: Colors.white,
              //                                 fontWeight: FontWeight.w500,
              //                                 fontSize: 17),
              //                           ),
              //                         ),
              //                       ),
              //                     ]),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ))
              //     // FutureBuilder<List<dynamic>>(
              //     //   future: api.streamFuture(token,
              //     //       "https://rcc-discipleship1.up.railway.app/api/members/"),
              //     //   builder: (context, snapshot) {
              //     //     if (snapshot.hasData) {
              //     //       final List<dynamic> data = snapshot.data!;
              //     //       final int dataLength = data.length;
              //     //       return Expanded(
              //     //           child: InkWell(
              //     //         onTap: () {
              //     //           Navigator.push(
              //     //             context,
              //     //             MaterialPageRoute(
              //     //               builder: (context) =>
              //     //                   AllMembersPage(token: token),
              //     //             ),
              //     //           );
              //     //         },
              //     //         child: Column(
              //     //           // crossAxisAlignment: CrossAxisAlignment.center,
              //     //           children: [
              //     //             Padding(
              //     //               padding:
              //     //                   const EdgeInsets.only(right: 50, left: 10),
              //     //               child: Card(
              //     //                 color: const Color.fromARGB(199, 6, 146, 60),
              //     //                 child: Padding(
              //     //                   padding: const EdgeInsets.all(8.0),
              //     //                   child: Row(
              //     //                       mainAxisAlignment:
              //     //                           MainAxisAlignment.center,
              //     //                       children: [
              //     //                         const Text(
              //     //                           "Members",
              //     //                           style:
              //     //                               TextStyle(color: Colors.white),
              //     //                         ),
              //     //                         const SizedBox(
              //     //                           width: 4,
              //     //                         ),
              //     //                         DecoratedBox(
              //     //                           decoration: const BoxDecoration(
              //     //                             color: Color.fromARGB(
              //     //                                 255, 87, 204, 91),
              //     //                             borderRadius: BorderRadius.all(
              //     //                                 Radius.circular(2)),
              //     //                           ),
              //     //                           child: Padding(
              //     //                             padding: const EdgeInsets.only(
              //     //                                 left: 2),
              //     //                             child: Text(
              //     //                               "$dataLength ",
              //     //                               style: const TextStyle(
              //     //                                   color: Colors.white,
              //     //                                   fontWeight: FontWeight.w500,
              //     //                                   fontSize: 17),
              //     //                             ),
              //     //                           ),
              //     //                         ),
              //     //                       ]),
              //     //                 ),
              //     //               ),
              //     //             ),
              //     //           ],
              //     //         ),
              //     //       ));
              //     //     } else if (snapshot.hasError) {
              //     //       return Card(
              //     //         child: Text('Error: ${snapshot.error}'),
              //     //       );
              //     //     } else {
              //     //       return const Text("");
              //     //     }
              //     //   },
              //     // ),
              //   ],
              // )
              // _userFollowInfo(dataLength)
            ],
          ),
        )
      ],
    );
  }

  Widget _userAvatar() {
    return const CircleAvatar(
      backgroundImage: NetworkImage(
          'https://res.cloudinary.com/dekhxk5wg/image/upload/v1681573495/logo_tkpxbk.jpg'),
      radius: 25,
    );
  }

  Widget _userPersonalInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Admin Name',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.white),
              ),
              Text(
                'Admin ',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      // AddMember()
                      AddMentorPage(token: token),
                ),
              );
            },
            child: const Icon(Icons.admin_panel_settings_rounded,
                color: Colors.white, size: 40),

            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: const Center(
            //     child: Text(
            //       'Add Member',
            //       style: TextStyle(
            //           color: Colors.green,
            //           // Color.fromARGB(255, 177, 22, 234),
            //           fontWeight: FontWeight.w500),
            //     ),
            //   ),
            // ),
          ),
        )
      ],
    );
  }

  Widget _userFollowInfo(int dataLength) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Card(
          color: const Color.fromARGB(199, 6, 146, 60),
          child: Row(children: [
            const Text("Disciplers"),
            DecoratedBox(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 87, 204, 91),
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  dataLength.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
              ),
            ),
          ]),
        ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Text(
        //       dataLength.toString(),
        //       style: const TextStyle(
        //           color: Colors.white,
        //           fontWeight: FontWeight.w500,
        //           fontSize: 17),
        //     ),
        //     // const SizedBox(
        //     //   height: 15,
        //     // ),
        //     // const Text(
        //     //   'Disciplers',
        //     //   style: TextStyle(
        //     //       color: Colors.white,
        //     //       fontWeight: FontWeight.w500,
        //     //       fontSize: 11),
        //     // ),
        //   ],
        // ),

        StreamBuilder<List<dynamic>>(
          stream: api.stream(
              token, "https://rcc-discipleship.up.railway.app/api/members/"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<dynamic> data = snapshot.data!;
              final int dataLength = data.length;
              return Expanded(
                  child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllMembersPage(token: token),
                    ),
                  );
                },
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: Card(
                        color: Color.fromARGB(199, 6, 146, 60),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Members",
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              DecoratedBox(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 87, 204, 91),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    dataLength.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    // const Text(
                    //   'Members',
                    //   style: TextStyle(
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.w500,
                    //       fontSize: 11),
                    // ),
                  ],
                ),
              ));
            } else if (snapshot.hasError) {
              return Card(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return const Text("");
            }
          },
        ),
        //
      ],
    );
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    Paint paint = Paint();
    Path path = Path();
    paint.shader = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.green,
        Colors.green,
        // Color.fromARGB(255, 87, 241, 40),
        // Color.fromARGB(255, 12, 168, 12)
        // Color.fromARGB(255, 242, 101, 197),
        // Color.fromARGB(255, 154, 76, 237),
      ],
    ).createShader(rect);
    path.lineTo(0, size.height - size.height / 8);
    path.conicTo(size.width / 1.2, size.height, size.width,
        size.height - size.height / 8, 9);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawShadow(path, const Color.fromARGB(255, 242, 101, 197), 4, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
