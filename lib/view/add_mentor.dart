import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../logins/api_calls.dart';

class AddMentorPage extends StatefulWidget {
  final String token;
  const AddMentorPage({
    super.key,
    required this.token,
  });

  @override
  State<AddMentorPage> createState() => _AddMentorPageState();
}

class _AddMentorPageState extends State<AddMentorPage> {
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
        title: const Text("Add Mentor"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: api.stream(
            token, "https://rcc-discipleship1.up.railway.app/api/users/"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<dynamic> data = snapshot.data!;
            final int dataLength = data.length;
            final List<dynamic> filteredData = data
                .where((item) =>
                    item['is_mentor'] == false && item['first_name'] != null)
                .toList();
            return ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final item = filteredData[index];
                //final menteeID = item['id'];
                final String name = item['first_name'] ?? "Name Not Update";
                return InkWell(
                    onTap: () {
                      // trackerSheet(context, menteeID, name, item);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 8, top: 2),
                      child: InkWell(
                        onTap: () {
                          api.addMentor(
                              token: token,
                              userID: item['id'],
                              context: context);
                          print(item);
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(
                                "${item['first_name']} ${item['last_name']}"),
                            subtitle: Row(
                              children: const [
                                Icon(
                                  Icons.person_add_alt_1,
                                  color: Colors.green,
                                  size: 15,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  "Add as Mentor",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),

                            // Text(item['phone_number'])

                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(item['photo'] ??
                                  "https://res.cloudinary.com/dekhxk5wg/image/upload/v1681630522/placeholder_ewiwh7.png"),
                            ),
                            trailing: TextButton(
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         DiscipleDetailsPage(
                                //             initialData: item,
                                //             token: token),
                                //   ),
                                // );
                              },
                              child: const Icon(Icons.add_box),
                            ),
                          ),
                        ),
                      ),
                    ));
              },
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
}
