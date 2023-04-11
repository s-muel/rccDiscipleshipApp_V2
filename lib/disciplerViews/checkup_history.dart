import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:reapers_app/disciplerViews/disciple_details_page.dart';

import '../logins/api_calls.dart';
import '../view/member_details_page.dart';

class ReportHistoryPage extends StatefulWidget {
  final String token;
  final int menteeID;
  const ReportHistoryPage({
    super.key,
    required this.token,
    required this.menteeID,
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

  bool wednesday = false;
  bool friday = false;
  bool sunday = false;
  bool _value = false;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        actions: const [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://e1.pngegg.com/pngimages/444/382/png-clipart-frost-pro-for-os-x-icon-set-now-free-contacts-male-profile.png'),
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
                        final String report = item['report_text'];
                        return ExpansionTile(
                          title: Text(date),
                          children: [
                            const Text(" Report Details"),
                            Text(report),
                          ],
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
