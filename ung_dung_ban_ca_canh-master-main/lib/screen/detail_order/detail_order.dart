import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/controller/cart_controller.dart';
import 'package:ung_dung_ban_ca_canh/model/fish_product.dart';
import 'package:ung_dung_ban_ca_canh/utils/core/app_service.dart';
import 'package:ung_dung_ban_ca_canh/utils/core/format_money.dart';

import '../process_order/process_order.dart';

final backgroundSiuCapVipPro = Colors.teal;

class CartDetailScreen extends StatelessWidget {
  CartDetailScreen({super.key});

  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng của bạn'),
        backgroundColor: const Color.fromARGB(255, 112, 57, 57),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: Obx(() {
              return ListView.builder(
                itemCount: cartController.fishes
                    .length, // Example count, replace with your cart items count
                itemBuilder: (context, index) {
                  return CartItemWidget(
                    model: cartController.fishes[index],
                  );
                },
              );
            })),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng tiền:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(() {
                  return Text(
                    formatCurrency(cartController.totalPrice
                        .value), // Example total price, replace dynamically
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add your checkout logic here
                Get.to(const AddressScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 112, 57, 57),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Center(
                child: Text(
                  'Tiến hành thanh toán',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  CartItemWidget({required this.model});
  final FishModel model;
  final cartController = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    String image =
        FetchClient().domainNotApi + model.productImages![0].imageUrl!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Image.network(
                image // Example image URL, replace with actual image URL),
                ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.productName!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatCurrency(model.price! * model.capacity!),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // Decrease quantity logic
                  cartController.decreaseProduct(model);
                },
                icon: const Icon(
                  Icons.remove_circle,
                  color: Color.fromARGB(255, 112, 57, 57),
                ),
              ),
              Text("${model.capacity}",
                  style: const TextStyle(fontSize: 16)), // Example quantity
              IconButton(
                onPressed: () {
                  cartController.increaseProduct(model);
                  // Increase quantity logic
                },
                icon: const Icon(
                  Icons.add_circle,
                  color: Color.fromARGB(255, 112, 57, 57),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
