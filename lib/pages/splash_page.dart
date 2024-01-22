import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodpilot_app/authentication/auth_page.dart';
import 'package:foodpilot_app/global/global.dart';
import 'package:foodpilot_app/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  startTimer() async {
    await Future.delayed(Duration(seconds: 8));

    // cheking the rider sign up or not
    if (firebaseAuth.currentUser != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const AuthPage()));
    }
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red,
      body: Container(
        color: const Color.fromARGB(255, 230, 108, 99),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset(
                    'assets/images/d47baf73869221.5c1845a4b8823.jpg'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  'Transfer safe food',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: "Signatra",
                    letterSpacing: 3,
                  ),
                ),
              ),
              const Text(
                "Tasty Bite",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: "Train",
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
