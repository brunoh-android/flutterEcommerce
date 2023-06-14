import 'package:app_quitanda/src/models/order_model.dart';
import 'package:app_quitanda/src/pages/auth/controller/auth_controller.dart';
import 'package:app_quitanda/src/pages/orders/orders_result/orders_result.dart';
import 'package:app_quitanda/src/pages/orders/repository/orders_repository.dart';
import 'package:app_quitanda/src/services/utlis_service.dart';
import 'package:get/get.dart';

class AllOrdersController extends GetxController {
  List<OrderModel> allOrders = [];
  final ordersRepository = OrdersRepository();
  final authController = Get.find<AuthController>();
  final utilsServices = UtilsService();

  @override
  void onInit() {
    super.onInit();

    getAllOrders();
  }

  Future<void> getAllOrders() async {
    OrdersResult<List<OrderModel>> result = await ordersRepository.getAllOrders(
      userId: authController.user.id!,
      token: authController.user.token!,
    );

    result.when(
      success: (orders) {
        allOrders = orders
          ..sort((a, b) => b.createdDateTime!.compareTo(a.createdDateTime!));
        update();
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }
}
