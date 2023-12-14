import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trading/main.dart';
import 'package:trading/utils/base.dart';
import 'package:trading/utils/clinet_http.dart';
import 'package:trading/utils/sessions.dart';
import 'package:trading/verify_identity.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  Future<void> login(BuildContext context) async {
    var response = await ClientHTTP().getClitentHTTP().post(
      Uri.parse('${BaseTrading().API}auth/login'),
      body: {
        "email": _email.text,
        "password": _password.text,
      },
    );

    if (response.statusCode == 200) {
      Sessions.save(response.body);
      if (jsonDecode(response.body)['user']['status'] == '0') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const VerifyIdentityPage(),
          ),
          (route) => false,
        );
      } else if (jsonDecode(response.body)['user']['status'] == '1') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
          (route) => false,
        );
      }
      print("LOGIN: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 60,
        horizontal: 35,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            TextFormField(
              controller: _email,
              style: TextStyle(color: Colors.blueGrey),
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'user@example.com',
                labelStyle: TextStyle(color: Colors.blueGrey),
                hintStyle: TextStyle(color: Colors.blueGrey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blueGrey,
                  ), // Warna border saat aktif
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ), // Warna border saat non-aktif
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _password,
              style: TextStyle(color: Colors.blueGrey),
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'user123',
                labelStyle: TextStyle(color: Colors.blueGrey),
                hintStyle: TextStyle(color: Colors.blueGrey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blueGrey,
                  ), // Warna border saat aktif
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ), // Warna border saat non-aktif
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                login(context);
              },
              child: const Text("Login"),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(
                  MediaQuery.of(context).size.width,
                  55,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
