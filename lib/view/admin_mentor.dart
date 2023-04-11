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
          title: Text(mentor['member']['first_name']),
          actions: const [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://scontent.facc6-1.fna.fbcdn.net/v/t1.6435-9/72487060_2328979970547953_1059076473484214272_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=8bfeb9&_nc_eui2=AeHYWnqRyV7k0Kffy0dcjo0yopQhhopr3OqilCGGimvc6uOKHS208NfW0zebRGOhA0iVwLABN24FSd33-AJWqFHL&_nc_ohc=A9SBL2wZeeAAX_tWqyD&_nc_ht=scontent.facc6-1.fna&oh=00_AfAnnFnyzOO_uqMrUjSlA-v6986u7KXlgSSyRlyOHiliOg&oe=645D3BF9'),
              radius: 50,
            )
          ],
        ),
        body: FutureBuilder<List<dynamic>>(
          future: api.get(token,
              'https://rcc-discipleship.up.railway.app/api/mentors/$mentorID/mentees/'),
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
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 3,
                                child: ListTile(
                                  title: Text(item['first_name'].toString()),
                                  subtitle: Text(item['email']),
                                  leading: const CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://scontent.facc6-1.fna.fbcdn.net/v/t1.6435-9/89948549_2639588916153722_2795377561931087872_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=174925&_nc_eui2=AeF7VDmJsYhtzKY59Vh3VAPrZB07xEaIvkhkHTvERoi-SM2LcZgHv9eMxbltvSoZneVOHFKA5n9Lec9V8up40R39&_nc_ohc=M9nyiotG8ygAX-GgxbI&_nc_ht=scontent.facc6-1.fna&oh=00_AfAoGrF60RR1LRKuUneih0xSdxJDXte0OWmucGn5A2qXcQ&oe=645D66A7'),
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
                  'https://rcc-discipleship.up.railway.app/api/mentors/$mentorID/mentees/$menteeID/report/'),
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
