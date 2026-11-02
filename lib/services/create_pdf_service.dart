import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:karamtechnology_services/model/company_model.dart';
import 'package:karamtechnology_services/model/home_model.dart';
import 'package:karamtechnology_services/model/worktable_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfServicePage {
  static pw.Font? poppinsMedium;

  static Future<void> loadFonts() async {
    poppinsMedium = pw.Font.ttf(
      await rootBundle.load(
        'assets/fonts/Poppins-Medium.ttf',
      ),
    );
  }
  static Future<Uint8List> generateServiceReportPdf({
    required CompanyModel companyData,
    required HomeModel report,
    required List<WorkTableModel> worktItems,
  })
  async {

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
          //PageFormat styling
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(35),

          //Header of the report
          // header:
          // (context) {
          //   return _buildHeader(companyData);
          // },

          //Footer of the report
          footer:
          (context) {
            return _buildFooter(companyData);
          },

          build:
          (context) {
            return [
              _buildHeader(companyData),

              pw.SizedBox(height: 15),
              _buildReportTitle(),

              pw.SizedBox(height: 15),
              _buildReportDetails(report),

              pw.SizedBox(height: 20),
              _buildWorkTable(worktItems),

              pw.SizedBox(height: 20),
              _buildVerification(),
            ];
          },
      )
    );
    return pdf.save();
  }

  static pw.Widget _buildHeader(CompanyModel companyData) {
    return pw.Column(
      children: [
        pw.Text(
          companyData.companyName,
          style: pw.TextStyle(
            fontSize: 18,
            color: PdfColors.deepPurple,
            fontWeight: pw.FontWeight.bold,
          ),
        ),

        pw.Text(
          companyData.subTitle,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 13,
            color: PdfColors.deepPurple,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        _RichDetailText(
          'Address',
          companyData.companyAddress,
        ),
       pw.Row(
         mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
         children:
           [
             _RichDetailText('Contact', companyData.contactNumber),
             _RichDetailText('Email', companyData.email),
           ]
       ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            _RichDetailText('GST IN', companyData.gstIn),
          ]
        ),
        pw.SizedBox(height: 5),
        pw.Divider(color: PdfColors.grey500),
      ],
    );
  }

  static pw.Widget _buildVerification() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),
        _buildAppText(
          text: 'Client Verification',
          fontWeight: pw.FontWeight.bold,
          // textAlign: TextAlign.left,
          textDecoration: pw.TextDecoration.underline,
        ),
        pw.SizedBox(height: 10),
        _buildAppText(
          text: 'I hereby certify that the above-mentioned work has been completed at our location and verified.',
        ),
        pw.SizedBox(height: 10),
        pw.Container(
          height: 50,
          color: PdfColor.fromHex("#ABD9F3FF"),
          child: pw.Row(
          children: [
            _buildAppText(text: 'Branch / location '),
            pw.VerticalDivider()
          ]
        ),),
        pw.SizedBox(height: 5),
        pw.Container(
          height: 50,
            color: PdfColor.fromHex("#ABD9F3FF"),
        child:   pw.Row(
            children: [
              _buildAppText(text: 'Verified by '),
              pw.VerticalDivider()
            ]
          )
        ),
        pw.SizedBox(height: 5),
        pw.Container(
          color: PdfColor.fromHex("#ABD9F3FF"),
          height: 50,
          child: pw.Row(
            children: [
              _buildAppText(text: 'Designation '),
              pw.VerticalDivider()
            ]
          )
        ),
        pw.SizedBox(height: 5),
        pw.Container(
            color: PdfColor.fromHex("#ABD9F3FF"),
            height: 50,
            child: pw.Row(
                children: [
                  _buildAppText(text: 'Employee Code '),
                  pw.VerticalDivider()
                ]
            )
        ),        pw.SizedBox(height: 5),
        pw.Container(
            color: PdfColor.fromHex("#ABD9F3FF"),
            height: 50,
            child: pw.Row(
                children: [
                  _buildAppText(text: 'Date '),
                  pw.VerticalDivider()
                ]
            )
        ),        pw.SizedBox(height: 5),
        _buildAppText(text: 'Signature & Branch Seal'),
        pw.SizedBox(height: 10),
        pw.Divider(color: PdfColors.grey500),

        pw.SizedBox(height: 10),
        _buildAppText(
          text: 'Filled By Admin Department',
          fontWeight: pw.FontWeight.bold,
          textAlign: pw.TextAlign.left,
          textDecoration: pw.TextDecoration.underline,
        ),
        pw.SizedBox(height: 10),
        pw.Container(
            color: PdfColor.fromHex("#ABD9F3FF"),
            height: 50,
            child: pw.Row(
                children: [
                  _buildAppText(text: 'Admin & Head Remark '),
                  pw.VerticalDivider()
                ]
            )
        ),
        pw.SizedBox(height: 5),

        pw.Container(
            color: PdfColor.fromHex("#ABD9F3FF"),
            height: 50,
            child: pw.Row(
                children: [
                  _buildAppText(text: 'Invoice No '),
                  pw.VerticalDivider()
                ]
            )
        ),
        pw.SizedBox(height: 5),
        pw.Container(
            color: PdfColor.fromHex("#ABD9F3FF"),
            height: 50,
            child: pw.Row(
                children: [
                  _buildAppText(text: 'Invoice Date '),
                  pw.VerticalDivider()
                ]
            )
        ),
        pw.SizedBox(height: 5),
        pw.Container(
            color: PdfColor.fromHex("#ABD9F3FF"),
            height: 50,
            child: pw.Row(
                children: [
                  _buildAppText(text: 'Bill Processed Date '),
                  pw.VerticalDivider()
                ]
            )
        ),
        pw.SizedBox(height: 10),
        _buildAppText(text: 'Admin & Infra Head Stamp with signature '),
      ],
    );
  }

  static pw.Widget _buildReportTitle() {
    return pw.Column(
      children: [
        _buildAppText(
          text: 'Work Completion Report',
          fontWeight: pw.FontWeight.bold,
          textAlign: pw.TextAlign.center,
        ),
        pw.Divider(color: PdfColors.grey500),

      ],
    );
  }

  static _buildReportDetails(HomeModel modelData) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(12.0),
      child: pw.Column(
        children: [
          _buildDetailRow(text: 'client Name', value: modelData.clientName),
          _buildDetailRow(text: 'Vendor No', value: modelData.vendorNo),
          _buildDetailRow(text: 'Technician No', value: modelData.technicianNo),
          _buildDetailRow(
            text: 'Approval Date',
            value: modelData.approvalDate.toString(),
          ),
          _buildDetailRow(
            text: 'WorkCompletion Date',
            value: modelData.workCompletionDate.toString(),
          ),
        ],
      ),
    );
  }

  //static Main Report
  static pw.Widget _buildDetailRow({required String text, required String value}) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 8.0),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              text,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          _buildAppText(text: ': '),
          pw.Expanded(child: _buildAppText(text: value.isNotEmpty ? value : '')),
        ],
      ),
    );
  }

  //workTable
  static _buildWorkTable(List<WorkTableModel> workItems) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey),

      columnWidths: {
        0: pw.FixedColumnWidth(50),
        1: pw.FlexColumnWidth(4),
        2: pw.FixedColumnWidth(65),
        3: pw.FixedColumnWidth(55),
      },

      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),

          children: [
            _tableHeader('S.No'),
            _tableHeader('Description'),
            _tableHeader('Quantity'),
            _tableHeader('Unit'),
          ],
        ),

        ...List.generate(workItems.length, (index) {
          final item = workItems[index];
          return pw.TableRow(
            children: [
              _tableCell(itemValue: '${index + 1}'),
              _tableCell(itemValue: item.workDescription),
              _tableCell(itemValue: item.quantity),
              _tableCell(itemValue: item.unit),
            ],
          );
        }),
      ],
    );
  }

  //table header
  static pw.Widget _tableHeader(String text) {
    return pw.Container(
      padding: pw.EdgeInsets.all(6),
      alignment: pw.Alignment.center,
      child: _buildAppText(text: text),
    );
  }

  //table cell
  static pw.Widget _tableCell({
    required String itemValue,
    pw.Alignment alignment = pw.Alignment.center,
  }) {
    return pw.Container(
      padding: pw.EdgeInsets.all(6),
      alignment: alignment,
      child: _buildAppText(text: itemValue),
    );
  }

  static pw.Widget _buildFooter(CompanyModel companyData)
  {
    return pw.Container(padding: pw.EdgeInsets.all(6),
       child: pw.Center(
        child: pw.Text('${companyData.companyName}@${DateTime.now().year}',style: pw.TextStyle(color: PdfColors.grey500)),
    )
    );
  }
}

pw.RichText _RichDetailText(String detailText, Object detailValue) {
  return pw.RichText(
    textAlign: pw.TextAlign.center,
    text: pw.TextSpan(
      children: [
        pw.TextSpan(
          text: '$detailText: ',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
        ),
        pw.TextSpan(
          text: detailValue.toString(),
          style: pw.TextStyle(fontSize: 14, font:PdfServicePage.poppinsMedium, fontWeight:pw.FontWeight.normal ),
        ),
        // TextSpan(),
      ],
    ),
  );
}

pw.Text _buildAppText({
  required String text,
  pw.TextAlign textAlign = pw.TextAlign.left,
  pw.FontWeight fontWeight = pw.FontWeight.bold,
  pw.TextDecoration textDecoration = pw.TextDecoration.none,
}) {
  return pw.Text(
    text,
    style: pw.TextStyle(
      color: PdfColors.black,
      fontSize: 16,
      font: PdfServicePage.poppinsMedium,
      fontWeight: fontWeight,
      letterSpacing: 0.1,
      decoration: textDecoration,
    ),
    textAlign: textAlign,
  );
}
