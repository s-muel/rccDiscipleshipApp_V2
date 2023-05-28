import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../logins/api_calls.dart';
import 'trypage2.dart';

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
  bool tap = false;

  @override
  void initState() {
    super.initState();
    token = widget.token;
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
        title: const Text("Add Discipler"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: api.stream(
            token, "https://rcc-discipleship.up.railway.app/api/users/"),
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
                          setState(() {
                            tap = true;
                            print(item['id']);
                          });
                          api.addMentor(
                              token: token,
                              userEmail: item['email'],
                              context: context);
                          print(item);
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(
                                "${item['first_name'].isNotEmpty ? '${item['first_name'][0].toUpperCase()}${item['first_name'].substring(1)}' : ''} "
                                "${item['last_name'].isNotEmpty ? '${item['last_name'][0].toUpperCase()}${item['last_name'].substring(1)}' : ''}"),

                            subtitle: Row(
                              children: [
                                const Icon(
                                  Icons.person_add_alt_1,
                                  color: Colors.green,
                                  size: 15,
                                ),
                                const SizedBox(width: 3),
                                const Text(
                                  "Add as Mentor",
                                  style: TextStyle(color: Colors.green),
                                ),
                                Visibility(
                                    visible: tap,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ))
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
            return const Center(
              child: Text('Lost connection, double check network')
              // Text('Error: ${snapshot.error}')
              ,
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
