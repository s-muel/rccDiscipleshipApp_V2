import 'package:flutter/material.dart';
import 'package:reapers_app/view/add_member.dart';

import '../logins/api_calls.dart';
import 'add_mem.dart';
import 'admin_mentor.dart';
import 'all_members.dart';
import 'unassigned_members.dart';

class Home extends StatefulWidget {
  final String token;
  const Home({Key? key, required this.token}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ApiCalls api = ApiCalls();
  int total = 0;
  late String token;
  @override
  void initState() {
    super.initState();
    token = widget.token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<List<dynamic>>(
          stream: api.stream(
              token, "https://rcc-discipleship.up.railway.app/api/mentors/"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<dynamic> data = snapshot.data!;
              final int dataLength = data.length;
              return Column(
                children: [
                  CustomPaint(
                      painter: LogoPainter(),
                      size: const Size(400, 195),
                      child: _appBarContent(dataLength)),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Disciplers List",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )),
                  Expanded(
                    child: SizedBox(
                      height: 500,
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final mentor = data[index];
                          return InkWell(
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
                                      '${mentor['member']['first_name']} ${mentor['member']['last_name']}'),
                                  subtitle: Row(
                                    children: [
                                      const Icon(
                                        Icons.call,
                                        color: Colors.green,
                                        size: 15,
                                      ),
                                      Text(
                                        mentor['member']['phone_number'],
                                      ),
                                    ],
                                  ),
                                  leading: const CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://scontent.facc6-1.fna.fbcdn.net/v/t1.6435-9/72890290_2351127111666572_1564614095821340672_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=8bfeb9&_nc_eui2=AeFIgKzN8pVoMtmF9CUNMHXjv5plVhw5eVS_mmVWHDl5VIq0ghNslvr9e10vTpbD-0jbBf1MDkpHbm9P9BHSELJq&_nc_ohc=poJq08SR9D4AX9-sy5p&_nc_ht=scontent.facc6-1.fna&oh=00_AfDJxzyS_nqdRPSvE14r_XJKoD0-eVlZaQOgf7yrr_UTYA&oe=645B36C3'),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward),
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
                  child: const Text(
                    "All members",
                    style: TextStyle(fontSize: 10),
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
        _userAvatar(),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _userPersonalInfo(),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 4,
                  ),
                  Card(
                    color: const Color.fromARGB(199, 6, 146, 60),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        const Text(
                          "Disciplers",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        DecoratedBox(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 87, 204, 91),
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Text(
                              " $dataLength ",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  StreamBuilder<List<dynamic>>(
                    stream: api.stream(token,
                        "https://rcc-discipleship.up.railway.app/api/members/"),
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
                                builder: (context) =>
                                    AllMembersPage(token: token),
                              ),
                            );
                          },
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 50, left: 10),
                                child: Card(
                                  color: const Color.fromARGB(199, 6, 146, 60),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Members",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          DecoratedBox(
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 87, 204, 91),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2)),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2),
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
                                ),
                              ),
                        
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
                ],
              )
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
                      AddMemberPage(token: token),
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
