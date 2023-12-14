// To parse this JSON data, do
//
//     final tradingHistoryModel = tradingHistoryModelFromJson(jsonString);

import 'dart:convert';

TradingHistoryModel tradingHistoryModelFromJson(String str) =>
    TradingHistoryModel.fromJson(json.decode(str));

String tradingHistoryModelToJson(TradingHistoryModel data) =>
    json.encode(data.toJson());

class TradingHistoryModel {
  String status;
  String message;
  List<Data> data;

  TradingHistoryModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TradingHistoryModel.fromJson(Map<String, dynamic> json) =>
      TradingHistoryModel(
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
  String code;
  int userId;
  String asset;
  String analyst;
  String nominal;
  String time;
  String closeTime;
  String lastPrice;
  String profitPercent;
  String profitNominal;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.code,
    required this.userId,
    required this.asset,
    required this.analyst,
    required this.nominal,
    required this.time,
    required this.closeTime,
    required this.lastPrice,
    required this.profitPercent,
    required this.profitNominal,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        code: json["code"],
        userId: json["user_id"],
        asset: json["asset"],
        analyst: json["analyst"],
        nominal: json["nominal"],
        time: json["time"],
        closeTime: json["close_time"],
        lastPrice: json["last_price"],
        profitPercent: json["profit_percent"],
        profitNominal: json["profit_nominal"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "user_id": userId,
        "asset": asset,
        "analyst": analyst,
        "nominal": nominal,
        "time": time,
        "close_time": closeTime,
        "last_price": lastPrice,
        "profit_percent": profitPercent,
        "profit_nominal": profitNominal,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
