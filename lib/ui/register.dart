import 'dart:async';

import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:shortid/shortid.dart';
import '../constant/constant.dart';
import '../operation/firebasecall.dart';
import 'home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isVisible = false;
  UserRole? _userRole;
  bool registrationSuccess = false;
  bool _isLoading = false;
  FormValidation _formValidation = FormValidation.PENDING;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color.fromARGB(255, 199, 199, 199)),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color.fromARGB(255, 58, 57, 57),
                    )),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Get into the club",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Email"),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text("Password"),
                      TextFormField(
                        obscureText: _isVisible ? false : true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isVisible = !_isVisible;
                                  });
                                },
                                icon: Icon(_isVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          } else if (!RegExp(
                                  r'^(?=.*[A-Z])(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                              .hasMatch(value)) {
                            return 'Password must must contain at least 1 capital ,1 symbol, minimum 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text("Role"),
                      Row(
                        children: [
                          Radio(
                              value: UserRole.ADMIN,
                              groupValue: _userRole,
                              fillColor: MaterialStateProperty.resolveWith(
                                  (states) =>
                                      _formValidation == FormValidation.FAILED
                                          ? Colors.red
                                          : null),
                              onChanged: (value) {
                                setState(() {
                                  _userRole = value;
                                });
                              }),
                          const Text('Admin'),
                          const SizedBox(width: 32),
                          Radio(
                            value: UserRole.VIEWER,
                            groupValue: _userRole,
                            fillColor: MaterialStateProperty.resolveWith(
                                (states) =>
                                    _formValidation == FormValidation.FAILED
                                        ? Colors.red
                                        : null),
                            onChanged: (value) {
                              setState(() {
                                _userRole = value;
                              });
                            },
                          ),
                          const Text('Viewer'),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      !_isLoading
                          ? SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    var svgImage = RandomAvatarString(
                                        generateRandomString(10),
                                        trBackground: true);
                                    String username = shortid.generate();

                                    debugPrint("Userrole $_userRole");

                                    if (_formKey.currentState!.validate() &&
                                        _userRole != null) {
                                      setState(() {
                                        _formValidation =
                                            FormValidation.SUCCESS;
                                        _isLoading = true;
                                      });

                                      registerUser(
                                          context: context,
                                          email: _emailController.text
                                              .trim()
                                              .toLowerCase(),
                                          password:
                                              _passwordController.text.trim(),
                                          username: username,
                                          image: svgImage,
                                          role: _userRole.toString()).then((value) {
                                            setState(() {
                                              _isLoading =false;
                                            });
                                      });

                                    } else {
                                      setState(() {
                                        _formValidation = FormValidation.FAILED;
                                      });
                                    }
                                  },
                                  child: const Text("Register")),
                            )
                          : const Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> registerUser({
  required BuildContext context,
  required String email,
  required String password,
  required String username,
  required String role,
  required String image,
}) async {
  await AuthenticationHelper.signUp(
    context,
    email: email,
    password: password,
  ).then((value) async {

    if (value == null) {
      AuthenticationHelper.userDetailSetup(
              username, email, role, password, image)
          .then((value) {
        AuthenticationHelper.auth.currentUser?.updateDisplayName(username);
      });

      snackBarMSG(context, message: 'Login Success', color: Colors.green);

      await SharedPref.setUserdata(
              username,
              email,
              role,
              AuthenticationHelper.auth.currentUser!.uid.toString(),
              image,
              password)
          .then((value) {
        if (value == true) {
          Timer(const Duration(seconds: 1), () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
                (route) => false);
          });
          return true;
        } else {
          snackBarMSG(context, message: 'Failed to save data locally');
        }
      });
    } else {
      snackBarMSG(context, message: 'Login failed. Please try again.');
    }
  });
  return false;
}
