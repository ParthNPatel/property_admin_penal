import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../components/common_widget.dart';
import '../constant/color_const.dart';
import '../constant/text_styel.dart';
import '../responsive/responsive.dart';
import 'add_property_screen.dart';
import 'dash_board_screen.dart';
import 'properties_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();

  List<Map<String, dynamic>> items = [
    {'name': "Dashboard", 'image': 'assets/images/dashboard.svg'},
    {'name': "Properties", 'image': 'assets/images/add_product.svg'},
    {'name': "Inbox", 'image': 'assets/images/inbox.svg'},
    {'name': "Support", 'image': 'assets/images/support.svg'},
  ];

  int selected = 0;

  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      drawer:
          Responsive.isDesktop(context) ? SizedBox() : drawerWidget(context),
      body: Row(
        children: [
          Responsive.isDesktop(context)
              ? Flexible(
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
                            4,
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
                        )
                      ],
                    ),
                  ),
                )
              : SizedBox(),
          selected == 0
              ? DashBoardScreen()
              : selected == 1
                  ? PropertiesScreen(
                      globalKey: globalKey,
                    )
                  : selected == 2
                      ? Center(child: Text("Inbox"))
                      : Center(child: Text("Support"))
        ],
      ),
    );
  }

  Drawer drawerWidget(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 2.h,
          ),
          CircleAvatar(
            radius: 15.sp,
            backgroundImage: AssetImage('assets/images/user.png'),
          ),
          SizedBox(
            height: 1.h,
          ),
          Column(
            children: [
              CommonText.textBoldWight500(text: "Naman Sharma", fontSize: 8.sp),
              SizedBox(
                height: 3.sp,
              ),
              CommonText.textBoldWight500(
                  textDecoration: TextDecoration.underline,
                  text: "View Profile",
                  fontSize: 5.sp,
                  color: themColors309D9D),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          Column(
            children: List.generate(
              4,
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
                            color:
                                selected == index ? Colors.black : Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
