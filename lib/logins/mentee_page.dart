import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reapers_app/view/all_members.dart';

import 'api_calls.dart';

class User {
  final String name;
  final String email;
  final String phone;

  User({required this.name, required this.email, required this.phone});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}

class UsersListPage extends StatefulWidget {
  final String token;

  const UsersListPage({required this.token, Key? key}) : super(key: key);

  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  late List<User> _users;
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
          title: Text(token),
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
                          final item = data[index];
                          return Card(
                            child: ListTile(
                              title: Text(item['id'].toString()),
                              subtitle: Text(item['name']),
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
}
