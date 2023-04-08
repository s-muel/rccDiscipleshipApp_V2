import 'package:flutter/foundation.dart';
import 'dart:convert';

// class Post {
//   final int userId;
//   final int id;
//   final String title;
//   final String body;

//   Post({
//     required this.userId,
//     required this.id,
//     required this.title,
//     required this.body,
//   });

//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       userId: json['userId'] as int,
//       id: json['id'] as int,
//       title: json['title'] as String,
//       body: json['body'] as String,
//     );
//   }
// }

// // class MyFristModel{
// //     final int userId;
// //   final int email;

// //    MyFristModel({
// //     required this.userId,
// //     required this.email,

// //   });

// //     factory  MyFristModel.fromJson(Map<String, dynamic> json) {
// //     return  MyFristModel(
// //       userId: json['userId'] as int,
// //       email: json['email'] ,
    
// //     );
// //   }

// // }


// class MyFristModel {
//   final int id;
//   final String email;
//   final String firstName;
//   final String lastName;
//   final String avatar;

//   MyFristModel({required this.id, required this.email, required this.firstName, required this.lastName, required this.avatar});

//   factory MyFristModel.fromJson(Map<String, dynamic> json) {
//     return MyFristModel(
//       id: json['data']['id'],
//       email: json['data']['email'],
//       firstName: json['data']['first_name'],
//       lastName: json['data']['last_name'],
//       avatar: json['data']['avatar'],
//     );
//   }
// }

// class SupportData {
//   final String url;
//   final String text;

//   SupportData({required this.url, required this.text});

//   factory SupportData.fromJson(Map<String, dynamic> json) {
//     return SupportData(
//       url: json['support']['url'],
//       text: json['support']['text'],
//     );
//   }
// }





class UserModel {
  final UserData data;
  final SupportData support;

  UserModel({required this.data, required this.support});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      data: UserData.fromJson(json['data']),
      support: SupportData.fromJson(json['support']),
    );
  }
}

class UserData {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  UserData({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

factory UserData.fromJson(Map<String, dynamic> json) {
  return UserData(
    id: json['data']['id'] ?? 0,
    email: json['data']['email'] ?? '',
    firstName: json['data']['first_name'] ?? '',
    lastName: json['data']['last_name'] ?? '',
    avatar: json['data']['avatar'] ?? '',
  );
}
}

class SupportData {
  final String url;
  final String text;

  SupportData({required this.url, required this.text});

  factory SupportData.fromJson(Map<String, dynamic> json) {
    return SupportData(
      url: json['url'],
      text: json['text'],
    );
  }
}





class Team {
  final String abbreviation; // eg. LAL
  final String city; // eg. Los Angeles

  Team({
    required this.abbreviation,
    required this.city,
  });
}