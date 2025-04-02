import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/controller/cart_controller.dart';
import 'package:ung_dung_ban_ca_canh/controller/category_controller.dart';
import 'package:ung_dung_ban_ca_canh/controller/create_product_controller.dart';
import 'package:ung_dung_ban_ca_canh/controller/detail_product_controller.dart';
import 'package:ung_dung_ban_ca_canh/controller/home_controller.dart';
import 'package:ung_dung_ban_ca_canh/controller/register_controller.dart';

import 'login_controller.dart';
import 'order_controller.dart';
import 'payment_process_controller.dart';

class SystemController extends GetxController {
  final isShowLogout = false.obs;

  late HomeController homeController;
  late LoginController loginController;
  late RegisterController registerController;
  late CreateProductController createFishController;
  late CategoryController categoryController;
  late DetailProductController detailProductController;
  late CartController cartController;
  late OrderController orderController;
  late PaymentProcessController paymentProcessController;

  initControllerApp() {
    homeController = Get.put(HomeController());
    orderController = Get.put(OrderController());  
    loginController = Get.put(LoginController());
    registerController = Get.put(RegisterController());
    createFishController = Get.put(CreateProductController());
    categoryController = Get.put(CategoryController());
    detailProductController = Get.put(DetailProductController());
    cartController = Get.put(CartController());
    paymentProcessController = Get.put(PaymentProcessController());
  }
}
