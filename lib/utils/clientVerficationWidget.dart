import 'package:flutter/material.dart';
import 'package:karamtechnology_services/utils/App_text.dart';
Widget clientVerificationAdmin() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 10),
      AppText(
        text: 'Client Verification',
        fontWeight: FontWeight.bold,
        textAlign: TextAlign.left,
        fontSize: 16,
        textDecoration: TextDecoration.underline,
      ),
      SizedBox(height: 10),
      AppText(
        text: 'I hereby certify that the above-mentioned work has been completed at our location and verified.',
      ),
      SizedBox(height: 10),
      AppText(text: 'Branch / location: '),
      AppText(text: 'Verified by: '),
      AppText(text: 'Designation: '),
      AppText(text: 'Employee code: '),
      AppText(text: 'Date: '),
      AppText(text: 'Signature & Branch Seal'),
      SizedBox(height: 10),
      Divider(height: 2, color: Colors.black),
      SizedBox(height: 10),
      AppText(
        text: 'Filled By Admin Department',
        fontWeight: FontWeight.bold,
        textAlign: TextAlign.left,
        textDecoration: TextDecoration.underline,
        fontSize: 16,
      ),
      SizedBox(height: 10),
      AppText(text: 'Admin & Infra Head Remark: '),
      AppText(text: 'Invoice No: '),
      AppText(text: 'Invoice Date: '),
      AppText(text: 'Bill Processed Date: '),
      AppText(text: 'Admin & Infra Head Stamp with signature '),
    ],
  );
}