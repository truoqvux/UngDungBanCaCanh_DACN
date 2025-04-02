import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../utils/core/app_service.dart';

class CreateProductController extends GetxController {
  RxBool isPostingProduct = false.obs;
  

  FetchClient apiService = FetchClient();
  handleCreateProduct(
      {required int quanity,
      required String name,
      required String description,
      required double price,
      required List<File> images}) async {
    Response rs = await apiService.uploadProduct(
        url: 'https://21e8-112-197-57-66.ngrok-free.app/api/products',
        mapDataForm: {
          'ProductName': name,
          'Description': description,
          'StockQuantity': quanity,
          'Price': price,
          'ProductImages': [await MultipartFile.fromFile(images[0].path)]
        });

    if (rs.statusCode! >= 200 && rs.statusCode! < 299) {
      isPostingProduct.value = false;
      Get.back() ;
      Get.snackbar('Thông báo',"Đã thêm 1 con cá") ;
    }
  }
}


/*


 FormData.fromMap({
          'name': name,
          'description': description,
          'price': price,
          'quanity': quanity,
          'images': images
        })
*/