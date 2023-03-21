import 'package:customer/screens/registerscreen.dart';
import 'package:customer/screens/tabsscreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../providers/auth.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  bool _isLoading = false;
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 2.0,
      //   title: const Text("Mignon Partner"),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/icon/icon.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          email = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This Field is Required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        onSaved: (value) {
                          password = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This Field is Required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      SizedBox(
                        height: 40.0,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            _formKey.currentState!.save();
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await Provider.of<Auth>(context, listen: false)
                                  .login(email, password);
                              if (!mounted) return;
                              Navigator.of(context)
                                  .pushReplacementNamed(TabsScreen.routeName);
                            } on HttpException catch (error) {
                              var errorMessage = 'Authentication failed';
                              if (error.toString().contains('EMAIL_EXISTS')) {
                                errorMessage =
                                    'This email address is already in use.';
                              }
                              _showSnackBar(errorMessage);
                            } catch (error) {
                              setState(() {
                                _isLoading = false;
                              });
                              _showSnackBar('Invalid Credentials');
                              if (kDebugMode) {
                                print(error);
                              }
                            }
                          },
                          child: const Text("Login"),
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      SizedBox(
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                                RegistrationScreen.routeName);
                          },
                          child: const Text('Not Registered? Register Here.'),
                        ),
                      ),
                      // const Divider(
                      //   thickness: 1.5,
                      // ),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.of(context)
                      //         .pushNamed(RegistrationScreen.routeName);
                      //   },
                      //   child: const Center(
                      //     child: Text(
                      //       'Registration Screen',
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
