// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ung_dung_ban_ca_canh/controller/home_controller.dart';
import 'package:ung_dung_ban_ca_canh/model/category_model.dart';

import '../../controller/detail_product_controller.dart';
import '../../model/fish_product.dart';

class MyDropdownMenu extends StatelessWidget {
  final FishModel model;
  final homeController = Get.find<HomeController>();
  MyDropdownMenu({required this.model});
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_vert), // Icon dấu 3 chấm
      onSelected: (String value) {
        // Xử lý khi người dùng chọn một item
        switch (value) {
          case 'update_quantity':
            showDialog(
              context: context,
              builder: (context) => UpdateQuantityDialog(
                currentQuantity: model.stockQuantity!,
                onQuantityUpdated: (newQuantity) {
                  homeController.handleUpdateQuanityFish(
                      newQuantity, model.id!);
                },
              ),
            );

            // model
            break;
          case 'update_info':
            showDialog(
              context: context,
              builder: (context) => UpdateProductDialog(
                product: model,
                onProductUpdated: (newQuantity) {
                  homeController.handleUpdateFishInfor(
                    productId: model.id!,
                    name: newQuantity.productName!,
                    price: newQuantity.price!,
                    quantity: newQuantity.stockQuantity!,
                    description: newQuantity.description!,
                  );
                },
              ),
            );
            break;
          case 'update_product_categories':
            showDialog(
              context: context,
              builder: (context) => UpdateProductCategories(
                product: model,
              ),
            );
            break;
          case 'hide_product':
            homeController.handleDeleteFish(model.id!);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'update_quantity',
          child: Text('Cập nhập số lượng'),
        ),
        const PopupMenuItem<String>(
          value: 'update_info',
          child: Text('Cập nhập thông tin'),
        ),
        const PopupMenuItem<String>(
          value: 'update_product_categories',
          child: Text('Thêm danh mục'),
        ),
        const PopupMenuItem<String>(
          value: 'hide_product',
          child: Text('Xóa sản phẩm'),
        ),
      ],
    );
  }
}

class UpdateQuantityDialog extends StatelessWidget {
  final int currentQuantity;
  final ValueChanged<int> onQuantityUpdated;

  UpdateQuantityDialog({
    required this.currentQuantity,
    required this.onQuantityUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: currentQuantity.toString(),
    );

    return AlertDialog(
      title: const Text('Cập nhật số lượng cá'),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Số lượng',
        ),
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
            final int? newQuantity = int.tryParse(controller.text);
            if (newQuantity != null && newQuantity >= 0) {
              onQuantityUpdated(newQuantity);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vui lòng nhập số lượng hợp lệ!')),
              );
            }
          },
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}

class UpdateProductCategories extends StatefulWidget {
  final FishModel product;
  UpdateProductCategories({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<UpdateProductCategories> createState() =>
      _UpdateProductCategoriesState();
}

class _UpdateProductCategoriesState extends State<UpdateProductCategories> {
  Set<int> _selectedCategories = {};

  List<CategoryModel> categories = [];
  List<Categories> productCategories = [];
  final detailProductController = Get.find<DetailProductController>();
  @override
  void initState() {
    super.initState();
    final homeController = Get.find<HomeController>();

    detailProductController.onInitial(widget.product.id!);
    categories = homeController.categoriesAnc;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      productCategories = detailProductController.model.value.categories ?? [];
      Set<int> a = productCategories.map((e) => e.id!).toSet();
      _selectedCategories = a;
      return AlertDialog(
        title: const Text('Cập nhật thông tin sản phẩm'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: categories.map((category) {
              return CheckboxListTile(
                value: _selectedCategories.contains(category.id),
                title: Text(category.categoryName!),
                onChanged: (bool? isChecked) {
                  if (isChecked == true) {
                    detailProductController.onTickedCategory(
                        categoryId: category.id!);
                  } else {
                    detailProductController.onUnTickCategory(
                        categoryId: category.id!);
                  }
                },
              );
            }).toList(),
          ),
        ),
        actions: [],
      );
    });
  }
}

class UpdateProductDialog extends StatelessWidget {
  final FishModel product;
  final ValueChanged<FishModel> onProductUpdated;

  UpdateProductDialog({
    required this.product,
    required this.onProductUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: product.productName);
    final TextEditingController descriptionController =
        TextEditingController(text: product.description);
    final TextEditingController priceController =
        TextEditingController(text: product.price.toString());
    final TextEditingController quantityController =
        TextEditingController(text: product.stockQuantity.toString());

    return AlertDialog(
      title: const Text('Cập nhật thông tin sản phẩm'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Tên sản phẩm',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mô tả',
              ),
            ),
         const   SizedBox(height: 10),
            TextField(
              controller: priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Giá tiền',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Số lượng',
              ),
            ),
          ],
        ),
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
            final String name = nameController.text.trim();
            final String description = descriptionController.text.trim();
            final double? price = double.tryParse(priceController.text);
            final int? quantity = int.tryParse(quantityController.text);

            if (name.isNotEmpty &&
                description.isNotEmpty &&
                price != null &&
                price >= 0 &&
                quantity != null &&
                quantity >= 0) {
              final updatedProduct = FishModel(
                productName: name,
                description: description,
                price: price,
                stockQuantity: quantity,
              );
              onProductUpdated(updatedProduct);
              Get.back();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Vui lòng nhập đầy đủ và hợp lệ thông tin sản phẩm!')),
              );
            }
          },
          child: const Text('Xác nhận'),
        ),
      ],
    );
  }
}
