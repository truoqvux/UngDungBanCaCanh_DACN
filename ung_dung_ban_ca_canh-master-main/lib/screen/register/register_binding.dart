import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/controller/register_controller.dart';


class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(RegisterController());
  }
}
