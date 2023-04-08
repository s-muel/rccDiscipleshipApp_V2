import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:reapers_app/logins/api_calls.dart';
import 'package:reapers_app/logins/mentee_page.dart';
import 'package:reapers_app/view/admin_main_page.dart';
import 'package:reapers_app/view/trypage2.dart';

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
  bool _isLoading = true;

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
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(token: token),
          ),
        );

        print("This is token $token");
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
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://scontent.facc5-2.fna.fbcdn.net/v/t39.30808-6/271922208_4485465008247648_4210291738365209830_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=7B4wb3Gzg-QAX_usODE&_nc_ht=scontent.facc5-2.fna&oh=00_AfAEMjpHDp6pGFU7kr0mVS3fGlR99TNwwI2Ru5ehg1JS3A&oe=64335EC8'),
            radius: 50,
          ),
          Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                    ),
                  ),
                  TextFormField(
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
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                    ),
                  ),
                  TextFormField(
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
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                    ),
                  ),
                  Visibility(
                      visible: _isLoading, child: CircularProgressIndicator()),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // const CircularProgressIndicator();
                      _startLoading();
                      _submit();
                    },
                    child: const Text('Login'),
                  ),
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
