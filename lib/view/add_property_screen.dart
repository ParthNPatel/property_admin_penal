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
import '../model/req_model/add_property_req_model.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({Key? key}) : super(key: key);

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  double progress = 0.0;

  List<Uint8List> _listOfImage = [];

  String category = "Home";

  List<String> categoryList = [
    'Home',
    'Villa',
    'Apartment',
  ];

  final propertyName = TextEditingController();
  final address = TextEditingController();
  final size = TextEditingController();
  final price = TextEditingController();
  final totalBedRooms = TextEditingController();
  final totalBathrooms = TextEditingController();
  final description = TextEditingController();

  bool isParkingAvailable = false;

  AddPropertyReqModel _addProductReqModel = AddPropertyReqModel();
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 6,
      child: Padding(
        padding: EdgeInsets.all(6.sp),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidget.commonSizedBox(height: 20),
              CommonText.textBoldWight700(
                  text: 'Add New Property', fontSize: 10.sp),
              CommonWidget.commonSizedBox(height: 20),
              Row(
                children: [
                  _listOfImage.length != 0
                      ? Row(
                          children: List.generate(
                            _listOfImage.length,
                            (index) => Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: MemoryImage(_listOfImage[index]),
                                      fit: BoxFit.cover),
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
                          _listOfImage.add(element.bytes!);
                        });
                        // Uint8List? file = selectedImages.files.first.bytes;

                        print('selectedImages  image of  ${selectedImages}');
                      }
                      print("Image List Length:${_listOfImage.length}");
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
                      CommonWidget.textFormField(controller: propertyName),
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
                  CommonText.textBoldWight500(text: 'Addresss', fontSize: 7.sp),
                  CommonWidget.commonSizedBox(height: 10),
                  CommonWidget.textFormField(controller: address),
                  CommonWidget.commonSizedBox(height: 20),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText.textBoldWight500(text: 'Size', fontSize: 7.sp),
                  CommonWidget.commonSizedBox(height: 10),
                  CommonWidget.textFormField(
                    controller: size,
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
                    controller: totalBedRooms,
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
                  CommonWidget.textFormField(
                    controller: totalBathrooms,
                  ),
                ],
              ),
              CommonWidget.commonSizedBox(height: 30),
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
                          if (_listOfImage.length != 0 &&
                              size.text.isNotEmpty &&
                              address.text.isNotEmpty &&
                              totalBedRooms.text.isNotEmpty &&
                              totalBathrooms.text.isNotEmpty &&
                              propertyName.text.isNotEmpty) {
                            isLoading = false;
                            setState(() {});

                            var getAllURL = await uploadFiles(_listOfImage);
                            print('url of image $getAllURL');

                            _addProductReqModel.listOfImage = getAllURL;
                            _addProductReqModel.propertyName =
                                propertyName.text;
                            _addProductReqModel.size = size.text;
                            _addProductReqModel.address = address.text;
                            _addProductReqModel.totalBathrooms =
                                totalBathrooms.text;
                            _addProductReqModel.totalBedRooms =
                                totalBedRooms.text;
                            _addProductReqModel.isParkingAvailable =
                                isParkingAvailable;
                            _addProductReqModel.price = size.text;
                            _addProductReqModel.description =
                                totalBathrooms.text;
                            _addProductReqModel.category = category;

                            await FirebaseFirestore.instance
                                .collection('Admin')
                                .doc('all_properties')
                                .collection('property_data')
                                .add(_addProductReqModel.toJson());
                            size.clear();
                            address.clear();
                            totalBedRooms.clear();
                            totalBathrooms.clear();
                            propertyName.clear();
                            category = "Home";

                            _listOfImage.clear();
                            isLoading = true;
                            setState(() {});
                            CommonWidget.getSnackBar(
                                color: themColors309D9D,
                                duration: 2,
                                title: 'Successful!',
                                message: 'Your Property Added Successfully');
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
                                    text: "Add",
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
      //   _uploadOfImage.add(await p0.storage.ref(getUrl).getDownloadURL());
    });
    // await task.snapshotEvents.listen((event) async {
    //   double progress = 0.0;
    //
    //   progress =
    //       ((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *
    //               100)
    //           .roundToDouble();
    //
    //   if (progress == 100) {
    //     finalImage = await event.ref.getDownloadURL();
    //     log('final url for  ${finalImage}');
    //     _uploadOfImage.add(finalImage);
    //   } else {
    //     finalImage = '';
    //   }
    //
    //   print(progress);
    // });

    return finalImage;
  }
}
