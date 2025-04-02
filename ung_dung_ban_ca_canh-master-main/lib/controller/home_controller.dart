import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/model/category_model.dart';
import 'package:ung_dung_ban_ca_canh/model/fish_product.dart';
import 'package:ung_dung_ban_ca_canh/utils/core/app_service.dart';

class HomeController extends GetxController {
  var count = 0.obs;

  increment() => count++;

  decrement() => count--;
  RxList<FishModel> fishesAnc = <FishModel>[].obs;
  RxList<CategoryModel> categoriesAnc = <CategoryModel>[].obs;
  // final loginController =  Get.find<LoginController>();
  RxBool isloadingFish = false.obs;
  RxBool isSearching = false.obs;
  FetchClient apiService = FetchClient();

  handleSearchFishes({required String searchText}) async {
    isloadingFish.value = true;
    isSearching.value = true;  

    final response = await apiService.getData(
      path: '/products',
      queryParameters: {
        'Search': searchText,
        'Page': 1,
        'PageSize': 25,
      },
    );
    List<FishModel> fishes = [];
    if (response.statusCode! >= 200 && response.statusCode! <= 299) {
      fishes =
          List<FishModel>.from(response.data.map((x) => FishModel.fromJson(x)));
    }
    isloadingFish.value = false;
    fishesAnc.value = fishes;
    // http://54.255.204.181:5212/api/category
  }

  handleFetchFishes(
      {required int page, required int pageSize, int? categoryId}) async {
    if (page == 1) {
      isloadingFish.value = true;
    }
    String path = categoryId != null
        ? '/products?Page=$page&PageSize=$pageSize&CategoryId=$categoryId'
        : '/products?Page=$page&PageSize=$pageSize';
    final response = await apiService.getData(
      path: path,
    );
    // http://54.255.204.181:5212/api/category

    final responseCategory = await apiService.getData(
      path: '/category',
    );

    List<CategoryModel> categories = [];
    if (responseCategory.statusCode! >= 200 &&
        responseCategory.statusCode! <= 299) {
      categories = List<CategoryModel>.from(
          responseCategory.data.map((x) => CategoryModel.fromJson(x)));
    }
    categoriesAnc.value = categories;

    isloadingFish.value = false;
    List<FishModel> fishes = [];
    if (response.statusCode! >= 200 && response.statusCode! <= 299) {
      fishes =
          List<FishModel>.from(response.data.map((x) => FishModel.fromJson(x)));
    }
    if (page == 1) {
      fishesAnc.value = fishes;
    } else {
      fishesAnc.value = [...fishesAnc, ...fishes];
    }
  }

  handleUpdateQuanityFish(int quanityUpdate, int productId) {
    List<FishModel> fishes = List.from(fishesAnc);
    final index = fishes.indexWhere((e) => e.id == productId);
    fishes
        .where(
          (element) => element.id == productId,
        )
        .first
        .stockQuantity = quanityUpdate;
    FetchClient().putData(path: '/products/$productId', params: {
      "productName": fishes[index].productName,
      "price": fishes[index].price,
      "description": fishes[index].description,
      "stockQuantity": quanityUpdate
    });
    // fishesAnc.value = fishes;
  }

  handleUpdateFishInfor(
      {required int productId,
      required int quantity,
      required String name,
      required double price,
      required String description}) async {
    final response =
        await FetchClient().putData(path: '/products/$productId', params: {
      "productName": name,
      "price": price,
      "description": description,
      "stockQuantity": quantity
    });

    if (response.statusCode! >= 200 && response.statusCode! <= 299) {
      Get.back();
      Get.showSnackbar(const GetSnackBar(
        title: 'Cập nhật thành công',
        message: 'Vui lòng tải lại dữ liệu',
      ));
    }
  }

  handleDeleteFish(int id) async {
    final response =
        await FetchClient().postData(path: '/products/visible/$id');
    if (response.statusCode! >= 200 && response.statusCode! <= 299) {
      Get.showSnackbar(const GetSnackBar(
        title: "Xóa sản phẩm thành công",
        message: 'Vui lòng tải lại sản phẩm ',
      ));
    }
  }

  handleFilterFishesCategory(List<int> categorries) async {
    isloadingFish.value = true;
    int page = 1;
    int pageSize = 20;
    List<FishModel> fishesTemp = [];
    for (int e in categorries) {
      String path = '/products?Page=$page&PageSize=$pageSize&CategoryId=$e';

      final response = await apiService.getData(
        path: path,
      );

      isloadingFish.value = false;

      List<FishModel> fishes = [];
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        fishes = List<FishModel>.from(
            response.data.map((x) => FishModel.fromJson(x)));
      }
      fishesTemp.addAll(fishes);
    }
    Get.back();
    fishesAnc.value = fishesTemp;
  }

  handleCreateFishes({required}) async {}
}
