import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../components/common_widget.dart';
import '../components/dashboard_shimmer.dart';
import '../components/inquiry_shimmer.dart';
import '../constant/color_const.dart';
import '../constant/text_styel.dart';
import '../responsive/responsive.dart';

class PropertyInquiryScreen extends StatefulWidget {
  const PropertyInquiryScreen({Key? key}) : super(key: key);

  @override
  State<PropertyInquiryScreen> createState() => _PropertyInquiryScreenState();
}

class _PropertyInquiryScreenState extends State<PropertyInquiryScreen>
    with SingleTickerProviderStateMixin {
  String searchText = '';

  TextEditingController searchController = TextEditingController();

  TabController? tabController;

  List<String> items = [
    'Valuation Inquiries',
    'Mortgage Check',
  ];

  int selected = 0;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 9,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              searchBar(context),
              CommonWidget.commonSizedBox(height: 20),
              SizedBox(
                width: 150.sp,
                child: TabBar(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  physics: BouncingScrollPhysics(),
                  indicatorColor: Colors.transparent,
                  controller: tabController,
                  onTap: (value) {
                    setState(() {
                      selected = value;
                    });
                  },
                  tabs: List.generate(
                    2,
                    (index) => Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 11),
                      decoration: BoxDecoration(
                        color: selected == index
                            ? themColors309D9D
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          items[index],
                          style: TextStyle(
                              color: selected == index
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: 200.sp,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            child: CommonText.textBoldWight700(
                                text: 'Valuation Inquiries', fontSize: 10.sp),
                          ),
                          CommonWidget.commonSizedBox(height: 20),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  propertyInquiry(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            child: CommonText.textBoldWight700(
                                text: 'Mortgage Check', fontSize: 10.sp),
                          ),
                          CommonWidget.commonSizedBox(height: 20),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  mortgageCheck(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container searchBar(BuildContext context) {
    return Container(
      height: 20.sp,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: Row(
        children: [
          SizedBox(
            width: 6.sp,
          ),
          SizedBox(
            height: 20.sp,
            width: 200.sp,
            child: Center(
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                cursorHeight: 8.sp,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> propertyInquiry() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Admin')
          .doc('inquires_list')
          .collection('get_a_free_valuation')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> inquiries = snapshot.data!.docs;
          print("length======>${inquiries.length}");
          if (searchText.isNotEmpty) {
            inquiries = inquiries.where((element) {
              return element
                  .get('full_name')
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase());
            }).toList();
          }
          return ListView.builder(
            padding: EdgeInsets.only(left: 20),
            shrinkWrap: true,
            itemCount: inquiries.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Responsive.isDesktop(context) ? 200.sp : 100.sp,
                      child: Card(
                        child: ExpansionTile(
                          title: Text(inquiries[index]['full_name']),
                          subtitle: Text(inquiries[index]['to_sell & to_let']),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      CommonText.textBoldWight500(
                                          text: "Phone No: ",
                                          color: themColors309D9D),
                                      Text(inquiries[index]['phone_number']),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      CommonText.textBoldWight500(
                                          text: "Email: ",
                                          color: themColors309D9D),
                                      Text(inquiries[index]['email']),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return InquiryShimmer();
        }
      },
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> mortgageCheck() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Admin')
          .doc('inquires_list')
          .collection('free_martgage_check')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> inquiries = snapshot.data!.docs;
          print("length======>${inquiries.length}");
          if (searchText.isNotEmpty) {
            inquiries = inquiries.where((element) {
              return element
                  .get('full_name')
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase());
            }).toList();
          }
          return ListView.builder(
            padding: EdgeInsets.only(left: 20),
            shrinkWrap: true,
            itemCount: inquiries.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Responsive.isDesktop(context) ? 200.sp : 100.sp,
                      child: Card(
                        child: ExpansionTile(
                          title: Text(inquiries[index]['full_name']),
                          subtitle: Text(inquiries[index]['email']),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      CommonText.textBoldWight500(
                                          text: "Phone No: ",
                                          color: themColors309D9D),
                                      Text(inquiries[index]['phone_number']),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return InquiryShimmer();
        }
      },
    );
  }
}
