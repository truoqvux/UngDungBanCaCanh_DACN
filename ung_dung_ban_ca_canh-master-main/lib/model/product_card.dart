import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/controller/cart_controller.dart';
import 'package:ung_dung_ban_ca_canh/controller/home_controller.dart';
import 'package:ung_dung_ban_ca_canh/controller/login_controller.dart';
import 'package:ung_dung_ban_ca_canh/model/fish_product.dart';
import 'package:ung_dung_ban_ca_canh/utils/core/app_service.dart';
import 'package:ung_dung_ban_ca_canh/utils/routes/routes.dart';

import '../controller/login_controller.dart';
import '../screen/detail_product/detail_product_screen.dart';
import '../utils/core/format_money.dart';

class ProductCard extends StatelessWidget {
  final FishModel? model;

  ProductCard({super.key, this.model});
  final loginController = Get.find<LoginController>();
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    String urlImage =
        'https://static.chotot.com/storage/chotot-kinhnghiem/c2c/2018/10/cac-loai-ca-canh-re-tien-ma-van-dep-hut-hon-dan-choi-ca-13380.jpg';
    if (model?.productImages?.isNotEmpty ?? false) {
      urlImage = model!.productImages!.isEmpty
          ? 'https://static.chotot.com/storage/chotot-kinhnghiem/c2c/2018/10/cac-loai-ca-canh-re-tien-ma-van-dep-hut-hon-dan-choi-ca-13380.jpg'
          : FetchClient().domainNotApi + model!.productImages![0].imageUrl!;
    }
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (loginController.isLoginSuccess.value == true) {
                Get.to(ProductDetailPage(
                  model: model ?? FishModel(),
                ));
              } else {
                Get.showSnackbar(const GetSnackBar(
                  title: 'Vui lòng đăng nhập',
                  duration: Duration(seconds: 1),
                  message: 'Hãy đăng nhập trước khi xem chi tiết khách hàng',
                ));
              }
            },
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                urlImage,
                height: 165, // 2/3 chiều cao của 280
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // Hình ảnh đã tải xong
                  }
                  return Container(
                    height: 165,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return Container(
                    height: 165,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (loginController.isLoginSuccess.value == true) {
                      Get.to(ProductDetailPage(
                        model: model ?? FishModel(),
                      ));
                    } else {
                      Get.showSnackbar(const GetSnackBar(
                        title: 'Vui lòng đăng nhập',
                        duration: Duration(seconds: 1),
                        message:
                            'Hãy đăng nhập trước khi xem chi tiết khách hàng',
                      ));
                    }
                  },
                  child: Text(
                    model?.productName ?? "Cá cảnh",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    if (loginController.isLoginSuccess.value == true) {
                      Get.to(ProductDetailPage(
                        model: model ?? FishModel(),
                      ));
                    } else {
                      Get.showSnackbar(const GetSnackBar(
                        title: 'Vui lòng đăng nhập',
                        duration: Duration(seconds: 1),
                        message:
                            'Hãy đăng nhập trước khi xem chi tiết khách hàng',
                      ));
                    }
                  },
                  child: Text(
                    formatCurrency(model?.price ?? 1 * 1000), // Format giá tiền
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                GestureDetector(
                  onTap: () {
                    if (loginController.isLoginSuccess.value) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return QuantityDialog(
                            model: model ?? FishModel(),
                          );
                        },
                      );
                    } else {
                      Get.showSnackbar(const GetSnackBar(
                        duration: Duration(seconds: 2),
                        message: "Vui lòng đăng nhập",
                      ));
                      Get.offAndToNamed(Routes.root);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kho có sẵn: ${model?.stockQuantity ?? 0}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Icon(
                        Icons.shopping_cart,
                        color: Color.fromARGB(255, 160, 44, 36),
                        size: 24,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuantityDialog extends StatefulWidget {
  QuantityDialog({super.key, required this.model});
  FishModel model;

  @override
  _QuantityDialogState createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<QuantityDialog> {
  int quantity = 1;
  double pricePerItem = 28.000; // Replace with dynamic price
  final cartController = Get.find<CartController>();
  @override
  void initState() {
    super.initState();
    pricePerItem = widget.model.price ?? 0;
    quantity = widget.model.capacity ?? 1;
  }

  void addToCart() async {
    Get.back();
    // Get.dialog(const Center(child: CircularProgressIndicator()),
    //     barrierDismissible: false);
    // await Future.delayed(const Duration(seconds: 2));
    // Get.back();
    // print('Adding $quantity items to cart');
    for (int i = 1; i <= quantity; i++) {
      cartController.addProductToCart(widget.model);
    }
    Get.snackbar(
      'Thành công',
      'Đã thêm cá vào giỏ!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nhập số lượng'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle,
                    color: Color.fromARGB(255, 160, 44, 36)),
                onPressed: quantity > 1
                    ? () {
                        setState(() {
                          quantity--;
                        });
                      }
                    : null,
              ),
              Text('$quantity', style: const TextStyle(fontSize: 18)),
              IconButton(
                icon: const Icon(Icons.add_circle,
                    color: Color.fromARGB(255, 160, 44, 36)),
                onPressed: () {
                  setState(() {
                    quantity++;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Tổng: ${formatCurrency(pricePerItem * quantity)}',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            'Hủy',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: addToCart,
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 160, 44, 36)),
          child: const Text('Xác nhận'),
        ),
      ],
    );
  }
}
