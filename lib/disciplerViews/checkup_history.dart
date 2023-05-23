import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../logins/api_calls.dart';

class ReportHistoryPage extends StatefulWidget {
  final String token;
  final int menteeID;
  final dynamic data;
  const ReportHistoryPage({
    super.key,
    required this.token,
    required this.menteeID,
    this.data,
  });

  @override
  State<ReportHistoryPage> createState() => _ReportHistoryPageState();
}

class _ReportHistoryPageState extends State<ReportHistoryPage> {
  ApiCalls api = ApiCalls();
  late int menteeID = menteeID;
  final _formKey = GlobalKey<FormState>();
  final reportTextController = TextEditingController();
  late String token;
  late dynamic mentor;
  late int mentorID = mentor;
  late dynamic data = data;

  bool wednesday = false;
  bool friday = false;
  bool sunday = false;
  final bool _value = false;

  //resetting the form
  void resetForm() {
    setState(() {
      wednesday = false;
      friday = false;
      sunday = false;
      reportTextController.text = '';
    });
  }

  @override
  void initState() {
    super.initState();
    token = widget.token;
    mentor = widget.menteeID;
    menteeID = widget.menteeID;
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data["first_name"] + " " + data['last_name']),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(data['photo'] ??
                "https://res.cloudinary.com/dekhxk5wg/image/upload/v1681630522/placeholder_ewiwh7.png"),
            radius: 50,
          )
        ],
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: api.stream(token,
            'https://rcc-discipleship.up.railway.app/api/weekly-reports/'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<dynamic> data = snapshot.data!;
            final int dataLength = data.length;
            final filteredData =
                data.where((item) => item['mentee'] == menteeID).toList();
            filteredData
                .sort((a, b) => b['created_at'].compareTo(a['created_at']));

            return Column(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 500,
                    child: ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final item = filteredData[index];
                        final menteeID = item['id'];
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
                            child: ExpansionTile(
                              title: Row(
                                children: [
                                  const Text(
                                    "Week : ",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  Text(weekNumber.toString()),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  const Icon(Icons.date_range,
                                      color: Colors.green),
                                  const SizedBox(width: 8),
                                  Text(DateFormat.yMMMMd().format(dateTime)),
                                ],
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
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("How is disciple doing"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(disStatus),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                      "significant_life_events_or_challenges"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(sFE),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Request"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(request),
                                ),
                              ],
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
    );
  }

  // Future<dynamic> trackerSheet(BuildContext context, int memberID, name) {
  //   return showModalBottomSheet(
  //       backgroundColor: Colors.white.withOpacity(0.2),
  //       context: context,
  //       isScrollControlled: true,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
  //       ),
  //       builder: (BuildContext context) {
  //         return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //             return SafeArea(
  //               child: DraggableScrollableSheet(
  //                 initialChildSize: 0.9,
  //                 // minChildSize: 0.2,
  //                 // maxChildSize: 1,
  //                 expand: false,
  //                 builder: (BuildContext context,
  //                     ScrollController scrollController) {
  //                   return Container(
  //                     decoration: const BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius:
  //                           BorderRadius.vertical(top: Radius.circular(30)),
  //                     ),
  //                     child: Stack(children: [
  //                       Positioned(
  //                         top: -5,
  //                         left: 0,
  //                         right: 0,
  //                         child: Center(
  //                           child: Container(
  //                             decoration: BoxDecoration(
  //                               color: Colors
  //                                   .green, // set the desired background color
  //                               borderRadius: BorderRadius.circular(
  //                                   10), // set the desired amount of rounding
  //                             ),
  //                             height: 10,
  //                             width: 50,
  //                           ),
  //                         ),
  //                       ),
  //                       SingleChildScrollView(
  //                         controller: scrollController,
  //                         child: Column(
  //                           children: [
  //                             const SizedBox(
  //                               height: 10,
  //                             ),
  //                             Row(
  //                               children: [
  //                                 const Icon(Icons.people, color: Colors.green),
  //                                 Text("$name"),
  //                                 const Spacer(),
  //                                 TextButton(
  //                                     onPressed: () {
  //                                       //
  //                                       showDialog(
  //                                         context: context,
  //                                         builder: (BuildContext context) {
  //                                           return AlertDialog(
  //                                             title: const Text('Coming Soon'),
  //                                             content: const Text(
  //                                                 'This feature is coming soon.'),
  //                                             actions: [
  //                                               TextButton(
  //                                                 onPressed: () {
  //                                                   Navigator.pop(context);
  //                                                 },
  //                                                 child: const Text('OK'),
  //                                               ),
  //                                             ],
  //                                           );
  //                                         },
  //                                       );
  //                                       //
  //                                     },
  //                                     child: const Text("History"))
  //                               ],
  //                             ),
  //                             Form(
  //                                 key: _formKey,
  //                                 child: Column(
  //                                   children: [
  //                                     const SizedBox(height: 10),
  //                                     const Text("Church Attendance"),
  //                                     const SizedBox(height: 10),
  //                                     Row(
  //                                       children: const [
  //                                         Expanded(
  //                                           child: Text(
  //                                             'Wednesday',
  //                                             textAlign: TextAlign.center,
  //                                           ),
  //                                         ),
  //                                         Expanded(
  //                                           child: Text(
  //                                             'Friday',
  //                                             textAlign: TextAlign.center,
  //                                           ),
  //                                         ),
  //                                         Expanded(
  //                                           child: Text(
  //                                             'Sunday',
  //                                             textAlign: TextAlign.center,
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     Row(
  //                                       children: [
  //                                         Expanded(
  //                                           child: Checkbox(
  //                                             value: wednesday,
  //                                             onChanged: (bool? value) {
  //                                               setState(() {
  //                                                 wednesday = value!;
  //                                               });
  //                                             },
  //                                           ),
  //                                         ),
  //                                         Expanded(
  //                                           child: Checkbox(
  //                                             value: friday,
  //                                             onChanged: (bool? value) {
  //                                               setState(() {
  //                                                 friday = value!;
  //                                               });
  //                                             },
  //                                           ),
  //                                         ),
  //                                         Expanded(
  //                                           child: Checkbox(
  //                                             value: sunday,
  //                                             onChanged: (bool? value) {
  //                                               setState(() {
  //                                                 sunday = value!;
  //                                               });
  //                                             },
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     const SizedBox(height: 10),
  //                                     TextFormField(
  //                                       maxLines: null,
  //                                       textAlignVertical:
  //                                           TextAlignVertical.top,
  //                                       controller: reportTextController,
  //                                       decoration: InputDecoration(
  //                                         floatingLabelBehavior:
  //                                             FloatingLabelBehavior.always,
  //                                         labelText: 'Weekly Report',
  //                                         border: OutlineInputBorder(
  //                                           borderRadius:
  //                                               BorderRadius.circular(10.0),
  //                                         ),
  //                                         contentPadding:
  //                                             const EdgeInsets.symmetric(
  //                                                 vertical: 20.0),
  //                                       ),
  //                                       validator: (value) {
  //                                         if (value!.isEmpty) {
  //                                           return 'Please enter a report';
  //                                         }
  //                                         return null;
  //                                       },
  //                                     ),
  //                                     ElevatedButton(
  //                                       onPressed: () {
  //                                         if (_formKey.currentState!
  //                                             .validate()) {
  //                                           // check validation
  //                                           api.submitReport(
  //                                             token: token,
  //                                             memberID: memberID,
  //                                             report: reportTextController.text,
  //                                             context: context,
  //                                           );
  //                                           setState(() {});

  //                                           resetForm();
  //                                         }
  //                                       },
  //                                       child: const Text('Submit Report'),
  //                                     ),
  //                                   ],
  //                                 )),
  //                           ],
  //                         ),
  //                       ),
  //                     ]),
  //                   );
  //                 },
  //               ),
  //             );
  //           },
  //         );
  //       });
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
