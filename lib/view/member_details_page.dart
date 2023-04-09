import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../logins/api_calls.dart';
//import 'package:intl/intl.dart';

class MyForm extends StatefulWidget {
  final Map<String, dynamic> initialData; // Initial data from API
  final String token;

  MyForm({required this.initialData, required this.token});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
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
  late TextEditingController _isMentor;
  late String token;
  final TextEditingController _mentorNameController2 = TextEditingController();
  late int mentor;
  late dynamic data;
  int _selectedValue = 1;
  String _selectedItemText = "";

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
    _isMentor =
        TextEditingController(text: widget.initialData['is_mentor'].toString());
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
    _isMentor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Form')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            //
            TextField(
              controller: _isMentor,
              decoration: InputDecoration(labelText: 'Is mentor'),
            ),

            StreamBuilder<List<dynamic>>(
              stream: api.stream(token,
                  "https://rcc-discipleship.up.railway.app/api/mentors/"),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<dynamic> data = snapshot.data!;

                  final int dataLength = data.length;
                  //int iDValue = widget.initialData['mentor'];

                  int iDValue = widget.initialData['mentor'] ?? 1;

                  return DropdownButton<int>(
                    // value: iDValue,
                    hint: const Text("Select Discipler"),
                    items: snapshot.data!
                        .map((option) => DropdownMenuItem<int>(
                            value: option['id'],
                            child: Text(option['username'])))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedItemText = snapshot.data?.firstWhere(
                            (item) => item['id'] == newValue)['username'];
                        iDValue = newValue!;
                        _mentorNameController.text = _selectedItemText;
                        _selectedValue = newValue;

                        print(_selectedItemText);
                      });
                    },
                  );
                  // DropdownButtonFormField<String>(
                  //   items: snapshot.data!.map((option) {
                  //     return DropdownMenuItem<String>(
                  //       value: option['id']
                  //           .toString(), // Assuming 'mentor_name' is the field name for mentor name in the API response
                  //       child: Text(option[
                  //           'username']), // Assuming 'mentor_name' is the field name for mentor name in the API response
                  //     );
                  //   }).toList(),
                  //   onChanged: (value) {
                  //     _mentorNameController2.text = value!;
                  //     mentor = value as int;

                  //     print(_mentorNameController2.text);
                  //   },
                  //   decoration: InputDecoration(
                  //     labelText: 'Select a mentor',
                  //     border: OutlineInputBorder(),
                  //   ),
                  // );
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
            // CheckboxListTile(
            //   title: Text('Is Mentor'),
            //   value: widget.initialData['is_mentor'],
            //   onChanged: (bool? value) {
            //     setState(() {
            //       widget.initialData['is_mentor'] = value;
            //     });
            //   },
            // ),
            if (_mentorNameController.text.isEmpty)
              const Text('Please assign a Discipler'),
            if (_mentorNameController.text.isNotEmpty)
              Text('Mentor name: ${_mentorNameController.text}'),
            // Text(_mentorNameController.text),
            // TextField(
            //   controller: _mentorNameController,
            //   decoration: InputDecoration(labelText: 'Mentor Name'),
            // ),
            TextField(
              controller: _workController,
              decoration: InputDecoration(labelText: 'Work'),
            ),
            TextField(
              controller: _homeAddressController,
              decoration: InputDecoration(labelText: 'Home Address'),
            ),
            TextField(
              controller: _languageController,
              decoration: InputDecoration(labelText: 'Language'),
            ),
            TextField(
              controller: _auxiliaryController,
              decoration: InputDecoration(labelText: 'Auxiliary'),
            ),
            CheckboxListTile(
              title: Text('Baptized'),
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
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
// Update the data in the API with the values from the form
                String firstName = _firstNameController.text;
                String lastName = _lastNameController.text;
                String email = _emailController.text;
                String phoneNumber = _phoneNumberController.text;
                bool isMentor = widget.initialData['is_mentor'];
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
                    firstName,
                    lastName,
                    email,
                    phoneNumber,
                    isMentor,
                    _selectedValue,
                    mentorName,
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
          ],
        ),
      ),
    );
  }

  void updateDataInApi(
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      bool isMentor,
      int mentor,
      String mentorName,
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
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'is_mentor': isMentor,
      'mentor': mentor,
      'mentor_name': mentorName,
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
