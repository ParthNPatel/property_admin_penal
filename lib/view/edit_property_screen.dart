import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:property/controller/handle_screen_controller.dart';
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

  // List<String> categoryList = [
  //   'Home',
  //   'Villa',
  //   'Apartment',
  // ];

  EditPropertyController editProductController = Get.find();

  HandleScreenController controller = Get.find();

  TextEditingController? propertyName;
  TextEditingController? address;
  TextEditingController? address1;
  TextEditingController? country;
  TextEditingController? pinCode;

  TextEditingController? postalCode;
  TextEditingController? size;
  TextEditingController? price;
  TextEditingController? totalBedRooms;
  TextEditingController? totalBathrooms;
  TextEditingController? description;
  TextEditingController? propertyStatus;

  TextEditingController? label;
  TextEditingController? garages;
  List<TextEditingController> _controllers = [];

  int groupValue = 1;

  AddPropertyReqModel _addProductReqModel = AddPropertyReqModel();
  bool isLoading = true;

  bool isParkingAvailable = false;
  bool isNewBuild = false;
  bool isSharedOwnerShip = false;
  bool underOffer = false;

  final featureController = TextEditingController();

  List featureList = [];

  String dropDownValue = "For Rent";

  List<String> dropDownList = [
    "For Rent",
    "To Sale",
  ];

  @override
  void initState() {
    print(
        'editProductController.propertyName   ${editProductController.nearByPlaces}');

    propertyName =
        TextEditingController(text: editProductController.propertyName);
    address = TextEditingController(text: editProductController.address);
    address1 = TextEditingController(text: editProductController.address1);
    country = TextEditingController(text: editProductController.country);
    pinCode = TextEditingController(text: editProductController.pinCode);
    size = TextEditingController(text: editProductController.size);
    price = TextEditingController(text: editProductController.price);
    totalBedRooms =
        TextEditingController(text: editProductController.totalBedRooms);
    totalBathrooms =
        TextEditingController(text: editProductController.totalBathrooms);
    description =
        TextEditingController(text: editProductController.description);
    propertyStatus =
        TextEditingController(text: editProductController.propertyStatus);
    label = TextEditingController(text: editProductController.label);
    garages = TextEditingController(text: editProductController.garages);

    log('list of nera by place  ${editProductController.features!}');

    featureList.addAll(editProductController.features!);
    print('tetettettete  ${featureList}');
    category = editProductController.category!;

    try {
      category = editProductController.category!;
      isNewBuild = editProductController.isNewBuild!;
      isSharedOwnerShip = editProductController.isSharedOwnerShip!;
      underOffer = editProductController.underOffer!;
    } catch (e) {
      isNewBuild = false;
      isSharedOwnerShip = false;
      underOffer = false;
      category = "Home";
    }

    super.initState();
  }

  bool isOpened = false;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 8,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Padding(
          padding: EdgeInsets.only(
              left: 10.sp, right: isOpened == true ? 15.sp : 28.sp),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidget.commonSizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GetBuilder<HandleScreenController>(
                      builder: (controller) => IconButton(
                        onPressed: () {
                          controller.changeTapped1(false);
                        },
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                    ),
                    Spacer(),
                    Center(
                      child: CommonText.textBoldWight700(
                          text: 'Edit Property', fontSize: 10.sp),
                    ),
                    Spacer(),
                  ],
                ),
                CommonWidget.commonSizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 10)),
                  child: GetBuilder<EditPropertyController>(
                    builder: (controller) => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () async {
                              FilePickerResult? selectedImages =
                                  await FilePicker.platform.pickFiles(
                                allowMultiple: true,
                                type: FileType.custom,
                                allowedExtensions: [
                                  'jpg',
                                  'png',
                                  'webp',
                                  'jpeg'
                                ],
                              );

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
                              height: 250,
                              width: 200,
                              child: Icon(Icons.add),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2.5),
                              ),
                            ),
                          ),
                          editProductController.listOfImage!.length != 0
                              ? Padding(
                                  padding: EdgeInsets.only(right: 10.sp),
                                  child: Row(
                                    children: List.generate(
                                      editProductController
                                                  .listOfImage!.length >
                                              6
                                          ? isOpened == true
                                              ? editProductController
                                                  .listOfImage!.length
                                              : 6
                                          : editProductController
                                              .listOfImage!.length,
                                      (index) => Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: 250,
                                            width: 200,
                                            child: editProductController
                                                        .listOfImage![index]
                                                        .runtimeType ==
                                                    Uint8List
                                                ? Image.memory(
                                                    editProductController
                                                            .listOfImage![index]
                                                        as Uint8List,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    '${editProductController.listOfImage![index].toString()}',
                                                    fit: BoxFit.cover),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black)),
                                          ),
                                          editProductController
                                                          .listOfImage!.length >
                                                      6 &&
                                                  index == 5
                                              ? isOpened == true
                                                  ? SizedBox()
                                                  : Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                        height: 250,
                                                        width: 200,
                                                        color: Colors.black54,
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              isOpened = true;
                                                            });
                                                          },
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons.image,
                                                                color: Colors
                                                                    .white,
                                                                size: 13.sp,
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              CommonText.textBoldWight700(
                                                                  text:
                                                                      "and ${editProductController.listOfImage!.length - 5} More",
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      7.sp),
                                                            ],
                                                          ),
                                                        ),
                                                      ))
                                              : SizedBox(),
                                          Positioned(
                                            right: 5,
                                            top: 5,
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {});
                                                editProductController
                                                    .listOfImage!
                                                    .removeAt(index);
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: themColors309D9D,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
                CommonWidget.commonSizedBox(height: 40),
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
                        FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('Admin')
                              .doc('categories')
                              .collection('categories_list')
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                height: 14.sp,
                                width: 55.sp,
                                padding: EdgeInsets.only(left: 2.sp),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(color: Colors.grey)),
                                child: Center(
                                  child: DropdownButton(
                                    underline: SizedBox(),
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
                        CommonWidget.commonSizedBox(height: 30),
                      ],
                    )
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
                      width: 500.sp,
                      child: TextFormField(
                        controller: description,
                        maxLines: 15,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: TextConst.fontFamily,
                        ),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(top: 13.sp, left: 6.sp),
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
                CommonWidget.commonSizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText.textBoldWight500(
                        text: 'Property Features', fontSize: 7.sp),
                    CommonWidget.commonSizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 417.sp,
                          child: TextFormField(
                            controller: featureController,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: TextConst.fontFamily,
                            ),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(top: 13.sp, left: 6.sp),
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
                        SizedBox(
                          width: 5.sp,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {});
                            if (featureController.text.isNotEmpty) {
                              featureList.add(featureController.text);
                            }

                            featureController.clear();
                          },
                          child: Container(
                            height: 14.sp,
                            width: 14.sp,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(
                                color: themColors309D9D,
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              color: themColors309D9D,
                            ),
                          ),
                        )
                      ],
                    ),
                    CommonWidget.commonSizedBox(height: 10),
                    featureList.length != 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              featureList.length,
                              (index) => Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: CommonText.textBoldWight500(
                                        text: "• ${featureList[index]}",
                                        fontSize: 6.sp,
                                        color: themColors309D9D),
                                  ),
                                  SizedBox(
                                    width: 4.sp,
                                  ),
                                  InkResponse(
                                    onTap: () {
                                      setState(() {});
                                      featureList.removeAt(index);
                                    },
                                    child: Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.red.shade300,
                                      size: 23,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
                CommonWidget.commonSizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //CommonWidget.commonSizedBox(height: 20),
                    CommonText.textBoldWight500(
                        text: 'Address', fontSize: 7.sp),
                    CommonWidget.commonSizedBox(height: 10),
                    CommonWidget.textFormField(
                        controller: address!, hintText: "Address line 1"),
                    CommonWidget.commonSizedBox(height: 10),
                    CommonWidget.textFormField(
                        controller: address1!, hintText: "Address line 2"),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText.textBoldWight500(
                            text: 'Country', fontSize: 7.sp),
                        CommonWidget.commonSizedBox(height: 10),
                        SizedBox(
                          width: 70.sp,
                          child: CommonWidget.textFormField(
                            controller: country!,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonWidget.commonSizedBox(height: 20),
                        CommonText.textBoldWight500(
                            text: 'Zip Code', fontSize: 7.sp),
                        CommonWidget.commonSizedBox(height: 10),
                        SizedBox(
                          width: 70.sp,
                          child: CommonWidget.textFormField(
                            controller: pinCode!,
                          ),
                        ),
                        CommonWidget.commonSizedBox(height: 20),
                      ],
                    )
                  ],
                ),
                GetBuilder<EditPropertyController>(
                  builder: (controller) => Padding(
                    padding: EdgeInsets.only(right: 30.sp),
                    child: Column(
                      children: List.generate(
                          editProductController.nearByPlaces!.length > 5
                              ? 5
                              : editProductController.nearByPlaces!.length,
                          (index) {
                        editProductController.nearByPlaces!.forEach((element) {
                          print('elelelelelle   ${element}');
                          _controllers
                              .add(TextEditingController(text: element));
                        });
                        return Padding(
                          padding: const EdgeInsets.only(top: 13),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    CommonText.textBoldWight500(
                                        text: "${index + 1})"),
                                    // getKmWidget(snapshot, index),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    SizedBox(
                                      width: 250.sp,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 3.sp),
                                        child: TextFormField(
                                          controller: _controllers[index],
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: TextConst.fontFamily,
                                          ),
                                          cursorColor: Colors.black,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                top: 7.sp, left: 6.sp),
                                            filled: true,
                                            fillColor: Colors.white,
                                            // hintText: "Write Description here",
                                            hintStyle: TextStyle(
                                                fontFamily:
                                                    TextConst.fontFamily,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    CommonColor.hinTextColor),
                                            border: InputBorder.none,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: themColors309D9D),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // CommonText.textBoldWight500(
                                    //     text:
                                    //         "${snapshot.data['results'][index]['name']}",
                                    //     color: Colors.black,
                                    //     fontSize: 17),

                                    // constWidgets.textWidget(
                                    //     "School",
                                    //     FontWeight.w500,
                                    //     12,
                                    //     Colors.grey.shade400),
                                  ],
                                ),
                              ),

                              // SizedBox(
                              //   width: 4.sp,
                              // ),
                              // InkResponse(
                              //   onTap: () {
                              //     setState(() {});
                              //     snapshot.data['results']
                              //         .removeAt(index);
                              //   },
                              //   child: Icon(
                              //     Icons.remove_circle_outline,
                              //     color: Colors.red.shade300,
                              //     size: 20,
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 3.sp),
                          child: CommonText.textBoldWight500(
                              text: 'Size', fontSize: 7.sp),
                        ),
                        CommonWidget.commonSizedBox(width: 20),
                        SizedBox(
                          width: 50.sp,
                          child: CommonWidget.textFormField(
                            controller: size!,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CommonWidget.commonSizedBox(width: 20),
                        SizedBox(
                          width: 170,
                          child: RadioListTile(
                            activeColor: themColors309D9D,
                            value: 1,
                            groupValue: groupValue,
                            title: Text("Square feet"),
                            onChanged: (int? value) {
                              setState(() {
                                groupValue = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 190,
                          child: RadioListTile(
                            activeColor: themColors309D9D,
                            value: 2,
                            groupValue: groupValue,
                            title: Text("Square Meters"),
                            onChanged: (int? value) {
                              setState(() {
                                groupValue = value!;
                              });
                            },
                          ),
                        ),
                        CommonWidget.commonSizedBox(width: 20),
                      ],
                    ),
                    CommonWidget.commonSizedBox(width: 20),
                    CommonWidget.commonSizedBox(height: 20),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonWidget.commonSizedBox(height: 20),
                        CommonText.textBoldWight500(
                            text: 'Total BedRooms', fontSize: 7.sp),
                        CommonWidget.commonSizedBox(height: 10),
                        SizedBox(
                          width: 70.sp,
                          child: CommonWidget.textFormField(
                            controller: totalBedRooms!,
                            inpuFormator: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonWidget.commonSizedBox(height: 20),
                        CommonText.textBoldWight500(
                            text: 'Total BathRooms', fontSize: 7.sp),
                        CommonWidget.commonSizedBox(height: 10),
                        SizedBox(
                          width: 70.sp,
                          child: CommonWidget.textFormField(
                            controller: totalBathrooms!,
                            inpuFormator: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // CommonWidget.commonSizedBox(height: 20),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText.textBoldWight500(
                            text: 'Property Status', fontSize: 7.sp),
                        CommonWidget.commonSizedBox(height: 10),
                        Container(
                          height: 14.sp,
                          width: 70.sp,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(color: Colors.grey)),
                          child: Center(
                            child: DropdownButton(
                              underline: SizedBox(),
                              value: dropDownValue,
                              icon: Padding(
                                padding: EdgeInsets.only(left: 30.sp),
                                child: Icon(Icons.arrow_drop_down),
                              ),
                              items: dropDownList.map((e) {
                                return DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  dropDownValue = value as String;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonWidget.commonSizedBox(height: 20),
                        CommonText.textBoldWight500(
                            text: 'Price', fontSize: 7.sp),
                        CommonWidget.commonSizedBox(height: 10),
                        SizedBox(
                          width: 70.sp,
                          child: CommonWidget.textFormField(
                            controller: price!,
                            maxLength: 9,
                            inpuFormator: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        CommonWidget.commonSizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
                // CommonWidget.commonSizedBox(height: 20),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText.textBoldWight500(
                            text: 'Label', fontSize: 7.sp),
                        CommonWidget.commonSizedBox(height: 10),
                        SizedBox(
                          width: 70.sp,
                          child: CommonWidget.textFormField(
                            controller: label!,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText.textBoldWight500(
                            text: 'Garages', fontSize: 7.sp),
                        CommonWidget.commonSizedBox(height: 10),
                        SizedBox(
                          width: 70.sp,
                          child: CommonWidget.textFormField(
                            controller: garages!,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // CommonWidget.commonSizedBox(height: 20),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     CommonText.textBoldWight500(
                //         text: 'NearBy Places', fontSize: 7.sp),
                //     CommonWidget.commonSizedBox(height: 10),
                //     CommonWidget.textFormField(
                //       controller: nearByPlaces!,
                //     ),
                //   ],
                // ),

                CommonWidget.commonSizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidget.commonSizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 70.sp,
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: themColors309D9D,
                                value: isParkingAvailable,
                                onChanged: (value) {
                                  setState(() {
                                    isParkingAvailable = value!;
                                  });
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              CommonText.textBoldWight500(
                                  text: 'Parking Available', fontSize: 6.sp),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 5.sp,
                        ),
                        SizedBox(
                          width: 70.sp,
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: themColors309D9D,
                                value: isNewBuild,
                                onChanged: (value) {
                                  setState(() {
                                    isNewBuild = value!;
                                  });
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              CommonText.textBoldWight500(
                                  text: 'New Build Home', fontSize: 6.sp),
                            ],
                          ),
                        ),
                      ],
                    ),
                    CommonWidget.commonSizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(
                          width: 70.sp,
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: themColors309D9D,
                                value: isSharedOwnerShip,
                                onChanged: (value) {
                                  setState(() {
                                    isSharedOwnerShip = value!;
                                  });
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              CommonText.textBoldWight500(
                                  text: 'Shared Ownership', fontSize: 6.sp),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 5.sp,
                        ),
                        SizedBox(
                          width: 70.sp,
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: themColors309D9D,
                                value: underOffer,
                                onChanged: (value) {
                                  setState(() {
                                    underOffer = value!;
                                  });
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              CommonText.textBoldWight500(
                                  text: 'Under Offer', fontSize: 6.sp),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                CommonWidget.commonSizedBox(height: 50),

                SizedBox(
                  width: 50.sp,
                  child: isLoading
                      ? MaterialButton(
                          onPressed: () async {
                            if (editProductController.listOfImage!.length !=
                                    0 &&
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
                              _addProductReqModel.address = "${address!.text}";
                              _addProductReqModel.address1 =
                                  "${address1!.text}";
                              _addProductReqModel.country = country!.text;
                              _addProductReqModel.addressSearch =
                                  address!.text.toLowerCase();
                              _addProductReqModel.countrySearch =
                                  country!.text.toLowerCase();
                              _addProductReqModel.pinCode = pinCode!.text;
                              _addProductReqModel.totalBathrooms =
                                  totalBathrooms!.text;
                              _addProductReqModel.totalBedRooms =
                                  totalBedRooms!.text;
                              _addProductReqModel.isParkingAvailable =
                                  isParkingAvailable;
                              _addProductReqModel.price = price!.text;
                              _addProductReqModel.size = "${size!.text}";
                              _addProductReqModel.description =
                                  description!.text;
                              _addProductReqModel.category = category;
                              _addProductReqModel.propertyStatus =
                                  propertyStatus!.text;
                              _addProductReqModel.label = label!.text;
                              _addProductReqModel.garages = garages!.text;
                              // _addProductReqModel.nearByPlaces =
                              //     nearByPlaces!.text;
                              _addProductReqModel.features = featureList;
                              _addProductReqModel.isNewBuild = isNewBuild;
                              _addProductReqModel.underOffer = underOffer;
                              _addProductReqModel.isSharedOwnerShip =
                                  isSharedOwnerShip;
                              _addProductReqModel.propertySlugName =
                                  propertyName!.text.toLowerCase();

                              _addProductReqModel.propertyId =
                                  int.parse(editProductController.productId!);

                              await FirebaseFirestore.instance
                                  .collection('property_data')
                                  .doc(editProductController.docId)
                                  .update(_addProductReqModel.toJson());

                              size!.clear();
                              address!.clear();
                              country!.clear();
                              pinCode!.clear();
                              propertyStatus!.clear();
                              label!.clear();
                              garages!.clear();
                              //nearByPlaces!.clear();
                              totalBedRooms!.clear();
                              totalBathrooms!.clear();
                              propertyName!.clear();

                              category = "Home";
                              editProductController.listOfImage!.clear();
                              isLoading = true;
                              setState(() {});
                              //Navigator.pop(context);
                              controller.changeTapped1(false);
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
                                      text: "Update",
                                      color: Colors.white,
                                      fontSize: 5.sp)
                                ]),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            color: themColors309D9D,
                          ),
                        ),
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
