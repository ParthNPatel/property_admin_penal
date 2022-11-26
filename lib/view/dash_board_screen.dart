import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:property/components/common_widget.dart';
import 'package:property/constant/color_const.dart';
import 'package:property/responsive/responsive.dart';
import 'package:sizer/sizer.dart';
import '../components/count_shimmer.dart';
import '../constant/text_styel.dart';
import 'dart:developer';

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
        padding: EdgeInsets.only(left: 0, top: 20),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              children: [
                GridView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.isDesktop(context) ? 2 : 2,
                    mainAxisExtent: 300,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
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
                            image: 'assets/images/services.svg',
                            height: 70,
                            width: 70,
                            color: themColors309D9D,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          CommonText.textBoldWight500(
                              text: 'Service Enquiries', fontSize: 7.sp),
                          SizedBox(
                            height: 10,
                          ),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('Admin')
                                .doc('inquires_list')
                                .collection('inquiries')
                                .get(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                var total;

                                try {
                                  // log("===>>>${snapshot.data.docs[0]['is_check']}");
                                  print("===>>>${snapshot.data}");
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
                            image: 'assets/images/valuation.svg',
                            height: 70,
                            width: 70,
                            color: themColors309D9D,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          CommonText.textBoldWight500(
                              text: 'Property Enquiries', fontSize: 7.sp),
                          SizedBox(
                            height: 10,
                          ),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('Admin')
                                .doc('inquires_list')
                                .collection('get_a_free_valuation')
                                .get(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                var total;
                                log("11===>>>${snapshot.data.docs.length}");
                                try {
                                  return FutureBuilder(
                                    future: FirebaseFirestore.instance
                                        .collection('Admin')
                                        .doc('inquires_list')
                                        .collection('free_martgage_check')
                                        .get(),
                                    builder: (context, AsyncSnapshot inq) {
                                      if (inq.hasData) {
                                        print("22===>>>}");

                                        total = snapshot.data.docs.length +
                                            inq.data.docs.length;
                                        return CommonText.textBoldWight500(
                                          text: '${total}',
                                          fontSize: 7.sp,
                                          fontWeight: FontWeight.bold,
                                        );
                                      } else {
                                        return CountShimmer();
                                      }
                                    },
                                  );
                                  //log("===>>>${snapshot.data.docs[0]['is_check']}");

                                } catch (e) {
                                  total = 0;
                                }
                                // return CommonText.textBoldWight500(
                                //   text: '${total}',
                                //   fontSize: 7.sp,
                                //   fontWeight: FontWeight.bold,
                                // );
                                return SizedBox();
                              } else {
                                return CountShimmer();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Row(
                //   children: [
                //     Container(
                //       height: 250,
                //       width: 250,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(5),
                //         color: Color(0xffdee0ef),
                //       ),
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           CommonWidget.commonSvgPitcher(
                //             image: 'assets/images/home.svg',
                //             height: 70,
                //             width: 70,
                //             color: themColors309D9D,
                //           ),
                //           SizedBox(
                //             height: 15,
                //           ),
                //           CommonText.textBoldWight500(
                //               text: 'Total Property', fontSize: 7.sp),
                //           SizedBox(
                //             height: 10,
                //           ),
                //           FutureBuilder(
                //             future: FirebaseFirestore.instance
                //                 .collection('Admin')
                //                 .doc('all_properties')
                //                 .collection('property_data')
                //                 .get(),
                //             builder: (context, snapshot) {
                //               if (snapshot.hasData) {
                //                 var total;
                //                 try {
                //                   total = snapshot.data!.docs.length;
                //                 } catch (e) {
                //                   total = 0;
                //                 }
                //                 return CommonText.textBoldWight500(
                //                   text: '${total}',
                //                   fontSize: 7.sp,
                //                   fontWeight: FontWeight.bold,
                //                 );
                //               } else {
                //                 return CountShimmer();
                //               }
                //             },
                //           ),
                //         ],
                //       ),
                //     ),
                //     SizedBox(
                //       width: 50,
                //     ),
                //     Container(
                //       height: 250,
                //       width: 250,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(5),
                //         color: Color(0xffeedad9),
                //       ),
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           CommonWidget.commonSvgPitcher(
                //             image: 'assets/images/inbox.svg',
                //             height: 70,
                //             width: 70,
                //             color: themColors309D9D,
                //           ),
                //           SizedBox(
                //             height: 15,
                //           ),
                //           CommonText.textBoldWight500(
                //               text: 'Total Categories', fontSize: 7.sp),
                //           SizedBox(
                //             height: 10,
                //           ),
                //           FutureBuilder(
                //             future: FirebaseFirestore.instance
                //                 .collection('Admin')
                //                 .doc('categories')
                //                 .collection('categories_list')
                //                 .get(),
                //             builder: (context, snapshot) {
                //               if (snapshot.hasData) {
                //                 var total;
                //                 try {
                //                   total = snapshot.data!.docs.length;
                //                 } catch (e) {
                //                   total = 0;
                //                 }
                //                 return CommonText.textBoldWight500(
                //                   text: '${total}',
                //                   fontSize: 7.sp,
                //                   fontWeight: FontWeight.bold,
                //                 );
                //               } else {
                //                 return CountShimmer();
                //               }
                //             },
                //           ),
                //         ],
                //       ),
                //     ),
                //     SizedBox(
                //       width: 50,
                //     ),
                //     Responsive.isDesktop(context)
                //         ? Row(
                //             children: [
                //               Container(
                //                 height: 250,
                //                 width: 250,
                //                 decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(5),
                //                   color: Color(0xffddefe1),
                //                 ),
                //                 child: Column(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   children: [
                //                     CommonWidget.commonSvgPitcher(
                //                       image: 'assets/images/valuation.svg',
                //                       height: 70,
                //                       width: 70,
                //                       color: themColors309D9D,
                //                     ),
                //                     SizedBox(
                //                       height: 15,
                //                     ),
                //                     CommonText.textBoldWight500(
                //                         text: 'Valuation Enquiries',
                //                         fontSize: 7.sp),
                //                     SizedBox(
                //                       height: 10,
                //                     ),
                //                     FutureBuilder(
                //                       future: FirebaseFirestore.instance
                //                           .collection('All_User_Details')
                //                           .where('is_check_valuation',
                //                               isEqualTo: true)
                //                           .get(),
                //                       builder:
                //                           (context, AsyncSnapshot snapshot) {
                //                         if (snapshot.hasData) {
                //                           var total;
                //
                //                           try {
                //                             // log("===>>>${snapshot.data.docs[0]['is_check']}");
                //                             print("===>>>${snapshot.data}");
                //                             total = snapshot.data!.docs.length;
                //                           } catch (e) {
                //                             total = 0;
                //                           }
                //                           return CommonText.textBoldWight500(
                //                             text: '${total}',
                //                             fontSize: 7.sp,
                //                             fontWeight: FontWeight.bold,
                //                           );
                //                         } else {
                //                           return CountShimmer();
                //                         }
                //                       },
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //               SizedBox(
                //                 width: 50,
                //               ),
                //               Container(
                //                 height: 250,
                //                 width: 250,
                //                 decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(5),
                //                   color: Color(0xff93dee4),
                //                 ),
                //                 child: Column(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   children: [
                //                     CommonWidget.commonSvgPitcher(
                //                       image: 'assets/images/morgage.svg',
                //                       height: 70,
                //                       width: 70,
                //                       color: themColors309D9D,
                //                     ),
                //                     SizedBox(
                //                       height: 15,
                //                     ),
                //                     CommonText.textBoldWight500(
                //                         text: 'Mortgage Enquiries',
                //                         fontSize: 7.sp),
                //                     SizedBox(
                //                       height: 10,
                //                     ),
                //                     FutureBuilder(
                //                       future: FirebaseFirestore.instance
                //                           .collection('All_User_Details')
                //                           .where('is_check_mortgage',
                //                               isEqualTo: true)
                //                           .get(),
                //                       builder:
                //                           (context, AsyncSnapshot snapshot) {
                //                         if (snapshot.hasData) {
                //                           var total;
                //                           //log("===>>>${snapshot.data.docs[0]['is_check']}");
                //                           try {
                //                             //log("===>>>${snapshot.data.docs[0]['is_check']}");
                //                             print("===>>>${snapshot.data}");
                //                             total = snapshot.data!.docs.length;
                //                           } catch (e) {
                //                             total = 0;
                //                           }
                //                           return CommonText.textBoldWight500(
                //                             text: '${total}',
                //                             fontSize: 7.sp,
                //                             fontWeight: FontWeight.bold,
                //                           );
                //                         } else {
                //                           return CountShimmer();
                //                         }
                //                       },
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ],
                //           )
                //         : SizedBox(),
                //   ],
                // ),
                // SizedBox(
                //   height: 30,
                // ),
                // Responsive.isDesktop(context)
                //     ? SizedBox()
                //     : Row(
                //         children: [
                //           Container(
                //             height: 250,
                //             width: 250,
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(5),
                //               color: Color(0xffddefe1),
                //             ),
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 CommonWidget.commonSvgPitcher(
                //                   image: 'assets/images/valuation.svg',
                //                   height: 70,
                //                   width: 70,
                //                   color: themColors309D9D,
                //                 ),
                //                 SizedBox(
                //                   height: 15,
                //                 ),
                //                 CommonText.textBoldWight500(
                //                     text: 'Valuation Enquiries',
                //                     fontSize: 7.sp),
                //                 SizedBox(
                //                   height: 10,
                //                 ),
                //                 FutureBuilder(
                //                   future: FirebaseFirestore.instance
                //                       .collection('All_User_Details')
                //                       .where('is_check_valuation',
                //                           isEqualTo: true)
                //                       .get(),
                //                   builder: (context, AsyncSnapshot snapshot) {
                //                     if (snapshot.hasData) {
                //                       var total;
                //
                //                       try {
                //                         //log("===>>>${snapshot.data.docs[0]['is_check']}");
                //                         print("===>>>${snapshot.data}");
                //                         total = snapshot.data!.docs.length;
                //                       } catch (e) {
                //                         total = 0;
                //                       }
                //                       return CommonText.textBoldWight500(
                //                         text: '${total}',
                //                         fontSize: 7.sp,
                //                         fontWeight: FontWeight.bold,
                //                       );
                //                     } else {
                //                       return CountShimmer();
                //                     }
                //                   },
                //                 ),
                //               ],
                //             ),
                //           ),
                //           SizedBox(
                //             width: 50,
                //           ),
                //           Container(
                //             height: 250,
                //             width: 250,
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(5),
                //               color: Color(0xff93dee4),
                //             ),
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 CommonWidget.commonSvgPitcher(
                //                   image: 'assets/images/morgage.svg',
                //                   height: 70,
                //                   width: 70,
                //                   color: themColors309D9D,
                //                 ),
                //                 SizedBox(
                //                   height: 15,
                //                 ),
                //                 CommonText.textBoldWight500(
                //                     text: 'Mortgage Enquiries', fontSize: 7.sp),
                //                 SizedBox(
                //                   height: 10,
                //                 ),
                //                 FutureBuilder(
                //                   future: FirebaseFirestore.instance
                //                       .collection('All_User_Details')
                //                       .where('is_check_mortgage',
                //                           isEqualTo: true)
                //                       .get(),
                //                   builder: (context, AsyncSnapshot snapshot) {
                //                     if (snapshot.hasData) {
                //                       var total;
                //
                //                       try {
                //                         //log("===>>>${snapshot.data.docs[0]['is_check']}");
                //                         print("===>>>${snapshot.data}");
                //                         total = snapshot.data!.docs.length;
                //                       } catch (e) {
                //                         total = 0;
                //                       }
                //                       return CommonText.textBoldWight500(
                //                         text: '${total}',
                //                         fontSize: 7.sp,
                //                         fontWeight: FontWeight.bold,
                //                       );
                //                     } else {
                //                       return CountShimmer();
                //                     }
                //                   },
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ],
                //       )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
