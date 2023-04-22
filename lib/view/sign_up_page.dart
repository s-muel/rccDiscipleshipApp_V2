import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:reapers_app/logins/firsttry.dart';

import '../logins/api_calls.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  ApiCalls api = ApiCalls();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  bool _isLoading = false;

  void registerMember() async {
    if (_formKey.currentState!.validate()) {
      //  const String url = "https://rcc-discipleship.up.railway.app/api/auth";
      final username = _usernameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _passwordController.text.trim();
      setState(() {
        // loginIndicator = true;
      });

      try {
        final Future<void> data = api.registerMember(
            email: email,
            password: password,
            confirmPassword: confirmPassword,
            context: context);
      } catch (e) {
        print('Failed to login: $e');
      }
    }
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
      // appBar: AppBar(),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 50.0, right: 50.0, top: 30.0, bottom: 20.0),
                  child: SizedBox(
                    height: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        image: const DecorationImage(
                          image: NetworkImage(
                              "https://res.cloudinary.com/dekhxk5wg/image/upload/v1682120332/appFeatureImages/RCC_App_tag_Logo_cieaqz.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const Text(
                  "SignUp",
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

                //password text field
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
                const Padding(
                  padding: EdgeInsets.only(
                      left: 35.0, right: 35.0, top: 8.0, bottom: 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Confirm Password",
                      style: TextStyle(fontSize: 15, color: Colors.green),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 35.0, right: 35.0, top: 8.0, bottom: 8.0),
                  child: TextFormField(
                    controller: _confirmpasswordController,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
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
                    _startLoading();
                    registerMember();
                  },

                  // onPressed: () {
                  //   setState(() {
                  //     _isLoading = true;
                  //   });
                  //   //const CircularProgressIndicator();
                  //   _startLoading();
                  //   _submit();
                  // },
                  child: const Text('Sign Up'),
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
                Padding(
                  padding: const EdgeInsets.only(
                      left: 35.0, right: 35.0, top: 8.0, bottom: 0),
                  child: Row(
                    children: [
                      const Text("Already Registered?"),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginForm(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),

                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: InkWell(
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => const SignUpPage(),
                  //         ),
                  //       );
                  //     },
                  //     child: const Text(
                  //       "Sign Up",
                  //       style: TextStyle(
                  //         color: Colors.green,
                  //         fontWeight: FontWeight.bold,
                  //         decoration: TextDecoration.underline,
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
        ],
      ),
    );
  }
}
