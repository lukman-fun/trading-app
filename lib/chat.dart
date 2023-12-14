import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:trading/model/chat_model.dart';
import 'package:trading/utils/base.dart';
import 'package:trading/utils/clinet_http.dart';
import 'package:trading/utils/sessions.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late IO.Socket socket;
  List<Data> chat_data = [];
  var token = '';

  TextEditingController _message = TextEditingController();

  Future<void> getChat() async {
    var response = await ClientHTTP().getClitentHTTP().get(
      Uri.parse(
          '${BaseTrading().API}chat/get/${jsonDecode((await Sessions.get())!)['user']['id'].toString()}'),
      headers: {"Authorization": "Bearer ${await Sessions.jwtToken()}"},
    );

    if (response.statusCode == 200) {
      setState(() {
        token = chatModelFromJson(response.body).token;
        socket.emit('roomchat', token);
        chat_data = chatModelFromJson(response.body).data;
      });
    }
    print("CHAT RESPONSE : ${response.body}");
  }

  Future<void> sendChat() async {
    var response = await ClientHTTP().getClitentHTTP().post(
      Uri.parse('${BaseTrading().API}chat/send'),
      headers: {"Authorization": "Bearer ${await Sessions.jwtToken()}"},
      body: {
        "token": token,
        "sender_id":
            jsonDecode((await Sessions.get())!)['user']['id'].toString(),
        "receiver_id": "0",
        "message": _message.text
      },
    );

    if (response.statusCode == 201) {
      var responseData = jsonDecode(response.body)['data'];

      socket.emit('conversation', responseData);
      setState(() {
        chat_data.add(
          Data(
            id: responseData['id'],
            token: responseData['token'],
            senderId: responseData['sender_id'],
            receiverId: responseData['receiver_id'],
            message: responseData['message'],
            createdAt: DateTime.parse(responseData['created_at']),
            updatedAt: DateTime.parse(responseData['updated_at']),
          ),
        );
        _message.text = '';
      });
      print("SEND CHAT : ${response.body}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    socket = IO.io(
      BaseTrading().SOCKET,
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection// optional
          .build(),
    );
    socket.connect();

    socket.onConnect((data) {
      print('SOCKET CHAT : ${socket.id}');
    });

    socket.on('message', (data) {
      print('SOCKET MSG CHAT : ${data}');
    });

    socket.on('conversation', (data) {
      print('SOCKET BUY : ${data}');
    });

    socket.onConnecting((data) {
      print('SOCKET CHAT CONNECTION... ${data}');
    });

    socket.onConnectError((data) {
      print('SOCKET CHAT ERROR ${data}');
    });

    getChat();

    socket.on('conversation', (data) {
      print("CONVERSATION : $data");
      setState(() {
        chat_data.add(
          Data(
            id: data['id'],
            token: data['token'],
            senderId: data['sender_id'],
            receiverId: data['receiver_id'],
            message: data['message'],
            createdAt: DateTime.parse(data['created_at']),
            updatedAt: DateTime.parse(data['updated_at']),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Service"),
        backgroundColor: Color.fromRGBO(34, 34, 34, 1),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        width: double.infinity,
        height: double.infinity,
        color: Color.fromRGBO(34, 34, 34, 1),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chat_data.length,
                itemBuilder: (context, index) {
                  if (chat_data[index].senderId.toString() == '0') {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 153, 0, 0.8),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Text(chat_data[index].message),
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 255, 0, 0.8),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: Text(chat_data[index].message),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: Colors.blueGrey),
                    controller: _message,
                    decoration: const InputDecoration(
                      hintText: 'Typing in here',
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
                ),
                SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    sendChat();
                  },
                  child: const Text('SEND'),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(
                      80,
                      55,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
