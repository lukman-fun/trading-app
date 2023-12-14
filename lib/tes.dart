import 'dart:convert';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'package:trading/utils/base.dart';
import 'package:trading/utils/clinet_http.dart';
import 'package:trading/utils/sessions.dart';

class Tester extends StatefulWidget {
  const Tester({super.key});

  @override
  State<Tester> createState() => _TesterState();
}

class _TesterState extends State<Tester> {
  late InAppWebViewController _webViewController;

  CustomPopupMenuController _timePopupMenuController =
      CustomPopupMenuController();
  int _timeSelected = 0;
  List<Map<String, dynamic>> timeList = [
    {
      'id': '60',
      'label': '60s',
      'income': '+12%',
    },
    {
      'id': '90',
      'label': '90s',
      'income': '+18.85%',
    },
    {
      'id': '120',
      'label': '120s',
      'income': '+21.75%',
    },
    {
      'id': '180',
      'label': '180s',
      'income': '+27.80%',
    },
    {
      'id': '240',
      'label': '240s',
      'income': '+38.85%',
    },
    {
      'id': '360',
      'label': '360s',
      'income': '+45.34%',
    },
  ];

  CustomPopupMenuController _cryptoMenuPopupMenuController =
      CustomPopupMenuController();
  int _cryptoCoinSelected = 0;
  List<String> cryptoCoinList = [
    'BTCUSDT',
    'ETHUSDT',
    'BNBUSDT',
    'XRPUSDT',
    'USDCUSDT',
    'SOLUSDT',
    'DOGEUSDT',
    'ADAUSDT',
    'TRXUSDT',
    'LTCUSDT'
  ];

  CustomPopupMenuController _nominalMenuPopupMenuController =
      CustomPopupMenuController();
  int _nominalSelected = 100;
  TextEditingController _nominalTextEditingController = TextEditingController();

  late IO.Socket socket;

  int saldo = 0;

  Future<void> getUser() async {
    var response = await ClientHTTP().getClitentHTTP().post(
      Uri.parse('${BaseTrading().API}auth/me'),
      headers: {"Authorization": "Bearer ${await Sessions.jwtToken()}"},
    );

    if (response.statusCode == 200) {
      setState(() {
        saldo = int.tryParse(jsonDecode(response.body)['data']['balance'])!;
      });
      print("USER : ${response.body}");
    }
  }

  Future<void> joinToRoom() async {
    socket.emit(
        'join', jsonDecode((await Sessions.get())!)['user']['id'].toString());
    // socket.emit('join', '11');
  }

  var jwtToken = '';
  var tokenCryptoSelectedWebview = '';

