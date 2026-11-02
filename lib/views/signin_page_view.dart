
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:karamtechnology_services/utils/App_text.dart';
import 'package:karamtechnology_services/views/signup_page_view.dart';

import '../controllers/signin_controller.dart';
import '../services/auth_service.dart';

class SignIn extends StatelessWidget {
  final VoidCallback onSignUpTap;

  SignIn({
    super.key,
    required this.onSignUpTap
});

  final signInController = Get.find<SignInController>();
  final formKey = GlobalKey<FormState>();



  Future<void> signIn() async{
    final user = FirebaseAuth.instance.currentUser;
    try {
      await authService.value.signInWithEmailAndPassword(
        email: signInController.emailController.text.trim(),
        password: signInController.passwordController.text.trim(),
      );
      if (user != null) {
        print('LOGIN SUCCESS');
        print('UID: ${user.uid}');
        print('Email: ${user.email}');
      }
    }
      on FirebaseAuthException catch (e) {
      print('LOGIN FAILED');
      print('Code: ${e.code}');
      print('Message: ${e.message}');
      signInController.errorMsg.value = e.message ?? 'account creation failed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.sizeOf(context).height * 0.08,
            horizontal: MediaQuery.sizeOf(context).width * 0.08,
          ),
          child: Center(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login Your \n Account',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),
                GestureDetector(
                  onTap:
                    onSignUpTap,
                  child: Text(
                    'Create Own Account?',
                    style: TextStyle(fontSize: 16, fontWeight:FontWeight.bold,color: Colors.black),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EMAIL',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                // isDense: false,
                              ),
                              controller: signInController.emailController,
                            ),

                            SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PASSWORD',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.deepPurpleAccent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Password is required';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                // isDense: true,
                              ),
                              controller: signInController.passwordController,
                            ),

                            Obx(
                              () =>  AppText(
                                text: signInController.errorMsg.value,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 38),
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurpleAccent,
                                ),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    print('~~---------------~form valid~~------------~');
                                    signIn();
                                  } else {
                                    print('~~---------------~~invalid~~---------------~~');
                                  }
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
