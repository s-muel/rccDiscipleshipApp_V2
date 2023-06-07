import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:reapers_app/disciplerViews/discipler_main_page.dart';
import 'dart:convert';

import 'package:reapers_app/logins/api_calls.dart';
import 'package:reapers_app/logins/mentee_page.dart';
import 'package:reapers_app/view/admin_main_page.dart';
import 'package:reapers_app/view/rest_password.dart';
import 'package:reapers_app/view/sign_up_page.dart';
import 'package:reapers_app/view/trypage2.dart';

import '../disciplerViews/user_view/user_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  ApiCalls api = ApiCalls();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loginIndicator = false;
  bool _isLoading = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      const String url = "https://rcc-discipleship.up.railway.app/api/auth";
      final username = _usernameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      setState(() {
        loginIndicator = true;
      });

      try {
        final Map<String, dynamic> data =
            await api.login(context, username, email, password, url);
        // await login(username, email, password, url);
        print("am pressed");

        final String token = data['token'] as String;
        final int id = data['user']['id'] as int;
        final bool isDiscipler = data['user']['is_staff'];
        final bool isUser = data['user']['is_mentor'];

        //
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DisciplerMainPage(token: token, mentor: id),
        //   ),
        // );
        //
        // ignore: use_build_context_synchronously
        if (isDiscipler) {
          //  ignore: use_build_context_synchronously
          Navigator.pop(context);
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(token: token, admin: data),
            ),
          );
        } else if (isDiscipler!) {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DisciplerMainPage(token: token, mentor: data),
            ),
          );
        } else if (isUser == false) {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserPage(token: token, mentor: data),
            ),
          );
        }

        // else {
        //   // ignore: use_build_context_synchronously
        //   Navigator.pop(context);
        //   // ignore: use_build_context_synchronously
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) =>
        //           DisciplerMainPage(token: token, mentor: data),
        //     ),
        //   );
        // }
        // Do something with the token, such as save it to shared preferences
      } catch (e) {
        print('Failed to login: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  Future<void> _startLoading() async {
    await Future.delayed(const Duration(seconds: 4));
    // setState(() {
    //   //_isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 50.0, right: 50.0, top: 70.0, bottom: 20.0),
            child: SizedBox(
              height: 200,
              width: 50,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/login_logo.png"),
                    //  NetworkImage(
                    //     "https://res.cloudinary.com/dekhxk5wg/image/upload/v1682120332/appFeatureImages/RCC_App_tag_Logo_cieaqz.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // const CircleAvatar(
          //   backgroundImage: NetworkImage(
          //       'https://res.cloudinary.com/dekhxk5wg/image/upload/v1681573495/logo_tkpxbk.jpg'),
          //   radius: 50,
          // ),
          Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 35.0, right: 35.0, top: 8.0, bottom: 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 35.0, right: 35.0, top: 8.0, bottom: 20.0),
                    child: TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'E.g l****@gmail.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 35.0, right: 35.0, top: 8.0, bottom: 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password",
                        style: TextStyle(fontSize: 15, color: Colors.green),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 35.0, right: 35.0, top: 8.0, bottom: 8.0),
                    child: TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '●●●●●●',
                        suffixIcon: const Icon(Icons.remove_red_eye),
                        hintStyle: const TextStyle(
                          fontSize: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        // filled: true,
                        // fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      //const CircularProgressIndicator();
                      _startLoading();
                      _submit();
                    },
                    child: const Text('Login'),
                  ),

                  Visibility(
                    visible: _isLoading,
                    child: const SizedBox(
                      width: 60,
                      child: LinearProgressIndicator(
                        minHeight: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Container(
                            height: 1,
                            color: Colors.grey,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            // padding: const EdgeInsets.only(left: 100),
                          ),
                        ),
                      ),
                      const Text('or'),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Container(
                            height: 1,
                            color: Colors.grey,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      // Divider(),
                      Padding(
                        padding: const EdgeInsets.only(right: 35),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResetPassword(),
                              ),
                            );
                          },
                          child: const Text(
                            "Forget password",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 35.0, right: 35.0, top: 20.0, bottom: 0),
                    child: Card(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://cdn.freebiesupply.com/logos/large/2x/google-g-2015-logo-png-transparent.png"),
                              backgroundColor: Colors.white,
                            ),
                            // Icon(
                            //   FontAwesomeIcons.google,
                            // ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Continue with google",
                              style: TextStyle(color: Colors.green),
                            )
                          ]),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "We Believe There Is More",
                    style: TextStyle(fontSize: 10),
                  ),
                  // const SizedBox(height: 16),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // const CircularProgressIndicator();
                  //     _startLoading();
                  //     _submit();
                  //   },
                  //   child: const Text('Login'),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<Map<String, dynamic>> login(
    String username, String email, String password, String baseUrl) async {
  final http.Response response = await http.post(
    Uri.parse('$baseUrl/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      //'username': username,
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final String token = data['token'] as String;
    return data;
  } else {
    print(response.statusCode);
    throw Exception('Failed to login');
  }
}
