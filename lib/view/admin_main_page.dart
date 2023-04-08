import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:reapers_app/view/admin_mentor.dart';

import '../logins/api_calls.dart';
import 'all_members.dart';

class AdminPage extends StatefulWidget {
  final String token;

  const AdminPage({required this.token, Key? key}) : super(key: key);

  @override
  // _AdminPageState createState() => _AdminPageState();
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: api.get(
            token, "https://rcc-discipleship.up.railway.app/api/mentors/"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<dynamic> data = snapshot.data!;
            final int dataLength = data.length;

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: ListTile(
                          trailing: Text(dataLength.toString()),
                          title: const Text("Number of Mentors"),
                        ),
                      ),
                    ),
                    FutureBuilder<List<dynamic>>(
                      future: api.get(token,
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
                            child: Card(
                              child: ListTile(
                                trailing: Text(dataLength.toString()),
                                title: const Text("Number of Members"),
                              ),
                            ),
                          ));
                        } else if (snapshot.hasError) {
                          return Card(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          return const Card(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ],
                ),
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
                          child: Card(
                            child: ListTile(
                              title: Text(
                                  '${mentor['member']['first_name']} ${mentor['member']['last_name']}'),
                              subtitle: Text(
                                mentor['member']['phone_number'],
                              ),
                              leading: const CircleAvatar(),
                              trailing: const Icon(Icons.arrow_forward),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context).pop();
        },
        tooltip: 'Increment',
        //insert_chart
        child: const Icon(Icons.add),
        // backgroundColor: Colors.blue,
        // splashColor: Colors.lightGreenAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        //bottom navigation bar on scaffold
        // color: Colors.blue,
        shape: const CircularNotchedRectangle(), //shape of notch
        notchMargin:
            5, //notche margin between floating button and bottom appbar
        child: Row(
          //children inside bottom appbar
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.people_alt,
                color: Colors.green,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
