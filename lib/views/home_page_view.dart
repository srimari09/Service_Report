import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:karamtechnology_services/appConstant/app_color.dart';
import 'package:karamtechnology_services/controllers/company_details_Controller.dart';
import 'package:karamtechnology_services/controllers/home_controller.dart';
import 'package:karamtechnology_services/model/home_model.dart';
import 'package:karamtechnology_services/services/create_pdf_service.dart';
import 'package:karamtechnology_services/services/service_report_service.dart';
import 'package:karamtechnology_services/utils/dialogue_widget.dart';
import '../controllers/work_table_controller.dart';
import 'package:get/get.dart';
import '../utils/App_text.dart';
import '../utils/clientVerficationWidget.dart';
import '../utils/detail_text.dart';
import '../utils/show_dailog_textfield.dart';
import '../utils/static_textfield.dart';

class HomePageView extends StatefulWidget {
  final String? reportId;
  final String companyRefId;
  final bool updateOption;

  HomePageView({
    super.key,
    this.reportId,
    required this.companyRefId,
    this.updateOption = false,
  });

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  TextEditingController saveNameController = TextEditingController();

  TextEditingController clientNameController = TextEditingController();

  TextEditingController vendorNoController = TextEditingController();

  TextEditingController approvalDateController = TextEditingController();

  TextEditingController workCompletionController = TextEditingController();

  TextEditingController technicianNoController = TextEditingController();

  final WorkTableController workTableController =
      Get.find<WorkTableController>();

  final HomeController homeController = Get.find<HomeController>();
  final CompanyDetailsController companyDetailsController =
      Get.find<CompanyDetailsController>();

  @override
  void initState() {
    super.initState();
    loadCompanyDetails();
    print('REPORT ID: ${widget.reportId}');
    print('UPDATE OPTION: ${widget.updateOption}');
    if (widget.reportId != null && widget.updateOption == true) {
      fetchData();
    }
  }

