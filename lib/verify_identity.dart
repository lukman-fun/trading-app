import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trading/auth.dart';
import 'package:http/http.dart' as http;
import 'package:trading/main.dart';
import 'package:trading/utils/base.dart';
import 'package:trading/utils/clinet_http.dart';
import 'package:trading/utils/sessions.dart';

class VerifyIdentityPage extends StatefulWidget {
  const VerifyIdentityPage({super.key});

  @override
  State<VerifyIdentityPage> createState() => _VerifyIdentityPageState();
}

class _VerifyIdentityPageState extends State<VerifyIdentityPage> {
  TextEditingController _nik = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _birthPlace = TextEditingController();
  TextEditingController _birthDate = TextEditingController();

  File? file = null;
  final ImagePicker imagePicker = ImagePicker();
  Future<void> getImage() async {
    var img = await imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      file = File(img!.path);
    });
    print("GAMBAR : ${img!.path}");
  }

  Future<String> uploadImage() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${BaseTrading().API}image/upload'));
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        file!.readAsBytesSync(),
        filename: 'images.png',
      ),
    );
    request.headers.addAll({
      "Authorization": "Bearer ${await Sessions.jwtToken()}",
      "Content-type": "multipart/form-data"
    });

    var response = await request.send();
    var responseBody = (await http.Response.fromStream(response)).body;
    return jsonDecode(responseBody)['data']['id'].toString();
  }

  Future<void> uploadIdentity() async {
    var imageID = await uploadImage();

    var users = jsonDecode((await Sessions.get())!)['user'];

    var response = await ClientHTTP().getClitentHTTP().post(
      Uri.parse('${BaseTrading().API}identity/upload'),
      headers: {"Authorization": "Bearer ${await Sessions.jwtToken()}"},
      body: {
        "user_id": users['id'].toString(),
        "nik": _nik.text,
        "name": _name.text,
        "address": _address.text,
        "image_id": imageID,
        "birth_place": _birthPlace.text,
        "birth_date": _birthDate.text
      },
    );

    if (response.statusCode == 201) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthPage(),
        ),
        (route) => false,
      );
      Sessions.logout();
    }
    print("IDENTITY : ${response.body}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Identity"),
        backgroundColor: Color.fromRGBO(34, 34, 34, 1),
        centerTitle: true,
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
                controller: _nik,
                decoration: const InputDecoration(
                  labelText: 'NIK (16 Digit)',
                  hintText: '552xxxxxxxxxxxx',
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
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Name',
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
                controller: _address,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  hintText: 'Jl.xxx',
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
                controller: _birthPlace,
                decoration: const InputDecoration(
                  labelText: 'Birth Place',
                  hintText: 'Kota',
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
                controller: _birthDate,
                decoration: const InputDecoration(
                  labelText: 'Birth Date',
                  hintText: 'YYYY-mm-dd',
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
              GestureDetector(
                onTap: () {
                  getImage();
                },
                child: Container(
                  width: 300,
                  height: 150,
                  color: Colors.grey,
                  child: file != null
                      ? Image.file(
                          file!,
                          width: 300,
                          height: 400,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Icon(
                            Icons.image,
                            size: 100,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  uploadIdentity();
                },
                child: const Text("Proses"),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(
                    MediaQuery.of(context).size.width,
                    55,
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Sessions.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthPage(),
                    ),
                    (route) => false,
                  );
                },
                child: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(
                    MediaQuery.of(context).size.width,
                    55,
                  ),
                  backgroundColor: Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
