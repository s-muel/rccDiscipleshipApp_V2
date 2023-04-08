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
  ApiCalls api = ApiCalls();
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
        title: const Text("All Members"),
      ),
      body: StreamBuilder<List<dynamic>>(
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
                                      builder: (context) => MyForm(
                                          initialData: item, token: token),
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
      ),
    );
  }
}
