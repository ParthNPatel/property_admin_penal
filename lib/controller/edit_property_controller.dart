import 'package:get/get.dart';

class EditPropertyController extends GetxController {
  String? propertyName;
  String? address;
  String? address1;
  String? country;
  String? pinCode;
  String? size;
  String? price;
  String? totalBedRooms;
  String? totalBathrooms;
  String? propertyStatus;
  String? label;
  String? garages;
  List? listOfImage = [];
  String? category;
  String? description;
  bool? isParkingAvailable;
  String? productId;
  String? docId;
  List? features = [];
  bool? isNewBuild;
  bool? isSharedOwnerShip;
  bool? underOffer;

  void addPropertyData({
    String? docId,
    String? productId,
    String? propertyName,
    String? address,
    String? address1,
    String? country,
    String? pinCode,
    String? size,
    String? price,
    String? totalBedRooms,
    String? propertyStatus,
    String? totalBathrooms,
    String? label,
    String? garages,
    List? listOfImage,
    String? category,
    String? description,
    bool? isParkingAvailable = false,
    List? features,
    bool? isNewBuild,
    bool? isSharedOwnerShip,
    bool? underOffer,
  }) {
    this.docId = docId;
    this.productId = productId;
    this.propertyName = propertyName;
    this.address = address;
    this.address1 = address1;
    this.country = country;
    this.pinCode = pinCode;
    this.size = size;
    this.price = price;
    this.propertyStatus = propertyStatus;
    this.totalBedRooms = totalBedRooms;
    this.totalBathrooms = totalBathrooms;
    this.label = label;
    this.garages = garages;
    this.propertyStatus = propertyStatus;
    this.listOfImage = listOfImage;
    this.category = category;
    this.description = description;
    this.isParkingAvailable = isParkingAvailable;
    this.isSharedOwnerShip = isSharedOwnerShip;
    this.isNewBuild = isNewBuild;
    this.underOffer = underOffer;
    this.features = features;
  }
}
