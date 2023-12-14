import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trading/utils/base.dart';
import 'package:trading/utils/clinet_http.dart';
import 'package:trading/utils/sessions.dart';
import 'package:http/http.dart' as http;

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  TextEditingController _password = TextEditingController();
  TextEditingController _passwordConfirm = TextEditingController();

  Future<void> updatePassword() async {
    var user = jsonDecode((await Sessions.get())!)['user'];

    var response = await ClientHTTP().getClitentHTTP().post(
      Uri.parse('${BaseTrading().API}auth/update-password'),
      headers: {"Authorization": "Bearer ${await Sessions.jwtToken()}"},
      body: {
        "user_id": user['id'].toString(),
        "password": _password.text,
        "password_confirm": _passwordConfirm.text
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _password.text = '';
        _passwordConfirm.text = '';
      });

      print("UPDATE PROFILE : ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Password"),
        backgroundColor: Color.fromRGBO(34, 34, 34, 1),
        elevation: 0.0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color.fromRGBO(34, 34, 34, 1),
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(color: Colors.blueGrey),
                controller: _password,
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
              SizedBox(height: 20),
              TextFormField(
                style: TextStyle(color: Colors.blueGrey),
                controller: _passwordConfirm,
                decoration: const InputDecoration(
                  labelText: 'Password Confirmation',
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
                  updatePassword();
                },
                child: const Text("Update"),
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
      ),
    );
  }
}
