import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:property/components/common_widget.dart';
import 'package:property/constant/color_const.dart';
import 'package:property/responsive/responsive.dart';
import 'package:sizer/sizer.dart';
import '../components/count_shimmer.dart';
import '../constant/text_styel.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 8,
      child: Padding(
        padding: EdgeInsets.only(left: 50, top: 50),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffdee0ef),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonWidget.commonSvgPitcher(
                        image: 'assets/images/home.svg',
                        height: 70,
                        width: 70,
                        color: themColors309D9D,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CommonText.textBoldWight500(
                          text: 'Total Property', fontSize: 7.sp),
                      SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('Admin')
                            .doc('all_properties')
                            .collection('property_data')
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var total;
                            try {
                              total = snapshot.data!.docs.length;
                            } catch (e) {
                              total = 0;
                            }
                            return CommonText.textBoldWight500(
                              text: '${total}',
                              fontSize: 7.sp,
                              fontWeight: FontWeight.bold,
                            );
                          } else {
                            return CountShimmer();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffeedad9),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonWidget.commonSvgPitcher(
                        image: 'assets/images/inbox.svg',
                        height: 70,
                        width: 70,
                        color: themColors309D9D,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CommonText.textBoldWight500(
                          text: 'Total Categories', fontSize: 7.sp),
                      SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('Admin')
                            .doc('categories')
                            .collection('categories_list')
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var total;
                            try {
                              total = snapshot.data!.docs.length;
                            } catch (e) {
                              total = 0;
                            }
                            return CommonText.textBoldWight500(
                              text: '${total}',
                              fontSize: 7.sp,
                              fontWeight: FontWeight.bold,
                            );
                          } else {
                            return CountShimmer();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Responsive.isDesktop(context)
                    ? Row(
                        children: [
                          Container(
                            height: 250,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xffddefe1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonWidget.commonSvgPitcher(
                                  image: 'assets/images/valuation.svg',
                                  height: 70,
                                  width: 70,
                                  color: themColors309D9D,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                CommonText.textBoldWight500(
                                    text: 'Valuation Enquiries',
                                    fontSize: 7.sp),
                                SizedBox(
                                  height: 10,
                                ),
                                FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('All_User_Details')
                                      .where('to_sell & to_let',
                                          isEqualTo: 'male')
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var total;
                                      try {
                                        total = snapshot.data!.docs.length;
                                      } catch (e) {
                                        total = 0;
                                      }
                                      return CommonText.textBoldWight500(
                                        text: '${total}',
                                        fontSize: 7.sp,
                                        fontWeight: FontWeight.bold,
                                      );
                                    } else {
                                      return CountShimmer();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Container(
                            height: 250,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xff93dee4),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonWidget.commonSvgPitcher(
                                  image: 'assets/images/morgage.svg',
                                  height: 70,
                                  width: 70,
                                  color: themColors309D9D,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                CommonText.textBoldWight500(
                                    text: 'Mortgage Enquiries', fontSize: 7.sp),
                                SizedBox(
                                  height: 10,
                                ),
                                FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('All_User_Details')
                                      .where('to_sell & to_let',
                                          isEqualTo: 'male')
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var total;
                                      try {
                                        total = snapshot.data!.docs.length;
                                      } catch (e) {
                                        total = 0;
                                      }
                                      return CommonText.textBoldWight500(
                                        text: '${total}',
                                        fontSize: 7.sp,
                                        fontWeight: FontWeight.bold,
                                      );
                                    } else {
                                      return CountShimmer();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Responsive.isDesktop(context)
                ? SizedBox()
                : Row(
                    children: [
                      Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xffddefe1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonWidget.commonSvgPitcher(
                              image: 'assets/images/valuation.svg',
                              height: 70,
                              width: 70,
                              color: themColors309D9D,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            CommonText.textBoldWight500(
                                text: 'Valuation Enquiries', fontSize: 7.sp),
                            SizedBox(
                              height: 10,
                            ),
                            FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('All_User_Details')
                                  .where('to_sell & to_let', isEqualTo: 'male')
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var total;
                                  try {
                                    total = snapshot.data!.docs.length;
                                  } catch (e) {
                                    total = 0;
                                  }
                                  return CommonText.textBoldWight500(
                                    text: '${total}',
                                    fontSize: 7.sp,
                                    fontWeight: FontWeight.bold,
                                  );
                                } else {
                                  return CountShimmer();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xff93dee4),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonWidget.commonSvgPitcher(
                              image: 'assets/images/morgage.svg',
                              height: 70,
                              width: 70,
                              color: themColors309D9D,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            CommonText.textBoldWight500(
                                text: 'Mortgage Enquiries', fontSize: 7.sp),
                            SizedBox(
                              height: 10,
                            ),
                            FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('All_User_Details')
                                  .where('to_sell & to_let', isEqualTo: 'male')
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var total;
                                  try {
                                    total = snapshot.data!.docs.length;
                                  } catch (e) {
                                    total = 0;
                                  }
                                  return CommonText.textBoldWight500(
                                    text: '${total}',
                                    fontSize: 7.sp,
                                    fontWeight: FontWeight.bold,
                                  );
                                } else {
                                  return CountShimmer();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
