import 'package:get_storage/get_storage.dart';

class PreferenceManager {
  static GetStorage getStorage = GetStorage();

  static setEmail(String value) {
    getStorage.write('email', value);
  }

  static getEmail() {
    return getStorage.read('email');
  }

  static removeEmail() {
    return getStorage.remove('email');
  }
}
