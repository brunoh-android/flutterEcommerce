import 'package:app_quitanda/src/pages/base/controller/navigation_controller.dart';
import 'package:get/get.dart';

class NavigationBinds extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationController());
  }
  
}