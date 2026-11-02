import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
class SignInController extends GetxController
{
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxString errorMsg =  ''.obs;

  @override
  void dispose()
  {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
