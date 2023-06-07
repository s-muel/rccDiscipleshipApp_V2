import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:reapers_app/landing_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../new_landing_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  void fBLunch() async {
    // final url = Uri.parse('https://web.facebook.com/reapnet1');
    final url = Uri.parse('https://rcc-discipleship.up.railway.app/landing/');

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      fBLunch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.yellow,
        child: Image.asset('assets/images/landing.jpg'));
  }
}
