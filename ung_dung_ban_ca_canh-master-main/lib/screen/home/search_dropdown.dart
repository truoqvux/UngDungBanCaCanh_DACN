import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/model/fish_product.dart';

import '../../controller/login_controller.dart';
import '../detail_product/detail_product_screen.dart';

class SearchDropdown extends StatefulWidget {
  const SearchDropdown({super.key});

  @override
  _SearchDropdownState createState() => _SearchDropdownState();
}

class _SearchDropdownState extends State<SearchDropdown> {
  final Dio _dio = Dio();
  List<FishModel> _items = [];
  FishModel? _selectedItem;
  bool _isLoading = false;
  final loginController = Get.find<LoginController>();

  // Hàm gọi API
  Future<void> _fetchItems(String query) async {
    if (query.isEmpty) {
      setState(() {
        _items = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.get(
        'http://54.255.204.181:5212/api/products',
        queryParameters: {
          'Search': query,
          'Page': 1,
          'PageSize': 10,
        },
      );

      final List<FishModel> fishes =
          List<FishModel>.from(response.data.map((x) => FishModel.fromJson(x)));
      setState(() {
        _items = fishes;
      });
    } catch (e) {
      print('Error fetching items: $e');
      setState(() {
        _items = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Search',
            border: const OutlineInputBorder(),
            suffixIcon:
                _isLoading ? CircularProgressIndicator() : Icon(Icons.search),
          ),
          onChanged: (value) {
            _fetchItems(value);
          },
        ),
        const SizedBox(height: 10),
        if (_items.isNotEmpty)
          DropdownButtonFormField<FishModel>(
            value: _selectedItem,
            // hint: Text('Select an item'),
            onChanged: (value) {
              // setState(() {
              //   _selectedItem = value;
              // });
            },
            items: _items.map((item) {
              return DropdownMenuItem<FishModel>(
                value: item,
                onTap: () {
                  if (loginController.isLoginSuccess.value) {
                    Get.to(() => ProductDetailPage(model: item));
                  } else {
                    Get.showSnackbar(const GetSnackBar(
                      title: 'Login Required',
                      message: 'Please login to view product details.',
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
                child: Text(item.productName ?? ''),
              );
            }).toList(),
          ),
        // if (_selectedItem != null) ...[
        //   const SizedBox(height: 10),
        //   Text('Selected: $_selectedItem'),
        // ]x
      ],
    );
  }
}
