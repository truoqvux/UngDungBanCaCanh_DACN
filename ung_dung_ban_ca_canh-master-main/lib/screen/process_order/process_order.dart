import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/model/address_model.dart';
import 'package:ung_dung_ban_ca_canh/screen/process_order/address_component_widget.dart';

import '../../controller/payment_process_controller.dart';

class Address {
  final String city;
  final String district;
  final String phoneNumber;
  final String street;
  final String fullname;

  Address(
      {required this.city,
      required this.district,
      required this.phoneNumber,
      required this.street,
      required this.fullname});
}

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final List<AddressModel> _addresses = [
    AddressModel(
        city: 'tp Thuan An',
        fullname: 'Doan Minh Hieu',
        district: 'Binh Duong',
        street: 'Vinh Phu 17A',
        phoneNumber: '0337247723'),
    AddressModel(
        city: 'tp Ha Noi',
        fullname: 'Nguyen Van Hung',
        district: 'pho hang banh',
        street: 'Pho hang banh 17A',
        phoneNumber: '0288477231'),
  ];

  final paymentProcessController = Get.find<PaymentProcessController>();

  void _addNewAddress() {
    showDialog(
      context: context,
      builder: (context) {
        String? name;
        String? district;
        String? city;
        String? street;
        String? phoneNumber;

        return AlertDialog(
          title: const Text('Thêm địa chỉ mới'),
          insetPadding: const EdgeInsets.all(16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Tên người nhận'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Tên đường'),
                onChanged: (value) => street = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Thành phố'),
                onChanged: (value) => city = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Quận/Huyện'),
                onChanged: (value) => district = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
                onChanged: (value) => phoneNumber = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (name != null &&
                    district != null &&
                    city != null &&
                    street != null &&
                    phoneNumber != null) {
                  final newAddress = AddressModel(
                    fullname: name!,
                    street: street!,
                    district: district!,
                    city: city!,
                    phoneNumber: phoneNumber!,
                  );
                  paymentProcessController.addAddress(newAddress);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Thêm mới'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    paymentProcessController.fetchAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn 1 địa chỉ'),
      ),
      body: RefreshIndicator(onRefresh: () async {
        paymentProcessController.fetchAddress();
      }, child: Obx(() {
        _addresses.clear();
        _addresses.addAll(paymentProcessController.addressList);
        if (paymentProcessController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (paymentProcessController.addressList.isEmpty) {
          return const Center(
            child: Text(
                'Chưa có địa chỉ. Hãy tạo thêm địa chỉ để tiến hành mua hàng.'),
          );
        }
        return ListView(
          children: [
            const SizedBox(
              height: 12,
            ),
            const Center(
              child: Text(
                "Danh sách các địa chỉ hiện có",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                final address = _addresses[index];
                return AddressComponentWidget(
                  model: address,
                  onTap: () {
                    Get.showSnackbar(GetSnackBar(
                      title: 'OnTap',
                      message: 'You tapped on ${address.fullname}',
                    ));
                  },
                );
              },
            ),
          ],
        );
      })),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewAddress,
        child: const Icon(Icons.add),
      ),
    );
  }
}
