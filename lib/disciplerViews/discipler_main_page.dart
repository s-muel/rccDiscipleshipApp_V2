import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reapers_app/disciplerViews/disciple_details_page.dart';
import 'package:reapers_app/view/trypage2.dart';
import 'package:url_launcher/url_launcher.dart';

import '../logins/api_calls.dart';
import '../logins/firsttry.dart';
import 'checkup_history.dart';
import 'dis_add_member.dart';
import 'dis_all_members.dart';

class DisciplerMainPage extends StatefulWidget {
  final String token;
  final dynamic mentor;
  const DisciplerMainPage({super.key, required this.token, this.mentor});

  @override
  State<DisciplerMainPage> createState() => _DisciplerMainPageState();
}

class _DisciplerMainPageState extends State<DisciplerMainPage> {
  ApiCalls api = ApiCalls();
  final _formKey = GlobalKey<FormState>();
  final discipleStatus = TextEditingController();
  final lifeEvent = TextEditingController();
  final request = TextEditingController();
  late String token;
  late dynamic mentor;
  late int mentorID = mentor;
  bool wednesday = false;
  bool friday = false;
  bool sunday = false;
  final bool _value = false;
  // late String mentorName;

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

  //resetting the form
  void resetForm() {
    setState(() {
      wednesday = false;
      friday = false;
      sunday = false;
      discipleStatus.text = '';
      lifeEvent.text = "";
      request.text = "";
      // Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    token = widget.token;
    mentor = widget.mentor;
    // mentorName = "loading";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(mentorName),
        //   actions: const [
        //     CircleAvatar(
        //       backgroundImage: NetworkImage(
        //           'https://e1.pngegg.com/pngimages/444/382/png-clipart-frost-pro-for-os-x-icon-set-now-free-contacts-male-profile.png'),
        //       radius: 50,
        //     )
        //   ],
        // ),
        body: StreamBuilder<List<dynamic>>(
          stream: api.stream(
              token, 'https://rcc-discipleship.up.railway.app/api/members/'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<dynamic> data = snapshot.data!;
              final int dataLength = data.length;
              String firstName = mentor['user']['first_name'] ?? " ";
              String lastName = mentor['user']['last_name'] ?? "";
              String disciplerPhoto = mentor['user']['photo'] ??
                  "https://res.cloudinary.com/dekhxk5wg/image/upload/v1681630522/placeholder_ewiwh7.png";
              // Map<String, dynamic> user = data.firstWhere((user) => user['id'] == 6,
              //     orElse: () => Map<String, dynamic>());

              // if (user != null) {
              //   firstName = user['first_name'];
              // }
              // for (var user in data) {
              //   if (user['id'] == mentor) {
              //     firstName = user['first_name'];
              //     print(user['id']);
              //     break;
              //   }
              // }

              // print(
              //     'The first name of user with ID ${mentor['user']['id']}, ${mentor['user']['first_name']}');

              // String? mentorName;
              // if(data['id']==mentor){
              // String firstName = data['first_name'];
              // }
              // for (var item in data) {
              //   if (item['id'] == mentor) {
              //     mentorName = item["first_name"].toString();
              //     print(item);

              //     break; // Stop searching after finding the first match
              //   }
              // }

              return Column(
                children: [
                  CustomPaint(
                    painter: LogoPainter(),
                    size: const Size(400, 105),
                    child: Container(
                      height: 120,
                      width: 400,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 13),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 25,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(disciplerPhoto),
                          ),
                          title: Text(
                            'Welcome, $firstName',
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: const Text(
                            "Discipler",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                          trailing: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginForm(),
                                  ),
                                );
                              },
                              child: const Icon(Icons.login_outlined,
                                  color: Colors.white)),
                        ),
                      ),
                      // Column(
                      //   children: [
                      //     const SizedBox(
                      //       height: 15,
                      //     ),
                      //     Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         const CircleAvatar(
                      //           radius: 25,
                      //         ),
                      //         const SizedBox(
                      //           width: 10,
                      //         ),
                      //         Expanded(
                      //           flex: 2,
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: const [
                      //               Text(
                      //                 'Discipler Name',
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.w500,
                      //                     fontSize: 17,
                      //                     color: Colors.white),
                      //               ),
                      //               Text(
                      //                 'Discipler',
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.w500,
                      //                     fontSize: 10,
                      //                     color: Colors.white),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           height: 30,
                      //           child: InkWell(
                      //             onTap: () {
                      //               Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                   builder: (context) =>
                      //                       // AddMember()
                      //                       AddMemberPage(token: token),
                      //                 ),
                      //               );
                      //             },
                      //             child: const Icon(
                      //                 Icons.admin_panel_settings_rounded,
                      //                 color: Colors.white,
                      //                 size: 40),

                      //             // Container(
                      //             //   decoration: BoxDecoration(
                      //             //     color: Colors.white,
                      //             //     borderRadius: BorderRadius.circular(10),
                      //             //   ),
                      //             //   child: const Center(
                      //             //     child: Text(
                      //             //       'Add Member',
                      //             //       style: TextStyle(
                      //             //           color: Colors.green,
                      //             //           // Color.fromARGB(255, 177, 22, 234),
                      //             //           fontWeight: FontWeight.w500),
                      //             //     ),
                      //             //   ),
                      //             // ),
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.only(
                      //           top: 10, left: 120, right: 120),
                      //       child: Card(
                      //         color: const Color.fromARGB(199, 6, 146, 60),
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 const Text(
                      //                   "Disciplers",
                      //                   style: TextStyle(color: Colors.white),
                      //                 ),
                      //                 const SizedBox(
                      //                   width: 4,
                      //                 ),
                      //                 DecoratedBox(
                      //                   decoration: const BoxDecoration(
                      //                     color:
                      //                         Color.fromARGB(255, 87, 204, 91),
                      //                     borderRadius: BorderRadius.all(
                      //                         Radius.circular(2)),
                      //                   ),
                      //                   child: Padding(
                      //                     padding:
                      //                         const EdgeInsets.only(left: 2),
                      //                     child: Text(
                      //                       " $dataLength ",
                      //                       style: const TextStyle(
                      //                           color: Colors.white,
                      //                           fontWeight: FontWeight.w500,
                      //                           fontSize: 17),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ]),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: Row(
                        children: [
                          const Text(
                            "Disciples",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          DecoratedBox(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 87, 204, 91),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                ' $dataLength ',
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
                  Expanded(
                    child: SizedBox(
                      height: 500,
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          final menteeID = item['id'];
                          final String name =
                              item['first_name'] + " " + item['last_name'];
                          return Slidable(
                            key: Key(index.toString()),
                            startActionPane: ActionPane(
                              
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  backgroundColor: Colors.green,
                                  onPressed: (context) {
                                    makePhoneCall(item['phone_number']);
                                  },
                                  icon: Icons.call,
                                ),
                                SlidableAction(
                                  backgroundColor: Colors.blue,
                                  onPressed: (context) {
                                    sendSMS(item['phone_number']);
                                  },
                                  icon: Icons.message,
                                )
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                trackerSheet(context, menteeID, name, item);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, bottom: 8, top: 2),
                                child: Card(
                                  child: ListTile(
                                    title: Text(
                                        "${item['first_name']} ${item['last_name']}"),
                                    subtitle: Row(
                                      children: [
                                        const Icon(
                                          Icons.call,
                                          color: Colors.green,
                                          size: 15,
                                        ),
                                        Text(
                                          item['phone_number'],
                                        ),
                                      ],
                                    ),

                                    // Text(item['phone_number'])

                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(item[
                                              'photo'] ??
                                          "https://res.cloudinary.com/dekhxk5wg/image/upload/v1681630522/placeholder_ewiwh7.png"),
                                    ),
                                    trailing: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DiscipleDetailsPage(
                                                      initialData: item,
                                                      token: token),
                                            ),
                                          );
                                        },
                                        child: const Text("Details")),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
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
                      return DisAllMembersPage(
                        token: token,
                      );
                    }));
                  }),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DisAllMembersPage(
                        token: token,
                      );
                    }));
                  },
                  child: const Text(
                    "All members",
                    style: TextStyle(fontSize: 10),
                  )),
              const Spacer(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigator.of(context).pop();

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DisAddMemberPage(
                          token: token,
                        )));
          },
          tooltip: 'Add Members',
          //insert_chart
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked);
  }

  Future<dynamic> trackerSheet(BuildContext context, int memberID, name, item) {
    return showModalBottomSheet(
        backgroundColor: Colors.white.withOpacity(0.2),
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SafeArea(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.9,
                  // minChildSize: 0.2,
                  // maxChildSize: 1,
                  expand: false,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: Stack(children: [
                        Positioned(
                          top: -5,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors
                                    .green, // set the desired background color
                                borderRadius: BorderRadius.circular(
                                    10), // set the desired amount of rounding
                              ),
                              height: 10,
                              width: 50,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: [
                                    const Icon(Icons.person,
                                        color: Colors.green),
                                    Text("$name"),
                                    const Spacer(),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReportHistoryPage(
                                                      menteeID: memberID,
                                                      token: token,
                                                      data: item),
                                            ),
                                          );
                                        },
                                        child: const Text("History"))
                                  ],
                                ),
                              ),
                              Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      const Text("Church Attendance"),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: const [
                                          Expanded(
                                            child: Text(
                                              'Wednesday',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Friday',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Sunday',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Checkbox(
                                              value: wednesday,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  wednesday = value!;
                                                });
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: Checkbox(
                                              value: friday,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  friday = value!;
                                                });
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: Checkbox(
                                              value: sunday,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  sunday = value!;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25, bottom: 30),
                                        child: TextFormField(
                                          maxLines: null,
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          controller: discipleStatus,
                                          decoration: InputDecoration(
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            labelText: 'How is disciple doing',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            // contentPadding:
                                            //EdgeInsets.all(8.0),
                                            // const EdgeInsets.symmetric(
                                            //     vertical: 20.0),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter a report';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25, bottom: 30),
                                        child: TextFormField(
                                          maxLines: null,
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          controller: lifeEvent,
                                          decoration: InputDecoration(
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            labelText:
                                                'Significant life events / Challenges',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            // contentPadding:
                                            //     const EdgeInsets.symmetric(
                                            //         vertical: 20.0),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter a report';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25, bottom: 30),
                                        child: TextFormField(
                                          maxLines: null,
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          controller: request,
                                          decoration: InputDecoration(
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            labelText:
                                                'Disciple discussion / requests',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            // contentPadding:
                                            //     const EdgeInsets.symmetric(
                                            //         vertical: 20.0),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter a report';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            // check validation
                                            api.submitReport(
                                              token: token,
                                              memberID: memberID,
                                              wednesday: wednesday,
                                              friday: friday,
                                              sunday: sunday,
                                              disStatus: discipleStatus.text,
                                              lifeEvent: lifeEvent.text,
                                              request: request.text,
                                              context: context,
                                            );
                                            setState(() {});

                                            resetForm();
                                          }
                                        },
                                        child: const Text('Submit Report'),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ]),
                    );
                  },
                ),
              );
            },
          );
        });
  }
}

void _showModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.music_note),
                  title: const Text('Music'),
                  onTap: () => {}),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Video'),
                onTap: () => {},
              ),
            ],
          ),
        );
      });
}
