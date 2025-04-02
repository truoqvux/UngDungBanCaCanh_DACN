import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/controller/cart_controller.dart';
import 'package:ung_dung_ban_ca_canh/model/address_model.dart';
import 'package:ung_dung_ban_ca_canh/model/fish_product.dart';
import 'package:ung_dung_ban_ca_canh/utils/core/app_service.dart';

class PaymentProcessController extends GetxController {
  List<AddressModel> addressList = <AddressModel>[].obs;

  var isLoading = false.obs;
  final addressPicked = AddressModel().obs;

  RxBool isPostSuccess = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddress();
  }

  void onPickAddress(AddressModel address) {
    addressPicked.value = address;
  }

  void fetchAddress() async {
    isLoading.value = true;
    isPostSuccess.value = false;
    final response = await FetchClient().getData(path: '/address');
    isLoading.value = false;
    if (response.statusCode! >= 200 && response.statusCode! <= 299) {
      addressList = List<AddressModel>.from(
          response.data.map((x) => AddressModel.fromJson(x)));
    }
  }

  void createOrder(
      {required int id,
      required String note,
      required List<FishModel> fish}) async {
    final response = await FetchClient().postData(
      path: '/order',
      params: {
        'addressId': addressPicked.value.id,
        "note": note,
        'orderDetails': fish
            .map((e) => {
                  'productId': e.id,
                  'quantity': e.capacity,
                })
            .toList(),
      },
    );
    print(response);  

    Get.back();
    Get.back();
    Get.back();

    Get.showSnackbar(const GetSnackBar(
      title: 'Thành công',
      message: 'Tạo đơn hàng thành công',
      duration: Duration(seconds: 2),
    ));
    // isPostSuccess.value = true;
    // fetchAddress();

    // Get.back();
    // Get.back();
  }

  Future<void> addAddress(AddressModel address) async {
    isLoading.value = true;
    final response = await FetchClient().postData(
      path: '/address',
      params: address.toJson(),
    );
    isLoading.value = false;

    if (response.statusCode! >= 200 && response.statusCode! <= 299) {
      fetchAddress();
    } else {
      Get.showSnackbar(const GetSnackBar(
        title: 'Lỗi',
        message: 'Không thể thêm địa chỉ mới',
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> deleteAddress(int addressId) async {
    isLoading.value = true;
    final response = await FetchClient().postData(
      path: '/address/visible/$addressId',
    );
    isLoading.value = false;

    if (response.statusCode! >= 200 && response.statusCode! <= 299) {
      fetchAddress();
    } else {
      Get.showSnackbar(const GetSnackBar(
        title: 'Lỗi',
        message: 'Không thể xóa địa chỉ',
        duration: Duration(seconds: 2),
      ));
    }
  }
}
