String category = "Home";

class AddPropertyReqModel {
  String? propertyName;
  String? propertySlugName;
  String? address;
  String? address1;
  String? country;
  String? addressSearch;
  String? countrySearch;
  String? pinCode;
  String? size;
  String? price;
  String? totalBedRooms;
  String? totalBathrooms;
  String? propertyStatus;
  List<String>? nearByPlaces;

  String? label;
  String? garages;
  List? listOfImage;
  String? leasHold;
  String? florPlan;
  String? epc;
  String? councilTax;
  String? category;
  String? description;
  int? propertyId;
  bool? isParkingAvailable;
  List? features = [];
  bool? isNewBuild;
  bool? isSharedOwnerShip;
  bool? underOffer;

  AddPropertyReqModel(
      {this.propertyName,
      this.propertySlugName,
      this.address,
      this.address1,
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
      this.leasHold,
      this.florPlan,
      this.epc,
      this.councilTax,
      this.underOffer,
      this.nearByPlaces});

  Map<String, dynamic> toJson() {
    return {
      "propertySlugName": propertySlugName,
      "propertyName": propertyName,
      "address": address,
      "address1": address1,
      "country": country,
      "address_search": addressSearch,
      "country_search": countrySearch,
      "pinCode": pinCode,
      "size": size,
      "price": price,
      "totalBedRooms": totalBedRooms,
      "totalBathrooms": totalBathrooms,
      "propertyStatus": propertyStatus,
      "label": label,
      "garages": garages,
      "listOfImage": listOfImage,
      "category": category,
      "description": description,
      "isParkingAvailable": isParkingAvailable,
      "productId": propertyId,
      "features": features,
      "nearByPlaces": nearByPlaces,
      "isNewBuild": isNewBuild,
      "isSharedOwnerShip": isSharedOwnerShip,
      "underOffer": underOffer,
      "leasehold_doc": leasHold,
      "floorplan_doc": florPlan,
      "epc_doc": epc,
      "counciltax_doc": councilTax,
      "create_time": DateTime.now().toString()
    };
  }
}

//"nearByPlaces": nearByPlaces,
//String? nearByPlaces;
