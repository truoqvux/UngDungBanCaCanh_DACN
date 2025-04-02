import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/controller/home_controller.dart';
import 'package:ung_dung_ban_ca_canh/controller/login_controller.dart';
import 'package:ung_dung_ban_ca_canh/screen/category/category.dart';
import 'package:ung_dung_ban_ca_canh/screen/home/filter_dialog.dart';
import 'package:ung_dung_ban_ca_canh/screen/invoice/invoice_screen.dart';

import '../../model/product_card.dart';
import '../../model/product_card_2 .dart';
import '../../utils/routes/routes.dart';
import '../chart_product/chart_product.dart';
import '../detail_order/detail_order.dart';
import '../order_success/order_success_screen.dart';
import '../tracking_order/tracking_order.dart';
import 'drawer_information_user.dart';
import 'search_textfield_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());
  final LoginController loginController = Get.find<LoginController>();
  TextEditingController controllerSearch = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller.handleFetchFishes(page: page, pageSize: pageSize);
    _scrollController.addListener(_onScroll);
  }

  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();
  _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      controller.handleFetchFishes(page: ++page, pageSize: pageSize);
    }
  }

  int page = 1;
  int pageSize = 10;
  // final LoginController lC =  Get.find<LoginController>() ;
  final List<Map<String, dynamic>> products = List.generate(
    100,
    (index) => {
      'name': 'Sản phẩm cá cảnh số $index',
      'price': (index + 1) * 10,
      'image':
          'https://static.chotot.com/storage/chotot-kinhnghiem/c2c/2018/10/cac-loai-ca-canh-re-tien-ma-van-dep-hut-hon-dan-choi-ca-13380.jpg',
      'reviews': (index + 5) % 10 + 1,
    },
  );
// ProductCard2
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Trang chủ'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt_outlined), // Biểu tượng lọc
              tooltip: 'Lọc loại cá',
              onPressed: () {
                // Thêm hành động xử lý khi nhấn vào nút filter
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FilterDialog();
                  },
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerInformationUser(),
              loginController.isLoginSuccess.value &&
                      !loginController.isAdmin.value
                  ? ListTile(
                      leading: const Icon(Icons.shopping_basket),
                      title: const Text('Chi tiết giỏ hàng'),
                      onTap: () {
                        Get.to(CartDetailScreen());
                      },
                    )
                  : const SizedBox(),
              loginController.isLoginSuccess.value &&
                      !loginController.isAdmin.value
                  ? ListTile(
                      leading: const Icon(Icons.receipt_long),
                      title: const Text('Trạng thái đơn hàng'),
                      onTap: () {
                        Get.to(OrderStatusScreen());
                      },
                    )
                  : const SizedBox(),
              loginController.isAdmin.value == true
                  ? ListTile(
                      leading: const Icon(Icons.bar_chart),
                      title: const Text('Thống kê doanh thu'),
                      onTap: () {
                        // Navigator.pop(context);
                        Get.to(RevenueScreen());
                      },
                    )
                  : const SizedBox(),
              loginController.isAdmin.value == true
                  ? ListTile(
                      leading: const Icon(Icons.add_box),
                      title: const Text('Thêm sản phẩm'),
                      onTap: () {
                        Get.toNamed(Routes.addFish);
                        // Navigator.pop(context);
                      },
                    )
                  : const SizedBox(),
              loginController.isAdmin.value == true
                  ? ListTile(
                      leading: const Icon(Icons.shopping_cart),
                      title: const Text('Đơn đặt hàng'),
                      onTap: () {
                        Get.to(OrderStatusScreen());
                      },
                    )
                  : const SizedBox(),
              loginController.isAdmin.value == true
                  ? ListTile(
                      leading: const Icon(Icons.check_circle),
                      title: const Text('Đơn giao thành công'),
                      onTap: () {
                       Get.to(OrderStatusScreen());
                      },
                    )
                  : const SizedBox(),
              loginController.isAdmin.value == true
                  ? ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Điều chỉnh danh mục'),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(CategoryManagementScreen());
                      },
                    )
                  : const SizedBox(),
              loginController.isLoginSuccess.value
                  ? ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Đăng xuất'),
                      onTap: () {
                        Get.offNamed(Routes.root);
                      },
                    )
                  : ListTile(
                      leading: const Icon(Icons.login),
                      title: const Text('Đăng nhập'),
                      onTap: () {
                        Get.offNamed(Routes.root);
                      },
                    ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            page = 1;
            controller.handleFetchFishes(page: page, pageSize: pageSize);
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SearchTextField(
                      controller: controllerSearch,
                      onSearch: (query) {
                        if (query.isNotEmpty) {
                          controller.handleSearchFishes(searchText: query);
                        }
                      },
                    )),
                loginController.isAdmin.value
                    ? Obx(
                        () => controller.isloadingFish.value
                            ? const RefreshProgressIndicator()
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(8.0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.fishesAnc.length,
                                itemBuilder: (context, index) {
                                  return ProductCard2(
                                    model: controller.fishesAnc[index],
                                  );
                                },
                              ),
                      )
                    : Obx(
                        () => controller.isloadingFish.value
                            ? const RefreshProgressIndicator()
                            : GridView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(8.0),
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8.0,
                                  mainAxisExtent: 280,
                                  mainAxisSpacing: 8.0,
                                ),
                                itemCount: controller.fishesAnc.length,
                                itemBuilder: (context, index) {
                                  if (controller.fishesAnc[index].isVisible ==
                                      false) {
                                    return const SizedBox();
                                  }
                                  return ProductCard(
                                    model: controller.fishesAnc[index],
                                  );
                                },
                              ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Other extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  final HomeController c = Get.find();
  @override
  Widget build(context) {
    // Access the updated count variable
    return Scaffold(
        body: Center(child: Obx(() => Text("${c.count}"))),
        floatingActionButton: FloatingActionButton(
          onPressed: () => c.decrement(),
          child: Icon(Icons.remove),
        ));
  }
}
