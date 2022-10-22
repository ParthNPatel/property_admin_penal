import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property/view/add_product_screen.dart';
import 'package:property/view/edit_product_screen.dart';
import 'package:property/view/home_page.dart';
import 'package:sizer/sizer.dart';

import 'controller/edit_product_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDT17HzMpYeBt6C_cYlCzQscKUdEheTO5o",
        authDomain: "property-53eb7.firebaseapp.com",
        projectId: "property-53eb7",
        storageBucket: "property-53eb7.appspot.com",
        messagingSenderId: "210888755019",
        appId: "1:210888755019:web:e242a2330a9b89697b0ace",
        measurementId: "G-GNWQ3SH428"),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        // home: HomePage(),
        debugShowCheckedModeBanner: false, initialBinding: BaseBindings(),
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/AddProduct': (context) => AddProductScreen(),
          '/EditProduct': (context) => EditProductScreen(),
        },
        title: 'Inzoid Admin Panel',
      ),
    );
  }
}

class BaseBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProductController(), fenix: true);
  }
}
