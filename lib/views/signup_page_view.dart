import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:karamtechnology_services/services/widget_Connection.dart';

import '../controllers/signup_controller.dart';
import '../services/auth_service.dart';
import '../utils/App_text.dart';

class SignUp extends StatelessWidget {

  final VoidCallback onSignInTap;

  SignUp({
    super.key,
    required this.onSignInTap
});

  final signUpController = Get.find<SignUpController>();
  final formKey = GlobalKey<FormState>();

  Future<void> createAccount() async {
    try {
      final credential = await authService.value
          .createAccountWithEmailAndPassword(
            email: signUpController.emailController.text.trim(),
            password: signUpController.passwordController.text.trim(),
          );

      final user = credential.user;
      if (user != null) {
        // Save the signup name in Firebase Authentication
        await user.updateDisplayName(signUpController.nameController.text.trim(),);

        // Refresh user details
        await user.reload();

        final updatedUser = authService.value.currentUser;

        print('User created successfully');
        print('UID: ${updatedUser?.uid}');
        print('Email: ${updatedUser?.email}');
        print('Display Name: ${updatedUser?.displayName}');
      }
      // await authService.value.updateUserName(userName: signUpController.nameController.text.trim());
      else {
        print('No user created');
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error');
      print('Code: ${e.code}');
      print('Message: ${e.message}');

      signUpController.errorMsg.value = e.message ?? 'Account creation failed';
    } catch (e) {
      print('Unknown Error: $e');

      signUpController.errorMsg.value = 'Account creation failed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.sizeOf(context).height * 0.08,
              horizontal: MediaQuery.sizeOf(context).width * 0.08,
            ),
            child: Column(
              children: [
                Text(
                  'Create New \n Account',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),
                GestureDetector(

                  onTap: onSignInTap,
                  child: Text(
                  'Already Registered? Login in here',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                ),
                SizedBox(height: 19),
                Center(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'NAME',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.deepPurpleAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Name is required';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            controller: signUpController.nameController,
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'EMAIL',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.deepPurpleAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
                            ),

                            controller: signUpController.emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'PASSWORD',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.deepPurpleAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'password is required';
                              }
                              if (value.length < 6) {
                                return 'password atleast 6 character';
                              }
                              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                return ' Both UpperCase and numbers required';
                              }
                              if (!RegExp(r'[0-9]').hasMatch(value)) {
                                return 'Numbers required for strong password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            controller: signUpController.passwordController,
                            obscureText: false,
                          ),
                          SizedBox(height: 10),

                          Text(
                            'DATE OF BIRTH',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.deepPurpleAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextFormField(
                            readOnly: true,
                            validator: (value) {
                              if (value == null) {
                                return 'date of birth required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffixIcon: Icon(
                                Icons.date_range,
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                            controller: signUpController.dobController,

                            onTap: () async {
                              final today = DateTime.now();
                              final eighteenPlus = DateTime(
                                today.year - 18,
                                today.month,
                                today.day,
                              );

                              DateTime? pickDate = await showDatePicker(
                                context: context,
                                initialDate: eighteenPlus,
                                firstDate: DateTime(1990),
                                lastDate: eighteenPlus,
                              );
                              if (pickDate != null) {
                                signUpController.dobController.text =
                                    '${pickDate.day}/${pickDate.month}/${pickDate.year}';
                              }
                            },
                          ),
                          Obx(() {
                            if (signUpController.errorMsg.value.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return AppText(
                              text: signUpController.errorMsg.value,
                              color: Colors.red,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        print('~~--------~~valid form~~~~');
                        await createAccount();

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => HomePageView()
                        //   ),
                        // );
                      } else {
                        print('~~---------------------3~~invalid form----');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    child: Text('SIGN UP'),
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
