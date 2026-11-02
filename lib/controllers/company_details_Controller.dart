import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:karamtechnology_services/model/company_model.dart';
import 'package:karamtechnology_services/services/service_report_service.dart';

class CompanyDetailsController {
    final RxList<CompanyModel> companyModelData = <CompanyModel>[].obs;
    final RxString companyId=''.obs;
    final  userId=''.obs;
    final RxString companyName=''.obs;
    final RxString subTitle = ''.obs;
    final RxString companyAddress = ''.obs;
    final RxString contactNumber = ''.obs;
    final RxString email = ''.obs;
    final RxString gstIn= ''.obs;


    Future<CompanyModel?> getCompanyDetails(String companyId)
    async{
        try {
            final companyData = await ServiceReportService().getCompanyDetails(
                companyId);
            companyModelData.clear();
            if (companyData != null) {
                companyModelData.add(companyData);
                print('--COMPANY DATA-- ${companyData.companyId}');
                print('--COMPANY NAME-- ${companyData.companyName}');
                return companyData;
            }
            return null;
        }
        catch(e)
        {
            print('Error to get company Details: $e ');
            return null;
        }
    }
}