  Future<void> loadCompanyDetails() async {
    try {
      final company = await ServiceReportService().getCompanyById(
        widget.companyRefId,
      );
      if (!mounted) return;

      if (company == null) {
        debugPrint('No company found for UID: $company.id');
        return;
      }

      companyDetailsController.companyId.value = company.companyId;
      companyDetailsController.userId.value = company.ownerUId;
      companyDetailsController.companyName.value = company.companyName;
      companyDetailsController.subTitle.value = company.subTitle;
      companyDetailsController.companyAddress.value = company.companyAddress;
      companyDetailsController.contactNumber.value = company.contactNumber;
      companyDetailsController.email.value = company.email;
      companyDetailsController.gstIn.value = company.gstIn;

      debugPrint('Company loaded: ${company.companyName}');
      debugPrint('Company ID: ${company.companyId}');
    } catch (e, stackTrace) {
      debugPrint('Failed to load company details: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> fetchData() async {
    if (widget.reportId == null) return;
    final basicData = await ServiceReportService().getMainReport(
      widget.companyRefId,
      widget.reportId!,
    );
    final workTableData = await ServiceReportService().getWorkTableData(
      widget.companyRefId,
      widget.reportId!,
    );

    if (basicData != null) {
      clientNameController.text = basicData.clientName;
      vendorNoController.text = basicData.vendorNo;
      technicianNoController.text = basicData.technicianNo;
      saveNameController.text = basicData.saveName;
      if (basicData.approvalDate != null) {
        approvalDateController.text =
            '${basicData.approvalDate!.day.toString().padLeft(2, '0')}/${basicData.approvalDate!.month.toString().padLeft(2, '0')}/${basicData.approvalDate!.year}';
        homeController.approvalDate.value = basicData.approvalDate;
      }
      if (basicData.workCompletionDate != null) {
        workCompletionController.text =
            '${basicData.workCompletionDate!.day.toString().padLeft(2, '0')}/${basicData.workCompletionDate!.month.toString().padLeft(2, '0')}/${basicData.workCompletionDate!.year}';
        homeController.workCompletionDate.value = basicData.workCompletionDate;
      }
      homeController.clientName.value = basicData.clientName;
      homeController.vendorNo.value = basicData.vendorNo;
      homeController.technicianNo.value = basicData.technicianNo;
      homeController.saveName = basicData.saveName;
    }
    if (workTableData != null) {
      workTableController.workTableData.assignAll(workTableData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            toolbarHeight: 70,
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: AppColor.secondaryColor,
            title: AppText(
              text: 'SERVICE REPORT',
              fontSize: 16,
              color: AppColor.scaffoldWhite,
              letterSpacing: 0.6,
            ),
            actions: [
              Row(
                children: [
                  GestureDetector(
                    child: Icon(Icons.download),
                    onTap: () async {
                      final fileNameController = TextEditingController();
                      fileNameController.text = homeController.saveName;
                      try {
                        print(
                          '____________Inside the dialogue entering____________________',
                        );
                        final fileName = await ShowDailogTextfield.show(
                          context: context,
                          title: 'Download File',
                          message: 'Download the Report!',
                          fileTextController: fileNameController,
                        );
                        print('____________Inside the dialogue completed');

                        if (fileName == null || fileName.trim().isEmpty) {
                          return;
                        }

                        await downloadServiceReport(fileName.trim());
                      } catch (e, stackTrace) {
                        debugPrint('Dialog error: $e');
                        debugPrintStack(stackTrace: stackTrace);
                        return;
                      }
                    },
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    child: Icon(Icons.save),
                    onTap: () async {
                      //-----------------------------------

                      //------------- UPDATE----------------

                      if (widget.updateOption == true) {
                        try {
                          final report = HomeModel(
                            clientName: homeController.clientName.value,
                            vendorNo: homeController.vendorNo.value,
                            approvalDate: homeController.approvalDate.value,
                            workCompletionDate:
                                homeController.workCompletionDate.value,
                            technicianNo: homeController.technicianNo.value,
                            saveName: homeController.saveName,
                          );

                          await homeController.updateMainReport(
                            widget.reportId!,
                            widget.companyRefId,
                            report,
                          );
                          for (
                            int index = 0;
                            index < workTableController.workTableData.length;
                            index++
                          ) {
                            final item =
                                workTableController.workTableData[index];

                            if (item.id.isEmpty) {
                              await workTableController
                                  .addWorkItemIntoFirestore(
                                    widget.companyRefId,
                                    widget.reportId!,
                                    item,
                                    index,
                                  );
                            } else {
                              await workTableController
                                  .updateWorkItemToFirestore(
                                    widget.companyRefId, //companyId
                                    widget.reportId!,
                                    item.id, //workDocRefId
                                    item, //work
                                    index, // Item
                                  );
                            }
                          }
                          Get.snackbar(
                            'success',
                            'service report updated successfully',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColor.secondaryColor,
                            colorText: Colors.white,
                          );
                          print('REPORT SAVED: $report.id');
                          Navigator.pop(context);
                        } catch (e) {
                          print('ERROR FOR UPDATING THE REPORT : $e');
                          Get.snackbar(
                            'Update Failed',
                            'Could not update the report. Please try again.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                        }
                      }
                      //-----------------------------------
                      //------------- CREATE----------------
                      else {
                        try {
                          var saveNameText = await ShowDailogTextfield.show(
                            context: context,
                            title: 'Save',
                            message: 'Enter The File Name',
                            fileTextController: saveNameController,
                          );
                          if (saveNameText == null ||
                              saveNameText.trim().isEmpty) {
                            return;
                          }

                          final finalSaveText = await ServiceReportService()
                              .fileNameStore(widget.companyRefId, saveNameText);

                          final report = HomeModel(
                            clientName: homeController.clientName.value,
                            vendorNo: homeController.vendorNo.value,
                            approvalDate: homeController.approvalDate.value,
                            workCompletionDate:
                                homeController.workCompletionDate.value,
                            technicianNo: homeController.technicianNo.value,
                            saveName: '${finalSaveText.trim()}',
                          );

                          //create main report
                          final newReportId = await ServiceReportService()
                              .addMainReportWithAllWorkItems(
                                widget.companyRefId,
                                report,
                                workTableController.workTableData.toList(),
                              );

                          workTableController.currentReportId = newReportId;

                          debugPrint('--Report SAVED ID--:$newReportId');
                          if (!context.mounted) {
                            return;
                          }
                          saveNameController.clear();

                          Get.snackbar(
                            'Success',
                            'Service report saved successfully',
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: Colors.white,
                            backgroundColor: Colors.deepPurpleAccent.shade400,
                          );
                          print('REPORT SAVED: $newReportId');
                          Navigator.pop(context, finalSaveText.trim());
                        }
                        catch (e, stackTrace) {
                          debugPrint('_______Error in Creating service Report:______ $e');
                          debugPrintStack(stackTrace: stackTrace);
                          if (!context.mounted) return;
                          Get.snackbar(
                            'Creation Failed',
                            'Could not create the report. Please try again.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                          return;
                        }
                      }
                    },
                  ),
                  SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.02,
              horizontal: MediaQuery.of(context).size.width * 0.02,
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(() {
                  return Column(
                    children: [
                      Obx(
                        () => AppText(
                          text:
                              companyDetailsController.companyName.value.isEmpty
                              ? 'Register Your Company'
                              : companyDetailsController.companyName.value,
                          fontSize: 18,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppText(
                        text: companyDetailsController.subTitle.value,
                        // 'IT Infrastructure | Glass Works | Civil & Interior Solutions',
                        fontSize: 13,
                        color: Colors.deepPurple,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 8),
                      detailText(
                        'Address',
                        companyDetailsController.companyAddress.value,
                      ),
                      detailText(
                        'Contact',
                        companyDetailsController.contactNumber.value,
                      ),
                      detailText('Email', companyDetailsController.email.value),
                      detailText(
                        'GST IN',
                        companyDetailsController.gstIn.value,
                      ),
                      Divider(),
                    ],
                  );
                }),
                Column(
                  children: [
                    AppText(
                      text: 'Work Completion Report',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    ),
                    Divider(),

                    Row(
                      children: [
                        AppText(text: 'Client Name  '),

                        Expanded(
                          child: StaticTextFormField(
                            textEditingController: clientNameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Client Name is Required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              homeController.clientName.value = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AppText(text: 'Vendor Code  '),
                        Expanded(
                          child: StaticTextFormField(
                            textEditingController: vendorNoController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'vendor code is Required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              homeController.vendorNo.value = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AppText(text: 'Technicians Count'),
                        Expanded(
                          child: StaticTextFormField(
                            textEditingController: technicianNoController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Technicians Number is required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              homeController.technicianNo.value = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(text: 'Approval Date  '),
                        Expanded(
                          child: StaticTextFormField(
                            textEditingController: approvalDateController,
                            // suffixIcon: Icon(
                            //   Icons.calendar_month,
                            //   color: Colors.blue,
                            //   size: 20,
                            // ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1990),
                                lastDate: DateTime.now(),
                              );

                              if (pickedDate != null) {
                                approvalDateController.text =
                                    '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                                homeController.approvalDate.value = pickedDate;
                              }
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'ApprovalDate is Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(text: 'Completion Date  '),
                        Expanded(
                          child: StaticTextFormField(
                            textEditingController: workCompletionController,
                            // suffixIcon: Icon(
                            //   Icons.calendar_month,
                            //   color: Colors.blue,
                            //   size: 20,
                            // ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1990),
                                lastDate: DateTime.now(),
                              );

                              if (pickedDate != null) {
                                workCompletionController.text =
                                    '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                                homeController.workCompletionDate.value =
                                    pickedDate;
                              }
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Work Completion Date is Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                workTable(),
                SizedBox(height: 15),
                clientVerificationAdmin(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget workTable() {
    return Column(
      children: [
        Obx(
          () => Table(
            border: TableBorder.all(),
            columnWidths: const {
              0: FixedColumnWidth(50), // sno
              1: FlexColumnWidth(6), // desc
              2: FixedColumnWidth(50), // quantity
              3: FixedColumnWidth(50), // unit
            },
            children: [
              TableRow(
                children: [
                  AppText(
                    text: 'SNo',
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  AppText(
                    text: 'Work Description',
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  AppText(
                    text: 'Qty',
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  AppText(
                    text: 'Unit',
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              ...List.generate(workTableController.workTableData.length, (
                index,
              ) {
                final workData = workTableController.workTableData[index];
                return TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextFormField(
                            key: ValueKey('serial_${identityHashCode(workData)}'),
                            initialValue: (index + 1).toString(),
                            textAlign: TextAlign.center,
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                          Builder(
                            builder: (context) => GestureDetector(
                              onTap: () async {
                                // Capture the actual row before awaiting the dialog.
                                final item = workData;
                                final itemId = item.id;
                                final result = await DialogueWidget.show(
                                  context: context,
                                  title: 'Delete Row?',
                                  titleColor: Colors.red,
                                  message: 'Are you sure you want to delete this row?',
                                  confirmText: 'Delete',
                                  cancelText: 'Cancel',
                                );

                                if (result != true) return;

                                try {
                                  if (itemId.isNotEmpty) {
                                    await workTableController
                                        .deleteWorkItemFromFirestore(
                                          widget.companyRefId,
                                          widget.reportId!,
                                          itemId,
                                        );
                                  } else {
                                    final currentIndex = workTableController
                                        .workTableData
                                        .indexWhere(
                                          (element) => identical(element, item),
                                        );
//testing:
                                    debugPrint(
                                      'Deleting unsaved item: ${identityHashCode(item)}',
                                    );
                                    debugPrint('Current index: $currentIndex');
                                    debugPrint(
                                      'List: ${workTableController.workTableData.map((e) => identityHashCode(e)).toList()}',
                                    );

                                    if (currentIndex != -1) {
                                      workTableController.workTableData
                                          .removeAt(currentIndex);
                                    }
                                  }

                                  Get.snackbar(
                                    'Deleted',
                                    'Work item deleted successfully',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                } catch (e) {
                                  debugPrint('Delete error: $e');

                                  Get.snackbar(
                                    'Delete Failed',
                                    'Could not delete work item',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: TextFormField(
                        key: ValueKey( 'description_${identityHashCode(workData)}'),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 2,
                          ),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        initialValue: workData.workDescription,
                        onChanged: (value) {
                          workTableController.updateWorkData(
                            index: index,
                            description: value,
                          );
                        },
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: TextFormField(
                        key: ValueKey('quantity_${identityHashCode(workData)}'),

                        textAlign: TextAlign.center,
                        decoration: InputDecoration(border: InputBorder.none),
                        initialValue: workData.quantity.toString(),
                        onChanged: (value) {
                          workTableController.updateWorkData(
                            index: index,
                            quantity: value.toString(),
                          );
                        },
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: TextFormField(
                        key: ValueKey('unit_${identityHashCode(workData)}'),
                        decoration: InputDecoration(border: InputBorder.none),
                        textAlign: TextAlign.center,
                        maxLines: null,
                        initialValue: workData.unit,
                        onChanged: (value) {
                          workTableController.updateWorkData(
                            index: index,
                            unit: value,
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: InkWell(
            onTap: () {
              workTableController.addWorkData();
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.add, color: AppColor.primaryColor),
                ),
                AppText(text: 'Add Row', color: AppColor.primaryColor),
              ],
            ),
          ),
        ),
      ],
    );
  }



  // DOWNLOAD FUNCTION IN SERVICE REPORT

  Future<void> downloadServiceReport(String fileName) async {
    try {
      //save report before downloading - check
      if (widget.reportId == null || widget.reportId!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Save the File, before Downloading...'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      //get the basic report data
      final reportData = await homeController.readMainReport(
        widget.companyRefId,
        widget.reportId!,
      );
      if (reportData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Downloaded Failed. Something Went Wrong :('),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      //get the worktable data within the report
      final workItemsData = await workTableController.readWorkItemFromFirestore(
        widget.companyRefId,
        widget.reportId!,
      );

      //get the company data within the report
      final companyData = await companyDetailsController.getCompanyDetails(
        widget.companyRefId,
      );

      if (companyData == null) {
        throw Exception('Company Details are not found');
      }

      //Pdf creation
      final Uint8List pdfBytes = await PdfServicePage.generateServiceReportPdf(
        companyData: companyData,
        report: reportData,
        worktItems: workItemsData,
      );

      print(
        '-------------------------------------------------------user filename',
      );

      //clean user file name
      String safeFileName = fileName.trim();
      safeFileName = safeFileName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
      if (safeFileName.isEmpty) {
        safeFileName = reportData.saveName.toString();
      }
      //remove .pdf is user enters
      if (safeFileName.toLowerCase().endsWith('.pdf')) {
        safeFileName = safeFileName.substring(0, safeFileName.length - 4);
      }

      final finalFileName = safeFileName.trim().toString();
      print('---save download---');

      //Save download
      final result = await FileSaver.instance.saveAs(
        name: finalFileName,
        bytes: pdfBytes,
        fileExtension: 'pdf',
        mimeType: MimeType.pdf,
      );

      if (result == null) {
        debugPrint('PDF save cancelled or failed');
        return;
      }

      debugPrint('PDF save result: $result');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Downloaded successfully: $finalFileName.pdf'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      debugPrint('----------------------------------PDF ERROR: $e');
      debugPrintStack();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Downloaded Failed :('),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
