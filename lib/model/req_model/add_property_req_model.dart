String category = "Home";

class AddPropertyReqModel {
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

  AddPropertyReqModel({
    this.propertyName,
    this.address,
    this.size,
    this.price,
    this.totalBedRooms,
    this.totalBathrooms,
    this.listOfImage,
    this.category,
    this.description,
    this.isParkingAvailable = false,
  });
  Map<String, dynamic> toJson() {
    return {
      "propertyName": propertyName,
      "address": address,
      "size": size,
      "price": price,
      "totalBedRooms": totalBedRooms,
      "totalBathrooms": totalBathrooms,
      "listOfImage": listOfImage,
      "category": category,
      "description": description,
      "isParkingAvailable": isParkingAvailable,
      "create_time": DateTime.now().toString()
    };
  }
}
