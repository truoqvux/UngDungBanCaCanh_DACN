
import 'package:get/get.dart';
import '../utils/core/app_service.dart';

class RegisterController extends GetxController {
  RxString username =  "".obs ;
  RxString password = "".obs ;
  RxString email = "".obs ; 
  RxBool isLoading  = false.obs ;
  RxBool isPostedRegister = false.obs ;
  FetchClient apiService = FetchClient();

  Future<void> handleLoginProcees() async {
    isLoading.value = true;
    final response = await apiService.postData( path: '/account/register',
        params: {'username': username.value, 'password': password.value,'email' : email.value});
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
      FetchClient.token = response.data['token'];
       Get.showSnackbar(const GetSnackBar(
        duration: Duration(seconds: 2),
        message: "Đăng ký thành công",
      ));
      isPostedRegister.value = true;
    } else {
      Get.showSnackbar(const GetSnackBar(
        duration: Duration(seconds: 2),
        message: "Hãy thử đăng ký lại với 1 cách khác",
      ));
      isPostedRegister.value = false;
    }
  }
}