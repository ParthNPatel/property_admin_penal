import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:property/controller/edit_category_controller.dart';
import 'package:property/view/add_category_screen.dart';
import 'package:property/view/edit_category_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../components/category_shimmer.dart';
import '../components/common_widget.dart';
import '../constant/color_const.dart';
import '../constant/text_styel.dart';
import '../responsive/responsive.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String searchText = '';

  TextEditingController searchController = TextEditingController();

  EditCategoryController editCategoryController = Get.find();

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
          .doc('categories')
          .collection('categories_list')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<DocumentSnapshot> categories = snapshot.data!.docs;
          print("length======>${categories.length}");
          if (searchText.isNotEmpty) {
            categories = categories.where((element) {
              return element
                  .get('category_name')
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase());
            }).toList();
          }
          return GridView.builder(
            //reverse: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.isDesktop(context) ? 5 : 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 10,
                mainAxisExtent: 450
                //hildAspectRatio:
                //Responsive.isDesktop(context) ? 2 / 2.4 : 2 / 2.9,
                ),
            itemBuilder: (context, index) => Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                          color: CommonColor.greyColorF2F2F2,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(
                                  categories[index]['category_image'][0]),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4.sp,
                      right: 16.sp,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        child: InkWell(
                          onTap: () {
                            editCategoryController.addCategoryData(
                              docId: categories[index].id,
                              categoryName: categories[index]['category_name'],
                              categoryImage: categories[index]
                                  ['category_image'],
                            );

                            Get.to(() => EditCategoryScreen());
                          },
                          child: Icon(
                            Icons.edit,
                            size: 20,
                            color: CommonColor.greyColor838589,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4.sp,
                      right: 4.sp,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        child: InkWell(
                          onTap: () {
                            Get.dialog(AlertDialog(
                              title: Text(
                                  "Are you sure that you want to delete this category?"),
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
                                        .collection('Admin')
                                        .doc('categories')
                                        .collection('categories_list')
                                        .doc(categories[index].id)
                                        .delete();
                                    Get.back();
                                  },
                                  child: Text('YES'),
                                ),
                              ],
                            ));
                          },
                          child: Icon(
                            Icons.delete,
                            size: 20,
                            color: CommonColor.greyColor838589,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                CommonText.textBoldWight700(
                    text: categories[index]['category_name'], fontSize: 15),
                SizedBox(
                  height: 6,
                ),
              ],
            ),
          );
        } else {
          return CategoryShimmer();
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
          CommonWidget.commonButton(
              onTap: () {
                Get.to(() => AddCategoryScreen());
              },
              text: "Add New Category",
              radius: 40),
          SizedBox(
            width: 6.sp,
          ),
        ],
      ),
    );
  }
}
