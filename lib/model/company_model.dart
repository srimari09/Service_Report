import 'package:flutter/foundation.dart';

class CompanyModel {
  final String companyId;
  final String ownerUId;
  final String companyName;
  final String subTitle;
  final String companyAddress;
  final String contactNumber;
  final String email;
  final String gstIn;

  CompanyModel({
    required this.companyId,
    required this.ownerUId,
    required this.companyName,
    required this.subTitle,
    required this.companyAddress,
    required this.email,
    required this.contactNumber,
    required this.gstIn,
  });

  Map<String, dynamic> toJson() {
    return {
      'companyId':companyId,
      'ownerUID': ownerUId,
      'companyName': companyName,
      'subTitle': subTitle,
      'companyAddress': companyAddress,
      'contactNumber': contactNumber,
      'email': email,
      'gstIn': gstIn,
    };
  }

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      companyId: json['companyId'] ,
      ownerUId: json['ownerUID'] ?? '' ,
      companyName: json['companyName'] ?? '',
      subTitle: json['subTitle'] ?? '',
      companyAddress: json['companyAddress'] ?? '',
      email: json['email'] ?? '',
      contactNumber: json['contactNumber'],
      gstIn: json['gstIn'] ?? '',
    );
  }
}
