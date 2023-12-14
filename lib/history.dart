import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trading/model/trading_history_model.dart';
import 'package:trading/utils/base.dart';
import 'package:trading/utils/clinet_http.dart';
import 'package:trading/utils/sessions.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Data> history_trading_data = [];

  Future<void> getAll() async {
    var user = jsonDecode((await Sessions.get())!)['user'];

    final response = await ClientHTTP().getClitentHTTP().get(
      Uri.parse('${BaseTrading().API}trade/get?user_id=${user["id"]}'),
      headers: {'Authorization': 'Bearer ${await Sessions.jwtToken()}'},
    );

    if (response.statusCode == 200) {
      setState(() {
        history_trading_data = tradingHistoryModelFromJson(response.body).data;
      });
      print("HISTORY : ${tradingHistoryModelFromJson(response.body)}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History Perdagangan"),
        backgroundColor: Color.fromRGBO(34, 34, 34, 1),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        width: double.infinity,
        height: double.infinity,
        color: Color.fromRGBO(34, 34, 34, 1),
        child: ListView.builder(
          itemCount: history_trading_data.length,
          itemBuilder: (context, index) {
            return Card(
              color: Color.fromARGB(255, 22, 21, 21),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        history_trading_data[index].asset,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${history_trading_data[index].status == '1' ? (int.tryParse(history_trading_data[index].nominal)! + int.tryParse(history_trading_data[index].profitNominal)!) : '0'} USDT",
                        style: TextStyle(
                          color: history_trading_data[index].status == '1'
                              ? Colors.yellow
                              : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            history_trading_data[index].analyst == 'buy'
                                ? Icons.trending_up_rounded
                                : Icons.trending_down_rounded,
                            color: history_trading_data[index].analyst == 'buy'
                                ? Colors.green
                                : Colors.red,
                            size: 20,
                          ),
                          SizedBox(width: 3),
                          Text(
                            "${history_trading_data[index].profitNominal} USDT",
                            style: TextStyle(
                              color: Color.fromARGB(255, 138, 138, 138),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${history_trading_data[index].nominal} USDT",
                        style: TextStyle(
                          color: Color.fromARGB(255, 138, 138, 138),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                history_trading_data[index]
                                    .createdAt
                                    .toIso8601String(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 3),
                              Text(
                                "Masuk",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 138, 138, 138),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                history_trading_data[index]
                                    .updatedAt
                                    .toIso8601String(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 3),
                              Text(
                                "Keluar",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 138, 138, 138),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        "ID #${history_trading_data[index].code}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            );
          },
        ),
        // child: Column(
        //   children: [
        //     Card(
        //       color: Color.fromARGB(255, 22, 21, 21),
        //       child: Container(
        //         width: double.infinity,
        //         padding: EdgeInsets.all(15),
        //         child: Column(children: [
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: const [
        //               Text(
        //                 "JPY",
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 16,
        //                 ),
        //               ),
        //               Text(
        //                 "0.00 USDT",
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 16,
        //                 ),
        //               ),
        //             ],
        //           ),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Row(
        //                 children: const [
        //                   Icon(
        //                     Icons.trending_up_rounded,
        //                     color: Colors.green,
        //                     size: 20,
        //                   ),
        //                   SizedBox(width: 3),
        //                   Text(
        //                     "0.30 USDT",
        //                     style: TextStyle(
        //                       color: Color.fromARGB(255, 138, 138, 138),
        //                       fontSize: 12,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               const Text(
        //                 "300 USDT",
        //                 style: TextStyle(
        //                   color: Color.fromARGB(255, 138, 138, 138),
        //                   fontSize: 12,
        //                 ),
        //               ),
        //             ],
        //           ),
        //           SizedBox(height: 8),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: [
        //               Column(
        //                 children: [
        //                   Row(
        //                     children: const [
        //                       Text(
        //                         "29 Agu 12.23.05",
        //                         style: TextStyle(
        //                           color: Colors.white,
        //                           fontSize: 12,
        //                         ),
        //                       ),
        //                       SizedBox(width: 3),
        //                       Text(
        //                         "Masuk",
        //                         style: TextStyle(
        //                           color: Color.fromARGB(255, 138, 138, 138),
        //                           fontSize: 12,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                   SizedBox(height: 4),
        //                   Row(
        //                     children: const [
        //                       Text(
        //                         "29 Agu 12.23.05",
        //                         style: TextStyle(
        //                           color: Colors.white,
        //                           fontSize: 12,
        //                         ),
        //                       ),
        //                       SizedBox(width: 3),
        //                       Text(
        //                         "Keluar",
        //                         style: TextStyle(
        //                           color: Color.fromARGB(255, 138, 138, 138),
        //                           fontSize: 12,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //               const Text(
        //                 "ID #123456789",
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 12,
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ]),
        //       ),
        //     ),
        //     Card(
        //       color: Color.fromARGB(255, 22, 21, 21),
        //       child: Container(
        //         width: double.infinity,
        //         padding: EdgeInsets.all(15),
        //         child: Column(children: [
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: const [
        //               Text(
        //                 "Crypto IDX",
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 16,
        //                 ),
        //               ),
        //               Text(
        //                 "0.00 USDT",
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 16,
        //                 ),
        //               ),
        //             ],
        //           ),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Row(
        //                 children: const [
        //                   Icon(
        //                     Icons.trending_down_rounded,
        //                     color: Colors.red,
        //                     size: 20,
        //                   ),
        //                   SizedBox(width: 3),
        //                   Text(
        //                     "0.30 USDT",
        //                     style: TextStyle(
        //                       color: Color.fromARGB(255, 138, 138, 138),
        //                       fontSize: 12,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               const Text(
        //                 "300 USDT",
        //                 style: TextStyle(
        //                   color: Color.fromARGB(255, 138, 138, 138),
        //                   fontSize: 12,
        //                 ),
        //               ),
        //             ],
        //           ),
        //           SizedBox(height: 8),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: [
        //               Column(
        //                 children: [
        //                   Row(
        //                     children: const [
        //                       Text(
        //                         "29 Agu 12.23.05",
        //                         style: TextStyle(
        //                           color: Colors.white,
        //                           fontSize: 12,
        //                         ),
        //                       ),
        //                       SizedBox(width: 3),
        //                       Text(
        //                         "Masuk",
        //                         style: TextStyle(
        //                           color: Color.fromARGB(255, 138, 138, 138),
        //                           fontSize: 12,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                   SizedBox(height: 4),
        //                   Row(
        //                     children: const [
        //                       Text(
        //                         "29 Agu 12.23.05",
        //                         style: TextStyle(
        //                           color: Colors.white,
        //                           fontSize: 12,
        //                         ),
        //                       ),
        //                       SizedBox(width: 3),
        //                       Text(
        //                         "Keluar",
        //                         style: TextStyle(
        //                           color: Color.fromARGB(255, 138, 138, 138),
        //                           fontSize: 12,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //               const Text(
        //                 "ID #123456789",
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 12,
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ]),
        //       ),
        //     ),
        //     Card(
        //       color: Color.fromARGB(255, 22, 21, 21),
        //       child: Container(
        //         width: double.infinity,
        //         padding: EdgeInsets.all(15),
        //         child: Column(children: [
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: const [
        //               Text(
        //                 "USDT",
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 16,
        //                 ),
        //               ),
        //               Text(
        //                 "300.30 USDT",
        //                 style: TextStyle(
        //                   color: Colors.yellow,
        //                   fontSize: 16,
        //                 ),
        //               ),
        //             ],
        //           ),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Row(
        //                 children: const [
        //                   Icon(
        //                     Icons.trending_up_rounded,
        //                     color: Colors.green,
        //                     size: 20,
        //                   ),
        //                   SizedBox(width: 3),
        //                   Text(
        //                     "0.30 USDT",
        //                     style: TextStyle(
        //                       color: Color.fromARGB(255, 138, 138, 138),
        //                       fontSize: 12,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               const Text(
        //                 "300 USDT",
        //                 style: TextStyle(
        //                   color: Color.fromARGB(255, 138, 138, 138),
        //                   fontSize: 12,
        //                 ),
        //               ),
        //             ],
        //           ),
        //           SizedBox(height: 8),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: [
        //               Column(
        //                 children: [
        //                   Row(
        //                     children: const [
        //                       Text(
        //                         "29 Agu 12.23.05",
        //                         style: TextStyle(
        //                           color: Colors.white,
        //                           fontSize: 12,
        //                         ),
        //                       ),
        //                       SizedBox(width: 3),
        //                       Text(
        //                         "Masuk",
        //                         style: TextStyle(
        //                           color: Color.fromARGB(255, 138, 138, 138),
        //                           fontSize: 12,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                   SizedBox(height: 4),
        //                   Row(
        //                     children: const [
        //                       Text(
        //                         "29 Agu 12.23.05",
        //                         style: TextStyle(
        //                           color: Colors.white,
        //                           fontSize: 12,
        //                         ),
        //                       ),
        //                       SizedBox(width: 3),
        //                       Text(
        //                         "Keluar",
        //                         style: TextStyle(
        //                           color: Color.fromARGB(255, 138, 138, 138),
        //                           fontSize: 12,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //               const Text(
        //                 "ID #123456789",
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 12,
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ]),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
