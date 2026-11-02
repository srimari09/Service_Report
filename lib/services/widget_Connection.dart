
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:karamtechnology_services/views/all_service_report_view.dart';
import 'package:karamtechnology_services/views/signin_page_view.dart';
import 'package:karamtechnology_services/views/signup_page_view.dart';
import '../views/company_registration_view.dart';
import 'auth_service.dart';

class WidgetLayoutConnection extends StatefulWidget {
  const WidgetLayoutConnection({super.key});

  @override
  State<WidgetLayoutConnection> createState() =>
      _WidgetLayoutConnectionState();
}

class _WidgetLayoutConnectionState
    extends State<WidgetLayoutConnection> {
  bool showSignUp = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, auth, child) {
        return StreamBuilder(
          stream: auth.authStateChanges,
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            }

            final user = authSnapshot.data;

            if (user != null) {
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>
                (
                stream: FirebaseFirestore.instance
                    .collection('companies')
                    .where('ownerUID', isEqualTo: user.uid)
                    .limit(1)
                    .snapshots(),

                builder: (context, companySnapshot) {

                  if (companySnapshot.connectionState == ConnectionState.waiting)
                  {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  }

                  if (companySnapshot.hasError)
                  {
                    return Scaffold(
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Unable to load company details: \n'
                                '${companySnapshot.error}',
                          ),
                        ),
                      ),
                    );
                  }

                  final companies = companySnapshot.data?.docs ?? [];

                  if (companies.isEmpty) {
                    return CompanyRegistrationView();
                  }

                  final companyRefId = companies.first.id;

                  return AllServiceReportView(
                    companyRefId: companyRefId,
                  );
                },
              );
            }

            if (showSignUp) {
              return SignUp(
                onSignInTap: () {
                  setState(() {
                    showSignUp = false;
                  });
                },
              );
            }

            return SignIn(
              onSignUpTap: () {
                setState(() {
                  showSignUp = true;
                });
              },
            );
          },
        );
      },
    );
  }
}



// import 'package:flutter/material.dart'
// import 'package:karamtechnology_services/controllers/company_details_Controller.dart';
// import 'package:karamtechnology_services/views/all_service_report_view.dart';
// import 'package:karamtechnology_services/views/signin_page_view.dart';
// import 'package:karamtechnology_services/views/signup_page_view.dart';
// import '../views/company_registration_view.dart';
// import 'auth_service.dart';
//
// class WidgetLayoutConnection extends StatefulWidget {
//   const WidgetLayoutConnection({super.key});
//
//   @override
//   State<WidgetLayoutConnection> createState() =>
//       _WidgetLayoutConnectionState();
// }
//
// class _WidgetLayoutConnectionState
//     extends State<WidgetLayoutConnection> {
//   final _companyDetailsController = CompanyDetailsController();
//
//   bool showSignUp = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//       valueListenable: authService,
//       builder: (context, auth, child) {
//         return StreamBuilder(
//           stream: auth.authStateChanges,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState ==
//                 ConnectionState.waiting) {
//               return const Scaffold(
//                 body: Center(
//                   child: CircularProgressIndicator.adaptive(),
//                 ),
//               );
//             }
//
//             if (snapshot.hasData) {
//               final companyRefId = _companyDetailsController.companyId.value;
//               if(companyRefId.isEmpty)
//                 {
//                  return CompanyRegistrationView();
//                 }
//               return AllServiceReportView(companyRefId:companyRefId,);
//             }
//
//             if (showSignUp) {
//               return SignUp(
//                 onSignInTap: () {
//                   setState(() {
//                     showSignUp = false;
//                   });
//                 },
//               );
//             }
//
//             return SignIn(
//               onSignUpTap: () {
//                 setState(() {
//                   showSignUp = true;
//                 });
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }