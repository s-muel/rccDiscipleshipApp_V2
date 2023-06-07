import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class ApiCalls {
  final String baseURL = "https://rcc-discipleship.up.railway.app/api/";
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
      // final int id = data['user']['id'] as int;
      final bool isDiscipler = data['user']['is_staff'] as bool;
      print('api call $isDiscipler');
      print(data);
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

  Future<List<Map<String, dynamic>>> streamFuture(
      String token, String Url) async {
    final http.Response response =  await http.get(
      Uri.parse(Url),
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
      print(token);
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  // Future<List<Map<String, dynamic>>> streamFuture(
  //     String token, String Url) async {
  //   final http.Response response = await http.get(
  //     Uri.parse(Url),
  //     headers: <String, String>{
  //       'Authorization': 'Token  $token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     List<dynamic> data = jsonDecode(response.body);
  //     List<Map<String, dynamic>> result =
  //         data.map((e) => e as Map<String, dynamic>).toList();
  //     return result;
  //   } else {
  //     print(token);
  //     print(response.body);
  //     throw Exception('Failed to load data');
  //   }
  // }

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
    dynamic dateOfBirth,
    required BuildContext context,
    String? photo,

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
      'date_of_birth': dateOfBirth,
      'photo': photo
    };

    // Convert the map to JSON
    String jsonData = jsonEncode(updatedData);

    // Make an HTTP PUT request to update the data in the API
    Uri uri = Uri.parse('${baseURL}members/');
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
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(
                child: Text(
                  "Member added successfully!",
                ),
              ),
              actions: [
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"))),
                const SizedBox(height: 10),
                const Center(
                  child: Text('We Believe There Is More.',
                      style: TextStyle(fontSize: 10)),
                ),
              ],
            );
          });
      print(jsonData);

      // Handle success, e.g. show a success message to the user
    } else {
      print(jsonData);
      // Handle error, e.g. show an error message to the user
// ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                child: Text(
                  response.body,
                ),
              ),
              actions: [
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"))),
                const SizedBox(height: 10),
                const Center(
                  child: Text('We Believe There Is More.',
                      style: TextStyle(fontSize: 10)),
                ),
              ],
            );
          });
      print(response.statusCode);
      print(response.body);
    }
  }

  // adding as a mentor
  Future<void> addMentor({
    required String token,
    required String userEmail,
    // required int memberID,
    required BuildContext context,

    // required GlobalKey<ScaffoldState> scaffoldKey
  }) async {
    // Create a map of the updated data
    Map<String, dynamic> updatedData = {
      "email": userEmail,
    };

    // Convert the map to JSON
    String jsonData = jsonEncode(updatedData);

    // Make an HTTP PUT request to update the data in the API
    Uri uri = Uri.parse('${baseURL}create-mentor/');
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
          content: Text('Added as Mentor'),
        ),
      );
      print(jsonData);

      // Handle success, e.g. show a success message to the user
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
        ),
      );

      print(response.statusCode);
      print(response.body);
    }
  }

  //

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
    Uri uri = Uri.parse('${baseURL}unassigned-members/$memberID/');
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
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
    bool? wednesday,
    bool? friday,
    bool? sunday,
    required String disStatus,
    required String lifeEvent,
    required String request,
    required BuildContext context,

    // required GlobalKey<ScaffoldState> scaffoldKey
  }) async {
    // Create a map of the updated data
    Map<String, dynamic> updatedData = {
      "mentee": memberID,
      "wednesday_service_attended": wednesday,
      "friday_service_attended": friday,
      "sunday_service_attended": sunday,
      "how_is_mentee_doing": disStatus,
      "significant_life_events_or_challenges": lifeEvent,
      "mentee_discussion_requests": request
    };

    // Convert the map to JSON
    String jsonData = jsonEncode(updatedData);

    // Make an HTTP PUT request to update the data in the API
    Uri uri = Uri.parse('${baseURL}weekly-reports/');
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
      // void resetForm() {
      //  disStatus = "";
      // }

      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(
                child: Text(
                  'Report Submitted',
                ),
              ),
              actions: [
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"))),
                const SizedBox(height: 10),
                const Center(
                  child: Text('We Believe There Is More.',
                      style: TextStyle(fontSize: 10)),
                ),
              ],
            );
          });

      // Handle success, e.g. show a success message to the user
    } else {
      // Handle error, e.g. show an error message to the user
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                child: Text(
                  response.body,
                ),
              ),
              actions: [
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"))),
                const SizedBox(height: 10),
                const Center(
                  child: Text('We Believe There Is More.',
                      style: TextStyle(fontSize: 10)),
                ),
              ],
            );
          });
      //print(response.statusCode);
      // print(response.body);
      //  print(jsonData);
    }
  }

  // stream building
  Stream<List<Map<String, dynamic>>> stream(String token, String Url) async* {
    while (true) {
      final http.Response response = await http.get(
        Uri.parse(Url),
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
        print(response.statusCode);
        print(response.body);
        //
        // ignore: use_build_context_synchronously
        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         title: const Center(
        //           child: Text(
        //             'User Registered',
        //           ),
        //         ),
        //         actions: [
        //           Center(
        //               child: ElevatedButton(
        //                   onPressed: () {
        //                     Navigator.pop(context);
        //                   },
        //                   child: const Text("OK"))),
        //           const SizedBox(height: 10),
        //           const Center(
        //             child: Text('We Believe There Is More.',
        //                 style: TextStyle(fontSize: 10)),
        //           ),
        //         ],
        //       );
        //     });
        throw Exception('Failed to load Data ');
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }

//------------------stream2
  // stream building
  Stream<List<Map<String, dynamic>>> stream2(
      String token, String Url, BuildContext context) async* {
    while (true) {
      final http.Response response = await http.get(
        Uri.parse(Url),
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
        print(response.statusCode);
        print(response.body);
        //
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Center(
                  child: Text(
                    'User Registered',
                  ),
                ),
                actions: [
                  Center(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"))),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text('We Believe There Is More.',
                        style: TextStyle(fontSize: 10)),
                  ),
                ],
              );
            });
        //   throw Exception('Failed to load Data ');
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }

//-----------

  ///............................
  // adding a registerMember
  Future<void> registerMember({
    required String email,
    required String password,
    required String confirmPassword,
    //required int mentor,

    required BuildContext context,

    // required GlobalKey<ScaffoldState> scaffoldKey
  }) async {
    // Create a map of the updated data
    Map<String, dynamic> register = {
      'email': email,
      'password': password,
      'password_confirm': confirmPassword,
    };

    // Convert the map to JSON
    String jsonData = jsonEncode(register);

    // Make an HTTP PUT request to update the data in the API
    Uri uri = Uri.parse('${baseURL}auth/register');
    http.Response response = await http.post(
      uri,
      headers: {
        //'Authorization': 'Token  $token',
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    // Check the response status code
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(
                child: Text(
                  'User Registered',
                ),
              ),
              actions: [
                const Center(
                    child:
                        Text("Kindly check your email to verify your account")),
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"))),
                const SizedBox(height: 10),
                const Center(
                  child: Text('We Believe There Is More.',
                      style: TextStyle(fontSize: 10)),
                ),
              ],
            );
          });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('User Registered'),
      //   ),
      // );
      print(jsonData);

      // Handle success, e.g. show a success message to the user
    } else if (response.statusCode >= 400 && response.statusCode <= 499) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(
                child: Center(
                  child: Text('You have already Registered or Invalid Email',
                      style: TextStyle(fontSize: 18)),
                ),
              ),
              actions: [
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"))),
                const SizedBox(height: 10),
                const Center(
                  child: Text('We Believe There Is More.',
                      style: TextStyle(fontSize: 10)),
                ),
              ],
            );
          });
    } else {
      // Handle error, e.g. show an error message to the user

      print(response.statusCode);
      print(response.body);
    }
  }

  //deleting member

  Future<void> deleteMember({
    required String token,
    required int memberID,
    required BuildContext context,
  }) async {
    final uri = Uri.parse('${baseURL}members/$memberID/');
    final response = await http.delete(
      uri,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Member Removed'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove member'),
        ),
      );
      print('Failed to remove member');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  }

  // Future<void> deleteMember({
  //   required String token,
  //   // required int mentor,
  //   required int memberID,
  //   required BuildContext context,

  // }) async {

  //   Uri uri = Uri.parse('${baseURL}members/$memberID/');
  //   http.Response response = await http.delete(
  //     uri,
  //     headers: {
  //       'Authorization': 'Token  $token',
  //       'Content-Type': 'application/json',
  //     },

  //   );

  //   if (response.statusCode == 204) {
  //     print(response.statusCode);
  //     // ignore: use_build_context_synchronously
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Member Removed'),
  //       ),
  //     );

  //   } else {

  //     print(response.statusCode);
  //     print(response.body);
  //   }
  // }

  //reseting password
  // adding a registerMember
  Future<void> resetPassword({
    required String email,
    // required String password,
    // required String confirmPassword,
    //required int mentor,

    required BuildContext context,

    // required GlobalKey<ScaffoldState> scaffoldKey
  }) async {
    // Create a map of the updated data
    Map<String, dynamic> register = {
      'email': email,
      // 'password': password,
      // 'password_confirm': confirmPassword,
    };

    // Convert the map to JSON
    String jsonData = jsonEncode(register);

    // Make an HTTP PUT request to update the data in the API
    Uri uri = Uri.parse('${baseURL}auth/password/reset');
    http.Response response = await http.post(
      uri,
      headers: {
        //'Authorization': 'Token  $token',
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    // Check the response status code
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(
                child: Text(
                  'Done',
                ),
              ),
              actions: [
                const Center(
                  child: Text(
                      "Kindly visit your email to complete the reset proccess"),
                ),
                const SizedBox(height: 15),
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"))),
                const SizedBox(height: 10),
                const Center(
                  child: Text('We Believe There Is More.',
                      style: TextStyle(fontSize: 10)),
                ),
              ],
            );
          });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('User Registered'),
      //   ),
      // );
      print(jsonData);

      // Handle success, e.g. show a success message to the user
    } else if (response.statusCode >= 400 && response.statusCode <= 499) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(
                child: Center(
                  child: Text('You have already Registered or Invalid Email',
                      style: TextStyle(fontSize: 18)),
                ),
              ),
              actions: [
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"))),
                const SizedBox(height: 10),
                const Center(
                  child: Text('We Believe There Is More.',
                      style: TextStyle(fontSize: 10)),
                ),
              ],
            );
          });
    } else {
      // Handle error, e.g. show an error message to the user

      print(response.statusCode);
      print(response.body);
    }
  }
}
