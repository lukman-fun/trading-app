import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trading/utils/base.dart';
import 'package:trading/utils/clinet_http.dart';
import 'package:trading/utils/sessions.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  TextEditingController _nominal = TextEditingController();
  TextEditingController _accountBank = TextEditingController();
  TextEditingController _accountName = TextEditingController();
  TextEditingController _accountNumber = TextEditingController();

  bool isExpand = false;

  Future<void> postWithdraw(BuildContext context) async {
    var user = jsonDecode((await Sessions.get())!)['user'];
    var response = await ClientHTTP().getClitentHTTP().post(
      Uri.parse('${BaseTrading().API}transaction/withdraw'),
      headers: {"Authorization": "Bearer ${await Sessions.jwtToken()}"},
      body: {
        "user_id": user['id'].toString(),
        "nominal": _nominal.text,
        "account_name": _accountName.text,
        "account_bank": _accountBank.text,
        "account_number": _accountNumber.text
      },
    );

    if (response.statusCode == 201) {
      Navigator.pop(context);
      print("WITHDRAW : ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Withdraw"),
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
                  labelText: 'Nominal Withdraw',
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
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  postWithdraw(context);
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
