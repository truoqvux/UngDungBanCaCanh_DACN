import 'package:get/get.dart';
import 'package:ung_dung_ban_ca_canh/model/comment_model.dart';
import 'package:ung_dung_ban_ca_canh/model/fish_product.dart';
import 'package:ung_dung_ban_ca_canh/utils/core/app_service.dart';

class DetailProductController extends GetxController {
  RxInt productId = 0.obs;
  RxBool isLoading = false.obs;
  final model = FishModel().obs;
  List<CommentModel> comment = <CommentModel>[].obs;

  onInitial(int id) {
    productId.value = id;
    comment = [];
    model.value = FishModel();
    onFetchComment();
    onLoadModel();
  }

  onLoadModel() async {
    final response = await FetchClient().getData(path: '/products/$productId');
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      model.value = FishModel.fromJson(response.data);
    }
  }

  onTickedCategory({required int categoryId}) async {
    final response = await FetchClient().postData(
        path: '/product_category',
        params: {"productId": productId.value, "categoryId": categoryId});
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      onInitial(productId.value);
    }
  }

  onUnTickCategory({required int categoryId}) async {
    final response = await FetchClient().deleteData(
        path: '/product_category',
        params: {"productId": productId.value, "categoryId": categoryId});
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      onInitial(productId.value);
    }
  }

  onFetchComment() async {
    isLoading.value = true;
    final response =
        await FetchClient().getData(path: '/comment', queryParameters: {
      'ProductId': productId.value,
      'Page': 1,
      'PageSize': 20,
    });

    isLoading.value = false;

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      comment =
          (response.data as List).map((e) => CommentModel.fromJson(e)).toList();
    }
  }

  onCommentProduct({required int productId, required String content}) async {
    final response = await FetchClient()
        .postData(path: '/comment/$productId', params: {'content': content});
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      onFetchComment();
    }
  }

  onRemoveComment({required int productId}) async {
    final response = await FetchClient().deleteData(path: 'comment');
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      onFetchComment();
    }
  }

  onEditComment({required int productId, required String content}) async {
    final response = await FetchClient()
        .putData(path: '/comment/$productId', params: {'content': content});
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      onFetchComment();
    }
  }
}
