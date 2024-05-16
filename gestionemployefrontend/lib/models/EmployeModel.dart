// To parse this JSON data, do
//
//     final employeModel = employeModelFromJson(jsonString);

import 'dart:convert';

EmployeModel employeModelFromJson(String str) =>
    EmployeModel.fromJson(json.decode(str));

String employeModelToJson(EmployeModel data) => json.encode(data.toJson());

class EmployeModel {
  int? id;
  String? lastname;
  String? firstname;
  String? email;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  EmployeModel({
    required this.id,
    required this.lastname,
    required this.firstname,
    required this.email,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmployeModel.fromJson(Map<String, dynamic> json) => EmployeModel(
        id: json["id"],
        lastname: json["lastname"],
        firstname: json["firstname"],
        email: json["email"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lastname": lastname,
        "firstname": firstname,
        "email": email,
        "user_id": userId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
