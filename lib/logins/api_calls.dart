import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class ApiCalls {
  Future<Map<String, dynamic>> login(BuildContext context, String username,
      String email, String password, String baseUrl) async {
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
      final int id = data['user']['id'] as int;
      return data;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check Login Credentials'),
        ),
      );
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

  // adding a member
  Future<void> addMember({
    required String token,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required bool isMentor,
    //required int mentor,
    required String mentorName,
    required String work,
    required String homeAddress,
    required String language,
    required String auxiliary,
    required bool baptized,
    required String dateOfBirth,
    required BuildContext context,

    // required GlobalKey<ScaffoldState> scaffoldKey
  }) async {
    // Create a map of the updated data
    Map<String, dynamic> updatedData = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'is_mentor': isMentor,
      //"mentor": mentor,
      'mentor_name': mentorName,
      'work': work,
      'home_address': homeAddress,
      'language': language,
      'axilliary': auxiliary,
      'baptised': baptized,
      'date_of_birth': dateOfBirth
    };

    // Convert the map to JSON
    String jsonData = jsonEncode(updatedData);

    // Make an HTTP PUT request to update the data in the API
    Uri uri = Uri.parse('https://rcc-discipleship.up.railway.app/api/members/');
    http.Response response = await http.post(
      uri,
      headers: {
        'Authorization': 'Token  $token',
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    // Check the response status code
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Member created successfully!'),
        ),
      );
      print(jsonData);

      // Handle success, e.g. show a success message to the user
    } else {
      // Handle error, e.g. show an error message to the user

      print(response.statusCode);
      print(response.body);
    }
  }

  // adding a member
  Future<void> assignMentor({
    required String token,
    required int mentor,
    required int memberID,
    required BuildContext context,

    // required GlobalKey<ScaffoldState> scaffoldKey
  }) async {
    // Create a map of the updated data
    Map<String, dynamic> updatedData = {
      "mentor": mentor,
    };

    // Convert the map to JSON
    String jsonData = jsonEncode(updatedData);

    // Make an HTTP PUT request to update the data in the API
    Uri uri = Uri.parse(
        'https://rcc-discipleship.up.railway.app/api/unassigned-members/$memberID/');
    http.Response response = await http.patch(
      uri,
      headers: {
        'Authorization': 'Token  $token',
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    // Check the response status code
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Member created successfully!'),
        ),
      );
      print(jsonData);

      // Handle success, e.g. show a success message to the user
    } else {
      // Handle error, e.g. show an error message to the user

      print(response.statusCode);
      print(response.body);
    }
  }

  //submiting report
  Future<void> submitReport({
    required String token,
    required int memberID,
    required String report,
    required BuildContext context,

    // required GlobalKey<ScaffoldState> scaffoldKey
  }) async {
    // Create a map of the updated data
    Map<String, dynamic> updatedData = {
      "mentee": memberID,
      "report_text": report
    };

    // Convert the map to JSON
    String jsonData = jsonEncode(updatedData);

    // Make an HTTP PUT request to update the data in the API
    Uri uri = Uri.parse(
        'https://rcc-discipleship.up.railway.app/api/weekly-reports/');
    http.Response response = await http.post(
      uri,
      headers: {
        'Authorization': 'Token  $token',
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    // Check the response status code
    if (response.statusCode == 201) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report Submitted'),
        ),
      );
      print(jsonData);

      // Handle success, e.g. show a success message to the user
    } else {
      // Handle error, e.g. show an error message to the user

      print(response.statusCode);
      print(response.body);
    }
  }

  // stream building
  Stream<List<Map<String, dynamic>>> stream(String token, String Url) async* {
    while (true) {
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
        yield result;
      } else {
        throw Exception('Failed to load Data ');
      }
      await Future.delayed(Duration(seconds: 5));
    }
  }
}
