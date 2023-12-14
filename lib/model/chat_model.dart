// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
    String status;
    String message;
    String token;
    List<Data> data;

    ChatModel({
        required this.status,
        required this.message,
        required this.token,
        required this.data,
    });

    factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        status: json["status"],
        message: json["message"],
        token: json["token"],
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "token": token,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Data {
    int id;
    String token;
    String senderId;
    String receiverId;
    String message;
    DateTime createdAt;
    DateTime updatedAt;

    Data({
        required this.id,
        required this.token,
        required this.senderId,
        required this.receiverId,
        required this.message,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        token: json["token"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        message: json["message"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message": message,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
