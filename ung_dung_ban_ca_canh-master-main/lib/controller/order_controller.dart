import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/controller/login_controller.dart';
import 'package:ung_dung_ban_ca_canh/model/order_model.dart';
import 'package:ung_dung_ban_ca_canh/utils/core/app_service.dart';

class OrderController extends GetxController {
  List<OrderModel> orders = [];
  var isLoading = false.obs;
  onRefresh() {
    isLoading.value = false;
    orders.clear();
  }

  onFetchNewData(bool isAdmin , bool isSuccess) async {
    isLoading.value = true;
    String path = isAdmin == true?'/order':'/order/user';
    final response = await FetchClient().getData(
        path: path, queryParameters: {'Page': 1, 'PageSize': 50});
    isLoading.value = false;
    if (response.statusCode! >= 200 && response.statusCode! <= 299) {
      orders = List<OrderModel>.from(
          response.data.map((x) => OrderModel.fromJson(x)));
    }

  }

  updateApiOrder(int orderId ) async 
  {
 final response = await FetchClient().putData(
        path: '/order/$orderId', params:{
  "confirm": 1
});
  if (response.statusCode! >= 200 && response.statusCode! <= 299) {
      Get.showSnackbar(GetSnackBar (title: 'Thành công',  message: 'Chuyển trạng thái đơn hàng thành công',)); 
    }
  }
}
