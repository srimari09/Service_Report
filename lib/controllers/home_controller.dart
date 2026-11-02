import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:karamtechnology_services/controllers/work_table_controller.dart';
import 'package:karamtechnology_services/model/company_model.dart';
import 'package:karamtechnology_services/services/service_report_service.dart';

import '../model/home_model.dart';

class HomeController extends GetxController
{
  final RxList<HomeModel> homeModelData = <HomeModel>[].obs;
  final WorkTableController workTableController = Get.find<WorkTableController>();
  final RxString clientName = ''.obs;
  final RxString vendorNo = ''.obs;
  final RxString technicianNo = ''.obs;
   String saveName = '';
  Rxn<DateTime> approvalDate = Rxn<DateTime>();
  Rxn<DateTime> workCompletionDate = Rxn<DateTime>();

  final box2 = GetStorage();

  final ServiceReportService _serviceReportService = ServiceReportService();

  //Register company details and get companyId
  Future<String>  RegisterCompanyGetCompanyId(CompanyModel companyData) async
  {
    try{
      final companyId = await _serviceReportService.addCompanyDetails(companyData);
      return companyId;
    }
    catch(e)
    {
      print('ERROR DURING REGISTER THE COMPANY: $e');
      return '';
    }
  }




  //CREATE
  Future<String?> createMainReport(String companyId,HomeModel report) async
  {
    try{
      final reportId = await _serviceReportService.addReport(companyId,report);
      print('____________REPORT ID : ${reportId}______________');
      return reportId;
    }
    catch(e)
    {
      print('-----------------ERROR CREATING MAIN REPORT : ${e}______________');
    }
    return null;
  }

  //READ REPORT
  Future<HomeModel?> readMainReport(String companyId,String reportId) async
  {
    try{
      final report = await _serviceReportService.getMainReport(companyId,reportId);

      if(report!=null)
        {
          homeModelData.clear();
          homeModelData.add(report);
          print('Main Report Loaded: $reportId');
          return report;
        }
      print('Main Report Not Found: $reportId');
      return null;
    } catch (e) {
      print(
        '----------------- ERROR IN READING MAIN REPORT : $e -----------------',
      );
      return null;
    }
  }

  //UPDATE REPORT

  Future<void> updateMainReport(String companyId,String reportId, HomeModel report) async {
    try {
      await _serviceReportService.updatedMainReport(companyId,reportId, report);
      print('Updated Report : $reportId');
    }
    catch (e) {
      print(
          '-----------------ERROR IN UPDATING MAIN REPORT : ${e}______________');
    }
  }

  //DELETE REPORT
  Future<void> deleteMainReport(String companyId,String reportId) async{
    try{
      await _serviceReportService.deleteMainReport(companyId,reportId);
      homeModelData.clear();
      print('Main Report Deleted: $reportId');
    }
    catch(e)
    {
      '-----------------ERROR IN DELETING MAIN REPORT : ${e}______________';
    }
  }


  //---------------------------------------------------------------//
//          CLEAR LOCAL MAIN REPORT DATA
//---------------------------------------------------------------//

  void clearMainReportData() {
    clientName.value = '';
    vendorNo.value = '';
    technicianNo.value = '';

    approvalDate.value = null;
    workCompletionDate.value = null;

    print('--MAIN REPORT DATA CLEARED--');
  }
}