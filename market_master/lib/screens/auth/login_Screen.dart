import 'package:flutter/material.dart';
import 'package:market_master/component/bottom_nav_bar.dart';
import 'package:market_master/component/text%20components/custom_textfield_form.dart';
import 'package:market_master/component/text%20components/form_field_headers.dart';
import 'package:market_master/controller/providers/auth_provider.dart';
import 'package:market_master/screens/auth/register_Screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    Map<String, dynamic> userData = {
      // Assuming username is same as name
      'email': _emailController.text,
      'password': _passwordController.text,
    };
    try {
      print(userData);
      final responseData =
          await Provider.of<AuthProvider>(context, listen: false)
              .login(userData);
      print(responseData['message']);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()));

      // Navigate to your main screen or dashboard
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: Text(error.toString()),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
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
                      height: 80,
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
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ),
                            const SizedBox(
                              height: 10,
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
                            Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {}, //forgot password page
                                  child: const Text(
                                    "Fogot password?",
                                    style: TextStyle(
                                        fontSize: 18,
                                        decoration: TextDecoration.underline),
                                  ),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3DBD42)),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don’t you have account?",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      " Sign Up",
                                      style: TextStyle(
                                          color: Color(0xFF736E6E),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
