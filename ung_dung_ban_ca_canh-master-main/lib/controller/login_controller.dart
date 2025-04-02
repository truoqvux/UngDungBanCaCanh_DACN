import 'package:get/get.dart';

import '../utils/core/app_service.dart';
import '../utils/routes/routes.dart';

class LoginController extends GetxController {
  RxString usernameAbc = "".obs;
  RxString password = "".obs;
  RxString emailUser = "".obs;
  RxBool isAdmin = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLoginSuccess = false.obs;
  FetchClient apiService = FetchClient();

  @override
  void onInit() {
    super.onInit();
    onRefresh();
    // Lắng nghe sự thay đổi của isLoggedIn
    ever(isLoginSuccess, (loggedIn) {
      if (loggedIn == true) {
        Get.offNamed(Routes.home); // Điều hướng sang màn hình Home
      }
    });
  }

  onRefresh() {
    usernameAbc.value = "";
    password.value = "";
    isLoading.value = false;
    isLoginSuccess.value = false;
  }

  Future<void> handleLoginProcees(String username, String password) async {
    isLoading.value = true;
    final response = await apiService.postData(
        path: '/account/login',
        params: {'userName': username, 'password': password});
    isLoading.value = false;
    if (response.statusCode! >= 200 && response.statusCode! <= 299) {
      FetchClient.token = response.data['token'];
      print(FetchClient.token);
      isLoginSuccess.value = true;
      usernameAbc.value = username;
      emailUser.value = response.data['email'];
      if (username == 'adminCaCanh') {
        isAdmin.value = true;
      }else{
        isAdmin.value = false; 
      }
      Get.showSnackbar(const GetSnackBar(
        duration: Duration(seconds: 2),
        message: "Đăng nhập thành công",
      ));
      Get.toNamed(Routes.home);
    } else {
      Get.showSnackbar(const GetSnackBar(
        duration: Duration(seconds: 2),
        message: "Tài khoản hoặc mật khẩu không chính xác",
      ));
      isLoginSuccess.value = false;
    }
  }
}
