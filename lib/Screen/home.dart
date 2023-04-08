import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> data = {};
  late int dataLength;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: fetchData,
              child: const Text(
                "Fetch",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          String key = data.keys.elementAt(index);
          dynamic value = data[key];
          if (value is String) {
            return ListTile(
              title: Text(key),
              subtitle: Text(value),
              trailing: CircleAvatar(
                backgroundImage: NetworkImage(data['avatar']),
              ),
            );
          } else if (value is int) {
            return ListTile(
              title: Text(key),
              subtitle: Text(value.toString()),
              trailing: CircleAvatar(
                backgroundImage: NetworkImage(data['avatar']),
              ),
            );
          } else {
            // handle other data types
            return SizedBox();
          }
        },
      ),
    );
  }

  void fetchData() async {
    print("fetching Data");
    final url = Uri.parse('https://reqres.in/api/users/2');
    final response = await http.get(url);
    final body = response.body;
    final json = jsonDecode(body);

    setState(() {
      data = json['data'];
      dataLength = data.length;
    });
    print(dataLength);
  }
}
