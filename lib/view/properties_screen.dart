import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:property/view/edit_property_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../components/common_widget.dart';
import '../components/dashboard_shimmer.dart';
import '../components/product_tile.dart';

import '../controller/edit_property_controller.dart';
import '../responsive/responsive.dart';

class PropertiesScreen extends StatefulWidget {

  const PropertiesScreen({super.key});
  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  EditPropertyController editPropertyController = Get.find();

  String searchText = '';

  TextEditingController searchController = TextEditingController();

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
              searchBar(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      properties(),
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

  StreamBuilder<QuerySnapshot<Object?>> properties() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Admin')
          .doc('all_properties')
          .collection('property_data')
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
          return GridView.builder(
            //reverse: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 15),
            itemCount: properties.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.isDesktop(context) ? 5 : 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 10,
                mainAxisExtent: 450
                //hildAspectRatio:
                //Responsive.isDesktop(context) ? 2 / 2.4 : 2 / 2.9,
                ),
            itemBuilder: (context, index) => ProductTile(
              onEdit: () {
                editPropertyController.listOfImage!.clear();

                print('listOfImage   ${properties[index].get("listOfImage")}');

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
                );
                Get.to(() => EditPropertyScreen());
                //Navigator.pushNamed(context, '/EditProperty');
              },
              image: properties[index].get("listOfImage")[0],
              title: properties[index].get("propertyName"),
              subtitle: properties[index].get("address"),
              price: properties[index].get("price"),
              size: properties[index].get("size"),
              totalBedroom: properties[index].get("totalBedRooms"),
              totalWashroom: properties[index].get("totalBathrooms"),
              rating: '5',
            ),
          );
        } else {
          return DashBoardShimmer();
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
          CommonWidget.commonSvgPitcher(
            image: 'assets/images/bell.svg',
            height: 7.sp,
            width: 7.sp,
          ),
          SizedBox(
            width: 3.sp,
          ),
          SizedBox(
            height: 15.sp,
            child: VerticalDivider(
              thickness: 1,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            width: 3.sp,
          ),
          CommonWidget.commonButton(
              onTap: () {
                Navigator.pushNamed(context, '/AddProperty');
              },
              text: "Add New Property",
              radius: 40),
          SizedBox(
            width: 6.sp,
          ),
        ],
      ),
    );
  }
}
