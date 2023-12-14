import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:trading/utils/base.dart';
import 'package:trading/utils/clinet_http.dart';
import 'package:trading/utils/sessions.dart';

class DepositPage extends StatefulWidget {
  const DepositPage({super.key});

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  TextEditingController _nominal = TextEditingController();
  TextEditingController _accountBank = TextEditingController();
  TextEditingController _accountName = TextEditingController();
  TextEditingController _accountNumber = TextEditingController();
  TextEditingController _note = TextEditingController();

  bool isExpand = false;

  File? file = null;
  final ImagePicker imagePicker = ImagePicker();
  Future<void> getImageGallery() async {
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

  Future<void> postDeposit(BuildContext context) async {
    var user = jsonDecode((await Sessions.get())!)['user'];

    var imageID = await uploadImage();

    var response = await ClientHTTP().getClitentHTTP().post(
      Uri.parse('${BaseTrading().API}transaction/topup'),
      headers: {"Authorization": "Bearer ${await Sessions.jwtToken()}"},
      body: {
        "user_id": user['id'].toString(),
        "nominal": _nominal.text,
        "note": _note.text,
        "account_name": _accountName.text,
        "account_bank": _accountBank.text,
        "account_number": _accountNumber.text,
        "image_id": imageID
      },
    );

    if (response.statusCode == 201) {
      Navigator.pop(context);
      print("DEPOSIT : ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deposit"),
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
                controller: _nominal,
                decoration: const InputDecoration(
                  labelText: 'Nominal Deposit',
                  hintText: '20000',
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
                  labelText: 'Bank Pengirim',
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
                  labelText: 'Nama Rekening Pengirim',
                  hintText: 'Budi',
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
                  labelText: 'Nomor Rekening Pengirim',
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
                style: TextStyle(color: Colors.blueGrey),
                controller: _note,
                decoration: const InputDecoration(
                  labelText: 'Catatan',
                  hintText: 'catatan',
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
              // ExpansionPanelList(
              //   expansionCallback: (panelIndex, isExpanded) {
              //     setState(() {
              //       isExpand = !isExpanded;
              //     });
              //   },
              //   children: [
              //     ExpansionPanel(
              //       headerBuilder: (context, isExpanded) {
              //         return const ListTile(
              //           title: Text('Bank List'),
              //         );
              //       },
              //       body: Column(
              //         children: [
              //           Card(
              //             child: Container(
              //               padding: const EdgeInsets.all(10),
              //               child: Row(
              //                 children: [
              //                   Image.asset(
              //                     'assets/bank/bri.png',
              //                     width: 60,
              //                   ),
              //                   SizedBox(width: 15),
              //                   Expanded(
              //                     child: Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       children: const [
              //                         Text(
              //                           "Admin 1",
              //                           style: TextStyle(
              //                             color: Colors.black,
              //                             fontSize: 14,
              //                           ),
              //                         ),
              //                         Text(
              //                           "876187176286162",
              //                           style: TextStyle(
              //                             color: Colors.black,
              //                             fontSize: 20,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                   SizedBox(width: 15),
              //                   Radio(
              //                     value: 1,
              //                     groupValue: 1,
              //                     onChanged: (value) {},
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ),
              //           Card(
              //             child: Container(
              //               padding: const EdgeInsets.all(10),
              //               child: Row(
              //                 children: [
              //                   Image.asset(
              //                     'assets/bank/bri.png',
              //                     width: 60,
              //                   ),
              //                   SizedBox(width: 15),
              //                   Expanded(
              //                     child: Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       children: const [
              //                         Text(
              //                           "Admin 1",
              //                           style: TextStyle(
              //                             color: Colors.black,
              //                             fontSize: 14,
              //                           ),
              //                         ),
              //                         Text(
              //                           "876187176286162",
              //                           style: TextStyle(
              //                             color: Colors.black,
              //                             fontSize: 20,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                   SizedBox(width: 15),
              //                   Radio(
              //                     value: 2,
              //                     groupValue: 1,
              //                     onChanged: (value) {},
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       isExpanded: isExpand,
              //     )
              //   ],
              // ),
              // SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  getImageGallery();
                },
                child: Container(
                  width: 300,
                  height: 400,
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
                  postDeposit(context);
                },
                child: const Text("Proses"),
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
