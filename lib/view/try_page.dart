import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TryPage extends StatefulWidget {
  const TryPage({super.key});

  @override
  State<TryPage> createState() => _TryPageState();
}

class _TryPageState extends State<TryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://wallpapercave.com/wp/abLyE7p.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Column(),
      // Stack(
      //   children: [
      //     Container(
      //       decoration: const BoxDecoration(
      //         image: DecorationImage(
      //           image: NetworkImage('https://wallpapercave.com/wp/abLyE7p.jpg'),
      //           fit: BoxFit.cover,
      //         ),
      //       ),
      //     ),
      //     // Your main content widget goes here

      //     Positioned(
      //       // top: -1,
      //       child: SizedBox(
      //         height: 600,
      //         child: Container(
      //           color: Colors.white,
      //         ),
      //       ),
      //     ),
      //     TextButton(onPressed: () {}, child: Text("hello")),
      //   ],
      // ),
    );
  }
}
