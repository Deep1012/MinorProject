import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();

  /// Called from main.dart on app launch
  Future<void> initialize() async {
    // Any additional initialization tasks can be done here
  }
}
