import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:image_picker/image_picker.dart';
import '../logins/api_calls.dart';
import 'dart:io';
//import 'package:intl/intl.dart';

class DiscipleDetailsPage extends StatefulWidget {
  final Map<String, dynamic> initialData; // Initial data from API
  final String token;

  DiscipleDetailsPage({required this.initialData, required this.token});

  @override
  _DiscipleDetailsPageState createState() => _DiscipleDetailsPageState();
}

class _DiscipleDetailsPageState extends State<DiscipleDetailsPage> {
  ApiCalls api = ApiCalls();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _mentorNameController;
  late TextEditingController _workController;
  late TextEditingController _homeAddressController;
  late TextEditingController _languageController;
  late TextEditingController _auxiliaryController;
  late TextEditingController _dateOfBirthController;

  // late bool _isMentor;
  late String token;
  final TextEditingController _mentorNameController2 = TextEditingController();
  late int mentor;
  late dynamic data;
  int _selectedValue = 1;
  String _selectedItemText = "";

  late String userImage;

  //adding pictures functions
  //File _image = File('');
  File? _image = File('');
  XFile? _DBimage;
  String? _imageURL;
  bool isUploadImage = false;

  bool _isLoading = false;

  //sending image to cloud storage
  final cloudinary = Cloudinary.full(
    apiKey: '295462655464473',
    cloudName: 'dekhxk5wg',
    apiSecret: 'dPVVBpBhkyCEBSw9SHtObedz4nI',
  );
  //function for uploading
  Future _uploadImage(File imageFile) async {
    final response = await cloudinary.uploadResource(CloudinaryUploadResource(
      filePath: imageFile.path,
    ));
    setState(() {
      _imageURL = response.secureUrl;
      userImage = response.secureUrl!;
    });
    if (response.isSuccessful) {
      print('Get your image from with ${response.secureUrl}');
    } else {
      print(response.error);
    }
  }

  final picker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 25);

    if (pickedFile != null) {
      await _uploadImage(File(pickedFile.path));
    }
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        isUploadImage = true;
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (pickedFile != null) {
      await _uploadImage(File(pickedFile.path));
    }
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        isUploadImage = true;
      }
    });
  }

  //
  // loading widget
  Future<void> _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    print(_isLoading);
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      _isLoading = false;
    });
    print(_isLoading);
  }

