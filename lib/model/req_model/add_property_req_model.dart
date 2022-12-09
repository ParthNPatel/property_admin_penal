String category = "Home";

class AddPropertyReqModel {
  String? propertyName;
  String? propertySlugName;
  String? address;
  String? country;
  String? addressSearch;
  String? countrySearch;
  String? pinCode;
  String? size;
  String? price;
  String? totalBedRooms;
  String? totalBathrooms;
  String? propertyStatus;
  String? nearByPlaces;
  String? label;
  String? garages;
  List? listOfImage;
  String? category;
  String? description;
  int? propertyId;
  bool? isParkingAvailable;
  List? features = [];
  bool? isNewBuild;
  bool? isSharedOwnerShip;
  bool? underOffer;

  AddPropertyReqModel({
    this.propertyName,
    this.propertySlugName,
    this.address,
    this.country,
    this.addressSearch,
    this.countrySearch,
    this.size,
    this.price,
    this.totalBedRooms,
    this.totalBathrooms,
    this.listOfImage,
    this.category,
    this.description,
    this.propertyId,
    this.isParkingAvailable = false,
    this.features,
    this.isNewBuild,
    this.isSharedOwnerShip,
    this.underOffer,
  });
  Map<String, dynamic> toJson() {
    return {
      "propertySlugName": propertySlugName,
      "propertyName": propertyName,
      "address": address,
      "country": country,
      "address_search": addressSearch,
      "country_search": countrySearch,
      "pinCode": pinCode,
      "size": size,
      "price": price,
      "totalBedRooms": totalBedRooms,
      "totalBathrooms": totalBathrooms,
      "propertyStatus": propertyStatus,
      "nearByPlaces": nearByPlaces,
      "label": label,
      "garages": garages,
      "listOfImage": listOfImage,
      "category": category,
      "description": description,
      "isParkingAvailable": isParkingAvailable,
      "productId": propertyId,
      "features": features,
      "isNewBuild": isNewBuild,
      "isSharedOwnerShip": isSharedOwnerShip,
      "underOffer": underOffer,
      "create_time": DateTime.now().toString()
    };
  }
}
