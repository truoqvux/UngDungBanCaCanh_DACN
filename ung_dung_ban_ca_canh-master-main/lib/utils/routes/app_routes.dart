import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/screen/login/login_screen.dart';
import 'package:ung_dung_ban_ca_canh/screen/register/register_sreen.dart';

import '../../screen/create_product/create_fish_screen.dart';
import '../../screen/home/home_screen.dart';
import 'routes.dart';

abstract class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.root,
      showCupertinoParallax: false,
      transition: Transition.fadeIn,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: Routes.home,
      showCupertinoParallax: false,
      transition: Transition.fadeIn,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: Routes.register,
      showCupertinoParallax: false,
      transition: Transition.fadeIn,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: Routes.addFish,
      showCupertinoParallax: false,
      transition: Transition.fadeIn,
      page: () => const AddProductScreen(),
    ),
    // AddProductScreen
    // GetPage(
    //   name: Routes.focusProduct,
    //   showCupertinoParallax: false,
    //   transition: Transition.fadeIn,
    //   page: () => FocusProductScreen(
    //     items: Get.arguments,
    //   ),
    // ),
    // GetPage(
    //   name: Routes.cartTracking,
    //   showCupertinoParallax: false,
    //   transition: Transition.fadeIn,
    //   page: () => const CartTrackingScreen(),
    // ),
    // GetPage(
    //   name: Routes.cartTrackingDetail,
    //   showCupertinoParallax: false,
    //   transition: Transition.fadeIn,
    //   page: () => CartTrackingDetailScreen(),
    // ),
    // GetPage(
    //   name: Routes.cartOrderedReview,
    //   showCupertinoParallax: false,
    //   transition: Transition.fadeIn,
    //   page: () => CartOrderedReviewScreen(
    //     model: Get.arguments,
    //   ),
    // ),
  ];
}
