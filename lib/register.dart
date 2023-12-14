import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trading/utils/base.dart';
import 'package:trading/utils/clinet_http.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _accountBank = TextEditingController();
  TextEditingController _accountName = TextEditingController();
  TextEditingController _accountNumber = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _passwordConfirm = TextEditingController();

  Future<void> register() async {
    var response = await ClientHTTP().getClitentHTTP().post(
      Uri.parse('${BaseTrading().API}auth/register'),
      body: {
        "username": _username.text,
        "email": _email.text,
        "phone": _phone.text,
        "account_name": _accountName.text,
        "account_bank": _accountBank.text,
        "account_number": _accountNumber.text,
        "password": _password.text,
        "password_confirmation": _passwordConfirm.text
      },
    );

    if (response.statusCode == 201) {
      _username.text = '';
      _email.text = '';
      _phone.text = '';
      _accountBank.text = '';
      _accountName.text = '';
      _accountNumber.text = '';
      _password.text = '';
      _passwordConfirm.text = '';
    print("REGiSTER : ${response.body}");
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
              controller: _username,
              style: TextStyle(color: Colors.blueGrey),
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
              controller: _phone,
              style: TextStyle(color: Colors.blueGrey),
              decoration: const InputDecoration(
                labelText: 'Phone',
                hintText: '085xxxxxxxxxx',
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
              controller: _accountBank,
              style: TextStyle(color: Colors.blueGrey),
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
              controller: _accountName,
              style: TextStyle(color: Colors.blueGrey),
              decoration: const InputDecoration(
                labelText: 'Account Name',
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
              controller: _accountNumber,
              style: TextStyle(color: Colors.blueGrey),
              decoration: const InputDecoration(
                labelText: 'Account Number',
                hintText: '123456789',
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
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordConfirm,
              style: TextStyle(color: Colors.blueGrey),
              decoration: const InputDecoration(
                labelText: 'Password Confirm',
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
            SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (value) {},
                ),
                const Expanded(
                  child: const Text(
                    "I accept the terms of the Client Agreement and Privacy Police",
                    style: TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                register();
              },
              child: const Text("Register"),
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
