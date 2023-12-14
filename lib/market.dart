import 'dart:async';
import 'dart:math';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  List<CandleData> data = [];
  Timer? timer;
  int count = 1;
  TrackballBehavior? _trackballBehavior;

  CustomPopupMenuController _timeframePopupMenuController =
      CustomPopupMenuController();

  int _timeframeSelected = 0;
  List<Map<String, dynamic>> timeframeList = [
    {
      'index': 0,
      'id': '5d',
      'label': '5 dtk',
    },
    {
      'index': 1,
      'id': '15d',
      'label': '15 dtk',
    },
    {
      'index': 2,
      'id': '1m',
      'label': '1 mnt',
    },
    {
      'index': 3,
      'id': '5m',
      'label': '5 mnt',
    },
    {
      'index': 4,
      'id': '15m',
      'label': '15 mnt',
    },
    {
      'index': 5,
      'id': '30m',
      'label': '30 mnt',
    },
    {
      'index': 6,
      'id': '1j',
      'label': '1 jam',
    },
  ];

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

  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
        activationMode: ActivationMode.singleTap, enable: true);
    super.initState();
    generateData(); // Start with initial data
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // Every 60 seconds, add new data
      generateData();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void generateData() {
    // Simulate randomly changing candlestick data
    final random = Random();
    final open = 1000.0 + random.nextDouble() * 10;
    final close = 1000.0 + random.nextDouble() * 10;
    final high = max(open, close) + random.nextDouble() * 5;
    final low = min(open, close) - random.nextDouble() * 5;

    setState(() {
      data.add(CandleData(count.toString(), low, high, open, close));
      count++;
    });
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
        title: const Text("Trade"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(opposedPosition: true),
                series: <CandleSeries<CandleData, String>>[
                  CandleSeries<CandleData, String>(
                    enableSolidCandles: true,
                    dataSource: data,
                    xValueMapper: (CandleData data, _) => data.day,
                    lowValueMapper: (CandleData data, _) => data.low,
                    highValueMapper: (CandleData data, _) => data.high,
                    openValueMapper: (CandleData data, _) => data.open,
                    closeValueMapper: (CandleData data, _) => data.close,
                    // bearColor: Colors.red,
                    // bullColor: Colors.green,
                  ),
                ],
                trackballBehavior: _trackballBehavior,
                zoomPanBehavior: ZoomPanBehavior(
                  enablePanning: true,
                  enablePinching: true,
                  zoomMode: ZoomMode.x,
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
                      CustomPopupMenu(
                        pressType: PressType.singleClick,
                        menuBuilder: () {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            color: const Color.fromARGB(255, 22, 21, 21),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Text(
                                        "Timeframe",
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 15,
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: timeframeList.map((item) {
                                            return Container(
                                              margin: EdgeInsets.only(
                                                  right: (item['index'] ==
                                                          timeframeList.length -
                                                              1)
                                                      ? 0
                                                      : 8),
                                              child: ChoiceChip(
                                                label: Text(item['label']),
                                                selected: _timeframeSelected ==
                                                    item['index'],
                                                onSelected: (value) {
                                                  setState(() {
                                                    _timeframeSelected =
                                                        item['index'];
                                                  });
                                                  _timeframePopupMenuController
                                                      .hideMenu();
                                                },
                                                selectedColor: Colors.blue,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        controller: _timeframePopupMenuController,
                        arrowColor: const Color.fromARGB(255, 22, 21, 21),
                        arrowSize: 18,
                        child: TextButton(
                          onPressed: () {
                            _timeframePopupMenuController.showMenu();
                          },
                          child: Text(
                            timeframeList[_timeframeSelected]['id'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
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
                                  children: const [
                                    Text(
                                      "Saldo",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 138, 138, 138),
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      "4.000 USDT",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: const Text("Deposit"),
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
                            child: TextButton(
                              style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft,
                              ),
                              onPressed: () {},
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "FTT",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 138, 138, 138),
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      "CHF/JPY",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ]),
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
                                          "Waktu",
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
                                    children: const [
                                      Text(
                                        "Waktu",
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 138, 138, 138),
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "00:55",
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
                            child: TextButton(
                              style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft,
                              ),
                              onPressed: () {},
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Jumlah",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 138, 138, 138),
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      "100 USDT",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ]),
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
                                      "Harga Kesepakatan",
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
                                          "Rp 2.000",
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
                                Text("BUY")
                              ],
                            ),
                            onPressed: () {},
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
                                Text("SELL")
                              ],
                            ),
                            onPressed: () {},
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
