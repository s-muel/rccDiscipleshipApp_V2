import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../logins/api_calls.dart';
import 'member_details_page.dart';

class AllMembersPage extends StatefulWidget {
  final String token;
  const AllMembersPage({super.key, required this.token});

  @override
  State<AllMembersPage> createState() => _AllMembersPageState();
}

class _AllMembersPageState extends State<AllMembersPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  ApiCalls api = ApiCalls();
  late String token;
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    token = widget.token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("All Members"),
        ),
        body: Column(
          children: [
            TextField(
              
              onTapOutside: (value) {
                setState(() {
                  _isSearching = false;
                });
              },
              onChanged: (value) {
                setState(() {
                  _isSearching = true;
                });
              },

              onSubmitted: (value) {
                _isSearching = false;
              },
              // onChanged: (value) {
              //   setState(() {
              //     _isSearching = true;
              //   });
              // },
              controller: _searchController,
              decoration: const InputDecoration(
                  hintText: 'Search by name, phone number, or email'),
            ),
            Visibility(
              visible: _isSearching,
              child: const LinearProgressIndicator(),
            ),
            Expanded(
              child: StreamBuilder<List<dynamic>>(
                stream: api.stream(token,
                    "https://rcc-discipleship.up.railway.app/api/members/"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<dynamic> data = snapshot.data!;
                    final int dataLength = data.length;

                    final filteredData = data.where((item) {
                      final searchText = _searchController.text.trim();
                      final parts = searchText.split(' ');

                      if (parts.length > 1) {
                        final firstName = parts[0].toLowerCase();
                        final lastName = parts[1].toLowerCase();

                        return item['first_name']
                                .toString()
                                .toLowerCase()
                                .contains(firstName) &&
                            item['last_name']
                                .toString()
                                .toLowerCase()
                                .contains(lastName);
                      }

                      return item['first_name']
                              .toString()
                              .toLowerCase()
                              .contains(searchText.toLowerCase()) ||
                          item['last_name']
                              .toString()
                              .toLowerCase()
                              .contains(searchText.toLowerCase()) ||
                          item['phone'].toString().contains(searchText) ||
                          item['email']
                              .toString()
                              .toLowerCase()
                              .contains(searchText.toLowerCase());
                    }).toList();

                    return ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final item = filteredData[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                                '${item['first_name']} ${item['last_name']}'),
                            subtitle: Text(item['email']),
                            trailing: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MyForm(initialData: item, token: token),
                                  ),
                                );
                              },
                              child: const Text("Details"),
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
              ),
            ),
          ],
        )

        //allMembersWidget(api: api, token: token),
        );
  }
}

class allMembersWidget extends StatelessWidget {
  const allMembersWidget({
    super.key,
    required this.api,
    required this.token,
  });

  final ApiCalls api;
  final String token;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: api.stream(
          token, "https://rcc-discipleship.up.railway.app/api/members/"),
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
                      return Card(
                        child: ListTile(
                          title: Text(
                              '${item['first_name']} ${item['last_name']}'),
                          subtitle: Text(item['email']),
                          trailing: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MyForm(initialData: item, token: token),
                                  ),
                                );
                              },
                              child: const Text("Details")),
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
    );
  }
}
