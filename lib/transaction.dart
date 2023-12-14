import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trading/deposit.dart';
import 'package:trading/model/transaction_history_model.dart';
import 'package:trading/utils/base.dart';
import 'package:trading/utils/clinet_http.dart';
import 'package:trading/utils/sessions.dart';
import 'package:trading/withdraw.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<Data> transaction_history_data = [];

  Future<void> getAll() async {
    var user = jsonDecode((await Sessions.get())!)['user'];

    final response = await ClientHTTP().getClitentHTTP().get(
      Uri.parse('${BaseTrading().API}transaction/get?user_id=${user["id"]}'),
      headers: {'Authorization': 'Bearer ${await Sessions.jwtToken()}'},
    );

    if (response.statusCode == 200) {
      setState(() {
        transaction_history_data =
            transactionHistoryModelFromJson(response.body).data;
      });
      print("TRANSACTION : ${response.body}");
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
        title: const Text("History Transaksi"),
        backgroundColor: Color.fromRGBO(34, 34, 34, 1),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        width: double.infinity,
        height: double.infinity,
        color: Color.fromRGBO(34, 34, 34, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color.fromARGB(255, 22, 21, 21),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            size: 36,
                            color: Colors.grey[350],
                          ),
                          SizedBox(width: 10),
                          Text(
                            '1000 USDT',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[350],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        right: 15,
                        bottom: 15,
                        left: 15,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: Text('Deposit'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DepositPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton(
                              child: Text('Withdraw'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const WithdrawPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                "Riwayat",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: transaction_history_data.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Color.fromARGB(255, 22, 21, 21),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                transaction_history_data[index].type == 'topup'
                                    ? 'Deposit'
                                    : 'Tarik',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${transaction_history_data[index].type == 'topup' ? '+' : '-'}${transaction_history_data[index].nominal} USDT",
                                style: TextStyle(
                                  color: transaction_history_data[index].type ==
                                          'topup'
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                transaction_history_data[index]
                                    .createdAt
                                    .toIso8601String(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                transaction_history_data[index].status == '0'
                                    ? 'Pending'
                                    : (transaction_history_data[index].status ==
                                            '1'
                                        ? 'Success'
                                        : 'Reject'),
                                style: TextStyle(
                                  color:
                                      transaction_history_data[index].status ==
                                              '0'
                                          ? Colors.yellow
                                          : (transaction_history_data[index]
                                                      .status ==
                                                  '1'
                                              ? Colors.green
                                              : Colors.red),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