//

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.initialData['first_name']);
    _lastNameController =
        TextEditingController(text: widget.initialData['last_name']);
    _emailController = TextEditingController(text: widget.initialData['email']);
    _phoneNumberController =
        TextEditingController(text: widget.initialData['phone_number']);
    _mentorNameController =
        TextEditingController(text: widget.initialData['mentor_name']);
    _workController = TextEditingController(text: widget.initialData['work']);
    _homeAddressController =
        TextEditingController(text: widget.initialData['home_address']);
    _languageController =
        TextEditingController(text: widget.initialData['language']);
    _auxiliaryController =
        TextEditingController(text: widget.initialData['axilliary']);
    _dateOfBirthController =
        TextEditingController(text: widget.initialData['date_of_birth']);
    // _isMentor =
    //     TextEditingController(text: widget.initialData['is_mentor'].toString());
    userImage = widget.initialData['photo'] ??
        "https://res.cloudinary.com/dekhxk5wg/image/upload/v1681630522/placeholder_ewiwh7.png";

    token = widget.token;
    data = widget.initialData;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _mentorNameController.dispose();
    _workController.dispose();
    _homeAddressController.dispose();
    _languageController.dispose();
    _auxiliaryController.dispose();
    _dateOfBirthController.dispose();
    // _isMentor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disciple Details'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // image Upload
            Visibility(
              visible: isUploadImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: FileImage(_image!),
                    radius: 50,
                  ),
                  Positioned(
                    top: 70,
                    left: 60,
                    child: Card(
                      color: const Color.fromARGB(255, 230, 225, 225),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 5, right: 5, bottom: 3),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: 150.0,
                                  child: Column(
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      //const Text("Select Image from"),

                                      ListTile(
                                        leading: const Icon(Icons.camera_alt),
                                        title: const Text('Take a picture'),
                                        onTap: () async {
                                          await getImageFromCamera();
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context, _image);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.image),
                                        title:
                                            const Text('Choose from gallery'),
                                        onTap: () async {
                                          await getImageFromGallery();
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context, _image);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: const Icon(
                            Icons.camera_alt,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !isUploadImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    // backgroundColor: Color.fromARGB(255, 163, 240, 167),
                    backgroundImage: NetworkImage(userImage),
                  ),
                  Positioned(
                    top: 70,
                    left: 60,
                    child: Card(
                      color: const Color.fromARGB(255, 230, 225, 225),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 5, right: 5, bottom: 3),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: 150.0,
                                  child: Column(
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      //const Text("Select Image from"),

                                      ListTile(
                                        leading: const Icon(Icons.camera_alt),
                                        title: const Text('Take a picture'),
                                        onTap: () async {
                                          await getImageFromCamera();
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context, _image);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.image),
                                        title:
                                            const Text('Choose from gallery'),
                                        onTap: () async {
                                          await getImageFromGallery();
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context, _image);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: const Icon(
                            Icons.camera_alt,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            //
            // TextField(
            //   controller: _isMentor,
            //   decoration: const InputDecoration(labelText: 'Is mentor'),
            // ),
            // Row(
            //   children: [
            //     const Text('Add as mentor'),
            //     Checkbox(
            //       value: _isMentor,
            //       onChanged: (value) {
            //         setState(() {
            //           _isMentor = value!;
            //         });
            //       },
            //     ),
            //   ],
            // ),

            // Row(
            //   children: [
            //     if (_mentorNameController.text.isEmpty)
            //       const Expanded(child: Text('Discipler not assigned')),
            //     if (_mentorNameController.text.isNotEmpty)
            //       Expanded(
            //           child: Text(
            //               'Discipler name: ${_mentorNameController.text}')),
            //     StreamBuilder<List<dynamic>>(
            //       stream: api.stream(token,
            //           "https://rcc-discipleship.up.railway.app/api/mentors/"),
            //       builder: (context, snapshot) {
            //         if (snapshot.hasData) {
            //           final List<dynamic> data = snapshot.data!;

            //           final int dataLength = data.length;
            //           //int iDValue = widget.initialData['mentor'];

            //           int iDValue = widget.initialData['mentor'] ?? 1;

            //           return Expanded(
            //             child: DropdownButton<int>(
            //               // value: iDValue,
            //               hint: const Text("Select Discipler"),
            //               items: snapshot.data!
            //                   .map((option) => DropdownMenuItem<int>(
            //                       value: option['id'],
            //                       child: Text(option['username'])))
            //                   .toList(),
            //               onChanged: (newValue) {
            //                 setState(() {
            //                   _selectedItemText = snapshot.data?.firstWhere(
            //                       (item) => item['id'] == newValue)['username'];
            //                   iDValue = newValue!;
            //                   _mentorNameController.text = _selectedItemText;
            //                   _selectedValue = newValue;

            //                   print(_selectedItemText);
            //                 });
            //               },
            //             ),
            //           );

            //         } else if (snapshot.hasError) {
            //           return Center(
            //             child: Text('Error: ${snapshot.error}'),
            //           );
            //         } else {
            //           return const Center(
            //             child: CircularProgressIndicator(),
            //           );
            //         }
            //       },
            //     ),
            //   ],
            // ),
            // CheckboxListTile(
            //   title: Text('Is Mentor'),
            //   value: widget.initialData['is_mentor'],
            //   onChanged: (bool? value) {
            //     setState(() {
            //       widget.initialData['is_mentor'] = value;
            //     });
            //   },
            // ),

            // Text(_mentorNameController.text),
            // TextField(
            //   controller: _mentorNameController,
            //   decoration: InputDecoration(labelText: 'Mentor Name'),
            // ),
            TextField(
              controller: _workController,
              decoration: const InputDecoration(labelText: 'Work'),
            ),
            TextField(
              controller: _homeAddressController,
              decoration: const InputDecoration(labelText: 'Home Address'),
            ),
            TextField(
              controller: _languageController,
              decoration: const InputDecoration(labelText: 'Language'),
            ),
            TextField(
              controller: _auxiliaryController,
              decoration: const InputDecoration(labelText: 'Auxiliary'),
            ),
            CheckboxListTile(
              title: const Text('Baptized'),
              value: widget.initialData['baptised'],
              onChanged: (bool? value) {
                setState(() {
                  widget.initialData['baptised'] = value;
                });
              },
            ),
            InkWell(
              onTap: () {
                print(widget.initialData['date_of_birth']);
                DatePicker.showDatePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime(1900, 1, 1),
                  maxTime: DateTime.now(),
                  onChanged: (date) {
                    // Do something with the selected date
                  },
                  onConfirm: (date) {
                    setState(() {
                      _dateOfBirthController.text =
                          DateFormat('yyyy-MM-dd').format(date);
                    });
                  },
                  currentTime: DateTime.now(),
                  locale: LocaleType.en,
                );
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: _dateOfBirthController,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _startLoading();
// Update the data in the API with the values from the form
                String firstName = _firstNameController.text;
                String lastName = _lastNameController.text;
                String email = _emailController.text;
                String phoneNumber = _phoneNumberController.text;
                // bool isMentor = _isMentor;
                String mentorName = _mentorNameController2.text;
                String work = _workController.text;
                String homeAddress = _homeAddressController.text;
                String language = _languageController.text;
                String auxiliary = _auxiliaryController.text;
                bool baptized = widget.initialData['baptised'];
                String dateOfBirth = _dateOfBirthController.text;
                int memberID = widget.initialData['id'];
                String tokenz = token;

                print('this is before function $memberID');
// Update the API with the new values
                // Replace this with your actual API call to update the data
                updateDataInApi(
                    userImage,
                    firstName,
                    lastName,
                    email,
                    phoneNumber,
                    //  isMentor,
                    //  _selectedValue,
                    // mentorName,
                    work,
                    homeAddress,
                    language,
                    auxiliary,
                    baptized,
                    dateOfBirth,
                    memberID,
                    tokenz);

                // Show a success message to the user
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return AlertDialog(
                //       title: Text('Success'),
                //       content: Text('Form data updated successfully'),
                //       actions: [
                //         TextButton(
                //           onPressed: () {
                //             Navigator.pop(context);
                //           },
                //           child: Text('OK'),
                //         ),
                //       ],
                //     );
                //   },
                // );
              },
              child: Text('Update'),
            ),
            Visibility(
              visible: _isLoading,
              child: const SizedBox(
                width: 60,
                child: LinearProgressIndicator(
                  minHeight: 1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void updateDataInApi(
      String photo,
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      // bool isMentor,
      //   int mentor,
      //  String mentorName,
      String work,
      String homeAddress,
      String language,
      String auxiliary,
      bool baptized,
      String dateOfBirth,
      int memberID,
      String token) async {
    // Create a map of the updated data
    Map<String, dynamic> updatedData = {
      // 'id': memberID,
      'photo': photo,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      //  'is_mentor': isMentor,
      //  'mentor': mentor,
      // 'mentor_name': mentorName,
      'work': work,
      'home_address': homeAddress,
      'language': language,
      'axilliary': auxiliary,
      'baptised': baptized,
      'date_of_birth': dateOfBirth
    };

    // Convert the map to JSON
    String jsonData = jsonEncode(updatedData);

    // Make an HTTP PATCH request to update the data in the API
    Uri uri = Uri.parse(
        'https://rcc-discipleship.up.railway.app/api/members/$memberID/');
    http.Response response = await http.put(
      uri,

      headers: {
        'Authorization': 'Token  $token',
        'Content-Type': 'application/json',
      },
      //  body: jsonEncode(updatedData),
      body: jsonData,
    );

    // Check the response status code
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Update was successfully!')));
      // Handle success, e.g. show a success message to the user
    } else {
      // throw Exception('Failed to load data');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('An error occurred try again',
              style: TextStyle(
                color: Colors.red,
              ))));

      // Handle error, e.g. show an error message to the user
    }
  }
}
