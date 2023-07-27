import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/material.dart';
import 'package:reapers_app/logins/api_calls.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'trypage2.dart';

class AddMemberPage extends StatefulWidget {
  final String token;
  const AddMemberPage({super.key, required this.token});

  @override
  //_AddMemberPageState createState() => _AddMemberPageState();
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  ApiCalls api = ApiCalls();
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _mentorNameController = TextEditingController();
  final _workController = TextEditingController();
  final _homeAddressController = TextEditingController();
  final _languageController = TextEditingController();
  final _auxiliaryController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  bool _baptized = false;
  bool _isMentor = false;
  String _errorMessage = '';
  String _successMessage = '';
  int _currentStep = 0;
  bool _formCompleted = false;
  bool _selectedValue = false;
  String _selectedItemText = "";
  dynamic mentorID = null;

  bool _isLoading = false;
  dynamic BOD = null;

  //adding pictures functions
  //File _image = File('');
  File? _image = File('');
  XFile? _DBimage;
  String? _imageURL;
  bool isUploadImage = false;

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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? emailValue =
            _emailController.text.isEmpty ? null : _emailController.text;
        String? dateOfBirthValue = _dateOfBirthController.text.isEmpty
            ? null
            : _dateOfBirthController.text;

        await api.addMember(
          context: context,
          token: token,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: emailValue,
          phoneNumber: _phoneNumberController.text,
          mentorName: _mentorNameController.text,
          //mentor: mentorID,
          work: _workController.text,
          homeAddress: _homeAddressController.text,
          language: _languageController.text,
          auxiliary: _auxiliaryController.text,
          dateOfBirth: dateOfBirthValue,
          baptized: _selectedValue,
          isMentor: _isMentor,
          photo: _imageURL,
        );

