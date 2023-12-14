import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trading/utils/base.dart';
import 'package:trading/utils/clinet_http.dart';
import 'package:trading/utils/sessions.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _accountName = TextEditingController();
  TextEditingController _accountBank = TextEditingController();
  TextEditingController _accountNumber = TextEditingController();

  Future<void> getUser() async {
    var response = await ClientHTTP().getClitentHTTP().post(
      Uri.parse('${BaseTrading().API}auth/me'),
      headers: {"Authorization": "Bearer ${await Sessions.jwtToken()}"},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      setState(() {
        _username.text = data['username'];
        _email.text = data['email'];
        _phone.text = data['phone'];
        _accountName.text = data['account_name'];
        _accountBank.text = data['account_bank'];
        _accountNumber.text = data['account_number'];
      });
      print("USER : ${response.body}");
    }
  }

  Future<void> updateProfile() async {
    var user = jsonDecode((await Sessions.get())!)['user'];

    var response = await ClientHTTP().getClitentHTTP().post(
      Uri.parse('${BaseTrading().API}api/auth/update-profile'),
      headers: {"Authorization": "Bearer ${await Sessions.jwtToken()}"},
      body: {
        "user_id": user['id'].toString(),
        "username": _username.text,
        "email": _email.text,
        "phone": _phone.text,
        "account_name": _accountName.text,
        "account_number": _accountNumber.text,
        "account_bank": _accountBank.text
      },
    );

    if (response.statusCode == 200) {
      getUser();
      print("UPDATE PROFILE : ${response.body}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
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
                controller: _username,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'user',
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
                controller: _email,
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
                style: TextStyle(color: Colors.blueGrey),
                controller: _phone,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  hintText: '085xxxxxxxxx',
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
                controller: _accountBank,
                decoration: const InputDecoration(
                  labelText: 'Account Bank',
                  hintText: 'BRI',
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
                controller: _accountName,
                decoration: const InputDecoration(
                  labelText: 'Account Name',
                  hintText: 'User',
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
                controller: _accountNumber,
                decoration: const InputDecoration(
                  labelText: 'Account Number',
                  hintText: '1234xxxxx',
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
                  updateProfile();
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
