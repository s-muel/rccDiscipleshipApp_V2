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
          work: _workController.text,
          homeAddress: _homeAddressController.text,
          language: _languageController.text,
          auxiliary: _auxiliaryController.text,
          dateOfBirth: _dateOfBirthController.text,
          baptized: _baptized,
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
                // if (_formKey.currentState!.validate()) {
                //   if (_currentStep < 2) {
                //     _currentStep += 1;
                //   } else {
                //      _formCompleted = true;
                //   }
                // }
                print(_currentStep);
                if (_currentStep < 2) {
                  _currentStep += 1;
                } else {
                  _formCompleted = true;
                }
                if (_currentStep == 2) {
                  _submitForm();
                  
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
            steps: [
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
                    if (_isMentor)
                      TextFormField(
                        controller: _mentorNameController,
                        decoration: InputDecoration(labelText: 'Mentor Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter mentor name';
                          }
                          return null;
                        },
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _dateOfBirthController,
                            decoration:
                                const InputDecoration(labelText: 'Baptized '),
                          ),
                        ),
                        const Expanded(
                          child: TextField(
                            enabled: false,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
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
