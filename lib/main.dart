import 'dart:io';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:reapers_app/Pages/view.dart';
import 'package:reapers_app/disciplerViews/discipler_main_page.dart';
import 'package:reapers_app/landing_page.dart';
import 'package:reapers_app/view/camera_test.dart';
import 'package:reapers_app/view/try_page.dart';
import 'package:reapers_app/view/trypage2.dart';

import 'Pages/landpage.dart';
import 'Screen/home.dart';
import 'disciplerViews/user_view/user_page.dart';
import 'logins/firsttry.dart';
import 'notifications/notify.dart';
import 'socialMedia/splash_screen.dart';

import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final HttpClient client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  runApp(MyApp());
}

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token = "";
  bool isStaff = false;
  bool isMentor = false;
  int id = 0;
  dynamic name;
  int expirationTimestamp = 0;

  // Method to check if the user is logged in (checks if the token is stored in shared preferences)
  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    // You can add more conditions here depending on your login logic
    return token != null && token.isNotEmpty;
  }

  @override
  initState() {
    super.initState();
    // Check for token in shared preferences

    newFunction();
    // If token is not empty, navigate to home page
    // if (token.isNotEmpty) {
    //   Navigator.pushReplacementNamed(context, '/home');
    // }
  }

  Future<void> newFunction() async {
    //print("newfunction is up and runing");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      token = prefs.getString('token')!;
      name = prefs.getString('name');
      isStaff = prefs.getBool('isStaff')!;
      isMentor = prefs.getBool('isMentor')!;
      id = prefs.getInt('userId') as int;
      expirationTimestamp = prefs.getInt('tokenExpiration')!;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home:
          //const LoginForm()
          // SplashScreen()
          FutureBuilder(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoginForm(); // Display a splash screen while checking login status
          } else {
            int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
            if (snapshot.data == true &&
                currentTimestamp < expirationTimestamp) {
              // checking the access control levels

              if (isStaff) {
                return Home(
                  token: token,
                  admin: name,
                );
              } else if (isStaff == false && isMentor == true) {
                return DisciplerMainPage(
                  token: token,
                  mentor: id,
                  name: name,
                );
              } else if (isMentor == false) {
                return UserPage(token: token, mentor: id);
              }
            }
          }
          return LoginForm();
        },
      ),

      //const LoginForm(),
    );
  }
}

Future<List<dynamic>> fetchData() async {
  final response = await http
      .get(Uri.parse('https://rcc-discipleship.up.railway.app/api/mentors/'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

class MyListView extends StatefulWidget {
  const MyListView({super.key});

  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  late Future<List<dynamic>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My List View'),
      ),
      body: Center(
        child: FutureBuilder<List<dynamic>>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index]['name']),
                    subtitle: Text('ID: ${snapshot.data![index]['id']}'),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
