import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/utils/core/app_service.dart';

import '../model/category_model.dart';

class CategoryController extends GetxController {
  FetchClient apiService = FetchClient();
  RxInt index = 0.obs;
  RxBool isLoading = false.obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  handleFetchCategories() async {
    final responseCategory = await FetchClient().getData(
      path: '/category',
    );

    List<CategoryModel> categoriesValue = [];

    if (responseCategory.statusCode! >= 200 &&
        responseCategory.statusCode! <= 299) {
      categoriesValue = List<CategoryModel>.from(
          responseCategory.data.map((x) => CategoryModel.fromJson(x)));
    }
    categories.value = categoriesValue;
  }

  handleCreateCategories(String name) async {
    final responseCategory = await FetchClient().postData(
      path: '/category',
      params: {
        "categoryName": name,
      },
    );

    if (responseCategory.statusCode! >= 200 &&
        responseCategory.statusCode! <= 299) {
      await handleFetchCategories();
    }
  }

  handleUpdateCategories(String name, int id) async {
    final responseCategory = await FetchClient().putData(
      path: '/category/$id',
      params: {
        "categoryName": name,
      },
    );

    if (responseCategory.statusCode! >= 200 &&
        responseCategory.statusCode! <= 299) {
      await handleFetchCategories();
    }
  }

  handleDeleteCategories(int id) async {
    final responseCategory = await FetchClient().deleteData(
      path: '/category/$id',
    );
    if (responseCategory.statusCode! >= 200 &&
        responseCategory.statusCode! <= 299) {
      await handleFetchCategories();
    }
  }
}
