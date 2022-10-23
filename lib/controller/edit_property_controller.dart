import 'package:get/get.dart';

class EditPropertyController extends GetxController {
  String? propertyName;
  String? address;
  String? country;
  String? pinCode;
  String? size;
  String? price;
  String? totalBedRooms;
  String? totalBathrooms;
  String? propertyStatus;
  String? nearByPlaces;
  String? label;
  String? garages;
  List? listOfImage = [];
  String? category;
  String? description;
  bool? isParkingAvailable;
  String? productId;
  String? docId;

  void addPropertyData({
    String? docId,
    String? productId,
    String? propertyName,
    String? address,
    String? country,
    String? pinCode,
    String? size,
    String? price,
    String? totalBedRooms,
    String? propertyStatus,
    String? totalBathrooms,
    String? nearByPlaces,
    String? label,
    String? garages,
    List? listOfImage,
    String? category,
    String? description,
    bool? isParkingAvailable = false,
  }) {
    this.docId = docId;
    this.productId = productId;
    this.propertyName = propertyName;
    this.address = address;
    this.country = country;
    this.pinCode = pinCode;
    this.size = size;
    this.price = price;
    this.propertyStatus = propertyStatus;
    this.totalBedRooms = totalBedRooms;
    this.totalBathrooms = totalBathrooms;
    this.nearByPlaces = nearByPlaces;
    this.label = label;
    this.garages = garages;
    this.propertyStatus = propertyStatus;
    this.listOfImage = listOfImage;
    this.category = category;
    this.description = description;
    this.isParkingAvailable = isParkingAvailable;
  }
}
