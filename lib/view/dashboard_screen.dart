import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../components/common_widget.dart';
import '../components/dashboard_shimmer.dart';
import '../components/product_tile.dart';
import '../constant/image_const.dart';
import '../controller/edit_property_controller.dart';
import '../responsive/responsive.dart';

class DashBoardScreen extends StatefulWidget {
  final globalKey;

  const DashBoardScreen({super.key, this.globalKey});
  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  EditPropertyController editPropertyController = Get.find();

  List<Map<String, dynamic>> data = [
    {
      'image': ImageConst.women3,
      'title': 'CLAUDETTE CORSET',
      'subtitle': 'TMP Company',
      'price': '₹999,00',
      'oldPrice': '₹1299,00',
      'rating': '(200 Ratings)'
    },
    {
      'image': ImageConst.women4,
      'title': ' Tailored FULL Skirta',
      'subtitle': 'TMP Company',
      'price': '₹999,00',
      'oldPrice': '₹1299,00',
      'rating': '(200 Ratings)'
    },
    {
      'image': ImageConst.women5,
      'title': 'CLAUDETTE CORSET',
      'subtitle': 'TMP Company',
      'price': '₹999,00',
      'oldPrice': '₹1299,00',
      'rating': '(200 Ratings)'
    },
    {
      'image': ImageConst.women6,
      'title': ' Tailored FULL Skirta',
      'subtitle': 'TMP Company',
      'price': '₹999,00',
      'oldPrice': '₹1299,00',
      'rating': '(200 Ratings)'
    },
  ];

  String searchText = '';

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 6,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              searchBar(context),
              properties(),
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
            itemCount: properties.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.isDesktop(context) ? 5 : 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 10,
                mainAxisExtent: 450
                //hildAspectRatio:
                //Responsive.isDesktop(context) ? 2 / 2.4 : 2 / 2.9,
                ),
            itemBuilder: (context, index) => ProductTile(
              onEdit: () {
                editPropertyController.listOfImage!.clear();
                editPropertyController.addPropertyData(
                  docId: properties[index].id,
                  listOfImage: properties[index].get("listOfImage"),
                  propertyName: properties[index].get("propertyName"),
                  description: properties[index].get("description"),
                  category: properties[index].get("category"),
                  address: properties[index].get("address"),
                  isParkingAvailable:
                      properties[index].get("isParkingAvailable"),
                  price: properties[index].get("price"),
                  size: properties[index].get("size"),
                  totalBathrooms: properties[index].get("totalBathrooms"),
                  totalBedRooms: properties[index].get("totalBedRooms"),
                );
                // Get.to(() => EditProductScreen());
                Navigator.pushNamed(context, '/EditProperty');
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
          Responsive.isDesktop(context)
              ? SizedBox()
              : IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onPressed: () {
                    widget.globalKey.currentState!.openDrawer();
                  },
                  icon: Icon(Icons.menu),
                ),
          SizedBox(
            height: 20.sp,
            width: 80.sp,
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
              onTap: () {}, text: "Add New Property", radius: 40),
          SizedBox(
            width: 6.sp,
          ),
        ],
      ),
    );
  }
}
