import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:property/components/inquiry_shimmer.dart';
import 'package:property/constant/color_const.dart';
import 'package:property/responsive/responsive.dart';
import 'package:sizer/sizer.dart';
import '../components/common_widget.dart';
import '../constant/text_styel.dart';

class ServiceInquiryScreen extends StatefulWidget {
  const ServiceInquiryScreen({Key? key}) : super(key: key);

  @override
  State<ServiceInquiryScreen> createState() => _ServiceInquiryScreenState();
}

class _ServiceInquiryScreenState extends State<ServiceInquiryScreen> {
  String searchText = '';

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 9,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              searchBar(context),
              CommonWidget.commonSizedBox(height: 20),
              CommonText.textBoldWight700(
                  text: 'All Service Inquiries', fontSize: 10.sp),
              CommonWidget.commonSizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      serviceInquiry(),
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

  StreamBuilder<QuerySnapshot<Object?>> serviceInquiry() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Admin')
          .doc('inquires_list')
          .collection('inquiries')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> inquiries = snapshot.data!.docs;
          print("length======>${inquiries.length}");
          if (searchText.isNotEmpty) {
            inquiries = inquiries.where((element) {
              return element
                  .get('inquiryFor')
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
                          subtitle: Text(inquiries[index]['inquiryFor']),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
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
                                          text: "Message: ",
                                          color: themColors309D9D),
                                      Text(inquiries[index]['message']),
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
