import 'package:app_quitanda/src/models/cart_item_model.dart';
import 'package:app_quitanda/src/models/order_model.dart';
import 'package:app_quitanda/src/pages/auth/controller/auth_controller.dart';
import 'package:app_quitanda/src/pages/orders/orders_result/orders_result.dart';
import 'package:app_quitanda/src/pages/orders/repository/orders_repository.dart';
import 'package:app_quitanda/src/services/utlis_service.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  OrderModel order;
  OrderController(this.order);

  final ordersRepository = OrdersRepository();
  final authController = Get.find<AuthController>();
  final utilsService = UtilsService();
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  Future<void> getOrderItems() async {
    setLoading(true);
    final OrdersResult<List<CartItemModel>> result = await ordersRepository
        .getOrderItems(orderId: order.id, token: authController.user.token!);
    setLoading(false);
    result.when(success: (items) {
      order.items;
      update();
    }, error: (message) {
      utilsService.showToast(message: message, isError: true);
    });
  }
}
