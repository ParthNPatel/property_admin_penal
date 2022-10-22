import 'package:get/get.dart';

class EditPropertyController extends GetxController {
  String? propertyName;
  String? address;
  String? size;
  String? price;
  String? totalBedRooms;
  String? totalBathrooms;
  List? listOfImage;
  String? category;
  String? description;
  bool? isParkingAvailable;
  String? docId;

  void addPropertyData({
    String? docId,
    String? propertyName,
    String? address,
    String? size,
    String? price,
    String? totalBedRooms,
    String? totalBathrooms,
    List? listOfImage,
    String? category,
    String? description,
    bool? isParkingAvailable = false,
  }) {
    this.docId = docId;
    this.propertyName = propertyName;
    this.address = address;
    this.size = size;
    this.price = price;
    this.totalBedRooms = totalBedRooms;
    this.totalBathrooms = totalBathrooms;
    this.listOfImage = listOfImage;
    this.category = category;
    this.description = description;
    this.isParkingAvailable = isParkingAvailable;
  }
}
