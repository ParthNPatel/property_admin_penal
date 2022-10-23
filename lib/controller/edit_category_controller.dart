import 'package:get/get.dart';

class EditCategoryController extends GetxController {
  String? docId;
  String? categoryName;
  List? categoryImage = [];

  void addCategoryData({
    String? docId,
    String? categoryName,
    List? categoryImage,
  }) {
    this.docId = docId;
    this.categoryName = categoryName;
    this.categoryImage = categoryImage;
  }
}
