import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karamtechnology_services/controllers/company_details_Controller.dart';
import 'package:karamtechnology_services/model/company_model.dart';
import 'package:karamtechnology_services/services/service_report_service.dart';
import 'package:karamtechnology_services/views/all_service_report_view.dart';
import '../services/auth_service.dart';


class CompanyRegistrationView extends StatefulWidget
{
  final bool update;
  CompanyRegistrationView({super.key,this.update = false});

  @override
  State<CompanyRegistrationView> createState() => CompanyRegistrationViewState();
}

class CompanyRegistrationViewState extends State<CompanyRegistrationView> {
final  CompanyDetailsController companyDetailsController = Get.find<CompanyDetailsController>();
  final ServiceReportService _serviceReportService = ServiceReportService();

  final companyNameController = TextEditingController();
  final companySubTitleController = TextEditingController();
  final companyAddressController = TextEditingController();
  final contactNumberController = TextEditingController();
  final companyEmailController = TextEditingController();
  final companyGstInController = TextEditingController();

  final companyId = TextEditingController(); // newly register company id
  final ownerId = TextEditingController(); // newly register user id

  final formKey = GlobalKey<FormState>();

  Future<void> registerCompany() async {
    try
    {
      final currentUser = authService.value.currentUser;
      if(currentUser==null)
        {
        print('User Not Login');
        // GestureDetector(onTap: onSignInTap,);
        Get.back();
        return;
      }
      if(widget.update == true)
        {
        final  companyRegisterId =  currentUser.uid;
          final companyDetail = CompanyModel(
              companyId: companyDetailsController.userId.value,
              ownerUId: companyDetailsController.userId.value,
              companyName: companyDetailsController.companyName.value,
              subTitle: companyDetailsController.subTitle.value,
              companyAddress: companyDetailsController.companyAddress.value,
              email: companyDetailsController.email.value,
              contactNumber: companyDetailsController.contactNumber.value,
              gstIn: companyDetailsController.gstIn.value
          );

          final companyRefId = await _serviceReportService.
          updateCompanyDetails(companyRegisterId,companyDetail);
          print('Company updated successfully: $companyRefId');
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => AllServiceReportView(
              companyRefId: companyRefId,
            ),
          ),
        );
        }
      else
      {
        companyDetailsController.userId.value = currentUser.uid;
        final companyDetail = CompanyModel(
            companyId: companyDetailsController.userId.value,
            ownerUId: companyDetailsController.userId.value,
            companyName: companyDetailsController.companyName.value,
            subTitle: companyDetailsController.subTitle.value,
            companyAddress: companyDetailsController.companyAddress.value,
            email: companyDetailsController.email.value,
            contactNumber: companyDetailsController.contactNumber.value,
            gstIn: companyDetailsController.gstIn.value
        );

        final companyRefId = await _serviceReportService.addCompanyDetails(companyDetail);

        companyDetailsController.companyId.value=companyRefId;
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => AllServiceReportView(
              companyRefId: companyRefId,
            ),
          ),
        );
        // Error in registration This widget has been unmounted, so the State no longer so as a context (so comment below and replaced above).
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>AllServiceReportView( companyRefId: companyRefId,)));
        print('Company registered successfully: $companyRefId');
      }
    }
    catch (e)
    {
      print('Error in registration : $e');
      return;
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
                  'Register Your \n Company',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
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
                          'Company Name',
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
                          controller: companyNameController,
                          keyboardType: TextInputType.name,
                          onChanged: (value)
                          {
                            companyDetailsController.companyName.value = value.trim().toUpperCase();
                          },
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Company Slogan or About',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextFormField(
                          maxLines: 2,
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          controller: companySubTitleController,
                          keyboardType: TextInputType.name,
                          onChanged: (value)
                          {
                            companyDetailsController.subTitle.value = value.trim();
                          },
                        ),
                        SizedBox(height: 10),
                        Text(
                          'COMPANY EMAIL',
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
                          controller: companyEmailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value)
                          {
                            companyDetailsController.email.value = value.trim();
                          },
                        ),
                        SizedBox(height: 10),
                        Text(
                          'COMPANY ADDRESS',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Address is required';
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
                          controller: companyAddressController,
                          obscureText: false,
                          onChanged: (value)
                          {
                            companyDetailsController.companyAddress.value = value.trim();
                          },
                        ),
                        SizedBox(height: 10),
                        Text(
                          'CONTACT NUMBER',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty)
                            {
                              return 'Contact number is required';
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
                          controller: contactNumberController,
                          obscureText: false,
                          onChanged: (value)
                          {
                            companyDetailsController.contactNumber.value = value.trim();
                          },
                        ),
                        SizedBox(height: 10),

                        Text(
                          'GST IN',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextFormField(

                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'GST Number required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8), )
                            ,
                          ),
                          controller: companyGstInController,
                          onChanged: (value)
                          {
                            companyDetailsController.gstIn.value = value.trim();
                          },
                        ),
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
                        await registerCompany();

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
                    child: Text('SUBMITTED'),
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
