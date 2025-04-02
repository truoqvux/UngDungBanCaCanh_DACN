import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/controller/login_controller.dart';
import 'package:ung_dung_ban_ca_canh/controller/order_controller.dart';
import 'package:ung_dung_ban_ca_canh/model/order_model.dart';

import '../../controller/order_controller.dart';
import '../../utils/core/format_money.dart';

class OrderStatusScreen extends StatefulWidget {
  OrderStatusScreen({super.key ,  this.isSuccess = false});

  bool isSuccess = false ; 

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  List<OrderModel> orders = [];
  final cartController = Get.find<OrderController>();
  final loginController = Get.find<LoginController>();
  @override
  void initState() {
    super.initState();
    cartController.onFetchNewData(loginController.isAdmin.value  , widget.isSuccess );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Trạng thái đơn hàng.'),
          backgroundColor: const Color.fromARGB(255, 112, 57, 57),
        ),
        body: RefreshIndicator(onRefresh: () async {
          cartController.onFetchNewData(loginController.isAdmin.value , widget.isSuccess);
        }, child: Obx(() {
          if (cartController.isLoading.value) {
            return const Center(child: RefreshProgressIndicator());
          }
          if (cartController.orders.isEmpty) {
            return const Center(
              child: Text("Không có đơn hàng nào."),
            );
          }

          bool isAdmin = loginController.isAdmin.value;
          print(cartController.orders.length);
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: cartController.orders.length,
            itemBuilder: (context, index) {
              if (isAdmin) {
                if (cartController.orders[index].status == "pending") {
                  return OrderCard(
                    model: cartController.orders[index],
                    isAdmin: isAdmin,
                  );
                } else {
                  return const SizedBox();
                }
              } else  if (widget.isSuccess) {
                 return OrderCard(
                  model: cartController.orders[index],
                  isAdmin: false,
                );
              }else {
                 return OrderCard(
                  model: cartController.orders[index],
                  isAdmin: false,
                );
              }
            },
          );
        })));
  }
}

class OrderCard extends StatelessWidget {
  final OrderModel model;
  final bool isAdmin;
  OrderCard({required this.model, required this.isAdmin});
  final systemController = Get.find<LoginController>();
  final orderController = Get.find<OrderController>() ; 
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSheIGqovu4cXYzyjTJJBCXOnOUJaKhGXEyxw&s', // Replace with actual image path
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Người nhận: ${model.address?.fullname ?? "_Test_"}', // Replace dynamically
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          systemController.isAdmin.value
                              ? GestureDetector(
                                  onTap: () {
                                    showConfirmDialog(context, model.id!, () {
                                         orderController.updateApiOrder(model.id!) ;
                                    });
                                  },
                                  child: const Icon(Icons.fork_right_rounded),
                                )
                              : const SizedBox()
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Địa chỉ: ${model.address!.street!}, ${model.address!.district!}, ${model.address!.city!}, ', // Replace dynamically
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Tổng tiền: - ', // Replace dynamically
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trạng thái: ${model.status == "pending" ? "Đang vẫn chuyển" : "Đã hoàn thành"}', // Replace dynamically
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 112, 57, 57),
                  ),
                ),
                Text(
                  'Ngày tạo: ${convertDate(model.createdAt!)}', // Replace dynamically
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showConfirmDialog(
      BuildContext context, int orderId, VoidCallback onConfirm) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Người dùng phải nhấn nút để thoát
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận chuyển trạng thái'),
          content: Text(
              'Bạn có chắc chắn chuyển trạng thái đơn hàng $orderId trở thành "hoàn thành" không?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Đóng dialog
              },
            ),
            TextButton(
              child: const Text('Xác nhận'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Đóng dialog
                onConfirm(); // Gọi hàm xử lý khi xác nhận
              },
            ),
          ],
        );
      },
    );
  }
}
