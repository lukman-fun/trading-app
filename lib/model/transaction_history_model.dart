// To parse this JSON data, do
//
//     final transactionHistoryModel = transactionHistoryModelFromJson(jsonString);

import 'dart:convert';

TransactionHistoryModel transactionHistoryModelFromJson(String str) =>
    TransactionHistoryModel.fromJson(json.decode(str));

String transactionHistoryModelToJson(TransactionHistoryModel data) =>
    json.encode(data.toJson());

class TransactionHistoryModel {
  String status;
  String message;
  List<Data> data;

  TransactionHistoryModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) =>
      TransactionHistoryModel(
        status: json["status"],
        message: json["message"],
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Data {
  int id;
  int userId;
  String nominal;
  String status;
  String type;
  String? note;
  String accountName;
  String accountBank;
  String accountNumber;
  int? imageId;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.userId,
    required this.nominal,
    required this.status,
    required this.type,
    required this.note,
    required this.accountName,
    required this.accountBank,
    required this.accountNumber,
    required this.imageId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        nominal: json["nominal"],
        status: json["status"],
        type: json["type"],
        note: json["note"],
        accountName: json["account_name"],
        accountBank: json["account_bank"],
        accountNumber: json["account_number"],
        imageId: json["image_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "nominal": nominal,
        "status": status,
        "type": type,
        "note": note,
        "account_name": accountName,
        "account_bank": accountBank,
        "account_number": accountNumber,
        "image_id": imageId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
