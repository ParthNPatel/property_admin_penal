import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../components/common_widget.dart';
import '../components/dashboard_shimmer.dart';
import '../components/product_tile.dart';
import '../constant/image_const.dart';
import '../controller/edit_product_controller.dart';
import '../responsive/responsive.dart';

class DashBoardScreen extends StatefulWidget {
  final globalKey;

  const DashBoardScreen({super.key, this.globalKey});
  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  EditProductController editProductController = Get.find();

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
              products(),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> products() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Admin')
          .doc('all_product')
          .collection('product_data')
          .orderBy('create_time', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> products = snapshot.data!.docs;
          print("length======>${products.length}");
          if (searchText.isNotEmpty) {
            products = products.where((element) {
              return element
                  .get('productName')
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase());
            }).toList();
          }
          return GridView.builder(
            //reverse: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: products.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.isDesktop(context) ? 5 : 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 10,
                mainAxisExtent: 400
                //hildAspectRatio:
                //Responsive.isDesktop(context) ? 2 / 2.4 : 2 / 2.9,
                ),
            itemBuilder: (context, index) => ProductTile(
              onEdit: () {
                editProductController.listOfImage!.clear();
                editProductController.addProductData(
                  docId: products[index].id,
                  listOfImage: products[index].get("listOfImage"),
                  productName: products[index].get("productName"),
                  brand: products[index].get("brand"),
                  price: products[index].get("price"),
                  oldPrice: products[index].get("oldPrice"),
                  color: products[index].get("color"),
                  category: products[index].get("category"),
                  description: products[index].get("description"),
                  material: products[index].get("material"),
                  season: products[index].get("season"),
                  subCategory: products[index].get("subCategory"),
                );
                // Get.to(() => EditProductScreen());
                Navigator.pushNamed(context, '/EditProduct');
              },
              image: products[index].get("listOfImage")[0],
              title: products[index].get("productName"),
              subtitle: products[index].get("brand"),
              price: products[index].get("price"),
              oldPrice: products[index].get("oldPrice"),
              rating: '(200 Ratings)',
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
              onTap: () {}, text: "Add New Product", radius: 40),
          SizedBox(
            width: 6.sp,
          ),
        ],
      ),
    );
  }
}
