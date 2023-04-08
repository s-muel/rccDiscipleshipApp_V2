import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiCalls {
  Future<Map<String, dynamic>> login(
      String username, String email, String password, String baseUrl) async {
    final http.Response response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String token = data['token'] as String;
      return data;
    } else {
      throw Exception('Failed to login');
    }
  }

  // 

// Future<Map<String, dynamic>> get(String token, String Url) async {
//     final http.Response response = await http.get(
//       Uri.parse('$Url'),
//       headers: <String, String>{
//         'Authorization': 'Token  $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

  Future<List<Map<String, dynamic>>> get(String token, String Url) async {
    final http.Response response = await http.get(
      Uri.parse('$Url'),
      headers: <String, String>{
        'Authorization': 'Token  $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Map<String, dynamic>> result =
          data.map((e) => e as Map<String, dynamic>).toList();
      return result;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
