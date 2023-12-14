import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trading/auth.dart';
import 'package:trading/history.dart';
import 'package:trading/login.dart';
import 'package:trading/market.dart';
import 'package:trading/profile.dart';
import 'package:trading/tes.dart';
import 'package:trading/testing.dart';
import 'package:trading/transaction.dart';
import 'package:trading/utils/sessions.dart';
import 'package:trading/verify_identity.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: Sessions.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot != null) {
            if (jsonDecode(snapshot.data!)['user']['status'] == '0') {
              return const VerifyIdentityPage();
            } else {
              return const MainPage();
            }
          }
          return const AuthPage();
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var currentIndex = 0;
  List<Widget> pages = [
    // const MarketPage(),
    // const MyCandle(),
    // const MyTrading(),
    const Tester(),
    const HistoryPage(),
    const TransactionPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(34, 34, 34, 1),
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 28,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_rounded),
            label: 'Finance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
