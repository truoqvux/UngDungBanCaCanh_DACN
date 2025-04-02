import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ung_dung_ban_ca_canh/controller/create_product_controller.dart';
import 'package:ung_dung_ban_ca_canh/controller/home_controller.dart';
import 'package:ung_dung_ban_ca_canh/model/category_model.dart';

import '../../utils/core/format_money.dart';
// import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final createProductController = Get.find<CreateProductController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<File> _images = [];
  List<CategoryModel> _categories = [];

  // final List<Map<String, dynamic>> _categories = [
  //   {'id': 1, 'nameCategory': 'Electronics'},
  //   {'id': 2, 'nameCategory': 'Clothing'},
  //   {'id': 3, 'nameCategory': 'Home Appliances'},
  //   {'id': 4, 'nameCategory': 'Books'},
  //   {'id': 5, 'nameCategory': 'Toys'},
  // ];
  String? _selectedCategory;

  _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.length + _images.length <= 4) {
      setState(() {
        _images.addAll(pickedFiles.map((file) => File(file.path)));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chỉ được chọn tối đa 4 hình ảnh!')),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _images.isNotEmpty &&
        _selectedCategory != null) {
      int quanity = int.parse(_quantityController.text.toString());
      String doubleeaa = _priceController.text.toString();
      double price = double.parse(doubleeaa);

      createProductController.handleCreateProduct(
          quanity: quanity,
          name: _nameController.text.toString(),
          description: _descriptionController.text.toString(),
          price: price,
          images: _images);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Sản phẩm được thêm thành công!')),
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đủ thông tin và chọn hình ảnh.')),
      );
    }
  }


  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:const BorderSide(color: Colors.grey, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:const BorderSide(color: Colors.blue, width: 2),
      ),
      contentPadding:const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final homeController = Get.find<HomeController>();
    _categories = homeController.categoriesAnc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm mới sản phẩm')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên sản phẩm
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration('Tên sản phẩm'),
                  validator: (value) =>
                      value!.isEmpty ? 'Vui lòng nhập tên sản phẩm' : null,
                ),
                SizedBox(height: 12),
                // Số lượng
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(
                      'Số lượng sản phẩm'), // InputDecoration(labelText: 'Số lượng sản phẩm'),
                  validator: (value) =>
                      value!.isEmpty ? 'Vui lòng nhập số lượng' : null,
                ),
                SizedBox(height: 12),
                // Mô tả
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: _inputDecoration('Mô tả sản phẩm'),
                  validator: (value) =>
                      value!.isEmpty ? 'Vui lòng nhập mô tả sản phẩm' : null,
                ),
                SizedBox(height: 12),
                // Giá tiền
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Giá sản phẩm'),
                  onChanged: (value) {
                    String newValue = value;
                    _priceController.value = TextEditingValue(
                      text: newValue,
                      selection:
                          TextSelection.collapsed(offset: newValue.length),
                    );
                  },
                  validator: (value) =>
                      value!.isEmpty ? 'Vui lòng nhập giá sản phẩm' : null,
                ),
                SizedBox(height: 12),

                // Chọn danh mục
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Hàng thuộc loại'),
                  value: _selectedCategory,
                  onChanged: (newValue) =>
                      setState(() => _selectedCategory = newValue),
                  items: _categories.map<DropdownMenuItem<String>>((category) {
                    return DropdownMenuItem<String>(
                      value: category.id.toString(),
                      child: Text(category.categoryName!),
                    );
                  }).toList(),
                  validator: (value) =>
                      value == null ? 'Vui lòng chọn loại hàng' : null,
                ),
                SizedBox(height: 12),
                // Hình ảnh
                Text('Hình ảnh (được chọn tối đa 4):'),
                SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImages,
                      child: const Text('Chọn hình'),
                    ),
                    const SizedBox(width: 12),
                    Text('${_images.length} / 4 đã chọn'),
                  ],
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _images
                      .map((image) => Image.file(image,
                          width: 100, height: 100, fit: BoxFit.cover))
                      .toList(),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Thêm sản phẩm'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
