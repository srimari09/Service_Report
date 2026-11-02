import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:karamtechnology_services/services/widget_Connection.dart';
import 'firebase_options.dart';
import 'package:karamtechnology_services/bindings/initial_bindings.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final user = FirebaseAuth.instance.currentUser;

  print('________________Current Firebase User:______________ $user');

  if (user != null) {
    print('~~~~~~~~~~~~~~~UID:~~~~~~~~~~~~~~~ ${user.uid}');
    print('Email: ${user.email}');
  } else {
    print('NO USER - Firebase session is empty');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // initialRoute:Routes.widgetLayoutConnection,
      initialBinding: InitialBindings(),
      // getPages: AppPages.routes,
      home:  WidgetLayoutConnection(),
    );
  }
}


