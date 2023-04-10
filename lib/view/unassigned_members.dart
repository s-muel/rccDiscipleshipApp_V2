import 'package:flutter/material.dart';

import '../logins/api_calls.dart';

class UnassignedMembersPage extends StatefulWidget {
  final String token;

  const UnassignedMembersPage({super.key, required this.token});

  @override
  State<UnassignedMembersPage> createState() => _UnassignedMembersPageState();
}

class _UnassignedMembersPageState extends State<UnassignedMembersPage> {
  final _mentorNameController = TextEditingController();
  ApiCalls api = ApiCalls();
  String _selectedItemText = "";
  int mentorID = 0;
  late String token;
  @override
  void initState() {
    super.initState();
    token = widget.token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unassigned Members"),
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: api.stream(token,
            "https://rcc-discipleship.up.railway.app/api/unassigned-members/"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<dynamic> data = snapshot.data!;
            final int dataLength = data.length;

            return Column(
              children: [
                Row(),
                Expanded(
                  child: SizedBox(
                    height: 500,
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 15,
                        );
                      },
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return ExpansionTile(
                          collapsedBackgroundColor:
                              Color.fromARGB(31, 41, 151, 21),
                          collapsedIconColor: Colors.green,
                          leading: const CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                                "https://scontent.facc6-1.fna.fbcdn.net/v/t1.6435-9/99294387_2785350708244208_8544346941536862208_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=8bfeb9&_nc_eui2=AeHcj_1VPmwhxtoaUVHMD0KwXWnmu-TqwuRdaea75OrC5IefOb5ZAYgoB_0BQOOAPg6pgDXmPvCw50b4iw8Vw2A1&_nc_ohc=kIU9ZmLN_MIAX89FFst&_nc_ht=scontent.facc6-1.fna&oh=00_AfAVYWwvfPPP8TdDfWxDTIap1j-LEnKR3cGXVEOzwFA3DQ&oe=645A787A"),
                          ),
                          title: Text(
                              '${item['first_name']} ${item['last_name']}'),
                          subtitle: Row(
                            children: [
                              const Icon(
                                Icons.call,
                                color: Colors.green,
                                size: 15,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${item['phone_number']}',
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.green),
                              ),
                            ],
                          ),
                          children: [
                            // ListTile(
                            //   trailing: TextButton(
                            //     onPressed: () {},
                            //     child: const Icon(Icons.call),
                            //   ),
                            //   title: const Text("Number"),
                            //   subtitle: Text("insert number here",
                            //       style: const TextStyle(color: Colors.green)),
                            // ),
                            ListTile(
                              title: const Text(
                                  "Marital Status       /    Home Location"),
                              subtitle: Row(
                                children: [
                                  if (item['marital_status'].isEmpty)
                                    const Text("   Not update"),
                                  if (item['marital_status'].isNotEmpty)
                                    Text("   ${item['marital_status']}     "),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  if (item['home_address'].isEmpty)
                                    const Text("             /Not update"),
                                  if (item['home_address'].isNotEmpty)
                                    Text(
                                      "            / ${item['home_address']}",
                                      maxLines: 1,
                                      overflow: TextOverflow.clip,
                                      softWrap: false,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    )
                                ],
                              ),
                              trailing: const Icon(
                                Icons.location_on,
                                color: Colors.blue,
                              ),
                            ),
                            ListTile(
                              title: const Text("Date of Birth"),
                              subtitle: Text("${item['date_of_birth']}"),
                              trailing: const Icon(
                                Icons.calendar_today_rounded,
                                color: Colors.blue,
                              ),
                            ),

                            Row(
                              children: [
                                if (_mentorNameController.text.isEmpty)
                                  const Text(''),
                                if (_mentorNameController.text.isNotEmpty)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        enabled: false,
                                        controller: _mentorNameController,
                                      ),
                                    ),
                                  ),
                                Expanded(
                                  child: StreamBuilder<List<dynamic>>(
                                    stream: api.stream(token,
                                        "https://rcc-discipleship.up.railway.app/api/mentors/"),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final List<dynamic> data =
                                            snapshot.data!;

                                        final int dataLength = data.length;
                                        int iDValue = 1;

                                        //   int iDValue = widget.initialData['mentor'] ?? 1;

                                        return DropdownButton<int>(
                                          // value: iDValue,
                                          hint: const Text("Select Discipler"),
                                          items: snapshot.data!
                                              .map((option) =>
                                                  DropdownMenuItem<int>(
                                                      value: option['id'],
                                                      child: Text(
                                                          option['username'])))
                                              .toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _selectedItemText = snapshot.data
                                                  ?.firstWhere((item) =>
                                                      item['id'] ==
                                                      newValue)['username'];
                                              mentorID = newValue!;
                                              _mentorNameController.text =
                                                  _selectedItemText;
                                              //_selectedValue = newValue;
                                            });
                                          },
                                        );
                                      } else if (snapshot.hasError) {
                                        return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'),
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    api.assignMentor(
                                        token: token,
                                        mentor: mentorID,
                                        memberID: item['id'],
                                        context: context);
                                  },
                                  child: const Text("Submit")),
                            )
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
              //
            );
          }
        },
      ),
    );
  }

  Future<dynamic> assignmentSheet(BuildContext context, int memberID) {
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
                  'https://rcc-discipleship.up.railway.app/api/unassigned-members/$memberID/'),
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
}
