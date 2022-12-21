import 'dart:typed_data';

import 'package:get/get.dart';

class HandleScreenController extends GetxController {
  bool isTapped = false;
  bool isTapped1 = false;
  bool isTapped2 = false;
  bool isTapped3 = false;
  bool isTapped4 = false;

  Uint8List? image;

  void changeTapped(bool value) {
    isTapped = value;
    update();
  }

  void changeTapped1(bool value) {
    isTapped1 = value;
    update();
  }

  void changeTapped2(bool value) {
    isTapped2 = value;
    update();
  }

  void changeTapped3(bool value) {
    isTapped3 = value;
    update();
  }

  void changeTapped4(bool value) {
    isTapped4 = value;
    update();
  }

  void setImage(Uint8List data) {
    image = data;
    update();
  }
}