  @override
  void initState() {
    super.initState();
    tokenCryptoSelectedWebview =
        cryptoCoinList[_cryptoCoinSelected].toLowerCase();
    getUser();
    socket = IO.io(
     BaseTrading().SOCKET,
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection// optional
          .build(),
    );
    socket.connect();

    socket.onConnect((data) {
      print('SOCKET ${socket.id}');
    });

    socket.on('message', (data) {
      print('SOCKET MSG : ${data}');
    });

    socket.on('buy', (data) {
      print('SOCKET BUY : ${data}');
    });

    socket.on('sell', (data) {
      print('SOCKET SELL : ${data}');
    });

    socket.onConnecting((data) {
      print('SOCKET CONNECTION... ${data}');
    });

    socket.onConnectError((data) {
      print('SOCKET ERROR ${data}');
    });

    joinToRoom();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    //   // Untuk status bar gelap, gunakan SystemUiOverlayStyle.dark
    //   // Untuk status bar terang, gunakan SystemUiOverlayStyle.light
    //   statusBarBrightness: Brightness.dark,
    // ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade'),
        backgroundColor: Color.fromRGBO(34, 34, 34, 1),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color.fromRGBO(34, 34, 34, 1),
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: FutureBuilder(
                  future: Sessions.jwtToken(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      jwtToken = snapshot.data.toString();
                      return InAppWebView(
                        initialUrlRequest: URLRequest(
                          url: Uri.parse(
                              '${BaseTrading().BASE}chart-app/${tokenCryptoSelectedWebview}/${jwtToken}'),
                        ),
                        initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(),
                        ),
                        onWebViewCreated: (InAppWebViewController controller) {
                          _webViewController = controller;
                        },
                        onLoadStart: (controller, url) {
                          print('START : ${url}');
                        },
                        onLoadStop: (controller, url) {
                          print('STOP : ${url}');
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 8,
                top: 0,
                right: 8,
                bottom: 8,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.ssid_chart_rounded,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          color: const Color.fromARGB(255, 22, 21, 21),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Saldo',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 138, 138, 138),
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      '$saldo USDT',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Deposit'),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Card(
                    color: Color.fromARGB(255, 22, 21, 21),
                    elevation: 0,
                    child: Column(children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomPopupMenu(
                              menuBuilder: () {
                                return Container(
                                  width: 130,
                                  height: 400,
                                  color: const Color.fromARGB(255, 22, 21, 21),
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Text(
                                          'Coin',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 1,
                                        width: double.infinity,
                                        color: const Color.fromARGB(
                                            255, 138, 138, 138),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: cryptoCoinList.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(
                                                cryptoCoinList[index]
                                                    .replaceAll('USDT', ''),
                                                style: TextStyle(
                                                  color: index ==
                                                          _cryptoCoinSelected
                                                      ? Colors.blue
                                                      : Colors.white,
                                                ),
                                              ),
                                              selected:
                                                  index == _cryptoCoinSelected,
                                              onTap: () {
                                                setState(() {
                                                  _cryptoCoinSelected = index;
                                                  tokenCryptoSelectedWebview =
                                                      cryptoCoinList[
                                                              _cryptoCoinSelected]
                                                          .toLowerCase();
                                                  _webViewController.loadUrl(
                                                    urlRequest: URLRequest(
                                                      url: Uri.parse(
                                                          '${BaseTrading().BASE}chart-app/${tokenCryptoSelectedWebview}/${jwtToken}'),
                                                    ),
                                                  );
                                                });
                                                _cryptoMenuPopupMenuController
                                                    .hideMenu();
                                              },
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              arrowColor: const Color.fromARGB(255, 22, 21, 21),
                              arrowSize: 18,
                              pressType: PressType.singleClick,
                              controller: _cryptoMenuPopupMenuController,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  alignment: Alignment.centerLeft,
                                ),
                                onPressed: () {
                                  _cryptoMenuPopupMenuController.showMenu();
                                },
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Coin',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 138, 138, 138),
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        cryptoCoinList[_cryptoCoinSelected]
                                            .replaceAll('USDT', ''),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          Expanded(
                            child: CustomPopupMenu(
                              menuBuilder: () {
                                return Container(
                                  width: 130,
                                  height: 400,
                                  color: const Color.fromARGB(255, 22, 21, 21),
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Text(
                                          'Waktu',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 1,
                                        width: double.infinity,
                                        color: const Color.fromARGB(
                                            255, 138, 138, 138),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: timeList.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    timeList[index]['label'],
                                                    style: TextStyle(
                                                      color:
                                                          index == _timeSelected
                                                              ? Colors.blue
                                                              : Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    timeList[index]['income'],
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              selected: index == _timeSelected,
                                              onTap: () {
                                                setState(() {
                                                  _timeSelected = index;
                                                });
                                                _timePopupMenuController
                                                    .hideMenu();
                                              },
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              arrowColor: const Color.fromARGB(255, 22, 21, 21),
                              arrowSize: 18,
                              pressType: PressType.singleClick,
                              controller: _timePopupMenuController,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  alignment: Alignment.centerLeft,
                                ),
                                onPressed: () {
                                  _timePopupMenuController.showMenu();
                                },
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Waktu',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 138, 138, 138),
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        timeList[_timeSelected]['label'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomPopupMenu(
                              menuBuilder: () {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: const Color.fromARGB(255, 22, 21, 21),
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Text(
                                          'Jumlah',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 1,
                                        width: double.infinity,
                                        color: const Color.fromARGB(
                                            255, 138, 138, 138),
                                      ),
                                      Container(
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: TextFormField(
                                                  controller:
                                                      _nominalTextEditingController,
                                                  style: TextStyle(
                                                      color: Colors.blueGrey),
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: '100',
                                                    labelStyle: TextStyle(
                                                        color: Colors.blueGrey),
                                                    hintStyle: TextStyle(
                                                        color: Colors.blueGrey),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.blueGrey,
                                                      ), // Warna border saat aktif
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.grey,
                                                      ), // Warna border saat non-aktif
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (int.tryParse(
                                                          _nominalTextEditingController
                                                              .text)! >=
                                                      100) {
                                                    setState(() {
                                                      _nominalSelected =
                                                          int.tryParse(
                                                              _nominalTextEditingController
                                                                  .text)!;

                                                      _nominalTextEditingController
                                                          .text = '';
                                                    });
                                                    _nominalMenuPopupMenuController
                                                        .hideMenu();
                                                  }
                                                },
                                                child: const Icon(Icons.check),
                                                style: ElevatedButton.styleFrom(
                                                  fixedSize: Size(
                                                    55,
                                                    55,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                );
                              },
                              arrowColor: const Color.fromARGB(255, 22, 21, 21),
                              arrowSize: 18,
                              pressType: PressType.singleClick,
                              controller: _nominalMenuPopupMenuController,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  alignment: Alignment.centerLeft,
                                ),
                                onPressed: () {
                                  _nominalMenuPopupMenuController.showMenu();
                                },
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Jumlah',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 138, 138, 138),
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        '$_nominalSelected USDT',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft,
                              ),
                              onPressed: () {},
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Harga Kesepakatan',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 138, 138, 138),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        Text(
                                          timeList[_timeSelected]['income'],
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          'Rp 2.000',
                                          style: TextStyle(
                                              color: Colors.transparent),
                                        ),
                                      ],
                                    )
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                  Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.trending_up_rounded),
                                SizedBox(
                                  width: 8,
                                  height: 50,
                                ),
                                Text('BUY')
                              ],
                            ),
                            onPressed: () {
                              socket.emit('buy_or_sell', {
                                'type': 'buy',
                                'nominal': _nominalSelected.toString(),
                                'time': timeList[_timeSelected]['id'],
                                'percent': (timeList[_timeSelected]['income'])
                                    .toString()
                                    .replaceAll('+', '')
                                    .replaceAll('%', '')
                              });
                              setState(() {
                                saldo = saldo - _nominalSelected;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.trending_down_rounded),
                                SizedBox(
                                  width: 8,
                                  height: 50,
                                ),
                                Text('SELL')
                              ],
                            ),
                            onPressed: () {
                              socket.emit('buy_or_sell', {
                                'type': 'sell',
                                'nominal': _nominalSelected.toString(),
                                'time': timeList[_timeSelected]['id'],
                                'percent': (timeList[_timeSelected]['income'])
                                    .toString()
                                    .replaceAll('+', '')
                                    .replaceAll('%', '')
                              });
                              setState(() {
                                saldo = saldo - _nominalSelected;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CandleData {
  CandleData(this.day, this.low, this.high, this.open, this.close);

  final String day;
  final double low;
  final double high;
  final double open;
  final double close;
}
