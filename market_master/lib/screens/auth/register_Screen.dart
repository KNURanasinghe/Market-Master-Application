import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_master/component/text%20components/custom_textfield_form.dart';
import 'package:market_master/component/text%20components/form_field_headers.dart';
import 'package:market_master/controller/providers/auth_provider.dart';
import 'package:market_master/screens/auth/login_Screen.dart';
import 'package:provider/provider.dart';

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

  /// Farmer controllers
  final _homeAddressController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _nicNoController = TextEditingController();

  /// Seller controllers
  final _shopNameController = TextEditingController();
  final _shopAddressController = TextEditingController();
  final _shopRegNoController = TextEditingController();
  String? _selectedGoodsType;

  bool _isFarmer = false;
  bool _isSeller = false;
  bool _isTerms = false;
  XFile? _nicImageFile;
  XFile? _brImageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source, String type) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (type == 'NIC') {
        _nicImageFile = pickedFile;
      } else if (type == 'BR') {
        _brImageFile = pickedFile;
      }
    });
  }

  void _submit() async {
    List<String> roles = ['common'];
    if (_isFarmer) roles.add('farmer');
    if (_isSeller) roles.add('seller');

    Map<String, dynamic> userData = {
      'name': _nameController.text, // Assuming username is same as name
      'email': _emailController.text,
      'password': _passwordController.text,
      'roles': roles,
      'additionalData': {}
    };

    if (_isFarmer) {
      userData['additionalData'].addAll({
        'homeAddress': _homeAddressController.text,
        'contactNumber': _contactNumberController.text,
        'nicNo': _nicNoController.text,
        'nicImage': _nicImageFile?.path,
      });
    }

    if (_isSeller) {
      userData['additionalData'].addAll({
        'shopName': _shopNameController.text,
        'shopAddress': _shopAddressController.text,
        'shopRegNo': _shopRegNoController.text,
        'typeOfGoods': _selectedGoodsType,
        'brImage': _brImageFile?.path,
      });
    }

    final responseData = await Provider.of<AuthProvider>(context, listen: false)
        .signup(userData);

    if (responseData['success'] == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: Text(responseData['message']),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
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
                    fit: BoxFit.cover,
                  ),
                  color: const Color(0xFFB6FAA6).withOpacity(0.53),
                ),
                child: Column(
                  children: [
                    const Image(
                        image: AssetImage('lib/assets/loginvector.png')),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF008E06).withOpacity(0.09),
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
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
                                  const SizedBox(height: 10),
                                  CustomTextFeildsForm(
                                    controller: _emailController,
                                    labelText: 'Email',
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
                                  ),
                                  const SizedBox(height: 10),
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
                                  const SizedBox(height: 10),

                                  /// Farmer information
                                  FormFiledHeaders(
                                    widget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Checkbox(
                                          value: _isFarmer,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _isFarmer = value ?? false;
                                              if (!_isFarmer) {
                                                _nicImageFile = null;
                                              }
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          'Farmer Information',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: _isFarmer,
                                    child: Column(
                                      children: [
                                        CustomTextFeildsForm(
                                          controller: _homeAddressController,
                                          labelText: 'Home Address',
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your home address';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextFeildsForm(
                                          controller: _contactNumberController,
                                          labelText: 'Contact Number',
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your contact number';
                                            }
                                            if (!RegExp(r'^\d+$')
                                                .hasMatch(value)) {
                                              return 'Please enter a valid contact number';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextFeildsForm(
                                          controller: _nicNoController,
                                          labelText: 'NIC No',
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your NIC No';
                                            }
                                            return null;
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () => _pickImage(
                                                ImageSource.gallery, 'NIC'),
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                    Icons.cloud_upload_rounded),
                                                SizedBox(width: 10),
                                                Text('Upload NIC Image')
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (_nicImageFile != null)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8.0,
                                            ),
                                            child: Image.file(
                                                File(_nicImageFile!.path)),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  /// Seller information
                                  FormFiledHeaders(
                                    widget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Checkbox(
                                          value: _isSeller,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _isSeller = value ?? false;
                                              if (!_isSeller) {
                                                _brImageFile = null;
                                              }
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        const SizedBox(width: 10),
                                        const Text(
                                          'Seller Information',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: _isSeller,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        CustomTextFeildsForm(
                                          controller: _shopNameController,
                                          labelText: 'Shop Name',
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your shop name';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextFeildsForm(
                                          controller: _shopAddressController,
                                          labelText: 'Shop Address',
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your shop address';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        CustomTextFeildsForm(
                                          controller: _shopRegNoController,
                                          labelText: 'Shop Registration No',
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your shop registration number';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(
                                                      0x6699F69D), // 40% opacity
                                                  Color(
                                                      0xFF3DBD42), // No opacity
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child:
                                                DropdownButtonFormField<String>(
                                              decoration: InputDecoration(
                                                labelText: 'Type of Goods',
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                              ),
                                              value: _selectedGoodsType,
                                              items: [
                                                'All',
                                                'Fruits',
                                                'Vegetables'
                                              ]
                                                  .map((label) =>
                                                      DropdownMenuItem(
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
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please select the type of goods';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () => _pickImage(
                                                ImageSource.gallery, 'BR'),
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                    Icons.cloud_upload_rounded),
                                                SizedBox(width: 10),
                                                Text('Upload BR Image')
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (_brImageFile != null)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8.0,
                                            ),
                                            child: Image.file(
                                                File(_brImageFile!.path)),
                                          ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 10),
                                  FormFiledHeaders(
                                    widget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Checkbox(
                                          value: _isTerms,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _isTerms = value ?? false;
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: _showTermsAndConditions,
                                          child: const Text(
                                            'I agree to terms and conditions',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
