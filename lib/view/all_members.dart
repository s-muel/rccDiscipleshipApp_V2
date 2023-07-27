import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../logins/api_calls.dart';
import 'member_details_page.dart';
import 'trypage2.dart';

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

  void deleteMember({
    required String token,
    required int memberID,
    required BuildContext context,
  }) async {
    final uri = Uri.parse(
        'https://rcc-discipleship.up.railway.app/api/members/$memberID/');
    final response = await http.delete(
      uri,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 204) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Member Removed'),
      //   ),
      // );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to remove member'),
        ),
      );
      print('Failed to remove member');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  }

  // String phoneNumber = '+1234567890';
  void makePhoneCall(String phoneNumber) async {
    // ignore: deprecated_member_use
    if (await canLaunch('tel:$phoneNumber')) {
      // ignore: deprecated_member_use
      await launch('tel:$phoneNumber');
    } else {
      //   throw 'Could not launch $phoneNumber';
    }
  }

  void sendSMS(String phoneNumber) async {
    // ignore: deprecated_member_use
    if (await canLaunch('sms:$phoneNumber')) {
      // ignore: deprecated_member_use
      await launch('sms:$phoneNumber');
    } else {
      //   throw 'Could not launch $phoneNumber';
    }
  }

  // showing Fullimage
  void showFullImageDialog(String imageURL) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Image.network(imageURL),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => Home(token: token),
          //         ),
          //       );
          //     },
          //     icon: const Icon(Icons.arrow_circle_left)),
          centerTitle: true,
          title: const Text('All Members'),
          elevation: 0,
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
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, bottom: 8, top: 10),
              child: TextFormField(
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
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Member',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
              ),
            ),
            Visibility(
              visible: _isSearching,
              child: const SizedBox(
                  width: 300,
                  child: LinearProgressIndicator(
                    minHeight: 1,
                  )),
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
                          item['phone_number']
                              .toString()
                              .contains(searchText) ||
                          item['email']
                              .toString()
                              .toLowerCase()
                              .contains(searchText.toLowerCase());
                    }).toList();

                    return ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final item = filteredData[index];
                        final String firstName = item['first_name'] ?? "";
                        final String lastName = item['last_name'] ?? "";

                        final String capitalizedFirstName = firstName.isNotEmpty
                            ? '${firstName[0].toUpperCase()}${firstName.substring(1)}'
                            : firstName;

                        final String capitalizedLastName = lastName.isNotEmpty
                            ? '${lastName[0].toUpperCase()}${lastName.substring(1)}'
                            : lastName;

                        String imageURL = item['photo'] ??
                            "https://res.cloudinary.com/dekhxk5wg/image/upload/v1681630522/placeholder_ewiwh7.png";
                        bool hasImage = true;
                        if (imageURL == null) {
                          setState(() {
                            hasImage = false;
                          });
                        }
                        return Slidable(
                          key: Key(index.toString()),
                          startActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                backgroundColor: Colors.green,
                                onPressed: (context) {
                                  makePhoneCall(item['phone_number']);
                                },
                                icon: Icons.call,
                              ),
                              SlidableAction(
                                backgroundColor: Colors.blue,
                                onPressed: (context) {
                                  sendSMS(item['phone_number']);
                                },
                                icon: Icons.message,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 8, top: 2),
                            child: Card(
                              elevation: 3,
                              child: ListTile(
                                title: Text(
                                    '$capitalizedFirstName $capitalizedLastName'),
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
                                leading: InkWell(
                                  onTap: () {
                                    showFullImageDialog(imageURL);
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(imageURL),
                                  ),
                                ),
                                trailing: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyForm(
                                            initialData: item, token: token),
                                      ),
                                    );
                                  },
                                  child: const Text("Details"),
                                ),
                              ),
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
          token, "https://rcc-discipleship1.up.railway.app/api/members/"),
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
