import 'package:app_quitanda/src/pages/orders/controller/all_orders_controller.dart';
import 'package:get/get.dart';

class OrdersBingind extends Bindings {
  @override
  void dependencies() {
    Get.put(AllOrdersController());
  }
}
