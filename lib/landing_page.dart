// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class LandingPage extends StatelessWidget {
//   const LandingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(

//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:reapers_app/logins/firsttry.dart';

import 'view/trypage2.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            CustomPaint(
              painter: LogoPainter1(),
              size: const Size(400, 120),
              child: const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child: Center(
                    child: Text(
                  "Reapers City Chapel App",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    // shadows: ,
                  ),
                )),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () async {
                // final url = Uri.parse('https://web.facebook.com/reapnet1');
                final url = Uri.parse('https://m.facebook.com/reapnet1/');

                if (await canLaunchUrl(url)) {
                  await launchUrl(
                    url,
                  );
                }
              },
              // onTap: (
              //   () => Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => const MessagesPage()))),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Card(
                  elevation: 10,
                  child: Container(
                    width: 200,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/app1.jpg'),
                        fit: BoxFit.cover,
                      ),
                      // color: Colors.black
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: InkWell(
                onTap: () async {
                  // final url = Uri.parse('https://web.facebook.com/reapnet1');
                  final url = Uri.parse(
                      'https://podcasts.google.com/feed/aHR0cHM6Ly9hbmNob3IuZm0vcy82NTUwYTk4Yy9wb2RjYXN0L3Jzcw==');

                  if (await canLaunchUrl(url)) {
                    await launchUrl(
                      url,
                    );
                  }
                },
                child: Card(
                  elevation: 10,
                  child: Container(
                    width: 300,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/app2.jpg'),
                        fit: BoxFit.fitWidth,
                      ),
                      // color: Colors.black
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginForm(),
                    ),
                  );
                },
                child: Card(
                  elevation: 10,
                  child: Container(
                    width: 300,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/app3.jpg'),
                        fit: BoxFit.fitWidth,
                      ),
                      // color: Colors.black
                    ),
                  ),
                ),
              ),
            ),
            // Card(),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 30, 90, 30),
          onPressed: () {},
          tooltip: 'We Believe There Is More',
          child: const Icon(
            Icons.church,
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }
}

class LogoPainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    Paint paint = Paint();
    Path path = Path();
    paint.shader = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        //Color.fromARGB(255, 27, 58, 28),
        Color.fromARGB(255, 49, 109, 51),
        Color.fromARGB(255, 49, 109, 51)
        //Color.fromARGB(255, 23, 54, 23),
        // Color.fromARGB(255, 87, 241, 40),
        // Color.fromARGB(255, 12, 168, 12)
        // Color.fromARGB(255, 242, 101, 197),
        // Color.fromARGB(255, 154, 76, 237),
      ],
    ).createShader(rect);
    path.lineTo(0, size.height - size.height / 8);
    path.conicTo(size.width / 1.2, size.height, size.width,
        size.height - size.height / 8, 9);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawShadow(path, Color.fromARGB(255, 44, 241, 61), 4, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
