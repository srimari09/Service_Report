import 'package:get/get.dart';
import 'package:karamtechnology_services/controllers/company_details_Controller.dart';
import 'package:karamtechnology_services/controllers/home_controller.dart';

import '../controllers/signin_controller.dart';
import '../controllers/signup_controller.dart';
import '../controllers/work_table_controller.dart';

class InitialBindings extends Bindings
{
  @override
  void dependencies() {
    Get.lazyPut(()=>SignUpController());
    Get.lazyPut(()=>SignInController());
    Get.lazyPut(()=>HomeController());
    Get.lazyPut(()=>WorkTableController());
    Get.put<CompanyDetailsController>(
      CompanyDetailsController(),
      permanent: true,
    );
  }
}