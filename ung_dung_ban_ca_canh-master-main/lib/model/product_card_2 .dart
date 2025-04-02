import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/model/fish_product.dart';
import 'package:ung_dung_ban_ca_canh/screen/detail_product/detail_product_screen.dart';

import '../screen/home/dropdown_option_fish.dart';
import '../utils/core/app_service.dart';
import '../utils/core/format_money.dart';

class ProductCard2 extends StatelessWidget {
  ProductCard2({Key? key, required this.model}) : super(key: key);
  final FishModel? model;

  @override
  Widget build(BuildContext context) {
    bool isVisible = model?.isVisible ?? false;
    String urlImage =
        'https://static.chotot.com/storage/chotot-kinhnghiem/c2c/2018/10/cac-loai-ca-canh-re-tien-ma-van-dep-hut-hon-dan-choi-ca-13380.jpg';
    if (model?.productImages?.isNotEmpty ?? false) {
      urlImage = model!.productImages!.isEmpty
          ? 'https://static.chotot.com/storage/chotot-kinhnghiem/c2c/2018/10/cac-loai-ca-canh-re-tien-ma-van-dep-hut-hon-dan-choi-ca-13380.jpg'
          : FetchClient().domainNotApi + model!.productImages![0].imageUrl!;
    }
    return Container(
        height: 90,
        margin: const EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color.fromARGB(255, 207, 172, 172)),
        child: GestureDetector(
          onTap: () {
            Get.to(ProductDetailPage(model: model ?? FishModel()));
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                child: Image.network(
                  urlImage,
                  height: 60, // 2/3 chiều cao của 280
                  width: 60,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Hình ảnh đã tải xong
                    }
                    return Container(
                      height: 75,
                      width: 75,
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
                      height: 75,
                      width: 75,
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
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model?.productName ?? '',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        Text(
                          formatCurrency(
                            model?.price ?? 0,
                          ),
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        const Expanded(child: SizedBox()),
                        Text(
                          "Còn lại: ${model?.stockQuantity}",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              MyDropdownMenu(
                model: model ?? FishModel(),
              ),
            ],
          ),
        ));
  }
}
