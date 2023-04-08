// import 'package:flutter/material.dart';
// import 'Pages/model.dart';
// import 'Pages/services.dart';

// class PostsPage extends StatelessWidget {
//   final HttpService httpService = HttpService();
// // Future<List<Post>> responeSize = httpService.getPosts();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Posts"),
//       ),
//       body: FutureBuilder(
//         future: httpService.getPosts(),
//         builder:
//             (BuildContext context, AsyncSnapshot<List<MyFristModel>> snapshot) {
//           if (snapshot.hasData) {
//             List<MyFristModel>? posts = snapshot.data;
//             return ListView(
//               children: posts!
//                   .map(
//                     (MyFristModel post) => ListTile(
//                       title: Text(post.userId.toString()),
//                       subtitle: Text("${post.userId}"),
//                     ),
//                   )
//                   .toList(),
//             );
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