        setState(() {
          _successMessage = 'Data updated successfully';
          _errorMessage = '';
          //_formKey.currentState?.reset();
          _firstNameController.clear();
          _lastNameController.clear();
        });
      } catch (error) {
        setState(() {
          _errorMessage = 'Failed to update data: $error';
          _successMessage = '';
        });
      }
    }
  }

  // loading widget
  Future<void> _startLoading() async {
    _isLoading = true;
    print(_isLoading);
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      _isLoading = false;
    });
  }

  late String token;
  @override
  void initState() {
    super.initState();
    token = widget.token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => Home(token: token),
        //         ),
        //       );
        //     },
        //     icon: const Icon(Icons.arrow_circle_left)),
        centerTitle: true,
        title: const Text('Add Member Page'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              //   _formCompleted = true;
              // }

              Center(
                child: Visibility(
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
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, bottom: 3),
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
                                            leading:
                                                const Icon(Icons.camera_alt),
                                            title: const Text('Take a picture'),
                                            onTap: () async {
                                              await getImageFromCamera();
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context, _image);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.image),
                                            title: const Text(
                                                'Choose from gallery'),
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
              ),
              Center(
                child: Visibility(
                  visible: !isUploadImage,
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Color.fromARGB(255, 163, 240, 167),
                        child:
                            Icon(Icons.person, size: 80, color: Colors.white),
                      ),
                      Positioned(
                        top: 70,
                        left: 60,
                        child: Card(
                          color: const Color.fromARGB(255, 230, 225, 225),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, bottom: 3),
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
                                            leading:
                                                const Icon(Icons.camera_alt),
                                            title: const Text('Take a picture'),
                                            onTap: () async {
                                              await getImageFromCamera();
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context, _image);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.image),
                                            title: const Text(
                                                'Choose from gallery'),
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
              ),
              const SizedBox(
                height: 10,
              ),

              //  Row(),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "First Name",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 45,
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200]),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a first name';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Last Name",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 45,
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200]),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a last name';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Location",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 45,
                  child: TextFormField(
                      controller: _homeAddressController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200])),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Date of Birth",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: _dateOfBirthController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: const Icon(Icons.calendar_today,
                                color: Colors.green),
                            filled: true,
                            fillColor: Colors.grey[200]),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     setState(() {
                        //       _dateOfBirthController.value = BOD;
                        //     });

                        //     // return 'Please enter phone number';
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Phone Number",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 45,
                  child: TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: const Icon(Icons.call, color: Colors.green),
                        filled: true,
                        fillColor: Colors.grey[200]),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              //2 Church details
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Discipler",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Row(
                children: [
                  //  if (_mentorNameController.text.isEmpty)
                  // const Text(''),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 47,
                        child: TextField(
                          enabled: false,
                          controller: _mentorNameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              // suffixIcon: const Icon(
                              //     Icons.calendar_today,
                              //     color: Colors.green),
                              filled: true,
                              fillColor: Colors.grey[200]),
                        ),
                      ),
                    ),
                  ),
                  //  if (_mentorNameController.text.isNotEmpty)
                  //--------------------------

                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: SizedBox(
                  //       height: 45,
                  //       child: TextFormField(
                  //         decoration: InputDecoration(
                  //             border: OutlineInputBorder(
                  //               borderRadius:
                  //                   BorderRadius.circular(10),
                  //               borderSide: BorderSide.none,
                  //             ),
                  //             filled: true,
                  //             fillColor: Colors.grey[200]),
                  //         enabled: false,
                  //         controller: _mentorNameController,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  //--------------------------------------

                  Expanded(
                    child: StreamBuilder<List<dynamic>>(
                      stream: api.stream(token,
                          "https://rcc-discipleship.up.railway.app/api/mentors/"),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final List<dynamic> data = snapshot.data!;

                          final int dataLength = data.length;
                          int iDValue = 1;

                          //   int iDValue = widget.initialData['mentor'] ?? 1;

                          return SizedBox(
                            width: 50,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 5),
                              child: Card(
                                color: Colors.grey[200],
                                //  margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                  ),
                                  child: DropdownButton<int>(
                                    // value: iDValue,

                                    hint: const Text("Select Discipler"),
                                    items: snapshot.data!
                                        .map(
                                          (option) => DropdownMenuItem<int>(
                                            value: option['id'],
                                            child: Text(
                                              option["member"]['first_name'] +
                                                  " " +
                                                  option["member"]['last_name'],
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        var selectedMember = snapshot.data
                                            ?.firstWhere((item) =>
                                                item['id'] ==
                                                newValue)['member'];
                                        _selectedItemText =
                                            '${selectedMember['first_name']} ${selectedMember['last_name']}';
                                        mentorID = newValue!;
                                        _mentorNameController.text =
                                            _selectedItemText;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Auxiliary",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 45,
                  child: TextFormField(
                    controller: _auxiliaryController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200]),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              // Row(
              //   children: [
              //     if (_mentorNameController.text.isEmpty) const Text(''),
              //     if (_mentorNameController.text.isNotEmpty)
              //       Expanded(
              //         child: TextFormField(
              //           enabled: false,
              //           controller: _mentorNameController,
              //         ),
              //       ),
              //   ],
              // ),
              // Row(
              //   children: [
              //     const Text('Add as mentor',
              //         style: TextStyle(
              //             fontSize: 17,
              //             color: Colors.green,
              //             fontWeight: FontWeight.bold)),
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
              //const SizedBox(height: 15),

              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Baptized",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.grey[200],
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonFormField<bool>(
                      value: _selectedValue,
                      items: const [
                        DropdownMenuItem(
                          value: true,
                          child: Text('Yes'),
                        ),
                        DropdownMenuItem(
                          value: false,
                          child: Text('No'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Select an option',
                      ),
                    ),
                  ),
                ),
              ),

              // Row(

              //3 Other Details

              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    )),
              ),
              //const SizedBox(height: 10),

              // const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Work",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 45,
                  child: TextFormField(
                      controller: _workController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200])),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    height: 40,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        _startLoading();
                        _submitForm();
                      },
                      child: const Text("Submit"),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _isLoading,
                child: const LinearProgressIndicator(
                  minHeight: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
