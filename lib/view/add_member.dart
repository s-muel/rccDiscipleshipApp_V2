import 'package:flutter/material.dart';
import 'package:reapers_app/logins/api_calls.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

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
  int mentorID = 0;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await api.addMember(
          context: context,
          token: token,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phoneNumber: _phoneNumberController.text,
          mentorName: _mentorNameController.text,
          //mentor: mentorID,
          work: _workController.text,
          homeAddress: _homeAddressController.text,
          language: _languageController.text,
          auxiliary: _auxiliaryController.text,
          dateOfBirth: _dateOfBirthController.text,
          baptized: _selectedValue,
          isMentor: _isMentor,
        );
        setState(() {
          _successMessage = 'Data updated successfully';
          _errorMessage = '';
        });
        // _firstNameController.clear();
        // _lastNameController.clear();
      } catch (error) {
        setState(() {
          _errorMessage = 'Failed to update data: $error';
          _successMessage = '';
        });
      }
    }
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
      appBar: AppBar(),
      body: Form(
          key: _formKey,
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepContinue: () {
              setState(() {
                // if (_currentStep < steps.length - 1) {
                //   // If the current step is not the last step, move to the next step
                //   _currentStep++;
                // } else {
                //   // If the current step is the last step, call the _submit function
                //   _submitForm();
                // }
                // if (_formKey.currentState!.validate()) {
                //   if (_currentStep < 2) {
                //     _currentStep += 1;
                //   } else {
                //      _formCompleted = true;
                //   }
                // }

                if (_currentStep < 2) {
                  _currentStep += 1;
                }
                // else {
                //   _formCompleted = true;
                // }
                if (_currentStep == 3) {
                  print(_currentStep);
                  // _submitForm();
                }
              });
            },
            onStepCancel: () {
              setState(() {
                if (_currentStep > 0) {
                  _currentStep--;
                }
              });
            },
            steps: <Step>[
              //step 1 person details

              Step(
                isActive: _currentStep >= 0,
                title: const Text("Personal"),
                content: Column(
                  children: [
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a first name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a last name';
                        }
                        return null;
                      },
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
                        child: TextField(
                          controller: _dateOfBirthController,
                          decoration: const InputDecoration(
                            labelText: 'Date of Birth',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _phoneNumberController,
                      decoration:
                          const InputDecoration(labelText: 'Phone Number'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),

              //2 Church details
              Step(
                isActive: _currentStep >= 1,
                title: const Text("Church "),
                content: Column(
                  children: [
                    TextFormField(
                      controller: _auxiliaryController,
                      decoration: const InputDecoration(labelText: 'Auxiliary'),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    Row(
                      children: [
                        if (_mentorNameController.text.isEmpty) const Text(''),
                        if (_mentorNameController.text.isNotEmpty)
                          Expanded(
                            child: TextFormField(
                              enabled: false,
                              controller: _mentorNameController,
                            ),
                          ),
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
                                      _selectedItemText = snapshot.data
                                          ?.firstWhere((item) =>
                                              item['id'] ==
                                              newValue)['username'];
                                      mentorID = newValue!;
                                      _mentorNameController.text =
                                          _selectedItemText;
                                      //_selectedValue = newValue;
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
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Add as mentor'),
                        Checkbox(
                          value: _isMentor,
                          onChanged: (value) {
                            setState(() {
                              _isMentor = value!;
                            });
                          },
                        ),
                      ],
                    ),

                    // if (_mentorNameController.text.isEmpty)
                    //   const Text('Please assign a Discipler'),
                    // if (_mentorNameController.text.isNotEmpty)
                    //   TextFormField(
                    //     enabled: false,
                    //     controller: _mentorNameController,
                    //   ),

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
                    // if (_isMentor)
                    //   TextFormField(
                    //     controller: _mentorNameController,
                    //     decoration: InputDecoration(labelText: 'Mentor Name'),
                    //     validator: (value) {
                    //       if (value == null || value.isEmpty) {
                    //         return 'Please enter mentor name';
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            enabled: false,
                            readOnly: true,
                            decoration:
                                const InputDecoration(labelText: 'Baptized '),
                          ),
                        ),
                        DropdownButton<bool>(
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
                            setState(
                              () {
                                _selectedValue = value!;
                              },
                            );
                          },
                          hint: const Text("Select Status"),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              //3 Other Details
              Step(
                isActive: _currentStep >= 2,
                title: const Text("Other"),
                content: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter email';
                      //   }
                      //   return null;
                      // },
                    ),
                    TextFormField(
                      controller: _homeAddressController,
                      decoration:
                          const InputDecoration(labelText: 'Home Address'),
                    ),
                    TextFormField(
                      controller: _workController,
                      decoration: const InputDecoration(labelText: 'Work'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _submitForm();
                        },
                        child: const Text("Submit")),
                  ],
                ),
              )
            ],
          )

          //     Column(
          //   children: [
          //     TextFormField(
          //       controller: _firstNameController,
          //       decoration: InputDecoration(
          //         labelText: 'First Name',
          //       ),
          //       validator: (value) {
          //         if (value!.isEmpty) {
          //           return 'Please enter a first name';
          //         }
          //         return null;
          //       },
          //     ),
          //     TextFormField(
          //       controller: _lastNameController,
          //       decoration: InputDecoration(
          //         labelText: 'Last Name',
          //       ),
          //       validator: (value) {
          //         if (value!.isEmpty) {
          //           return 'Please enter a last name';
          //         }
          //         return null;
          //       },
          //     ),
          //     TextFormField(
          //       controller: _emailController,
          //       decoration: InputDecoration(labelText: 'Email'),
          //       validator: (value) {
          //         if (value == null || value.isEmpty) {
          //           return 'Please enter email';
          //         }
          //         return null;
          //       },
          //     ),
          //     TextFormField(
          //       controller: _phoneNumberController,
          //       decoration: InputDecoration(labelText: 'Phone Number'),
          //       validator: (value) {
          //         if (value == null || value.isEmpty) {
          //           return 'Please enter phone number';
          //         }
          //         return null;
          //       },
          //     ),
          //     Row(
          //       children: [
          //         Text('Is Mentor'),
          //         Checkbox(
          //           value: _isMentor,
          //           onChanged: (value) {
          //             setState(() {
          //               _isMentor = value!;
          //             });
          //           },
          //         ),
          //       ],
          //     ),
          //     if (_isMentor)
          //       TextFormField(
          //         controller: _mentorNameController,
          //         decoration: InputDecoration(labelText: 'Mentor Name'),
          //         validator: (value) {
          //           if (value == null || value.isEmpty) {
          //             return 'Please enter mentor name';
          //           }
          //           return null;
          //         },
          //       ),
          //     TextFormField(
          //       controller: _workController,
          //       decoration: InputDecoration(labelText: 'Work'),
          //     ),
          //     TextFormField(
          //       controller: _homeAddressController,
          //       decoration: InputDecoration(labelText: 'Home Address'),
          //     ),
          //     TextFormField(
          //       controller: _languageController,
          //       decoration: InputDecoration(labelText: 'Language'),
          //     ),
          //     TextFormField(
          //       controller: _auxiliaryController,
          //       decoration: InputDecoration(labelText: 'Auxiliary'),
          //     ),
          //     Row(
          //       children: [
          //         Text('Baptized'),
          //         Checkbox(
          //           value: _baptized,
          //           onChanged: (value) {
          //             setState(() {
          //               _baptized = value!;
          //             });
          //           },
          //         ),
          //       ],
          //     ),
          //     TextFormField(
          //       controller: _dateOfBirthController,
          //       decoration: InputDecoration(labelText: 'Date of Birth'),
          //     ),
          //     SizedBox(height: 16),
          //     ElevatedButton(
          //       onPressed: _submitForm,
          //       child: Text('Submit'),
          //     ),
          //     if (_errorMessage.isNotEmpty)
          //       Text(
          //         _errorMessage,
          //         style: TextStyle(color: Colors.red),
          //       ),
          //     if (_successMessage.isNotEmpty)
          //       Text(
          //         _successMessage,
          //         style: TextStyle(color: Colors.green),
          //       ),
          //   ],
          // ),
          ),
    );
  }
}
