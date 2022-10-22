import 'package:get/get.dart';

class EditProductController extends GetxController {
  String? docId;
  String? productName;
  String? brand;
  String? price;
  String? oldPrice;
  String? description;
  List? listOfImage = [];
  String? category;
  String? subCategory;
  String? season;
  String? material;
  String? color;

  void addProductData(
      {String? productName,
      String? brand,
      String? price,
      String? oldPrice,
      String? description,
      List? listOfImage,
      String? category,
      String? subCategory,
      String? season,
      String? material,
      String? color,
      String? docId}) {
    this.productName = productName;
    this.brand = brand;
    this.price = price;
    this.oldPrice = oldPrice;
    this.description = description;
    this.listOfImage = listOfImage;
    this.category = category;
    this.subCategory = subCategory;
    this.season = season;
    this.material = material;
    this.color = color;
    this.docId = docId;
  }
}
