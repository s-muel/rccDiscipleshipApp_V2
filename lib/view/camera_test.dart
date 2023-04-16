// import 'dart:io';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:image_picker/image_picker.dart';

// class CameraTestPage extends StatefulWidget {
//   const CameraTestPage({super.key});

//   @override
//   State<CameraTestPage> createState() => _CameraTestPageState();
// }

// class _CameraTestPageState extends State<CameraTestPage> {
//   // late CameraController _controller;
//   File? _imageFile;

//   void _takePicture() async {
//     final picker = ImagePicker();
//     final imageFile = await picker.pickImage(source: ImageSource.camera);

//     if (imageFile != null) {
//       setState(() {
//         _imageFile = File(imageFile.path);
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   void _initializeCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;

//     CameraController _controller =
//         CameraController(firstCamera, ResolutionPreset.medium);
//     await _controller.initialize();
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         children: [
//           // Center(
//           //   child: _imageFile != null
//           //       ? Image.file(_imageFile!)
//           //       : const Text('No image selected.'),
//           // ),
//           CircleAvatar(
//             radius: 50,

//             child: _imageFile != null
//                 ? Image.file(_imageFile!)
//                 : const Text('No image selected.'),
//           )
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _takePicture,
//         child: const Icon(Icons.camera),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:cloudinary_flutter/cloudinary_flutter.dart';


class CameraTestPage extends StatefulWidget {
  @override
  _CameraTestPageState createState() => _CameraTestPageState();
}

class _CameraTestPageState extends State<CameraTestPage> {
  File? _image;
  XFile? _DBimage;
  String? _base64Image;
  String? _imageURL;

  final cloudinary = Cloudinary.full(
    apiKey: '295462655464473',
    cloudName: 'dekhxk5wg',
    apiSecret: 'dPVVBpBhkyCEBSw9SHtObedz4nI',
  
  );
  Future _uploadImage() async {
    final response = await cloudinary.uploadResource(CloudinaryUploadResource(
      filePath: _DBimage?.path,
    )
        // CloudinaryFile.fromFile(_imageFile.path),
        );
    setState(() {
      _imageURL = response.secureUrl;
    });
    if (response.isSuccessful) {
      print('Get your image from with ${response.secureUrl}');
    } else {
      print(response.error);
    }
  }

  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _base64Image = base64Encode(_image!.readAsBytesSync());
        _DBimage = pickedFile;
      } else {
        //print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Base64 Image Demo'),
      ),
      body: Column(
        children: [
          Center(
            child: _base64Image == null
                ? const Text('No image selected.')
                : Image.memory(base64Decode(_base64Image!)),
          ),
          ElevatedButton(
              onPressed: () {
                _uploadImage();
              },
              child: const Text("Upload"))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: const Icon(Icons.camera),
      ),
    );
  }
}
