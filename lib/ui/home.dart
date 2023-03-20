import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fininfocom/constant/constant.dart';
import 'package:fininfocom/operation/firebasecall.dart';
import 'package:fininfocom/ui/profile.dart';
import 'package:fininfocom/ui/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:shortid/shortid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  CollectionReference userCollection =
      AuthenticationHelper.firebaseFirestore.collection('users');

  User? user = AuthenticationHelper.auth.currentUser;
  String? email;
  String? username;
  String? svgPicture;
  String? role;
  bool _loader = false;

  final _formKey = GlobalKey<FormState>();
  UserRole? _userRole;
  bool registrationSuccess = false;
  FormValidation _formValidation = FormValidation.PENDING;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  List<String?>? userData;
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  getUserDatafromShared() async {
    userData = await SharedPref.getUserData();
    debugPrint(userData.toString());
  }

  getUserDetail() {
    userCollection.doc(user!.uid).get().then((DocumentSnapshot snapshot) {
      email = snapshot["email"];
      username = snapshot["username"];
      role = snapshot["role"];
      svgPicture = snapshot["displayImage"];
      setState(() {
        _loader = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDatafromShared();
    getUserDetail();
    setState(() {
      _loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Fin Infocom'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(userData?[1] ?? ""),
            accountName: Text(userData?[0] ?? ""),
            currentAccountPicture: SvgPicture.string(userData?[4] ?? ""),
            otherAccountsPictures: [
              Text(
                userRole(userData?[2] ?? ""),
                style: Theme.of(context).textTheme.labelSmall,
              )
            ],
          ),
          ListTile(
              title: const Text("My Profile"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                          email: userData![1]!,
                          role: userData![2]!,
                          uid: userData![3]!,
                          svgPicture: userData![4]!,
                          username: userData![0]!),
                    ));
              }),
          if (userData != null && userData![2]! == "UserRole.ADMIN")
            ListTile(
                title: const Text("Add User"),
                onTap: () {
                  addUserDialog(context);
                }),
          ListTile(
              title: const Text("Sign Out"),
              onTap: () async {
                SharedPref.clearUserData();
                AuthenticationHelper.signOut().then((value) {
                  if (value == null) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomePage(),
                        ),
                        (route) => false);
                  }
                });
              })
        ]),
      ),
      body: !_loader
          ?
          // ? FutureBuilder(
          //     future: FireStoreDataBase().getData(),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasError) {
          //         return const Text(
          //           "Something went wrong",
          //         );
          //       }
          //       if (snapshot.connectionState == ConnectionState.done) {
          //         var dataList = snapshot.data as List;
          //         return buildItems(dataList);
          //       }
          //       return const Center(child: CircularProgressIndicator());
          //     },
          //   )

          StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator.adaptive(),);
                }

                return ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return ListTile(
                          leading: SvgPicture.string(
                            data["displayImage"],
                            height: 50,
                            width: 50,
                          ),
                          title: Text(
                            data["username"],
                          ),
                          subtitle: Text(data["email"]),
                          trailing: Text(
                            userRole(data["role"]),
                          ),
                        );
                      })
                      .toList()
                      .cast(),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
    );
  }

  Future<void> addUserDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: const Text('Add user to club'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      onChanged: (value) {},
                      controller: _usernameController,
                      validator: (value) => usernameValidator(value),
                      decoration: const InputDecoration(
                          hintText: "Enter your username"),
                    ),
                    GestureDetector(
                      onTap: () {
                        _usernameController.text = shortid.generate();
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.auto_awesome),
                          Text("Auto Generate Username"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      onChanged: (value) {},
                      controller: _emailController,
                      validator: (value) => emailValidator(value),
                      decoration:
                          const InputDecoration(hintText: "Enter your email"),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      onChanged: (value) {},
                      controller: _passwordController,
                      validator: (value) => passwordValidator(value),
                      decoration:
                          const InputDecoration(hintText: "Enter password"),
                    ),
                    const SizedBox(height: 16),
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
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          onPressed: () {
                            var svgImage = RandomAvatarString(
                                generateRandomString(10),
                                trBackground: true);
                            if (_formKey.currentState!.validate() &&
                                _userRole != null) {
                              String username = _usernameController.text.trim();
                              setState(() {
                                _formValidation = FormValidation.SUCCESS;
                              });

                              AuthenticationHelper.signUp(
                                context,
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              ).then((value) async {
                                if (value == null) {
                                  await AuthenticationHelper.userDetailSetup(
                                          username,
                                          _emailController.text.trim(),
                                          _userRole,
                                          _passwordController.text.trim(),
                                          svgImage)
                                      .then((value) {
                                    AuthenticationHelper.auth.currentUser
                                        ?.updateDisplayName(username);
                                  }).then((value) {
                                    if (value == null) {
                                      if (scaffoldKey
                                          .currentState!.isDrawerOpen) {
                                        resetController();
                                        Navigator.pop(context);
                                        scaffoldKey.currentState!.closeDrawer();
                                      }
                                      snackBarMSG(context,
                                          message: 'User Added Successfully',
                                          color: Colors.green);
                                    }
                                    //TODO: Remove code block
                                    Future.delayed(const Duration(seconds: 1),
                                        () async {
                                      await AuthenticationHelper.signOut()
                                          .then((value) async {
                                        if (value == null) {
                                          await AuthenticationHelper.signIn(
                                              context,
                                              email: userData![1]!,
                                              password: userData![5]!);
                                        }
                                      });
                                    });
                                  });
                                } else {
                                  snackBarMSG(context,
                                      message:
                                          'User registration failed. Please try again.');
                                }
                              });
                            } else {
                              setState(() {
                                _formValidation = FormValidation.FAILED;
                              });
                            }
                          },
                          child: const Text("Add User")),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  resetController() {
    _usernameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _userRole = null;
  }
}

String userRole(role) {
  if (role == "UserRole.ADMIN") {
    return "Admin";
  } else {
    return "Viewer";
  }
}

Widget buildItems(dataList) => ListView.separated(
    padding: const EdgeInsets.all(8),
    itemCount: dataList.length,
    separatorBuilder: (BuildContext context, int index) => const Divider(),
    itemBuilder: (BuildContext context, int index) {
      return ListTile(
        leading: SvgPicture.string(
          dataList[index]["displayImage"],
          height: 50,
          width: 50,
        ),
        title: Text(
          dataList[index]["username"],
        ),
        subtitle: Text(dataList[index]["email"]),
        trailing: Text(
          userRole(dataList[index]["role"]),
        ),
      );
    });

class FireStoreDataBase {
  List userList = [];
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("users");

  Future getData() async {
    try {
      await collectionRef.get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          userList.add(result.data());
        }
      });

      return userList;
    } catch (e) {
      debugPrint("Error - $e");
      return e;
    }
  }
}
