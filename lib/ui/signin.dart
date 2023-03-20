import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fininfocom/ui/home.dart';
import 'package:flutter/material.dart';
import '../constant/constant.dart';
import '../operation/firebasecall.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isVisible = false;
  bool _isLoading = false;
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
                "Sign-in to club",
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
                        obscureText: _isVisible ? true : false,
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
                      !_isLoading
                          ? SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate())  {
                                setState(() {
                                  _isLoading = true;
                                });
                              await  AuthenticationHelper.signIn(context,
                                    email:
                                    _emailController.text.trim(),
                                    password: _passwordController.text
                                        .trim())
                                    .then((value) async {
                                  if (value == null) {
                                    snackBarMSG(context,
                                        message: 'Login Success',
                                        color: Colors.green);
                                    String uid = AuthenticationHelper
                                        .auth.currentUser!.uid
                                        .toString();

                                    await AuthenticationHelper
                                        .firebaseFirestore.collection("users")
                                        .doc(uid)
                                        .get()
                                        .then(
                                            (DocumentSnapshot snapshot) {
                                          SharedPref.setUserdata(
                                              snapshot["username"],
                                              snapshot["email"],
                                              snapshot["role"],
                                              uid,
                                              snapshot["displayImage"],
                                              snapshot["password"]);
                                        }).then((value) {

                                       Navigator.pushAndRemoveUntil(
                                           context,
                                           MaterialPageRoute(
                                             builder: (context) =>
                                             const HomePage(),
                                           ),
                                               (route) => false);

                                    });
                                  } else {
                                    snackBarMSG(context,
                                        message:
                                        'Login failed. Please try again.');
                                  }
                                });
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            },
                            child: const Text("Login")),
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
