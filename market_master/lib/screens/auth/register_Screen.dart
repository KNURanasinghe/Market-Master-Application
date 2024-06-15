import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_master/component/text%20components/custom_textfield_form.dart';
import 'package:market_master/component/text%20components/form_field_headers.dart';
import 'package:market_master/screens/auth/login_Screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  ///farmer controllers
  final _homeAddressController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _nicNoController = TextEditingController();
  bool _isFarmer = false;

  // Seller Information
  final _shopNameController = TextEditingController();
  final _shopAddressController = TextEditingController();
  final _shopRegNoController = TextEditingController();
  String? _selectedGoodsType;
  bool _isSeller = false;
  XFile? _imageFile;

  bool _isTerms = false;

  // Image Picker
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  void _submit() {
    // if (_formKey.currentState!.validate()) {
    //   // If the form is valid, display a snackbar with the input data
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(
    //           'Name: ${_nameController.text}, Email: ${_emailController.text}, Form Submitted'),
    //     ),
    //   );
    //   // Here you can handle the submission (e.g., send the data to your backend)
    // }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms and Conditions'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('1. You must agree to all terms and conditions.'),
                Text('2. You must provide accurate information.'),
                Text('3. You must comply with all applicable laws.'),
                // Add more terms and conditions here.
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Disagree'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Agree'),
              onPressed: () {
                setState(() {
                  _isTerms = true;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('lib/assets/logback.png'),
                      fit: BoxFit.cover),
                  color: const Color(0xFFB6FAA6).withOpacity(0.53),
                ),
                child: Column(
                  children: [
                    const Image(
                        image: AssetImage('lib/assets/loginvector.png')),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: const Color(0xFF008E06).withOpacity(0.09),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: <Widget>[
                            FormFiledHeaders(
                              widget: const Center(
                                  child: Text(
                                "General information",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextFeildsForm(
                              controller: _nameController,
                              labelText: 'Name',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextFeildsForm(
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                // Basic email validation
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              labelText: 'Email',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextFeildsForm(
                              controller: _passwordController,
                              labelText: 'Password',
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            ///farmer details start from here
                            FormFiledHeaders(
                              widget: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Checkbox(
                                    value: _isFarmer,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isFarmer = value ?? false;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  const Center(
                                    child: Text(
                                      'Farmer Information',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Visibility(
                              visible: _isFarmer,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextFeildsForm(
                                      labelText: 'Home Address',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your home address';
                                        }
                                        return null;
                                      },
                                      controller: _homeAddressController,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextFeildsForm(
                                      labelText: 'Contact Number',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your contact number';
                                        }
                                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                                          return 'Please enter a valid contact number';
                                        }
                                        return null;
                                      },
                                      controller: _contactNumberController,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextFeildsForm(
                                      labelText: 'NIC No',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your NIC No';
                                        }
                                        return null;
                                      },
                                      controller: _nicNoController,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: ElevatedButton(
                                        onPressed: _pickImage,
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.cloud_upload_rounded),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Upload NIC Image'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (_imageFile != null)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                        ),
                                        child:
                                            Image.file(File(_imageFile!.path)),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            ///seller details start from here
                            FormFiledHeaders(
                              widget: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Checkbox(
                                    value: _isSeller,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isSeller = value ?? false;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  const Center(
                                    child: Text(
                                      'Seller Information',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Visibility(
                              visible: _isSeller,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomTextFeildsForm(
                                    labelText: 'Shop Name',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your shop name';
                                      }
                                      return null;
                                    },
                                    controller: _shopNameController,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomTextFeildsForm(
                                    labelText: 'Shop Address',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your shop address';
                                      }
                                      return null;
                                    },
                                    controller: _shopAddressController,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomTextFeildsForm(
                                    labelText: 'Shop Registration No',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your shop registration number';
                                      }
                                      return null;
                                    },
                                    controller: _shopRegNoController,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color(0x6699F69D), // 40% opacity
                                            Color(0xFF3DBD42), // No opacity
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          labelText: 'Type of Goods',
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                        ),
                                        value: _selectedGoodsType,
                                        items: ['All', 'Fruits', 'Vegetables']
                                            .map((label) => DropdownMenuItem(
                                                  value: label,
                                                  child: Text(label),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedGoodsType = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select the type of goods';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ElevatedButton(
                                      onPressed: _pickImage,
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.cloud_upload_rounded),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('BR NOC Image'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (_imageFile != null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Image.file(File(_imageFile!.path)),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: FormFiledHeaders(
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Checkbox(
                              value: _isTerms,
                              onChanged: (bool? value) {
                                if (value == false) {
                                  setState(() {
                                    _isTerms = false;
                                  });
                                } else {
                                  _showTermsAndConditions();
                                }
                              },
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Center(
                              child: Text(
                                'Agree to terms and conditions',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: _isTerms ? _submit : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isTerms
                              ? const Color(0xFF3DBD42)
                              : Colors.grey.shade400,
                        ),
                        child: Text(
                          'Sign In',
                          style: TextStyle(color: Colors.grey.shade200),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              " Sign In",
                              style: TextStyle(
                                  color: Color(0xFF736E6E),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
