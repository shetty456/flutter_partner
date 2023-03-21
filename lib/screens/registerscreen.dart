import 'package:customer/screens/loginscreen.dart';
import 'package:customer/screens/tabsscreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/http_exception.dart';
import '../providers/auth.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = '/register';
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final Map<String, String> _regData = {
    "firstname": '',
    "lastname": '',
    "email": '',
    'phonenumber': '',
    'password': '',
  };

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
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _regData["firstname"] = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This Field is Required';
                          } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                            return 'Enter a valid name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _regData["lastname"] = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This Field is Required';
                          } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                            return 'Enter a valid name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _regData["email"] = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This Field is Required';
                          } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _regData["phonenumber"] = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This Field is Required';
                          } else if (!RegExp(
                                  r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
                              .hasMatch(value)) {
                            return 'Enter a valid Phone Number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _regData["password"] = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This Field is Required';
                          }
                          return null;
                        },
                      ),
                      // const SizedBox(
                      //   height: 16.0,
                      // ),
                      // TextFormField(
                      //   keyboardType: TextInputType.visiblePassword,
                      //   decoration: const InputDecoration(
                      //     labelText: 'Confirm Password',
                      //     border: OutlineInputBorder(),
                      //   ),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'This Field is Required';
                      //     }
                      //     return null;
                      //   },
                      // ),
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
                            setState(() {
                              _isLoading = true;
                            });
                            _formKey.currentState!.save();
                            try {
                              await Provider.of<Auth>(context, listen: false)
                                  .register(
                                _regData['firstname'] as String,
                                _regData['lastname'] as String,
                                _regData['phonenumber'] as String,
                                _regData['email'] as String,
                                _regData['password'] as String,
                              );
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
                              _showSnackBar('Sorry, Couldn\'t Register');
                              if (kDebugMode) {
                                print(error);
                              }
                            }
                          },
                          child: const Text("Register"),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(LoginScreen.routeName);
                          },
                          child: const Text('Already Registered? Login Here.'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
