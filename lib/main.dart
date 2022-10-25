import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:property/auth/views/signUp_view.dart';
import 'package:property/controller/edit_category_controller.dart';
import 'package:property/view/add_property_screen.dart';
import 'package:property/view/edit_property_screen.dart';
import 'package:property/view/home_page.dart';
import 'package:sizer/sizer.dart';
import 'auth/controller/simple_ui_controller.dart';
import 'auth/views/login_view.dart';
import 'constant/color_const.dart';
import 'controller/edit_property_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  await GetStorage.init();
  var email;
  try {
    email = FirebaseAuth.instance.currentUser!.email;
  } catch (e) {
    email = null;
  }

  runApp(MyApp(
    userEmail: email,
  ));
}

class MyApp extends StatelessWidget {
  final userEmail;

  const MyApp({super.key, required this.userEmail});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(primary: themColors309D9D),
        ),
        debugShowCheckedModeBanner: false,
        initialBinding: BaseBindings(),
        initialRoute: userEmail != null ? '/HomePage' : '/',
        routes: {
          '/': (context) => LoginView(),
          '/SignUp': (context) => SignUpView(),
          '/HomePage': (context) => HomePage(),
          '/AddProperty': (context) => AddPropertyScreen(),
          '/EditProperty': (context) => EditPropertyScreen(),
        },
        title: 'Property Admin Panel',
      ),
    );
  }
}

class BaseBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditPropertyController(), fenix: true);
    Get.lazyPut(() => EditCategoryController(), fenix: true);
    Get.lazyPut(() => SimpleUIController(), fenix: true);
  }
}
