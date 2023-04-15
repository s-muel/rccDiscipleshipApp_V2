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
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                          item['phone_number'].toString().contains(searchText) ||
                          item['email']
                              .toString()
                              .toLowerCase()
                              .contains(searchText.toLowerCase());
                    }).toList();

                    return ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final item = filteredData[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 4,
                            child: ListTile(
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
                              leading: const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://scontent.facc6-1.fna.fbcdn.net/v/t1.6435-9/72890290_2351127111666572_1564614095821340672_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=8bfeb9&_nc_eui2=AeFIgKzN8pVoMtmF9CUNMHXjv5plVhw5eVS_mmVWHDl5VIq0ghNslvr9e10vTpbD-0jbBf1MDkpHbm9P9BHSELJq&_nc_ohc=poJq08SR9D4AX9-sy5p&_nc_ht=scontent.facc6-1.fna&oh=00_AfDJxzyS_nqdRPSvE14r_XJKoD0-eVlZaQOgf7yrr_UTYA&oe=645B36C3'),
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
