import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

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
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 3, top: 6),
                              child: Card(
                                elevation: 3,
                                child: ListTile(
                                  title: Text(
                                      '${item['first_name']} ${item['last_name']} '
                                      // item['first_name'].toString(),
                                      ),
                                  subtitle: Row(
                                    children: [
                                      const Icon(
                                        Icons.phone,
                                        color: Colors.green,
                                        size: 15,
                                      ),
                                      Text(item['phone_number']),
                                    ],
                                  ),
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
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.8,
            // // minChildSize: 0.25,
            // maxChildSize: 1.0,
            builder: (BuildContext context, ScrollController scrollController) {
              return StreamBuilder<List<dynamic>>(
                stream: api.stream(
                  token,
                  'https://rcc-discipleship.up.railway.app/api/mentors/$mentorID/mentees/$menteeID/report/',
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<dynamic> data = snapshot.data!;
                    final int dataLength = data.length;
                    // print(data);
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        final String date = item['created_at'] as String;
                        final String disStatus = item['how_is_mentee_doing'];
                        final String sFE =
                            item['significant_life_events_or_challenges'];
                        final String request =
                            item['mentee_discussion_requests'];
                        DateTime dateTime = DateTime.parse(date);
                        DateTime firstDayOfMonth =
                            DateTime(dateTime.year, dateTime.month, 1);
                        int weekNumber =
                            ((dateTime.difference(firstDayOfMonth).inDays) / 7)
                                .ceil();
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 8, top: 5),
                          child: Card(
                            elevation: 3,
                            child: ExpansionTile(
                              title: Row(children: [
                                const Icon(Icons.date_range,
                                    color: Colors.green),
                                Text(DateFormat.yMMMMd().format(dateTime))
                              ]),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Week: $weekNumber'),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.access_time,
                                      color: Colors.green),
                                  const SizedBox(width: 8),
                                  Text(DateFormat.jm().format(dateTime)),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.keyboard_arrow_down_rounded)
                                ],
                              ),
                              children: [
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
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Checkbox(
                                          value: item[
                                              'wednesday_service_attended'],
                                          // ignore: avoid_types_as_parameter_names
                                          onChanged: (bool) {}),
                                    ),
                                    Expanded(
                                      child: Checkbox(
                                          value:
                                              item['friday_service_attended'],
                                          // ignore: avoid_types_as_parameter_names
                                          onChanged: (bool) {}),
                                    ),
                                    Expanded(
                                      child: Checkbox(
                                          value:
                                              item['sunday_service_attended'],
                                          // ignore: avoid_types_as_parameter_names
                                          onChanged: (bool) {}),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25, bottom: 30),
                                  child: TextFormField(
                                    maxLines: null,
                                    textAlignVertical: TextAlignVertical.top,
                                    // controller: discipleStatus,
                                    initialValue: disStatus,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelText: 'How is disciple doing',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      // contentPadding: const EdgeInsets.symmetric(
                                      //     vertical: 20.0),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25, bottom: 30),
                                  child: TextFormField(
                                    maxLines: null,
                                    textAlignVertical: TextAlignVertical.top,
                                    // controller: discipleStatus,
                                    initialValue: sFE,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelText:
                                          'Significant life events or challenges',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      // contentPadding: const EdgeInsets.symmetric(
                                      //     vertical: 20.0),
                                    ),
                                  ),
                                ),

                                // const Padding(
                                //   padding: EdgeInsets.all(8.0),
                                //   child: Text("How is disciple doing"),
                                // ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25, bottom: 30),
                                  child: TextFormField(
                                    maxLines: null,
                                    textAlignVertical: TextAlignVertical.top,
                                    // controller: discipleStatus,
                                    initialValue: request,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelText:
                                          'Discipler discussion/ request',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      // contentPadding: const EdgeInsets.symmetric(
                                      //     vertical: 20.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('No report submitted '),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            },
          ),
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

// void _showModalBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//       context: context,
//       builder: (BuildContext bc) {
//         return Container(
//           child: new Wrap(
//             children: <Widget>[
//               new ListTile(
//                   leading: new Icon(Icons.music_note),
//                   title: new Text('Music'),
//                   onTap: () => {}),
//               new ListTile(
//                 leading: new Icon(Icons.videocam),
//                 title: new Text('Video'),
//                 onTap: () => {},
//               ),
//             ],
//           ),
//         );
//       });
// }
