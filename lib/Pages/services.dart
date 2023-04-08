import 'dart:convert';
import 'package:http/http.dart';
import 'model.dart';

class HttpService {
 // final postsURL = Uri.parse("https://jsonplaceholder.typicode.com/posts");
  final FirstURL = Uri.parse("https://www.balldontlie.io/api/v1/players");


  Future<List<UserData>> getPosts() async {
    Response res = await get(FirstURL);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

      List<UserData> posts = [];

      body.forEach((key, value) {
        // Create a new Post object from each key-value pair in the map
       UserData post = UserData.fromJson(value);
        posts.add(post);
      });

      return posts;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

// trying 

Future<List<dynamic>> fetchData() async {
  final response = await get(Uri.parse('https://rcc-discipleship.up.railway.app/api/mentors/'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

}
