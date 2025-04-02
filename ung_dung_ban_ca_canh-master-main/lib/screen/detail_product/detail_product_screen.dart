import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/controller/detail_product_controller.dart';
import 'package:ung_dung_ban_ca_canh/controller/login_controller.dart';
import 'package:ung_dung_ban_ca_canh/model/comment_model.dart';
import 'package:ung_dung_ban_ca_canh/model/fish_product.dart';
import 'package:ung_dung_ban_ca_canh/screen/detail_product/comment_widget.dart';

import '../../controller/cart_controller.dart';
import '../../model/product_card.dart';
import '../../utils/core/app_service.dart';
import '../../utils/core/format_money.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({Key? key, required this.model}) : super(key: key);

  final FishModel model;

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // Dữ liệu sản phẩm mẫu
  List<String> images = [];
  List<CommentModel> comments = [];
  final detailProductController = Get.find<DetailProductController>();
  final loginController = Get.find<LoginController>();
  final cartController = Get.find<CartController>();
  String productName = "Cá Hồi Tươi Nguyên Con (500g)";
  String productPrice = "12.00.0";
  String productCategory = "Thực phẩm tươi sống";

  // TextController cho bình luận đánh giá
  final TextEditingController _commentController = TextEditingController();

  // Danh sách đánh giá mẫu

  String image = '';
  @override
  void initState() {
    super.initState();
    detailProductController.onInitial(widget.model.id!);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.productImages!.isEmpty) {
      images.add(
          'https://static.chotot.com/storage/chotot-kinhnghiem/c2c/2018/10/cac-loai-ca-canh-re-tien-ma-van-dep-hut-hon-dan-choi-ca-13380.jpg');
    } else {
      for (var e in widget.model.productImages!) {
        image = FetchClient().domainNotApi + e.imageUrl!;
        images.add(image);
      }
    }

    productName = widget.model.productName!;
    productPrice = formatCurrency(widget.model.price!);
    // productCategory = widget.model;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Sản Phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh sản phẩm
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.network(images[index], fit: BoxFit.cover),
                    );
                  },
                ),
              ),

              // Tên sản phẩm
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  productName,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Giá tiền sản phẩm
              Text(
                productPrice,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12,
              ),
              // Nút Thêm vào giỏ hàng
              Obx(() {
                if (!loginController.isAdmin.value) {
                  return Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      ElevatedButton(
                        onPressed: () {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //       content:
                          //           Text('Sản phẩm đã được thêm vào giỏ hàng')),
                          // );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return QuantityDialog(
                                model: widget.model ,
                              );
                            },
                          );
                        },
                        child: const Text('Thêm vào giỏ hàng'),
                      ),
                    ],
                  );
                }
                return const SizedBox();
              }),
              const SizedBox(
                height: 12,
              ),
              Text(
                'Số lượng sản phẩm: ${widget.model.stockQuantity}.',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Loại sản phẩm: ',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 7,
              ),
              Obx(() {
                if (detailProductController.model.value.categories?.isEmpty ??
                    false) {
                  return const SizedBox();
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.of(detailProductController
                        .model.value.categories!
                        .map((e) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 5),
                            margin: const EdgeInsets.symmetric(horizontal: 2.5),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 123, 40, 34),
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 123, 40, 34),
                                )),
                            child: Text(
                              e.categoryName!,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )))),
                  ),
                );
              }),

              Container(
                margin: const EdgeInsets.only(top: 9),
                child: const Text(
                  'Thông tin',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              Text(widget.model.description!,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400)),
              // Đánh giá sản phẩm
              Container(
                margin: const EdgeInsets.symmetric(vertical: 28),
                child: const Text(
                  'Đánh giá',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              // Danh sách đánh giá từ người dùng
              Obx(() {
                comments = detailProductController.comment;
                if (detailProductController.isLoading.value) {
                  return const CircularProgressIndicator(
                    color: Color.fromARGB(255, 171, 50, 41),
                  );
                }
                if (comments.isEmpty) {
                  return const SizedBox(
                      height: 30,
                      child: Text('Hãy là người đánh giá đầu tiên'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return CommentWidget(model: comments[index]);
                  },
                );
              }),
              // Nhập bình luận đánh giá
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Bình luận của bạn',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 52,
                width: double.infinity,
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Nhập bình luận của bạn...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        detailProductController.onCommentProduct(
                            productId: widget.model.id!,
                            content: _commentController.text);
                        _commentController.clear();
                      },
                    ),
                  ),
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
