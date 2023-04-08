import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:reapers_app/Pages/model.dart';
import 'services.dart';
//import 'model.dart';

class PostsPage extends StatelessWidget {
  final HttpService httpService = HttpService();
 // UserModel userModel = UserModel.fromJson(json.decode(response.body));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
      ),
      body: FutureBuilder(
        future: httpService.getPosts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<UserData>> snapshot) {
          if (snapshot.hasData) {
            List<UserData>? posts = snapshot.data;
            return ListView(
              children: posts!
                  .map(
                    (UserData post) => ListTile(
                      title: Text(post.email),
                      subtitle: Text(post.firstName),
                    ),
                  )
                  .toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
