import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:property/controller/edit_category_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../components/common_widget.dart';
import '../constant/color_const.dart';
import '../constant/text_styel.dart';

class EditCategoryScreen extends StatefulWidget {
  const EditCategoryScreen({Key? key}) : super(key: key);

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  EditCategoryController editCategoryController = Get.find();

  double progress = 0.0;

  List _listOfImage = [];
  bool isLoading = true;

  TextEditingController? categoryTitle;

  @override
  void initState() {
    categoryTitle =
        TextEditingController(text: editCategoryController.categoryName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        //Get.back();
        return new Future(() => true);
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 6.sp, left: 13.sp),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidget.commonSizedBox(height: 20),
                Center(
                  child: CommonText.textBoldWight700(
                      text: 'Edit Category', fontSize: 10.sp),
                ),
                CommonWidget.commonSizedBox(height: 20),
                CommonText.textBoldWight500(
                    text: 'Edit Category Icon', fontSize: 7.sp),
                CommonWidget.commonSizedBox(height: 10),
                GetBuilder<EditCategoryController>(
                  builder: (controller) => InkWell(
                    onTap: () async {
                      FilePickerResult? selectedImages =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'png', 'webp', 'jpeg'],
                      );

                      if (selectedImages != null) {
                        selectedImages.files.forEach((element) {
                          editCategoryController.categoryImage![0] =
                              element.bytes;
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
                      child: editCategoryController.categoryImage!.length != 0
                          ? editCategoryController
                                      .categoryImage![0].runtimeType ==
                                  Uint8List
                              ? Image.memory(
                                  editCategoryController.categoryImage![0]
                                      as Uint8List,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  '${editCategoryController.categoryImage![0].toString()}',
                                  fit: BoxFit.cover)
                          : Icon(Icons.add),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                    ),
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
                            if (categoryTitle!.text.isNotEmpty) {
                              isLoading = false;
                              setState(() {});

                              // var getAllURL = await uploadFiles(
                              //     editCategoryController.categoryImage!);
                              // print('url of image $getAllURL');

                              List uploadImage = [];
                              List existImage = [];

                              try {
                                editCategoryController.categoryImage!
                                    .forEach((element) {
                                  if (element.runtimeType == Uint8List) {
                                    uploadImage.add(element);
                                  } else {
                                    existImage.add(element);
                                  }
                                });
                              } catch (e) {}
                              print(
                                  'image length for up  ${uploadImage.length}  ${existImage.length}');
                              if (uploadImage.length != 0) {
                                var getAllURL = await uploadFiles(uploadImage);
                                getAllURL.forEach((element) {
                                  existImage.add(element);
                                });
                                print('url of image ${existImage}');
                              }

                              await FirebaseFirestore.instance
                                  .collection('Admin')
                                  .doc('categories')
                                  .collection('categories_list')
                                  .doc(editCategoryController.docId)
                                  .update({
                                'category_name': categoryTitle!.text,
                                'category_image': existImage,
                              });

                              _listOfImage.clear();

                              isLoading = true;
                              setState(() {});

                              //Get.back();
                              Navigator.pop(context);

                              CommonWidget.getSnackBar(
                                  color: themColors309D9D,
                                  duration: 2,
                                  title: 'Successful!',
                                  message: 'Your Category Edited Successfully');
                            } else {
                              isLoading = false;
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
                                      text: "Edit Category",
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
