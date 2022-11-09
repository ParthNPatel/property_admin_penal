import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
import '../controller/handle_screen_controller.dart';
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

  HandleScreenController handleScreenController = Get.find();

  TextEditingController? categoryTitle;

  bool isLoading = true;

  List<Uint8List> _listOfImage = [];

  @override
  void initState() {
    try {
      categoryTitle =
          TextEditingController(text: editCategoryController.categoryName);
    } catch (e) {
      categoryTitle = TextEditingController();
    }
    super.initState();
  }

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
              SizedBox(
                height: 10.sp,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 20.sp,
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(color: Colors.grey.shade200),
                          ),
                          color: blueColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 90,
                              ),
                              // SizedBox(
                              //   width: 10,
                              // ),
                              Container(
                                width: 50.sp,
                                child: Center(
                                  child: Text(
                                    "CATEGORY",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 50.sp,
                                child: Center(
                                    child: Text(
                                  "CREATED DATE",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      categories(),
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

  StreamBuilder<QuerySnapshot<Object?>> categories() {
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
          return ListView.builder(
            //reverse: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            itemCount: categories.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.only(right: 20, bottom: 20),
                  decoration: BoxDecoration(
                    color: CommonColor.greyColorF2F2F2,
                    // image: DecorationImage(
                    //   image:
                    //       NetworkImage(categories[index]['category_image'][0]),
                    //   fit: BoxFit.cover,
                    // ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Image.network(
                      categories[index]['category_image'][0],
                      height: 70,
                      width: 70,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 50.sp,
                  child: CommonText.textBoldWight700(
                      text: categories[index]['category_name'], fontSize: 15),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 50.sp,
                  child: CommonText.textBoldWight700(
                      text: '09/11/22', fontSize: 15),
                ),
                SizedBox(
                  width: 10,
                ),
                GetBuilder<HandleScreenController>(
                  builder: (controller) => InkWell(
                    onTap: () {
                      //controller.changeTapped3(true);
                      editCategoryController.addCategoryData(
                        docId: categories[index].id,
                        categoryName: categories[index]['category_name'],
                        categoryImage: categories[index]['category_image'],
                      );
                      Get.dialog(
                        StatefulBuilder(
                          builder: (context, setState) => Dialog(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 13.sp, right: 13.sp),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonWidget.commonSizedBox(height: 20),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Center(
                                        child: CommonText.textBoldWight700(
                                            text: 'Edit Category',
                                            fontSize: 8.sp),
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                  CommonWidget.commonSizedBox(height: 20),
                                  CommonText.textBoldWight500(
                                      text: 'Edit Category Icon',
                                      fontSize: 7.sp),
                                  CommonWidget.commonSizedBox(height: 10),
                                  GetBuilder<EditCategoryController>(
                                    builder: (controller) => InkWell(
                                      onTap: () async {
                                        FilePickerResult? selectedImages =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: [
                                            'jpg',
                                            'png',
                                            'webp',
                                            'jpeg'
                                          ],
                                        );

                                        if (selectedImages != null) {
                                          selectedImages.files
                                              .forEach((element) {
                                            editCategoryController
                                                    .categoryImage![0] =
                                                element.bytes;
                                          });

                                          //Uint8List? file = selectedImages!.files.first.bytes;

                                          print(
                                              'selectedImages  image of  ${selectedImages}');
                                          //print("Image List Length:${_listOfImage.length}");
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        height: 200,
                                        width: 200,
                                        child: editCategoryController
                                                    .categoryImage!.length !=
                                                0
                                            ? editCategoryController
                                                        .categoryImage![0]
                                                        .runtimeType ==
                                                    Uint8List
                                                ? Image.memory(
                                                    editCategoryController
                                                            .categoryImage![0]
                                                        as Uint8List,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    '${editCategoryController.categoryImage![0].toString()}',
                                                    fit: BoxFit.cover)
                                            : Icon(Icons.add),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  CommonWidget.commonSizedBox(height: 35),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommonText.textBoldWight500(
                                          text: 'Category Name',
                                          fontSize: 7.sp),
                                      CommonWidget.commonSizedBox(height: 10),
                                      SizedBox(
                                        width: 30.w,
                                        child: CommonWidget.textFormField(
                                            controller: categoryTitle!),
                                      ),
                                    ],
                                  ),
                                  CommonWidget.commonSizedBox(height: 50),
                                  SizedBox(
                                    width: 50.sp,
                                    child: isLoading
                                        ? MaterialButton(
                                            onPressed: () async {
                                              if (categoryTitle!
                                                  .text.isNotEmpty) {
                                                isLoading = false;
                                                setState(() {});

                                                // var getAllURL = await uploadFiles(
                                                //     editCategoryController.categoryImage!);
                                                // print('url of image $getAllURL');

                                                List uploadImage = [];
                                                List existImage = [];

                                                try {
                                                  editCategoryController
                                                      .categoryImage!
                                                      .forEach((element) {
                                                    if (element.runtimeType ==
                                                        Uint8List) {
                                                      uploadImage.add(element);
                                                    } else {
                                                      existImage.add(element);
                                                    }
                                                  });
                                                } catch (e) {}
                                                print(
                                                    'image length for up  ${uploadImage.length}  ${existImage.length}');
                                                if (uploadImage.length != 0) {
                                                  var getAllURL =
                                                      await uploadFiles(
                                                          uploadImage);
                                                  getAllURL.forEach((element) {
                                                    existImage.add(element);
                                                  });
                                                  print(
                                                      'url of image ${existImage}');
                                                }

                                                await FirebaseFirestore.instance
                                                    .collection('Admin')
                                                    .doc('categories')
                                                    .collection(
                                                        'categories_list')
                                                    .doc(editCategoryController
                                                        .docId)
                                                    .update({
                                                  'category_name':
                                                      categoryTitle!.text,
                                                  'category_image': existImage,
                                                });

                                                _listOfImage.clear();

                                                isLoading = true;
                                                setState(() {});

                                                //Get.back();
                                                //Navigator.pop(context);
                                                controller.changeTapped3(false);
                                                Get.back();
                                                CommonWidget.getSnackBar(
                                                    color: themColors309D9D,
                                                    duration: 2,
                                                    title: 'Successful!',
                                                    message:
                                                        'Your Category Edited Successfully');
                                              } else {
                                                isLoading = false;
                                                CommonWidget.getSnackBar(
                                                    duration: 2,
                                                    title: 'Required',
                                                    message:
                                                        'Please Enter All Valid Details');
                                              }
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            color: themColors309D9D,
                                            height: 20.sp,
                                            child: Padding(
                                              padding: const EdgeInsets.all(2),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CommonText.textBoldWight500(
                                                        text: "Update Category",
                                                        color: Colors.white,
                                                        fontSize: 5.sp)
                                                  ]),
                                            ),
                                          )
                                        : Center(
                                            child: CircularProgressIndicator(
                                            color: themColors309D9D,
                                          )),
                                  ),
                                  CommonWidget.commonSizedBox(height: 30),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                      //Get.to(() => EditCategoryScreen());
                    },
                    child: Container(
                      height: 10.sp,
                      width: 10.sp,
                      decoration: BoxDecoration(
                        border: Border.all(color: themColors309D9D, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: CommonColor.greyColor838589,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
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
                  child: Container(
                    height: 10.sp,
                    width: 10.sp,
                    decoration: BoxDecoration(
                      border: Border.all(color: themColors309D9D, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      Icons.delete,
                      size: 20,
                      color: CommonColor.greyColor838589,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () async {
                    Get.dialog(
                      await addCategory(),
                    );
                  },
                  child: Container(
                    height: 10.sp,
                    width: 10.sp,
                    decoration: BoxDecoration(
                      border: Border.all(color: themColors309D9D, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color: CommonColor.greyColor838589,
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
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

  // StreamBuilder<QuerySnapshot<Object?>> categories() {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance
  //         .collection('Admin')
  //         .doc('categories')
  //         .collection('categories_list')
  //         .snapshots(),
  //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //       if (snapshot.hasData) {
  //         List<DocumentSnapshot> categories = snapshot.data!.docs;
  //         print("length======>${categories.length}");
  //         if (searchText.isNotEmpty) {
  //           categories = categories.where((element) {
  //             return element
  //                 .get('category_name')
  //                 .toString()
  //                 .toLowerCase()
  //                 .contains(searchText.toLowerCase());
  //           }).toList();
  //         }
  //         return GridView.builder(
  //           //reverse: true,
  //           physics: NeverScrollableScrollPhysics(),
  //           padding: EdgeInsets.symmetric(horizontal: 15),
  //           itemCount: categories.length,
  //           shrinkWrap: true,
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: Responsive.isDesktop(context) ? 5 : 3,
  //               crossAxisSpacing: 15,
  //               mainAxisSpacing: 10,
  //               mainAxisExtent: 300
  //               //hildAspectRatio:
  //               //Responsive.isDesktop(context) ? 2 / 2.4 : 2 / 2.9,
  //               ),
  //           itemBuilder: (context, index) => Column(
  //             children: [
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Stack(
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () {},
  //                     child: Container(
  //                       height: 250,
  //                       width: 250,
  //                       decoration: BoxDecoration(
  //                         color: CommonColor.greyColorF2F2F2,
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       child: Center(
  //                         child: Image.network(
  //                           categories[index]['category_image'][0],
  //                           height: 180,
  //                           width: 180,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   Positioned(
  //                     top: 4.sp,
  //                     right: 16.sp,
  //                     child: GetBuilder<HandleScreenController>(
  //                       builder: (controller) => CircleAvatar(
  //                         radius: 15,
  //                         backgroundColor: Colors.white,
  //                         child: InkWell(
  //                           onTap: () {
  //                             controller.changeTapped3(true);
  //
  //                             editCategoryController.addCategoryData(
  //                               docId: categories[index].id,
  //                               categoryName: categories[index]
  //                                   ['category_name'],
  //                               categoryImage: categories[index]
  //                                   ['category_image'],
  //                             );
  //
  //                             //Get.to(() => EditCategoryScreen());
  //                           },
  //                           child: Icon(
  //                             Icons.edit,
  //                             size: 20,
  //                             color: CommonColor.greyColor838589,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   Positioned(
  //                     top: 4.sp,
  //                     right: 4.sp,
  //                     child: CircleAvatar(
  //                       radius: 15,
  //                       backgroundColor: Colors.white,
  //                       child: InkWell(
  //                         onTap: () {
  //                           Get.dialog(AlertDialog(
  //                             title: Text(
  //                                 "Are you sure that you want to delete this category?"),
  //                             actions: [
  //                               TextButton(
  //                                 onPressed: () {
  //                                   Get.back();
  //                                 },
  //                                 child: Text('NO'),
  //                               ),
  //                               TextButton(
  //                                 onPressed: () {
  //                                   FirebaseFirestore.instance
  //                                       .collection('Admin')
  //                                       .doc('categories')
  //                                       .collection('categories_list')
  //                                       .doc(categories[index].id)
  //                                       .delete();
  //                                   Get.back();
  //                                 },
  //                                 child: Text('YES'),
  //                               ),
  //                             ],
  //                           ));
  //                         },
  //                         child: Icon(
  //                           Icons.delete,
  //                           size: 20,
  //                           color: CommonColor.greyColor838589,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: 12,
  //               ),
  //               CommonText.textBoldWight700(
  //                   text: categories[index]['category_name'], fontSize: 15),
  //               SizedBox(
  //                 height: 6,
  //               ),
  //             ],
  //           ),
  //         );
  //       } else {
  //         return CategoryShimmer();
  //       }
  //     },
  //   );
  // }
  Future<StatefulBuilder> addCategory() async {
    return StatefulBuilder(
      builder: (context, setState) => Dialog(
        child: Padding(
          padding: EdgeInsets.only(left: 13.sp, right: 13.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidget.commonSizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: CommonText.textBoldWight700(
                        text: 'Add Category', fontSize: 8.sp),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              CommonWidget.commonSizedBox(height: 20),
              CommonText.textBoldWight500(
                  text: 'Upload Category Icon', fontSize: 7.sp),
              CommonWidget.commonSizedBox(height: 10),
              InkWell(
                onTap: () async {
                  FilePickerResult? selectedImages =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'png', 'webp', 'jpeg'],
                  );

                  if (selectedImages != null) {
                    selectedImages.files.forEach((element) {
                      _listOfImage.add(element.bytes!);
                    });
                    //Uint8List? file = selectedImages!.files.first.bytes;

                    print('selectedImages  image of  ${selectedImages}');
                    //print("Image List Length:${_listOfImage.length}");
                    setState(() {});
                  }
                },
                child: Container(
                  height: 200,
                  width: 200,
                  child: _listOfImage.length != 0
                      ? Image.memory(
                          _listOfImage[0],
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.add),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                ),
              ),
              CommonWidget.commonSizedBox(height: 35),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText.textBoldWight500(
                      text: 'Category Name', fontSize: 7.sp),
                  CommonWidget.commonSizedBox(height: 10),
                  CommonWidget.textFormField(controller: categoryTitle!),
                ],
              ),
              CommonWidget.commonSizedBox(height: 50),
              SizedBox(
                width: 50.sp,
                child: isLoading
                    ? MaterialButton(
                        onPressed: () async {
                          if (_listOfImage.length != 0 &&
                              categoryTitle!.text.isNotEmpty) {
                            isLoading = false;
                            setState(() {});

                            var getAllURL = await uploadFiles(_listOfImage);
                            print('url of image $getAllURL');

                            await FirebaseFirestore.instance
                                .collection('Admin')
                                .doc('categories')
                                .collection('categories_list')
                                .add({
                              'category_name': categoryTitle!.text,
                              'category_image': getAllURL,
                            });

                            categoryTitle!.clear();
                            _listOfImage.clear();

                            _listOfImage.clear();
                            isLoading = true;
                            setState(() {});

                            //Get.back();
                            //Navigator.pop(context);
                            //controller.changeTapped2(false);
                            Get.back();

                            CommonWidget.getSnackBar(
                                color: themColors309D9D,
                                duration: 2,
                                title: 'Successful!',
                                message: 'Your Category Added Successfully');
                          } else {
                            CommonWidget.getSnackBar(
                                duration: 2,
                                title: 'Required',
                                message: 'Please Enter All Valid Details');
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        color: themColors309D9D,
                        height: 20.sp,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonText.textBoldWight500(
                                    text: "Add Category",
                                    color: Colors.white,
                                    fontSize: 5.sp)
                              ]),
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                        color: themColors309D9D,
                      )),
              ),
              CommonWidget.commonSizedBox(height: 30),
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
          Spacer(),
          GetBuilder<HandleScreenController>(
            builder: (controller) => CommonWidget.commonButton(
                onTap: () async {
                  Get.dialog(
                    await addCategory(),
                  );
                  //Navigator.pushNamed(context, '/AddProperty');
                },
                text: "Add New Category",
                radius: 40),
          ),
          SizedBox(
            width: 6.sp,
          ),
        ],
      ),
    );
  }

  Future<List<String>> uploadFiles(List _images) async {
    var imageUrls =
        await Future.wait(_images.map((_image) => uploadFile(_image)));
    print('all url  ${imageUrls}');
    return imageUrls;
  }

  Future<String> uploadFile(Uint8List _image) async {
    String finalImage = '';

    String getUrl = "files/${DateTime.now()}";
    var task = FirebaseStorage.instance.ref().child(getUrl);

    await task
        .putData(_image, SettableMetadata(contentType: 'image/jpeg'))
        .then((p0) async {
      finalImage = await p0.storage.ref(getUrl).getDownloadURL();
    });
    return finalImage;
  }
}
