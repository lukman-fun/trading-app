import 'package:flutter/material.dart';
import 'package:trading/login.dart';
import 'package:trading/register.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(34, 34, 34, 1),
      body: SafeArea(
        child: Container(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: const [
                TabBar(
                  labelColor: Colors.blueGrey,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blueGrey,
                  tabs: [
                    Tab(text: 'Register'),
                    Tab(text: 'Login'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      RegisterPage(),
                      LoginPage()
                    ],
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
