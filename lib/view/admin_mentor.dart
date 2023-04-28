import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../logins/api_calls.dart';
import 'member_details_page.dart';

class MentorManagementPage extends StatefulWidget {
  final String token;
  final dynamic mentor;
  const MentorManagementPage({super.key, required this.token, this.mentor});

  @override
  State<MentorManagementPage> createState() => _MentorManagementPageState();
}

class _MentorManagementPageState extends State<MentorManagementPage> {
  ApiCalls api = ApiCalls();
  late String token;
  late dynamic mentor;
  late int mentorID = mentor['id'];
  @override
  void initState() {
    super.initState();
    token = widget.token;
    mentor = widget.mentor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text(mentor['member']['first_name'] +
              " " +
              mentor['member']['last_name']),
          actions: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  mentor['member']['photo'] ??
                      "https://res.cloudinary.com/dekhxk5wg/image/upload/v1681630522/placeholder_ewiwh7.png",
                ),
                radius: 50,
              ),
            )
          ],
        ),
        body: StreamBuilder<List<dynamic>>(
          stream: api.stream(token,
              'https://rcc-discipleship1.up.railway.app/api/mentors/$mentorID/mentees/'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<dynamic> data = snapshot.data!;
              final int dataLength = data.length;

              return Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 500,
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          final menteeID = item['id'];
                          return InkWell(
                            onTap: () {
                              trackerSheet(context, menteeID);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 3, top: 6),
                              child: Card(
                                elevation: 3,
                                child: ListTile(
                                  title: Text(item['first_name'].toString()),
                                  subtitle: Text(item['email']),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(item[
                                            'photo'] ??
                                        "https://res.cloudinary.com/dekhxk5wg/image/upload/v1681630522/placeholder_ewiwh7.png"),
                                  ),
                                  trailing: TextButton(
                                      onPressed: () {
                                        trackerSheet(context, menteeID);
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //     MyForm(
                                        //         initialData: item, token: token),
                                        //   ),
                                        // );
                                      },
                                      child: const Text("View Reports")),
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
        ));
  }

  Future<dynamic> trackerSheet(BuildContext context, int menteeID) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.25,
          maxChildSize: 0.75,
          builder: (BuildContext context, ScrollController scrollController) {
            return StreamBuilder<List<dynamic>>(
              stream: api.stream(token,
                  'https://rcc-discipleship1.up.railway.app/api/mentors/$mentorID/mentees/$menteeID/report/'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<dynamic> data = snapshot.data!;
                  final int dataLength = data.length;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return InkWell(
                        onTap: () {
                          //  trackerSheet(context);
                        },
                        child: Card(
                          child: ListTile(
                            title: Row(children: [
                              Icon(Icons.date_range),
                              Text(item['created_at'].toString())
                            ]),
                            subtitle: Text(item['report_text']),
                          ),
                        ),
                      );
                    },
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
            );
          },
        );
      },
    );
  }

  // Future<dynamic> trackerSheet(BuildContext context) {
  //   return showModalBottomSheet(
  //                             context: context,
  //                             builder: (BuildContext context) {
  //                               return Container(
  //                                 height: 200,
  //                                 child: Center(
  //                                   child:
  //                                       Text('This is a modal bottom sheet'),
  //                                 ),
  //                               );
  //                             },
  //                           );
  // }
}

void _showModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.music_note),
                  title: new Text('Music'),
                  onTap: () => {}),
              new ListTile(
                leading: new Icon(Icons.videocam),
                title: new Text('Video'),
                onTap: () => {},
              ),
            ],
          ),
        );
      });
}
