import 'package:app_quitanda/src/constants/endpoints.dart';
import 'package:app_quitanda/src/models/category_model.dart';
import 'package:app_quitanda/src/pages/home/result/home_result.dart';
import 'package:app_quitanda/src/services/http_manager.dart';

import '../../../models/item_model.dart';

class HomeRepository {
  final HttpManager _httpManager = HttpManager();

  Future<HomeResult<CategoryModel>> getAllCategories() async {
    final result = await _httpManager.restRequest(
        url: Endpoints.getAllCategories, method: HttpMethods.post);

    if (result['result'] != null) {
      List<CategoryModel> data =
          (List<Map<String, dynamic>>.from(result['result']))
              .map(CategoryModel.fromJson)
              .toList();

      return HomeResult<CategoryModel>.success(data);
    } else {
      return HomeResult.error(
          'Ocorreu um erro inesperado ao carregar as categorias');
    }
  }

  Future<HomeResult<ItemModel>> getAllProducts(
      Map<String, dynamic> body) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.getAllProducts, method: HttpMethods.post, body: body);

    if (result['result'] != null) {
      List<ItemModel> data = List<Map<String, dynamic>>.from(result['result'])
          .map(ItemModel.fromJson)
          .toList();

      return HomeResult<ItemModel>.success(data);
    }

    return HomeResult.error('Ocorreu um erro inesperado ao recuperar os itens');
  }
}
