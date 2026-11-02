import 'package:cloud_firestore/cloud_firestore.dart';

class HomeModel {
  String clientName;
  String vendorNo;
  DateTime? approvalDate;
  DateTime? workCompletionDate;
  String technicianNo;
  DateTime? createdAt;
  String saveName; // ( user save the name in the field)
  // List<WorkTableModel> workItems;

  HomeModel({
    required this.clientName,
    this.vendorNo = '',
     this.approvalDate,
     this.workCompletionDate,
    required this.technicianNo,
    this.createdAt,
    this.saveName = ''
    // required this.workItems
  });

  Map<String, dynamic> toJson() {
    return {
      'clientName': clientName,
      'vendorNo':vendorNo,
      'approvalDate': approvalDate,
      'workCompletionDate': workCompletionDate,
      'technicianNo': technicianNo,
      'createdAt': FieldValue.serverTimestamp(),
      'saveName': saveName,
      // 'workItems': workItems.map((item)=>item.toJson()).toList()
    };
  }

  factory HomeModel.fromJson(Map<String, dynamic> json)
  {
    return HomeModel(
        clientName: json['clientName'] ?? '',
        vendorNo: json['vendorNo'] ?? '',
        approvalDate: json['approvalDate'] != null
          ? (json['approvalDate'] as Timestamp).toDate()
          : null,

         workCompletionDate: json['workCompletionDate'] != null
          ? (json['workCompletionDate'] as Timestamp).toDate()
          : null,
        technicianNo: json['technicianNo'] ?? '',
        saveName: json['saveName'] ?? '',
        createdAt: (json['createdAt']) !=null ? (json['createdAt'] as Timestamp).toDate() : null,
        // workItems: (json['workItems'] as List).
        // map((item)=>WorkTableModel.fromJson(item)).toList()
    );
  }
}