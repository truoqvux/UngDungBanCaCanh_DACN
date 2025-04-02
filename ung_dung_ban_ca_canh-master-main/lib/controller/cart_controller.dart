import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/model/fish_product.dart';

class CartController extends GetxController {
  RxList<FishModel> fishes = <FishModel>[].obs;
  RxInt totalPrice = 0.obs;

  addProductToCart(FishModel model) {
    int index = fishes.indexOf(model);
    if (index >= 0) {
      if (fishes[index].stockQuantity! == fishes[index].capacity!) {
        Get.snackbar(
          "Thông báo",
          "Số lượng sản phẩm đã đạt tối đa",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );
      } else {
        fishes[index].capacity = fishes[index].capacity! + 1;
        fishes.refresh();
        onCaCuLate();
      }
    } else {
      fishes.add(model);
    }
  }

  increaseProduct(FishModel model) {
    int index = fishes.indexOf(model);

    if (fishes[index].stockQuantity! == fishes[index].capacity!) {
      Get.snackbar(
        "Thông báo",
        "Số lượng sản phẩm đã đạt tối đa",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
    } else {
      fishes[index].capacity = fishes[index].capacity! + 1;
      fishes.refresh();
      onCaCuLate();
    }
  }

  decreaseProduct(FishModel model) {
    int index = fishes.indexOf(model);
    if (fishes[index].capacity! > 1) {
      fishes[index].capacity = fishes[index].capacity! - 1;
      fishes.refresh();
      onCaCuLate();
    } else {
      fishes.removeAt(index);
      onCaCuLate();
    }
  }

  onRefresh() {
    fishes = <FishModel>[].obs;
    totalPrice.value = 0;
  }

  onCaCuLate() {
    double totalPriceTemp = 0;
    for (var e in fishes) {
      totalPriceTemp += (e.price! * e.capacity!);
    }
    totalPrice.value = totalPriceTemp.toInt();
  }

  // removeFishes(FishModel model , int quanity) {
  //     fishes.
  // }
}
