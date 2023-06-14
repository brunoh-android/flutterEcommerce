import 'package:app_quitanda/src/pages/base/base_screen.dart';
import 'package:app_quitanda/src/pages/base/binding/navigation_binding.dart';
import 'package:app_quitanda/src/pages/home/binding/home_binding.dart';
import 'package:app_quitanda/src/pages/orders/bind/orders_binding.dart';
import 'package:app_quitanda/src/pages/product/product_screen.dart';
import 'package:app_quitanda/src/pages/splash/splash_screen.dart';
import 'package:get/get.dart';

import '../pages/auth/view/sign_in_screen.dart';
import '../pages/auth/view/sign_up_screen.dart';
import '../pages/cart/binding/cart_binding.dart';

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(name: PagesRoutes.splashRoute, page: () => const SplashScreen()),
    GetPage(name: PagesRoutes.productRoute, page: () => ProductScreen()),
    GetPage(name: PagesRoutes.signInRoute, page: () => SignInScreen()),
    GetPage(name: PagesRoutes.signUpRoute, page: () => SignUpScreen()),
    GetPage(
        name: PagesRoutes.baseRoute,
        page: () => const BaseScreen(),
        bindings: [
          HomeBinding(),
          NavigationBinds(),
          CartBinding(),
          OrdersBingind(),
        ]),
  ];
}

abstract class PagesRoutes {
  static const String splashRoute = '/splash';
  static const String productRoute = '/product';
  static const String signInRoute = '/signIn';
  static const String signUpRoute = '/signUp';
  static const String baseRoute = '/';
}
