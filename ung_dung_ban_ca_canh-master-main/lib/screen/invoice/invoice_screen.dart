import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:ung_dung_ban_ca_canh/controller/cart_controller.dart';
import 'package:ung_dung_ban_ca_canh/controller/payment_process_controller.dart';
import 'package:ung_dung_ban_ca_canh/model/fish_product.dart';
import 'package:ung_dung_ban_ca_canh/utils/core/app_service.dart';
import 'package:ung_dung_ban_ca_canh/utils/core/format_money.dart';

// ignore: must_be_immutable
class InvoiceScreen extends StatefulWidget {
  InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final PaymentProcessController paymentProcessController =
      Get.find<PaymentProcessController>();

  final CartController cartController = Get.find<CartController>();

  String note = '';

  final List<FishModel> orderedProducts = [];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh Toán'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin địa chỉ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (paymentProcessController.isPostSuccess.value) {
                Get.back();
              }
              if (paymentProcessController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final address = paymentProcessController.addressPicked.value;
              return Text(
                '${address.fullname}\n${address.street}, ${address.district}, ${address.city}\nSố điện thoại: ${address.phoneNumber}',
                style: const TextStyle(fontSize: 16),
              );
            }),
            const SizedBox(height: 16),
            const Text(
              'Danh sách sản phẩm',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                orderedProducts.addAll(cartController.fishes);
                return ListView.builder(
                  itemCount: orderedProducts.length,
                  itemBuilder: (context, index) {
                    final product = orderedProducts[index];
                    String image = FetchClient().domainNotApi +
                        product.productImages![0].imageUrl!;
                    return Container(
                      margin: const EdgeInsets.only(
                          bottom: 6, top: 6, left: 3, right: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      child: Row(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            image, // Replace with actual image path
                            width: 65,
                            height: 65,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Text(
                              'Số lượng: ${product.capacity}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(formatCurrency(product.price!),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                        const Expanded(child: SizedBox()),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                orderedProducts.remove(product);
                              });
                            },
                            child: const Icon(Icons.close),
                          ),
                        )
                      ]),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 16),
            Text(
              'Tổng tiền: ${formatCurrency(cartController.totalPrice.value)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ghi chú',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (value) {
                note = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập ghi chú của bạn',
              ),
              maxLines: 3,
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle payment logic here
                  paymentProcessController.createOrder(
                      id: paymentProcessController.addressPicked.value.id!,
                      note: note,
                      fish: orderedProducts);

                  cartController.onRefresh();
                },
                child: const Text(
                  'Thanh Toán',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
          ],
        ),
      ),
    );
  }
}
