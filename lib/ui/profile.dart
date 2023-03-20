import 'dart:async';

import 'package:fininfocom/constant/constant.dart';
import 'package:fininfocom/operation/firebasecall.dart';
import 'package:fininfocom/ui/home.dart';
import 'package:fininfocom/ui/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {super.key,
      required this.username,
      required this.email,
      required this.svgPicture,
      required this.role,
      required this.uid});
  final String username;
  final String email;
  final String svgPicture;
  final String role;
  final String uid;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  List<String?>? userData;

  getUserDatafromShared() async {
    userData = await SharedPref.getUserData();
  }

  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    _currentPassword.clear();
    _newPassword.clear();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    getUserDatafromShared();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fin Infocom'),
        centerTitle: true,
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.string(
                          widget.svgPicture,
                          height: 80,
                          width: 80,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              widget.username,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              widget.email,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              userRole(widget.role),
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          ],
                        )
                      ],
                    ),
                  ]),
            ),
          ),
        ),
        if (mounted)
          !_isLoading
              ? SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () {
                        displayTextInputDialog(context);
                      },
                      child: const Text("Change Password")),
                )
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
      ]),
    );
  }

  Future<void> displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: const Text('Change Password'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      onChanged: (value) {},
                      controller: _currentPassword,
                      decoration:
                          const InputDecoration(hintText: "Current Password"),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      onChanged: (value) {},
                      controller: _newPassword,
                      validator: (value) => passwordValidator(value),
                      decoration:
                          const InputDecoration(hintText: "New Password"),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              AuthenticationHelper.changePassword(
                                      context,
                                      userData,
                                      _currentPassword.text.trim(),
                                      _newPassword.text.trim())
                                  .then((value) async {
                                if (value == true) {
                                  snackBarMSG(context,
                                      message: 'Password Changed Successfully',
                                      color: Colors.green);
                                  AuthenticationHelper.signOut().then((value) {
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const WelcomePage(),), (route) => false);
                                    if(value==null){}else{
                                      Navigator.pop(context);
                                    }
                                  });
                                }
                              });
                            }
                            setState(() {
                              _isLoading = false;
                              resetController();
                            });
                          },
                          child: const Text("Update")),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  resetController() {
    _currentPassword.clear();
    _newPassword.clear();
  }
}
