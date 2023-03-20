import 'package:fininfocom/ui/register.dart';
import 'package:fininfocom/ui/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constant/assets.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _isRegister = true;
  
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Asset.welcome,
            height: screenSize.height * 0.45,
          ),
          Text(
            "Infocom Team Collaboration",
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Feeling bored? Let's change that! Come, let's chit-chat and have some fun. Trust me, it'll be worth it. Let's make some memories and enjoy the moment!",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color.fromARGB(255, 242, 242, 242),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                regbutton(
                    label: "Register",
                    color: _isRegister ? Theme.of(context).primaryColor : null,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(12),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                      setState(() {
                        _isRegister = true;
                      });
                    }),
                regbutton(
                    label: "Sign In",
                    color: !_isRegister ? Theme.of(context).primaryColor : null,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(4),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(4)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                      setState(() {
                        _isRegister = false;
                      });
                    }),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    ));
  }

  Expanded regbutton(
      {required String label,
      required Color? color,
      required BorderRadiusGeometry borderRadius,
      required Function() onPressed}) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(color: color, borderRadius: borderRadius),
        child: TextButton(
          style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                  (states) => Colors.transparent)),
          onPressed: onPressed,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ),
    );
  }
}
