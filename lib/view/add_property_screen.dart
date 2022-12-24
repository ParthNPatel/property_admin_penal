import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_geocoder_krutus/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:property/controller/handle_screen_controller.dart';
import 'package:sizer/sizer.dart';
import '../components/common_widget.dart';
import '../constant/color_const.dart';
import '../constant/text_const.dart';
import '../constant/text_styel.dart';
import '../model/req_model/add_property_req_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_geocoder_krutus/google_geocoder_krutus.dart';
//import 'dart:math' show sin;

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({Key? key}) : super(key: key);

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  double progress = 0.0;

  List<Uint8List> _listOfImage = [];

  List<Uint8List> florPlan = [];
  List<Uint8List> leaseHold = [];
  List<Uint8List> ecp = [];
  List<Uint8List> councilTax = [];

  List featureList = [];

  String category = "Home";

  String dropDownValue = "For Rent";

  List<String> dropDownList = [
    "For Rent",
    "To Sale",
  ];

  bool isOpened = false;

  // List<String> categoryList = [
  //   'Home',
  //   'Villa',
  //   'Apartment',
  // ];

  //final kGoogleApiKey = 'AIzaSyCMYLPYjJOBU6Pn_ho0IwbEIZNZfH-yjlg';

  final kGoogleApiKey = 'AIzaSyBLjgELUHE9X1z5OI0if3tMRDG5nWK2Rt8';

  // Future<void> displayPrediction(Prediction p) async {
  //   GoogleMapsPlaces places = GoogleMapsPlaces(
  //       apiKey: kGoogleApiKey,
  //       apiHeaders: await const GoogleApiHeaders().getHeaders());
  //
  //   PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
  //
  //   lat = detail.result.geometry!.location.lat;
  //   long = detail.result.geometry!.location.lng;
  //
  //   print('get lat long by map $lat  $long');
  //
  //   setState(() {});
  // }

  List<TextEditingController> _controllers = [];

  double? lat;
  double? long;

  LatLng? _center;

  bool isLoading1 = true;

  var data;

  Future<void> findLatLong(String address) async {
    GeocoderResponse? addressQuery = await GoogleGeocoderKrutus.addressQuery(
      apiKey: '$kGoogleApiKey',
      address: '${address}',
    );
    _center = LatLng(addressQuery!.results.first.geometry.location.latitude,
        addressQuery.results.first.geometry.location.longitude);

    lat = addressQuery.results.first.geometry.location.latitude;
    long = addressQuery.results.first.geometry.location.longitude;

    setState(() {});

    print('LAT==>>${addressQuery.results.first.geometry.location.longitude}');
    print('LAT==>>${addressQuery.results.first.geometry.location.latitude}');
  }

  Future searchNearByLocation(
      {required String lat, required String long}) async {
    print("LAT LONG==>>${lat} ${long}");
    http.Response response = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat%2C$long&radius=500&type=restaurant,school,bank,hospital&keyword=cruise&key=AIzaSyBLjgELUHE9X1z5OI0if3tMRDG5nWK2Rt8"));
    var result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print("RESPONSE===>>${result}");
      setState(
        () {},
      );
      isLoading1 = false;
      data = result;
      return result;
    } else {
      print(response.reasonPhrase);
      return null;
    }
  }

  final propertyName = TextEditingController();
  final address = TextEditingController();
  final country = TextEditingController();
  final pinCode = TextEditingController();
  final size = TextEditingController();
  final price = TextEditingController();
  final totalBedRooms = TextEditingController();
  final totalBathrooms = TextEditingController();
  final description = TextEditingController();
  // final propertyStatus = TextEditingController();
  final label = TextEditingController();
  final garages = TextEditingController();
  // final nearByPlaces = TextEditingController();
  final propertyDate = TextEditingController();
  final distance = TextEditingController();
  final featureController = TextEditingController();
  TextEditingController address1 = TextEditingController();

  bool isParkingAvailable = false;
  bool isNewBuild = false;
  bool isSharedOwnerShip = false;
  bool underOffer = false;

  AddPropertyReqModel _addProductReqModel = AddPropertyReqModel();

  bool isLoading = true;

  int groupValue = 1;

  HandleScreenController controller = Get.find();

  List categories = [];

  CollectionReference _collectionRef = FirebaseFirestore.instance
      .collection("Admin")
      .doc("categories")
      .collection("categories_list");

  getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    // Get data from docs and convert map to List
    List<Object?> allData =
        querySnapshot.docs.map((doc) => doc.data()).toList();
    print('All Data==>${allData}');

    allData.forEach((element) {
      // categories.add(element['category_name']);
      print('All Data1==>${element}');
    });

    // // categories = allData;
    // categories.removeWhere((element) {
    //   return element['category_name'] == "All";
    // });

    print("CATEGORIES++>>$categories");
  }

  Future<CroppedFile?> cropSquareImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    return croppedFile;
  }

  FilePickerResult? selectedImages;

  @override
  void initState() {
    //getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 8,
      child: Padding(
        padding: EdgeInsets.only(
            left: 13.sp, right: isOpened == true ? 15.sp : 28.sp),
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
                        controller.changeTapped(false);
                      },
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: CommonText.textBoldWight700(
                        text: 'Add New Property', fontSize: 10.sp),
                  ),
                  Spacer(),
                ],
              ),
              CommonWidget.commonSizedBox(height: 20),

              /// Testing
              // ElevatedButton(
              //     onPressed: () async {
              //       // await displayPrediction();
              //       await findLatLong("${address}");
              //       // var data =
              //       //     await searchNearByLocation(lat: '$lat', long: '$lat');
              //       //
              //       // print("DAtA====>>${data}");
              //     },
              //     child: Text("Get Data")),
              //SearchPlacesScreen(),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 10)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          selectedImages = await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'png', 'webp', 'jpeg'],
                          );

                          // .then((value) {
                          // // controller.changeTapped4(true);
                          // // controller.setImage(selectedImages!.files.first.bytes!);
                          // });
                          // final List<XFile>? selectedImages =
                          //     await _picker.pickMultiImage();
                          //cropSquareImage(File(selectedImages!.files.first.path!));

                          if (selectedImages != null) {
                            selectedImages!.files.forEach((element) {
                              _listOfImage.add(element.bytes!);
                            });

                            // Uint8List? file = selectedImages.files.first.bytes;

                            print(
                                'selectedImages  image of  ${selectedImages}');
                          }

                          // var fileName = '${_listOfImage[0]}';
                          // ByteData bytes = await rootBundle
                          //     .load(fileName); //load sound from assets
                          // Uint8List rawData = bytes.buffer.asUint8List(
                          //     bytes.offsetInBytes, bytes.lengthInBytes);
                          //
                          // Uint8List imageInUnit8List = rawData;
                          //
                          // final tempDir = await getTemporaryDirectory();
                          //
                          // File file =
                          //     await File('${tempDir.path}/${DateTime.now()}')
                          //         .create();
                          //
                          // file.writeAsBytesSync(imageInUnit8List);
                          //
                          // print('FILE>>>>>>>>>>> $file');
                          print("Image List Length:${_listOfImage.length}");

                          setState(() {});
                        },
                        child: Container(
                          height: 250,
                          width: 200,
                          child: Icon(Icons.add),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                        ),
                      ),
                      _listOfImage.length != 0
                          ? Row(
                              children: List.generate(
                                _listOfImage.length > 6
                                    ? isOpened == true
                                        ? _listOfImage.length
                                        : 6
                                    : _listOfImage.length,
                                (index) => Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: 250,
                                      width: 200,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: MemoryImage(
                                                  _listOfImage[index]),
                                              fit: BoxFit.cover),
                                          border:
                                              Border.all(color: Colors.black)),
                                    ),
                                    _listOfImage.length > 5 && index == 4
                                        ? Align(
                                            alignment: Alignment.center,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {});
                                                isOpened = true;
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.image,
                                                    color: themColors309D9D,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  CommonText.textBoldWight700(
                                                      text:
                                                          "and ${_listOfImage.length - 5} More",
                                                      color: themColors309D9D,
                                                      fontSize: 5.sp),
                                                ],
                                              ),
                                            ))
                                        : SizedBox(),
                                    Positioned(
                                      right: 5,
                                      top: 5,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {});
                                          _listOfImage.removeAt(index);
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
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
              CommonWidget.commonSizedBox(height: 35),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CommonText.textBoldWight500(
                              text: 'Property Name', fontSize: 7.sp),
                          SizedBox(
                            width: 1.sp,
                          ),
                          CommonText.textBoldWight500(
                            text: '*',
                            fontSize: 5.sp,
                            color: Colors.red,
                          ),
                        ],
                      ),
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
                              width: 50.sp,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CommonText.textBoldWight500(
                          text: 'Description', fontSize: 7.sp),
                      SizedBox(
                        width: 1.sp,
                      ),
                      CommonText.textBoldWight500(
                        text: '*',
                        fontSize: 5.sp,
                        color: Colors.red,
                      ),
                    ],
                  ),
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
                        contentPadding: EdgeInsets.only(top: 13.sp, left: 6.sp),
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
                        width: 412.sp,
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
                  Row(
                    children: [
                      CommonText.textBoldWight500(
                          text: 'Address', fontSize: 7.sp),
                      SizedBox(
                        width: 1.sp,
                      ),
                      CommonText.textBoldWight500(
                        text: '*',
                        fontSize: 5.sp,
                        color: Colors.red,
                      ),
                    ],
                  ),

                  CommonWidget.commonSizedBox(height: 10),
                  CommonWidget.textFormField(
                      controller: address, hintText: "Address line 1"),
                  CommonWidget.commonSizedBox(height: 10),
                  CommonWidget.textFormField(
                      controller: address1, hintText: "Address line 2"),
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CommonText.textBoldWight500(
                              text: 'Country', fontSize: 7.sp),
                          SizedBox(
                            width: 1.sp,
                          ),
                          CommonText.textBoldWight500(
                            text: '*',
                            fontSize: 5.sp,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      CommonWidget.commonSizedBox(height: 10),
                      SizedBox(
                        width: 70.sp,
                        child: CommonWidget.textFormField(
                          controller: country,
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
                          controller: pinCode,
                        ),
                      ),
                      CommonWidget.commonSizedBox(height: 20),
                    ],
                  )
                ],
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (address.text.isNotEmpty) {
                      await findLatLong("${address}");

                      searchNearByLocation(
                          lat: "${_center!.latitude}",
                          long: "${_center!.longitude}");
                    } else {
                      CommonWidget.getSnackBar(
                          title: "Required!",
                          message: "please enter property address");
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 53.sp,
                    ),
                    child: Text("Find Near By Places"),
                  )),
              SizedBox(
                height: 20,
              ),
              // isLoading1 == true
              //     ? SizedBox()
              //     : FutureBuilder(
              //         future: searchNearByLocation(
              //             lat: '${_center!.latitude}',
              //             long: '${_center!.longitude}'),
              //         builder: (BuildContext context,
              //             AsyncSnapshot<dynamic> snapshot) {
              //           try {
              //             if (snapshot.connectionState ==
              //                 ConnectionState.done) {
              //               try {
              //                 return Padding(
              //                   padding: EdgeInsets.only(right: 30.sp),
              //                   child: Column(
              //                     children: List.generate(
              //                         // (snapshot.data['results'] as List).length <
              //                         //         5
              //                         //     ? (snapshot.data['results'] as List)
              //                         //         .length
              //                         //     : 5,
              //                         (snapshot.data['results'] as List).length,
              //                         (index) {
              //                       _controllers.add(new TextEditingController(
              //                           text: "${calculateDistance(
              //                         lat,
              //                         long,
              //                         snapshot.data['results'][index]
              //                             ['geometry']['location']['lat'],
              //                         snapshot.data['results'][index]
              //                             ['geometry']['location']['lng'],
              //                       ).toStringAsFixed(2)} m'  ${snapshot.data['results'][index]['name']}"));
              //                       return Padding(
              //                         padding: const EdgeInsets.only(top: 13),
              //                         child: Row(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.spaceBetween,
              //                           crossAxisAlignment:
              //                               CrossAxisAlignment.start,
              //                           children: [
              //                             Flexible(
              //                               child: Row(
              //                                 children: [
              //                                   CommonText.textBoldWight500(
              //                                       text: "${index + 1})"),
              //                                   // getKmWidget(snapshot, index),
              //                                   SizedBox(
              //                                     width: 30,
              //                                   ),
              //                                   SizedBox(
              //                                     width: 250.sp,
              //                                     child: Padding(
              //                                       padding:
              //                                           EdgeInsets.symmetric(
              //                                               vertical: 3.sp),
              //                                       child: TextFormField(
              //                                         controller:
              //                                             _controllers[index],
              //                                         maxLines: 1,
              //                                         style: TextStyle(
              //                                           fontWeight:
              //                                               FontWeight.w500,
              //                                           fontFamily: TextConst
              //                                               .fontFamily,
              //                                         ),
              //                                         cursorColor: Colors.black,
              //                                         decoration:
              //                                             InputDecoration(
              //                                           contentPadding:
              //                                               EdgeInsets.only(
              //                                                   top: 7.sp,
              //                                                   left: 6.sp),
              //                                           filled: true,
              //                                           fillColor: Colors.white,
              //                                           // hintText: "Write Description here",
              //                                           hintStyle: TextStyle(
              //                                               fontFamily:
              //                                                   TextConst
              //                                                       .fontFamily,
              //                                               fontWeight:
              //                                                   FontWeight.w500,
              //                                               color: CommonColor
              //                                                   .hinTextColor),
              //                                           border:
              //                                               InputBorder.none,
              //                                           enabledBorder:
              //                                               OutlineInputBorder(
              //                                             borderSide:
              //                                                 BorderSide(
              //                                                     color: Colors
              //                                                         .grey),
              //                                             borderRadius:
              //                                                 BorderRadius
              //                                                     .circular(3),
              //                                           ),
              //                                           focusedBorder:
              //                                               OutlineInputBorder(
              //                                             borderSide: BorderSide(
              //                                                 color:
              //                                                     themColors309D9D),
              //                                             borderRadius:
              //                                                 BorderRadius
              //                                                     .circular(3),
              //                                           ),
              //                                         ),
              //                                       ),
              //                                     ),
              //                                   ),
              //                                   // CommonText.textBoldWight500(
              //                                   //     text:
              //                                   //         "${snapshot.data['results'][index]['name']}",
              //                                   //     color: Colors.black,
              //                                   //     fontSize: 17),
              //
              //                                   // constWidgets.textWidget(
              //                                   //     "School",
              //                                   //     FontWeight.w500,
              //                                   //     12,
              //                                   //     Colors.grey.shade400),
              //                                 ],
              //                               ),
              //                             ),
              //
              //                             // SizedBox(
              //                             //   width: 4.sp,
              //                             // ),
              //                             // InkResponse(
              //                             //   onTap: () {
              //                             //     setState(() {});
              //                             //     snapshot.data['results']
              //                             //         .removeAt(index);
              //                             //   },
              //                             //   child: Icon(
              //                             //     Icons.remove_circle_outline,
              //                             //     color: Colors.red.shade300,
              //                             //     size: 20,
              //                             //   ),
              //                             // ),
              //                           ],
              //                         ),
              //                       );
              //                     }),
              //                   ),
              //                 );
              //               } catch (e) {
              //                 return SizedBox();
              //               }
              //             } else {
              //               return Center(
              //                   child: CircularProgressIndicator(
              //                 backgroundColor: themColors309D9D,
              //               ));
              //             }
              //           } catch (e) {
              //             return SizedBox();
              //           }
              //         },
              //       ),

              isLoading1 == true
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(right: 30.sp),
                      child: Column(
                        children: List.generate(
                            // (snapshot.data['results'] as List).length <
                            //         5
                            //     ? (snapshot.data['results'] as List)
                            //         .length
                            //     : 5,
                            (data['results'] as List).length, (index) {
                          _controllers.add(new TextEditingController(
                              text: "${calculateDistance(
                            lat,
                            long,
                            data['results'][index]['geometry']['location']
                                ['lat'],
                            data['results'][index]['geometry']['location']
                                ['lng'],
                          ).toStringAsFixed(2)} m'  ${data['results'][index]['name']}"));
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
                      Row(
                        children: [
                          CommonText.textBoldWight500(
                              text: 'Total BedRooms', fontSize: 7.sp),
                          SizedBox(
                            width: 1.sp,
                          ),
                          CommonText.textBoldWight500(
                            text: '*',
                            fontSize: 5.sp,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      CommonWidget.commonSizedBox(height: 10),
                      SizedBox(
                        width: 70.sp,
                        child: CommonWidget.textFormField(
                          controller: totalBedRooms,
                          maxLength: 3,
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
                      Row(
                        children: [
                          CommonText.textBoldWight500(
                              text: 'Total BathRooms', fontSize: 7.sp),
                          SizedBox(
                            width: 1.sp,
                          ),
                          CommonText.textBoldWight500(
                            text: '*',
                            fontSize: 5.sp,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      CommonWidget.commonSizedBox(height: 10),
                      SizedBox(
                        width: 70.sp,
                        child: CommonWidget.textFormField(
                          controller: totalBathrooms,
                          maxLength: 3,
                          inpuFormator: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CommonText.textBoldWight500(
                              text: 'Property Status', fontSize: 7.sp),
                          SizedBox(
                            width: 1.sp,
                          ),
                          CommonText.textBoldWight500(
                            text: '*',
                            fontSize: 5.sp,
                            color: Colors.red,
                          ),
                        ],
                      ),
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
                              padding: EdgeInsets.only(left: 7.sp),
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
                      CommonWidget.commonSizedBox(height: 10),
                      Row(
                        children: [
                          CommonText.textBoldWight500(
                              text: 'Price', fontSize: 7.sp),
                          SizedBox(
                            width: 1.sp,
                          ),
                          CommonText.textBoldWight500(
                            text: '*',
                            fontSize: 5.sp,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      CommonWidget.commonSizedBox(height: 10),
                      SizedBox(
                        width: 70.sp,
                        child: CommonWidget.textFormField(
                          controller: price,
                          maxLength: 9,
                          // inpuFormator: [
                          //   FilteringTextInputFormatter.digitsOnly
                          // ],
                        ),
                      ),
                      CommonWidget.commonSizedBox(height: 20),
                    ],
                  ),
                ],
              ),
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
                          controller: label,
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
                          controller: garages,
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
              //     SizedBox(
              //       width: 150.sp,
              //       child: TextFormField(
              //         controller: nearByPlaces,
              //         maxLines: 5,
              //         style: TextStyle(
              //           fontWeight: FontWeight.w500,
              //           fontFamily: TextConst.fontFamily,
              //         ),
              //         cursorColor: Colors.black,
              //         decoration: InputDecoration(
              //           contentPadding: EdgeInsets.only(top: 7.sp, left: 6.sp),
              //           filled: true,
              //           fillColor: Colors.white,
              //           // hintText: "Write Description here",
              //           hintStyle: TextStyle(
              //               fontFamily: TextConst.fontFamily,
              //               fontWeight: FontWeight.w500,
              //               color: CommonColor.hinTextColor),
              //           border: InputBorder.none,
              //           enabledBorder: OutlineInputBorder(
              //             borderSide: BorderSide(color: Colors.grey),
              //             borderRadius: BorderRadius.circular(3),
              //           ),
              //           focusedBorder: OutlineInputBorder(
              //             borderSide: BorderSide(color: themColors309D9D),
              //             borderRadius: BorderRadius.circular(3),
              //           ),
              //         ),
              //       ),
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
              CommonWidget.commonSizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText.textBoldWight500(
                      text: 'Upload Documents', fontSize: 7.sp),
                  CommonWidget.commonSizedBox(height: 20),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          FilePickerResult? selectedImages =
                              await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            type: FileType.custom,
                            allowedExtensions: ['pdf'],
                          );

                          // final List<XFile>? selectedImages =
                          //     await _picker.pickMultiImage();

                          if (selectedImages != null) {
                            selectedImages.files.forEach((element) {
                              leaseHold.add(element.bytes!);
                            });

                            // Uint8List? file = selectedImages.files.first.bytes;

                            print('Lease Hold of  ${selectedImages}');
                          }

                          print("Lease Hold Length:${leaseHold.length}");
                          setState(() {});
                        },
                        child: Container(
                          height: 30.sp,
                          width: 30.sp,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: CommonColor.greyColorD9D9D9),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              leaseHold.length != 0
                                  ? Icon(Icons.check_outlined)
                                  : Icon(Icons.cloud_upload_outlined),
                              SizedBox(
                                height: 10,
                              ),
                              CommonText.textBoldWight500(
                                  text: 'Leasehold', fontSize: 4.sp),
                            ],
                          ),
                        ),
                      ),
                      CommonWidget.commonSizedBox(width: 20),
                      InkWell(
                        onTap: () async {
                          FilePickerResult? selectedImages =
                              await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            type: FileType.custom,
                            allowedExtensions: ['pdf'],
                          );

                          // final List<XFile>? selectedImages =
                          //     await _picker.pickMultiImage();

                          if (selectedImages != null) {
                            selectedImages.files.forEach((element) {
                              florPlan.add(element.bytes!);
                            });

                            // Uint8List? file = selectedImages.files.first.bytes;

                            print('florPlan of  ${selectedImages}');
                          }

                          print("florPlan Length:${florPlan.length}");
                          setState(() {});
                        },
                        child: Container(
                          height: 30.sp,
                          width: 30.sp,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: CommonColor.greyColorD9D9D9),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              florPlan.length != 0
                                  ? Icon(Icons.check_outlined)
                                  : Icon(Icons.cloud_upload_outlined),
                              SizedBox(
                                height: 10,
                              ),
                              CommonText.textBoldWight500(
                                  text: 'Floorplan', fontSize: 4.sp),
                            ],
                          ),
                        ),
                      ),
                      CommonWidget.commonSizedBox(width: 20),
                      InkWell(
                        onTap: () async {
                          FilePickerResult? selectedImages =
                              await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            type: FileType.custom,
                            allowedExtensions: ['pdf'],
                          );

                          // final List<XFile>? selectedImages =
                          //     await _picker.pickMultiImage();

                          if (selectedImages != null) {
                            selectedImages.files.forEach((element) {
                              ecp.add(element.bytes!);
                            });

                            // Uint8List? file = selectedImages.files.first.bytes;

                            print('ecp of  ${selectedImages}');
                          }

                          print("ecp Length:${ecp.length}");
                          setState(() {});
                        },
                        child: Container(
                          height: 30.sp,
                          width: 30.sp,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: CommonColor.greyColorD9D9D9),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ecp.length != 0
                                  ? Icon(Icons.check_outlined)
                                  : Icon(Icons.cloud_upload_outlined),
                              SizedBox(
                                height: 10,
                              ),
                              CommonText.textBoldWight500(
                                  text: 'EPC', fontSize: 4.sp),
                            ],
                          ),
                        ),
                      ),
                      CommonWidget.commonSizedBox(width: 20),
                      InkWell(
                        onTap: () async {
                          FilePickerResult? selectedImages =
                              await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            type: FileType.custom,
                            allowedExtensions: ['pdf'],
                          );

                          // final List<XFile>? selectedImages =
                          //     await _picker.pickMultiImage();

                          if (selectedImages != null) {
                            selectedImages.files.forEach((element) {
                              councilTax.add(element.bytes!);
                            });

                            // Uint8List? file = selectedImages.files.first.bytes;

                            print('councilTax of  ${selectedImages}');
                          }

                          print("councilTax Length:${councilTax.length}");
                          setState(() {});
                        },
                        child: Container(
                          height: 30.sp,
                          width: 30.sp,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: CommonColor.greyColorD9D9D9),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              councilTax.length != 0
                                  ? Icon(Icons.check_outlined)
                                  : Icon(Icons.cloud_upload_outlined),
                              SizedBox(
                                height: 10,
                              ),
                              CommonText.textBoldWight500(
                                  text: 'Council Tax', fontSize: 4.sp),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  CommonWidget.commonSizedBox(height: 20),
                ],
              ),
              CommonWidget.commonSizedBox(height: 50),
              // SearchPlacesScreen(),
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
                              propertyName.text.isNotEmpty &&
                              featureList.length != 0) {
                            try {
                              isLoading = false;
                              setState(() {});

                              var getAllURL = await uploadFiles(_listOfImage);
                              print('url of image $getAllURL');

                              List? leaseHoldDocs;
                              List? floorPlanDocs;
                              List? epcDocs;
                              List? councilTaxDocs;

                              if (leaseHold.length != 0) {
                                leaseHoldDocs = await uploadPdfFile(leaseHold);
                              }

                              print("===>>1111");

                              if (florPlan.length != 0) {
                                floorPlanDocs = await uploadPdfFile(florPlan);
                              }
                              print("===>>222");
                              if (ecp.length != 0) {
                                epcDocs = await uploadPdfFile(ecp);
                              }
                              print("===>>333");
                              if (councilTax.length != 0) {
                                councilTaxDocs =
                                    await uploadPdfFile(councilTax);
                              }
                              print("===>>4444");
                              print("===>>${_listOfImage}");

                              var getOldCount = FirebaseFirestore.instance
                                  .collection('Admin')
                                  .doc('property_count');

                              var fetchCount = await getOldCount.get();

                              getOldCount.update(
                                  {'total_count': FieldValue.increment(1)});

                              _addProductReqModel.listOfImage = getAllURL;

                              print("===>>55555");
                              if (leaseHold.length != 0) {
                                _addProductReqModel.leasHold =
                                    leaseHoldDocs!.first;
                              }

                              print("===>>66666");

                              if (florPlan.length != 0) {
                                _addProductReqModel.florPlan =
                                    floorPlanDocs!.first;
                              }

                              print("===>>77777");
                              if (ecp.length != 0) {
                                _addProductReqModel.epc = epcDocs!.first;
                              }

                              print("===>>8888");
                              if (councilTax.length != 0) {
                                _addProductReqModel.councilTax =
                                    councilTaxDocs!.first;
                              }

                              List<String> places = [];

                              try {
                                _controllers.forEach((element) {
                                  places.add(element.text);
                                });
                              } catch (e) {
                                places = [];
                              }

                              _addProductReqModel.propertyName =
                                  propertyName.text;

                              _addProductReqModel.totalBathrooms =
                                  totalBathrooms.text;
                              _addProductReqModel.totalBedRooms =
                                  totalBedRooms.text;
                              _addProductReqModel.isParkingAvailable =
                                  isParkingAvailable;
                              _addProductReqModel.price = price.text;
                              _addProductReqModel.size =
                                  "${size.text}${groupValue == 0 ? ' Meters' : ' Squares'}";
                              _addProductReqModel.description =
                                  description.text;
                              _addProductReqModel.category = category;
                              _addProductReqModel.country = country.text;
                              _addProductReqModel.address = "${address.text}";
                              _addProductReqModel.address1 = "${address1.text}";
                              _addProductReqModel.addressSearch =
                                  address.text.toLowerCase();
                              _addProductReqModel.countrySearch =
                                  country.text.toLowerCase();
                              _addProductReqModel.pinCode = pinCode.text;
                              _addProductReqModel.propertyStatus =
                                  dropDownValue;
                              _addProductReqModel.label = label.text;
                              _addProductReqModel.features = featureList;
                              _addProductReqModel.isNewBuild = isNewBuild;
                              _addProductReqModel.underOffer = underOffer;
                              _addProductReqModel.isSharedOwnerShip =
                                  isSharedOwnerShip;
                              _addProductReqModel.garages = garages.text;

                              _addProductReqModel.nearByPlaces = places;
                              _addProductReqModel.propertyId =
                                  fetchCount['total_count'] + 1;

                              await FirebaseFirestore.instance
                                  .collection('property_data')
                                  .add(_addProductReqModel.toJson());

                              size.clear();
                              address.clear();
                              country.clear();
                              pinCode.clear();
                              dropDownValue = "For Rent";
                              label.clear();
                              garages.clear();

                              totalBedRooms.clear();
                              totalBathrooms.clear();
                              propertyName.clear();
                              category = "Home";

                              _listOfImage.clear();
                              isLoading = true;
                              setState(() {});
                              controller.changeTapped(false);
                              //Navigator.pop(context);
                              CommonWidget.getSnackBar(
                                  color: themColors309D9D,
                                  duration: 2,
                                  title: 'Successful!',
                                  message: 'Your Property Added Successfully');
                            } catch (e) {
                              print("UPLOAD PROPERTY ERROR++>>>${e}");
                            }
                          } else {
                            CommonWidget.getSnackBar(
                                duration: 2,
                                title: 'Required',
                                message:
                                    'Please Fill All Required Property Details');
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
                            ],
                          ),
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

    return finalImage;
  }

  Future<List<String>> uploadPdfFile(List _images) async {
    var imageUrls =
        await Future.wait(_images.map((_image) => uploadPdf(_image)));
    print('all url  ${imageUrls}');
    return imageUrls;
  }

  Future<String> uploadPdf(Uint8List _image) async {
    String finalImage = '';

    String getUrl = "files/${DateTime.now()}";
    var task = FirebaseStorage.instance.ref().child(getUrl);

    await task
        .putData(_image, SettableMetadata(contentType: 'application/pdf'))
        .then((p0) async {
      finalImage = await p0.storage.ref(getUrl).getDownloadURL();
    });

    return finalImage;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    print('lat1     ${lat1}');
    print('lat1     ${lon1}');
    print('lat1     ${lat2}');
    print('lat1     ${lon2}');
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

    return 1000 * 12742 * asin(sqrt(a));
  }

  Widget getKmWidget(AsyncSnapshot<dynamic> snapshot, int index) {
    try {
      return CommonText.textBoldWight500(
          text: '${index + 1}) ${calculateDistance(
            lat,
            long,
            snapshot.data['results'][index]['geometry']['location']['lat'],
            snapshot.data['results'][index]['geometry']['location']['lng'],
          ).toStringAsFixed(2)} m',
          color: Colors.black,
          fontSize: 17);
    } catch (e) {
      return SizedBox();
    }
  }
}

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({Key? key}) : super(key: key);

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

//const kGoogleApiKey = 'AIzaSyCMYLPYjJOBU6Pn_ho0IwbEIZNZfH-yjlg';
const kGoogleApiKey = 'AIzaSyBLjgELUHE9X1z5OI0if3tMRDG5nWK2Rt8';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
  final Mode _mode = Mode.overlay;

  double? lat;
  double? long;

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    lat = detail.result.geometry!.location.lat;
    long = detail.result.geometry!.location.lng;

    print('get lat long by map $lat $long');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _handlePressButton,
      child: const Text("Search Places"),
    );
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        logo: SizedBox(),
        context: context,
        apiKey: kGoogleApiKey,
        mode: _mode,
        language: 'in',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
        components: [
          Component(Component.country, "in"),
          // Component(Component.country, "in")
        ]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }
}
