import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/controller/category_controller.dart';
import 'package:ung_dung_ban_ca_canh/model/category_model.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CategoryManagementScreenState createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  List<CategoryModel> categories = [];
  final TextEditingController _controller = TextEditingController();
  final categoryController = Get.find<CategoryController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryController.handleFetchCategories();
  }

  void _addCategory(String category) {
    categoryController.handleCreateCategories(category);
  }

  void _editCategory(int index, String newCategory) {
    categoryController.handleUpdateCategories(
        newCategory, categoryController.categories[index].id!);
  }

  void _deleteCategory(int index) {
    categoryController.handleDeleteCategories(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lí danh mục'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Thêm danh mục mới',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addCategory(_controller.text),
                  child: const Text('Thêm'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (categoryController.categories.isEmpty) {
                categories = [];
              } else {
                categories = categoryController.categories;
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(categories[index].categoryName!),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditDialog(index);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteCategory(categories[index].id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(int index) {
    final TextEditingController editController =
        TextEditingController(text: categories[index].categoryName ?? "a");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chỉnh sửa danh mục'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              labelText: 'Chỉnh sửa',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _editCategory(index, editController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
