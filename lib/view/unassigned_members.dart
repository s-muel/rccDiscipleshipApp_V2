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
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    token = widget.token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Unassigned Members'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 87, 241, 40),
                Color.fromARGB(255, 12, 168, 12)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        String imageURL = item['photo'] ??
                            "https://res.cloudinary.com/dekhxk5wg/image/upload/v1681630522/placeholder_ewiwh7.png";
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 8, top: 5),
                          child: Card(
                            elevation: 3,
                            child: ExpansionTile(
                              // collapsedBackgroundColor:
                              //     const Color.fromARGB(31, 41, 151, 21),
                              collapsedIconColor: Colors.green,
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(imageURL),
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
                                        Text(
                                            "   ${item['marital_status']}     "),
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
                                const Padding(
                                  padding: EdgeInsets.only(left: 18),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Discipler",
                                        style: TextStyle(fontSize: 17),
                                      )),
                                ),

                                Row(
                                  children: [
                                    if (_mentorNameController.text.isEmpty)
                                      const Text(''),
                                    if (_mentorNameController.text.isNotEmpty)
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 45,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.grey[200]),
                                              enabled: false,
                                              controller: _mentorNameController,
                                            ),
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

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 5),
                                              child: Card(
                                                color: Colors.grey[200],
                                                //  margin: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                elevation: 0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 20,
                                                  ),
                                                  child: DropdownButton<int>(
                                                    // value: iDValue,
                                                    hint: const Text(
                                                        "Select Discipler"),
                                                    items: snapshot.data!
                                                        .map((option) =>
                                                            DropdownMenuItem<
                                                                    int>(
                                                                value: option[
                                                                    'id'],
                                                                child: Text(option[
                                                                        "member"]
                                                                    [
                                                                    'first_name'])))
                                                        .toList(),
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        _selectedItemText = snapshot
                                                                .data
                                                                ?.firstWhere((item) =>
                                                                    item[
                                                                        'id'] ==
                                                                    newValue)[
                                                            "member"]['first_name'];
                                                        mentorID = newValue!;
                                                        _mentorNameController
                                                                .text =
                                                            _selectedItemText;
                                                        //_selectedValue = newValue;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                  'Error: ${snapshot.error}'),
                                            );
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        api.assignMentor(
                                            token: token,
                                            mentor: mentorID,
                                            memberID: item['id'],
                                            context: context);
                                      },
                                      child: const Text("Submit")),
                                ),
                                Visibility(
                                  visible: isLoading,
                                  child: const SizedBox(
                                    width: 60,
                                    child: LinearProgressIndicator(
                                      minHeight: 1,
                                    ),
                                  ),
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
