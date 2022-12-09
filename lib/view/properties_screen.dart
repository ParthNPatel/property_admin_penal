import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:property/controller/handle_screen_controller.dart';
import 'package:property/view/edit_property_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../components/common_widget.dart';
import '../components/dashboard_shimmer.dart';
import '../components/product_tile.dart';
import '../constant/color_const.dart';
import '../constant/text_styel.dart';
import '../controller/edit_property_controller.dart';
import '../responsive/responsive.dart';
import 'home_page.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});
  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  EditPropertyController editPropertyController = Get.find();

  HandleScreenController handleScreenController = Get.find();

  String searchText = '';

  TextEditingController searchController = TextEditingController();

  String category = "All";

  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 8,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // SizedBox(
              //   height: 10.sp,
              // ),
              searchBar(context),
              SizedBox(height: 10.sp),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 20.sp,
                        decoration: BoxDecoration(
                          color: blueColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 25,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 100,
                                width: 100,
                                margin: EdgeInsets.only(bottom: 7, right: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 50.sp,
                                child: CommonText.textBoldWight700(
                                    text: "PROPERTY NAME", fontSize: 13),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              SizedBox(
                                width: 50.sp,
                                child: CommonText.textBoldWight700(
                                    text: "ADDRESS", fontSize: 13),
                              ),
                              SizedBox(
                                width: 1.w,
                              ),
                              SizedBox(
                                width: 25.sp,
                                child: CommonText.textBoldWight700(
                                    text: "PRICE", fontSize: 13),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 50.sp,
                                child: CommonText.textBoldWight700(
                                    text: "TOTAL BEDROOMS", fontSize: 13),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              // SizedBox(
                              //   width: 50.sp,
                              //   child: CommonText.textBoldWight700(
                              //       text: 'Season', fontSize: 15),
                              // ),
                              SizedBox(
                                width: 50.sp,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CommonText.textBoldWight700(
                                        text: "TOTAL BATHROOMS", fontSize: 13),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                  width: 30.sp,
                                  child: Center(
                                    child: CommonText.textBoldWight700(
                                        text: "STATUS", fontSize: 13),
                                  )),

                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                  width: 50.sp,
                                  child: Center(
                                    child: CommonText.textBoldWight700(
                                        text: "RATING", fontSize: 13),
                                  )),
                              FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('Admin')
                                    .doc('categories')
                                    .collection('categories_list')
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<
                                            QuerySnapshot<Map<String, dynamic>>>
                                        snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      height: 14.sp,
                                      width: 45.sp,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: Center(
                                        child: DropdownButton(
                                          underline: SizedBox(),
                                          hint: Text("All"),
                                          disabledHint: Text("All"),
                                          value: category,
                                          items: snapshot.data!.docs.map((e) {
                                            return DropdownMenuItem(
                                              child: Text(e['category_name']),
                                              value: e['category_name'],
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              category = value as String;
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      products(),
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

  StreamBuilder<QuerySnapshot<Object?>> products() {
    return StreamBuilder<QuerySnapshot>(
      stream: category == 'All'
          ? FirebaseFirestore.instance
              .collection('property_data')
              .orderBy('create_time', descending: true)
              .snapshots()
          : FirebaseFirestore.instance
              .collection('property_data')
              .where("category", isEqualTo: category)
              .orderBy('create_time', descending: true)
              .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> properties = snapshot.data!.docs;
          print("length======>${properties.length}");
          if (searchText.isNotEmpty) {
            properties = properties.where((element) {
              return element
                  .get('propertyName')
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase());
            }).toList();
          }
          return GetBuilder<HandleScreenController>(
            builder: (controller) => ListView.builder(
              //reverse: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: properties.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 25, top: 25),
              itemBuilder: (context, index) => ProductTile(
                onEdit: () {
                  editPropertyController.addPropertyData(
                    docId: properties[index].id,
                    productId: properties[index].get("productId").toString(),
                    listOfImage: properties[index].get("listOfImage"),
                    propertyName: properties[index].get("propertyName"),
                    description: properties[index].get("description"),
                    category: properties[index].get("category"),
                    address: properties[index].get("address"),
                    country: properties[index].get("country"),
                    pinCode: properties[index].get("pinCode"),
                    isParkingAvailable:
                        properties[index].get("isParkingAvailable"),
                    price: properties[index].get("price"),
                    size: properties[index].get("size"),
                    totalBathrooms: properties[index].get("totalBathrooms"),
                    totalBedRooms: properties[index].get("totalBedRooms"),
                    garages: properties[index].get("garages"),
                    label: properties[index].get("label"),
                    propertyStatus: properties[index].get("propertyStatus"),
                    nearByPlaces: properties[index].get("nearByPlaces"),
                    features: properties[index].get("features"),
                    isNewBuild: properties[index].get("isNewBuild"),
                    isSharedOwnerShip:
                        properties[index].get("isSharedOwnerShip"),
                    underOffer: properties[index].get("underOffer"),
                  );

                  controller.changeTapped1(true);
                  //editPropertyController.listOfImage!.clear();
                  //Get.to(() => EditPropertyScreen());
                  //Navigator.pushNamed(context, '/EditProperty');
                },
                image: properties[index].get("listOfImage")[0],
                title: properties[index].get("propertyName"),
                subtitle: properties[index].get("address"),
                price: properties[index].get("price"),
                size: properties[index].get("size"),
                totalBedroom: properties[index].get("totalBedRooms"),
                totalWashroom: properties[index].get("totalBathrooms"),
                status: "Active",
                onDelete: () {
                  Get.dialog(AlertDialog(
                    title: Text(
                        "Are you sure that you want to delete this property?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('NO'),
                      ),
                      TextButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('property_data')
                              .doc(properties[index].id)
                              .delete();
                          Get.back();
                        },
                        child: Text('YES'),
                      ),
                    ],
                  ));
                },
                onAdd: () {
                  controller.changeTapped(true);
                },
                rating: '5',
              ),
            ),
          );
        } else {
          return ProductShimmer();
        }
      },
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
          Spacer(),
          InkWell(
            onTap: () async {
              DateTime? newData = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2019),
                lastDate: DateTime(2031),
              );

              if (newData != null) {
                setState(() {
                  startDate = newData;
                });
              }
            },
            child: Container(
              height: 14.sp,
              width: 40.sp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(startDate == null
                        ? "dd/mm/yyyy"
                        : "${startDate!.day}/${startDate!.month}/${startDate!.year}"),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 2.sp,
          ),
          InkWell(
            onTap: () async {
              DateTime? newData = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2019),
                lastDate: DateTime(2031),
              );

              if (newData != null) {
                setState(() {
                  endDate = newData;
                });
              }
            },
            child: Container(
              height: 14.sp,
              width: 40.sp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(endDate == null
                        ? "dd/mm/yyyy"
                        : "${endDate!.day}/${endDate!.month}/${endDate!.year}"),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 6.sp,
          ),
          SizedBox(
            width: 3.sp,
          ),
          GetBuilder<HandleScreenController>(
            builder: (controller) => CommonWidget.commonButton(
                onTap: () {
                  controller.changeTapped(true);
                  //Navigator.pushNamed(context, '/AddProperty');
                },
                text: "Add New Property",
                radius: 40),
          ),
          SizedBox(
            width: 6.sp,
          ),
        ],
      ),
    );
  }
}
