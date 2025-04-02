import 'package:flutter/material.dart';
import 'package:ung_dung_ban_ca_canh/model/address_model.dart';
import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/controller/payment_process_controller.dart';

import '../invoice/invoice_screen.dart';

class AddressComponentWidget extends StatelessWidget {
  const AddressComponentWidget(
      {super.key, required this.model, required this.onTap});

  final AddressModel model;
  final VoidCallback onTap;

  void _showDeleteConfirmationDialog(BuildContext context) {
    final paymentProcessController = Get.find<PaymentProcessController>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa địa chỉ này?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                paymentProcessController.deleteAddress(
                    model.id!); // Call the deleteAddress function
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final paymentProcessController = Get.find<PaymentProcessController>();
        paymentProcessController.onPickAddress(model);
        Get.to(InvoiceScreen());
      },
      child: Card(
          margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Center(
                  child: Icon(Icons.home_work_sharp,
                      size: 32, color: Color.fromARGB(255, 158, 42, 42)),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(
                        model.fullname!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Expanded(child: SizedBox()),
                      GestureDetector(
                        onTap: () {
                          _showDeleteConfirmationDialog(context);
                        },
                        child: const Icon(Icons.close),
                      ),
                    ]),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Địa chỉ: ${model.street} ,  ${model.district}, ${model.city}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text('Số điện thoại: ${model.phoneNumber}'),
                  ],
                )),
              ],
            ),
          )),
    );
  }
}
