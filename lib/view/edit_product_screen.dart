import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../components/common_widget.dart';
import '../constant/color_const.dart';
import '../constant/text_const.dart';
import '../constant/text_styel.dart';
import '../controller/edit_property_controller.dart';
import '../model/req_model/add_property_req_model.dart';
import 'package:get/get.dart';

class EditPropertyScreen extends StatefulWidget {
  const EditPropertyScreen({Key? key}) : super(key: key);

  @override
  State<EditPropertyScreen> createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  double progress = 0.0;

  String category = "Home";

  List<String> categoryList = [
    'Home',
    'Villa',
    'Apartment',
  ];

  EditPropertyController editProductController = Get.find();

  TextEditingController? propertyName;
  TextEditingController? address;
  TextEditingController? size;
  TextEditingController? price;
  TextEditingController? totalBedRooms;
  TextEditingController? totalBathrooms;
  TextEditingController? description;

  AddPropertyReqModel _addProductReqModel = AddPropertyReqModel();
  bool isLoading = true;

  bool isParkingAvailable = false;

  @override
  void initState() {
    print(
        'editProductController.propertyName   ${editProductController.propertyName}');
    propertyName =
        TextEditingController(text: editProductController.propertyName);
    address = TextEditingController(text: editProductController.address);
    size = TextEditingController(text: editProductController.size);
    price = TextEditingController(text: editProductController.price);
    totalBedRooms =
        TextEditingController(text: editProductController.totalBedRooms);
    totalBathrooms =
        TextEditingController(text: editProductController.totalBathrooms);
    description =
        TextEditingController(text: editProductController.description);

    category = editProductController.category!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(6.sp),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidget.commonSizedBox(height: 20),
              CommonText.textBoldWight700(
                  text: 'Edit Property', fontSize: 10.sp),
              CommonWidget.commonSizedBox(height: 20),
              GetBuilder<EditPropertyController>(
                builder: (controller) => Row(
                  children: [
                    editProductController.listOfImage!.length != 0
                        ? Row(
                            children: List.generate(
                              editProductController.listOfImage!.length,
                              (index) => Container(
                                height: 200,
                                width: 200,
                                child: editProductController
                                            .listOfImage![index].runtimeType ==
                                        Uint8List
                                    ? Image.memory(
                                        editProductController
                                            .listOfImage![index] as Uint8List,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        '${editProductController.listOfImage![index].toString()}',
                                        fit: BoxFit.cover),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                              ),
                            ),
                          )
                        : SizedBox(),
                    InkWell(
                      onTap: () async {
                        FilePickerResult? selectedImages =
                            await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'png', 'webp', 'jpeg'],
                        );
                        // final List<XFile>? selectedImages =
                        //     await _picker.pickMultiImage();

                        if (selectedImages != null) {
                          selectedImages.files.forEach((element) {
                            editProductController.listOfImage!
                                .add(element.bytes!);
                          });

                          print(
                              'selectedImages  image of  ${selectedImages.files.first.bytes.runtimeType}');
                        }
                        print(
                            "Image List Length:${editProductController.listOfImage!.length}");
                        setState(() {});
                      },
                      child: Container(
                        height: 200,
                        width: 200,
                        child: Icon(Icons.add),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
              CommonWidget.commonSizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText.textBoldWight500(
                          text: 'Property Name', fontSize: 7.sp),
                      CommonWidget.commonSizedBox(height: 10),
                      CommonWidget.textFormField(controller: propertyName!),
                    ],
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //CommonWidget.commonSizedBox(height: 18),
                      CommonText.textBoldWight500(
                          text: 'Select Category', fontSize: 7.sp),
                      CommonWidget.commonSizedBox(height: 10),
                      Container(
                        height: 14.sp,
                        width: 50.sp,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: Colors.grey)),
                        child: Center(
                          child: DropdownButton(
                            underline: SizedBox(),
                            value: category,
                            items: categoryList.map((e) {
                              return DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                category = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      CommonWidget.commonSizedBox(height: 30),
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //CommonWidget.commonSizedBox(height: 20),
                  CommonText.textBoldWight500(text: 'Address', fontSize: 7.sp),
                  CommonWidget.commonSizedBox(height: 10),
                  CommonWidget.textFormField(controller: address!),
                  CommonWidget.commonSizedBox(height: 20),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText.textBoldWight500(text: 'Size', fontSize: 7.sp),
                  CommonWidget.commonSizedBox(height: 10),
                  CommonWidget.textFormField(
                    controller: size!,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonWidget.commonSizedBox(height: 20),
                  CommonText.textBoldWight500(
                      text: 'Total BedRooms', fontSize: 7.sp),
                  CommonWidget.commonSizedBox(height: 10),
                  CommonWidget.textFormField(
                    controller: totalBedRooms!,
                  ),
                  CommonWidget.commonSizedBox(height: 20),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText.textBoldWight500(
                      text: 'Total BathRooms', fontSize: 7.sp),
                  CommonWidget.commonSizedBox(height: 10),
                  SizedBox(
                    width: 150.sp,
                    child: TextFormField(
                      controller: totalBathrooms,
                      maxLines: 5,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: TextConst.fontFamily,
                      ),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 7.sp, left: 6.sp),
                        filled: true,
                        fillColor: Colors.white,
                        // hintText: "Write Description here",
                        hintStyle: TextStyle(
                            fontFamily: TextConst.fontFamily,
                            fontWeight: FontWeight.w500,
                            color: CommonColor.hinTextColor),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themColors309D9D),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText.textBoldWight500(
                      text: 'Description', fontSize: 7.sp),
                  CommonWidget.commonSizedBox(height: 10),
                  SizedBox(
                    width: 150.sp,
                    child: TextFormField(
                      controller: description,
                      maxLines: 5,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: TextConst.fontFamily,
                      ),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 7.sp, left: 6.sp),
                        filled: true,
                        fillColor: Colors.white,
                        // hintText: "Write Description here",
                        hintStyle: TextStyle(
                            fontFamily: TextConst.fontFamily,
                            fontWeight: FontWeight.w500,
                            color: CommonColor.hinTextColor),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themColors309D9D),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              CommonWidget.commonSizedBox(height: 50),
              SizedBox(
                width: 50.sp,
                child: isLoading
                    ? MaterialButton(
                        onPressed: () async {
                          if (editProductController.listOfImage!.length != 0 &&
                              price!.text.isNotEmpty &&
                              propertyName!.text.isNotEmpty &&
                              size!.text.isNotEmpty &&
                              description!.text.isNotEmpty &&
                              totalBathrooms!.text.isNotEmpty &&
                              totalBedRooms!.text.isNotEmpty) {
                            isLoading = false;
                            setState(() {});
                            List uploadImage = [];
                            List existImage = [];

                            try {
                              editProductController.listOfImage!
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

                            _addProductReqModel.listOfImage = existImage;
                            _addProductReqModel.propertyName =
                                propertyName!.text;
                            _addProductReqModel.size = size!.text;
                            _addProductReqModel.address = address!.text;
                            _addProductReqModel.totalBathrooms =
                                totalBathrooms!.text;
                            _addProductReqModel.totalBedRooms =
                                totalBedRooms!.text;
                            _addProductReqModel.isParkingAvailable =
                                isParkingAvailable;
                            _addProductReqModel.price = size!.text;
                            _addProductReqModel.description =
                                totalBathrooms!.text;
                            _addProductReqModel.category = category;

                            await FirebaseFirestore.instance
                                .collection('Admin')
                                .doc('all_properties')
                                .collection('property_data')
                                .doc(editProductController.docId)
                                .update(_addProductReqModel.toJson());
                            price!.clear();
                            propertyName!.clear();
                            size!.clear();
                            description!.clear();
                            totalBedRooms!.clear();
                            totalBathrooms!.clear();
                            category = "Home";
                            editProductController.listOfImage!.clear();
                            isLoading = true;
                            setState(() {});
                            CommonWidget.getSnackBar(
                                color: themColors309D9D,
                                duration: 2,
                                title: 'Successful!',
                                message: 'Your Property has been Edited');
                          } else {
                            CommonWidget.getSnackBar(
                                title: 'Required',
                                message: 'Please Enter Valid Details');
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
                                    text: "Edit",
                                    color: Colors.white,
                                    fontSize: 5.sp)
                              ]),
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                        color: themColors309D9D,
                      )),
              )
            ],
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
