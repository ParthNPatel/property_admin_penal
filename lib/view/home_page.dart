import 'package:flutter/material.dart';
import 'package:property/auth/views/login_view.dart';
import 'package:property/controller/handle_screen_controller.dart';
import 'package:property/view/add_category_screen.dart';
import 'package:property/view/add_property_screen.dart';
import 'package:property/view/edit_category_screen.dart';
import 'package:property/view/edit_property_screen.dart';
import 'package:property/view/property_inquiry_screen.dart';
import 'package:property/view/service_inquiry_screen.dart';
import 'package:sizer/sizer.dart';
import '../auth/email_auth/email_auth_services.dart';
import '../components/common_widget.dart';
import '../constant/color_const.dart';
import '../constant/text_styel.dart';
import '../responsive/responsive.dart';
import 'categories_screen.dart';
import 'dash_board_screen.dart';
import 'properties_screen.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();

  HandleScreenController controller = Get.find();

  List<Map<String, dynamic>> items = [
    {'name': "Dashboard", 'image': 'assets/images/dashboard.svg'},
    {'name': "Categories", 'image': 'assets/images/inbox.svg'},
    {'name': "Properties", 'image': 'assets/images/add_product.svg'},
    {'name': "Service Inquiry", 'image': 'assets/images/services.svg'},
    {'name': "Property Inquiry", 'image': 'assets/images/morgage.svg'},
    {'name': "Support", 'image': 'assets/images/support.svg'},
  ];

  int selected = 0;

  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      // drawer:
      //     Responsive.isDesktop(context) ? SizedBox() : drawerWidget(context),
      body: GetBuilder<HandleScreenController>(
        builder: (controller) => Row(
          children: [
            Flexible(
              flex: 2,
              child: Container(
                width: 40.w,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: CommonColor.greyColorD9D9D9,
                      blurRadius: 2,
                      spreadRadius: 2,
                      offset: Offset(0, 1))
                ]),
                child: Column(
                  children: [
                    SizedBox(
                      height: 3.h,
                    ),
                    CommonWidget.commonSvgPitcher(
                      image: 'assets/images/logo.svg',
                      height: 15.sp,
                      width: 30.sp,
                      color: themColors309D9D,
                    ),
                    // SizedBox(
                    //   height: 2.h,
                    // ),
                    // CircleAvatar(
                    //   radius: 15.sp,
                    //   backgroundImage: AssetImage('assets/images/user.png'),
                    // ),
                    // SizedBox(
                    //   height: 1.h,
                    // ),
                    // Column(
                    //   children: [
                    //     CommonText.textBoldWight500(
                    //         text: "Naman Sharma", fontSize: 8.sp),
                    //     SizedBox(
                    //       height: 3.sp,
                    //     ),
                    //     CommonText.textBoldWight500(
                    //         textDecoration: TextDecoration.underline,
                    //         text: "View Profile",
                    //         fontSize: 5.sp,
                    //         color: themColors309D9D),
                    //   ],
                    // ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Column(
                      children: List.generate(
                        items.length,
                        (index) => InkWell(
                          onTap: () {
                            setState(() {
                              selected = index;
                            });
                          },
                          child: Container(
                            height: 25.sp,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: selected == index
                                    ? Colors.grey.withOpacity(0.2)
                                    : Colors.white),
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.w),
                              child: Row(
                                children: [
                                  CommonWidget.commonSvgPitcher(
                                      image: items[index]['image'],
                                      height: 10.sp,
                                      width: 10.sp,
                                      color: selected == index
                                          ? themColors309D9D
                                          : Colors.grey.shade400),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  CommonText.textBoldWight500(
                                      text: items[index]['name'],
                                      fontSize: 5.sp,
                                      color: selected == index
                                          ? Colors.black
                                          : Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 1.h,
                    ),
                    InkWell(
                      onTap: () {
                        Get.dialog(AlertDialog(
                          title: Text("Are you sure that you want to Log Out?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('NO'),
                            ),
                            TextButton(
                              onPressed: () {
                                EmailAuth.logOut().then(
                                    (value) => Get.off(() => LoginView()));
                                Get.back();
                              },
                              child: Text('YES'),
                            ),
                          ],
                        ));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: Row(
                          children: [
                            Icon(
                              Icons.exit_to_app,
                              size: 10.sp,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            CommonText.textBoldWight500(
                              text: "Log Out",
                              fontSize: 5.sp,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            selected == 0
                ? DashBoardScreen()
                : selected == 1
                    ? controller.isTapped2 == true
                        ? AddCategoryScreen()
                        : controller.isTapped3 == true
                            ? EditCategoryScreen()
                            : CategoriesScreen()
                    : selected == 2
                        ? controller.isTapped == true
                            ? AddPropertyScreen()
                            : controller.isTapped1 == true
                                ? EditPropertyScreen()
                                : PropertiesScreen()
                        : selected == 3
                            ? ServiceInquiryScreen()
                            : selected == 4
                                ? PropertyInquiryScreen()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: Responsive.isDesktop(context)
                                            ? 200.sp
                                            : 70.sp,
                                      ),
                                      Text(
                                        "Coming Soon...",
                                        textScaleFactor: 2,
                                      ),
                                    ],
                                  )
          ],
        ),
      ),
    );
  }

// Drawer drawerWidget(BuildContext context) {
//   return Drawer(
//     child: Column(
//       children: [
//         SizedBox(
//           height: 2.h,
//         ),
//         CircleAvatar(
//           radius: 15.sp,
//           backgroundImage: AssetImage('assets/images/user.png'),
//         ),
//         SizedBox(
//           height: 1.h,
//         ),
//         Column(
//           children: [
//             CommonText.textBoldWight500(text: "Naman Sharma", fontSize: 8.sp),
//             SizedBox(
//               height: 3.sp,
//             ),
//             CommonText.textBoldWight500(
//                 textDecoration: TextDecoration.underline,
//                 text: "View Profile",
//                 fontSize: 5.sp,
//                 color: themColors309D9D),
//           ],
//         ),
//         SizedBox(
//           height: 2.h,
//         ),
//         Column(
//           children: List.generate(
//             4,
//             (index) => InkWell(
//               onTap: () {
//                 setState(() {
//                   selected = index;
//                 });
//               },
//               child: Container(
//                 height: 25.sp,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                     color: selected == index
//                         ? Colors.grey.withOpacity(0.2)
//                         : Colors.white),
//                 child: Padding(
//                   padding: EdgeInsets.only(left: 2.w),
//                   child: Row(
//                     children: [
//                       CommonWidget.commonSvgPitcher(
//                           image: items[index]['image'],
//                           height: 10.sp,
//                           width: 10.sp,
//                           color: selected == index
//                               ? themColors309D9D
//                               : Colors.grey.shade400),
//                       SizedBox(
//                         width: 3.w,
//                       ),
//                       CommonText.textBoldWight500(
//                           text: items[index]['name'],
//                           fontSize: 5.sp,
//                           color:
//                               selected == index ? Colors.black : Colors.grey),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         )
//       ],
//     ),
//   );
// }
}
