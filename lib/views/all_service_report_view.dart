import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karamtechnology_services/appConstant/app_color.dart';
import 'package:karamtechnology_services/appConstant/app_drawer.dart';
import 'package:karamtechnology_services/controllers/company_details_Controller.dart';
import 'package:karamtechnology_services/controllers/home_controller.dart';
import 'package:karamtechnology_services/controllers/work_table_controller.dart';
import 'package:karamtechnology_services/services/service_report_service.dart';
import 'package:karamtechnology_services/views/home_page_view.dart';

import '../controllers/signup_controller.dart';
import '../utils/App_text.dart';

class AllServiceReportView extends StatefulWidget
{
  String companyRefId;
  AllServiceReportView({super.key,required this.companyRefId});

  @override
  State<AllServiceReportView> createState() => _AllServiceReportViewState();
}

class _AllServiceReportViewState extends State<AllServiceReportView> {
  final signUpController = Get.find<SignUpController>();

  final workTableController = Get.find<WorkTableController>();
  final companyDetailsController = Get.find<CompanyDetailsController>();

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.scaffoldWhite,
        drawer: AppDrawer(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Obx(()
          {
            return AppBar(
              toolbarHeight: 70,
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.deepPurple,
              title: Text(
                companyDetailsController.companyName.value.isNotEmpty ? companyDetailsController.companyName.value : 'Service Report',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          })
        ),

        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.01,
            horizontal: MediaQuery.of(context).size.width * 0.01,
          ),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: ServiceReportService().getAllServiceReportList(widget.companyRefId),
            builder: (context, Snapshot) {
              if (Snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (Snapshot.hasError) {
                debugPrint('Firestore Error: ${Snapshot.error}');

                return Center(
                  child: AppText(
                    text: 'Unable to load data.',
                  ),
                );
              }

              if (!Snapshot.hasData || Snapshot.data!.docs.isEmpty)
              {
                return Center(child: Text('No Service Report Exists :('));
              }

              final reportId = Snapshot.data!.docs;

              return ListView.builder(
                itemCount: reportId.length,
                itemBuilder: (context, index) {
                  final doc = reportId[index];
                  final docId = doc.id;
                  final data = reportId[index].data();
                  final Timestamp? timestampDate = data['createdAt'];
                  final createdAt = timestampDate?.toDate();
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HomePageView(reportId: docId,companyRefId: widget.companyRefId,updateOption: true,),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.business, size: 22),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: AppText(
                                        text: data['saveName'] ?? 'Service_Report',
                                        fontSize: 17,
                                      ),
                                    ),
                                    Icon(
                                      Icons.update,
                                      color: AppColor.primaryColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    createdAt != null
                                        ? '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}'
                                        : 'no date',
                                    style: TextStyle(
                                      color: AppColor.primaryColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text(
                                    createdAt != null
                                        ? '${createdAt.hour % 12 == 0 ? 12 : createdAt.hour % 12}:${createdAt.minute.toString().padLeft(2, '0')} ${createdAt.hour < 12 ? 'AM' : 'PM'}'
                                        : 'no time',
                                    style: const TextStyle(
                                      color: Colors.deepPurpleAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        //service creation button
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async{
            workTableController.clearCurrentReportId();
            homeController.clearMainReportData();
            workTableController.clearWorkTableData();
            //new service report created
            final resultName = await Navigator.push<String>(
              context,
              MaterialPageRoute(builder: (context) => HomePageView(companyRefId: widget.companyRefId,)),
            );
            if(resultName!=null)
            {
              setState(() {
                homeController.saveName = resultName;
              });
            }
          },
          backgroundColor: AppColor.primaryColor,
          foregroundColor: AppColor.scaffoldWhite,
          extendedPadding: EdgeInsets.all(8),
          focusColor: Colors.grey,
          label: AppText(
            text: 'Add Report',
            color: AppColor.scaffoldWhite,
            fontSize: 16,
            letterSpacing: 0.3,
          ),
          elevation: 8,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
          ),
          icon: Icon(Icons.note_add_rounded, size: 24),
        ),
      ),
    );
  }
}
