import 'package:flutter/material.dart';
import 'package:foodpilot_app/authentication/Login_page.dart';
import 'package:foodpilot_app/authentication/signup_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.orange,
                      Colors.red,
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.grey[600],
            title: const Text(
              'Food Pilot',
              style: TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  fontFamily: "Signatra",
                  letterSpacing: 4),
            ),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  text: "Login",
                ),
                Tab(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  text: "Register",
                ),
              ],
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.white38,
              indicatorWeight: 6,
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.topLeft,
                colors: [
                  Colors.red,
                  Colors.orange,
                ],
              ),
            ),
            child: TabBarView(
              children: [
                LoginPage(),
                SignUpPage(),
              ],
            ),
          ),
        ));
  }
}
