import 'package:flutter/material.dart';
import 'package:reapers_app/logins/firsttry.dart';

import 'view/trypage2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:overlapped_carousel/overlapped_carousel.dart';
import 'package:carousel_slider/carousel_slider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<Widget> images3 = [
    Image.asset('assets/images/app3.jpg'),
    Image.asset('assets/images/app3.jpg'),
    Image.asset('assets/images/app3.jpg'),
  ];

  final List<Widget> images2 = [
    'assets/images/app3.jpg',
    'assets/images/app3.jpg',
    'assets/images/app3.jpg',
  ].map((image) => Image.asset(image)).toList();

  List<Widget> widgets = List.generate(
    10,
    (index) => ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      ),
      child: Image.asset(
        'assets/images/$index.jpg', //Images stored in assets folder
        fit: BoxFit.fill,
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CustomPaint(
            painter: LogoPainter1(),
            size: const Size(400, 100),
            child: Column(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      "Welcome",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Reapers City Chapel",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/logo.jpg"),
                      radius: 25,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ImageSliderCarousel(),
          const SizedBox(
            height: 50,
          ),
          Stack(
            children: [
              SizedBox(
                height: screenHeight * 0.40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(223, 20, 20, 20),
                      //Color.fromARGB(225, 225, 252, 227),
                      image: DecorationImage(
                        image: AssetImage('assets/images/green3.gif'),
                        fit: BoxFit.cover,
                        // colorFilter: ColorFilter.mode(
                        //   Colors.white.withOpacity(
                        //       0.1), // Adjust the opacity value here
                        //   BlendMode.srcATop,
                        // ),
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: ListView(
                      // shrinkWrap: true,
                      children: [
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: const Color.fromARGB(255, 235, 245, 235),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              title: const Text("THE PRECIOUS WORD"),
                              subtitle: const Text("Every Sunday"),
                              trailing: ElevatedButton(
                                  child: const Text("8:00AM"),
                                  onPressed: () {
                                    // print(screenHeight);
                                  }),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: const Color.fromARGB(255, 235, 245, 235),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              title: const Text("MID-WEEK"),
                              subtitle: const Text("Every Wednesday"),
                              trailing: ElevatedButton(
                                  child: const Text("6:30PM"),
                                  onPressed: () {}),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: const Color.fromARGB(255, 235, 245, 235),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              title: const Text("PRAYER SERVICE"),
                              subtitle: const Text("Every Friday"),
                              trailing: ElevatedButton(
                                  child: const Text("7:00PM"),
                                  onPressed: () {}),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  child: Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Activities",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),

      // bottomNavigationBar: BottomAppBar(
      //   notchMargin: 10,
      //   shape: const CircularNotchedRectangle(),
      //   child: Row(
      //     children: [
      //       IconButton(
      //           icon: const Icon(Icons.group_rounded, color: Colors.green),
      //           onPressed: () {
      //             // Navigator.push(context,
      //             //     MaterialPageRoute(builder: (context) {
      //             //   return AllMembersPage(
      //             //     token: token,
      //             //   );
      //             // }));
      //           }),
      //       InkWell(
      //           onTap: () {
      //             // Navigator.push(context,
      //             //     MaterialPageRoute(builder: (context) {
      //             //   return AllMembersPage(
      //             //     token: token,
      //             //   );
      //             // }));
      //           },
      //           child: const Text(
      //             "All members",
      //             style: TextStyle(fontSize: 10),
      //           )),
      //       const Spacer(),
      //       InkWell(
      //           onTap: () {
      //             // Navigator.push(context,
      //             //     MaterialPageRoute(builder: (context) {
      //             //   return UnassignedMembersPage(
      //             //     token: token,
      //             //   );
      //             // }));
      //           },
      //           child:
      //               const Text("Unassigned", style: TextStyle(fontSize: 10))),
      //       IconButton(
      //           icon: const Icon(
      //             Icons.person_add_disabled,
      //             color: Colors.green,
      //           ),
      //           onPressed: () {
      //             // Navigator.push(context,
      //             //     MaterialPageRoute(builder: (context) {
      //             //   return UnassignedMembersPage(
      //             //     token: token,
      //             //   );
      //             // }));
      //           }),
      //     ],
      //   ),
      // ),

      bottomNavigationBar: BottomNavigationBar(
        // currentIndex: _selectedIndex,
        // backgroundColor: Colors.green,
        onTap: (index) {
          if (index == 0) {
            void fBLunch() async {
              // final url = Uri.parse('https://web.facebook.com/reapnet1');
              final url = Uri.parse('https://m.facebook.com/reapnet1/');

              if (await canLaunchUrl(url)) {
                await launchUrl(
                  url,
                );
              }
            }

            fBLunch();
          } else if (index == 1) {
            void messagesLunch() async {
              // final url = Uri.parse('https://web.facebook.com/reapnet1');
              final url = Uri.parse(
                  'https://podcasts.google.com/feed/aHR0cHM6Ly9hbmNob3IuZm0vcy82NTUwYTk4Yy9wb2RjYXN0L3Jzcw==');

              if (await canLaunchUrl(url)) {
                await launchUrl(
                  url,
                );
              }
            }

            messagesLunch();
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginForm(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.facebook,
            ),
            label: 'FaceBook',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark, color: Colors.green),
              label: 'Precious Word'),
          BottomNavigationBarItem(
            icon: Icon(Icons.people, color: Colors.green),
            label: 'Discipleship',
          ),
        ],
      ),
    );
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
        Colors.green,
        Colors.green
        //Color.fromARGB(255, 27, 58, 28),
        // Color.fromARGB(255, 49, 109, 51),
        // Color.fromARGB(255, 49, 109, 51)
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
    canvas.drawShadow(path, const Color.fromARGB(255, 44, 241, 61), 4, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Generate a list of widgets. You can use another way
  List<Widget> widgets = List.generate(
    10,
    (index) => ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      ),
      child: Image.asset(
        'assets/images/$index.jpg', //Images stored in assets folder
        fit: BoxFit.fill,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blue,
      //Wrap with Center to place the carousel center of the screen
      body: Center(
        //Wrap the OverlappedCarousel widget with SizedBox to fix a height. No need to specify width.
        child: SizedBox(
          //  height: min(screenWidth / 3.3 * (16 / 9),screenHeight*.9),
          child: OverlappedCarousel(
            widgets: widgets, //List of widgets
            currentIndex: 2,
            onClicked: (index) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("You clicked at $index"),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ImageSliderCarousel extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/app1.jpg',
    'assets/images/app2.jpg',
    'assets/images/app3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return CarouselSlider(
      options: CarouselOptions(
        height: screenHeight * 0.30,
        autoPlay: true,
        enlargeCenterPage: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 700),
        viewportFraction: 0.8,
      ),
      items: imagePaths.asMap().entries.map((entry) {
        int index = entry.key;
        String imagePath = entry.value;
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                // Navigate to a specific page based on the tapped image
                if (index == 0) {
                  void fBLunch() async {
                    // final url = Uri.parse('https://web.facebook.com/reapnet1');
                    final url = Uri.parse('https://m.facebook.com/reapnet1/');

                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                      );
                    }
                  }

                  fBLunch();
                } else if (index == 1) {
                  void messagesLunch() async {
                    // final url = Uri.parse('https://web.facebook.com/reapnet1');
                    final url = Uri.parse(
                        'https://podcasts.google.com/feed/aHR0cHM6Ly9hbmNob3IuZm0vcy82NTUwYTk4Yy9wb2RjYXN0L3Jzcw==');

                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                      );
                    }
                  }

                  messagesLunch();
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginForm(),
                    ),
                  );
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
