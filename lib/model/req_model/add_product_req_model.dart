String category = "Deal";
String subCategory = "Shirts";

String season = "Summer";
String material = "Cotton";

class AddProductReqModel {
  String? productName;
  String? brand;
  String? price;
  String? oldPrice;
  String? description;
  List? listOfImage;
  String? category;
  String? subCategory;
  String? season;
  String? material;
  String? color;

  AddProductReqModel(
      {this.productName,
      this.brand,
      this.price,
      this.oldPrice,
      this.description,
      this.listOfImage,
      this.category,
      this.subCategory,
      this.season,
      this.material,
      this.color});
  Map<String, dynamic> toJson() {
    return {
      "productName": productName,
      "brand": brand,
      "price": price,
      "oldPrice": oldPrice,
      "description": description,
      "listOfImage": listOfImage,
      "category": category,
      "subCategory": subCategory,
      "season": season,
      "material": material,
      "color": color,
      "create_time": DateTime.now().toString()
    };
  }
}
