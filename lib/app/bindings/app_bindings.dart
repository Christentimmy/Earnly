
import 'package:earnly/app/controllers/auth_controller.dart';
import 'package:earnly/app/controllers/earn_controller.dart';
import 'package:earnly/app/controllers/storage_controller.dart';
import 'package:earnly/app/controllers/user_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {

  @override
  void dependencies() {
    Get.put(StorageController());
    Get.put(AuthController());
    Get.put(UserController());
    Get.put(EarnController());
  }
}