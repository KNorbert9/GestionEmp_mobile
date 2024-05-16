// To parse this JSON data, do
//
//     final employeModel = employeModelFromJson(jsonString);

import 'dart:convert';

EmployeModel employeModelFromJson(String str) =>
    EmployeModel.fromJson(json.decode(str));

String employeModelToJson(EmployeModel data) => json.encode(data.toJson());

class EmployeModel {
  int? id;
  String? name;
  String? username;
  String? email;
  DateTime? emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  EmployeModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmployeModel.fromJson(Map<String, dynamic> json) => EmployeModel(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
