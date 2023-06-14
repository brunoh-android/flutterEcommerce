import 'package:app_quitanda/src/models/cart_item_model.dart';
import 'package:app_quitanda/src/models/item_model.dart';
import 'package:app_quitanda/src/models/order_model.dart';
import 'package:app_quitanda/src/pages/cart/cart_result/cart_result.dart';
import 'package:app_quitanda/src/pages/cart/repository/cart_repository.dart';
import 'package:app_quitanda/src/services/utlis_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/controller/auth_controller.dart';
import '../../common_widgets/payment_dialog.dart';

class CartController extends GetxController {
  final cartRepository = CartRepository();
  final authController = Get.find<AuthController>();
  final utilsServices = UtilsService();

  List<CartItemModel> cartItems = [];

  bool isCheckoutLoading = false;

  @override
  void onInit() {
    super.onInit();

    getCartItems();
  }

  double cartTotalPrice() {
    double total = 0;
    for (final item in cartItems) {
      total += item.totalPrice();
    }
    return total;
  }

  Future checkoutCart() async {
    isCheckoutLoading = true;
    update();

    CartResult<OrderModel> result = await cartRepository.checkoutCart(
        token: authController.user.token!, total: cartTotalPrice());

    result.when(success: (order) {
      cartItems.clear();
      update();

      showDialog(
        context: Get.context!,
        builder: (_) {
          return PaymentDialog(
            order: order,
          );
        },
      );
    }, error: (message) {
      utilsServices.showToast(message: message);
    });
    isCheckoutLoading = true;
    update();
  }

  Future<bool> changeItemQuantity(
      {required CartItemModel item, required int quantity}) async {
    final result = await cartRepository.changeItemQuantity(
        token: authController.user.token!,
        cartItemId: item.id,
        quantity: quantity);

    if (result) {
      if (quantity == 0) {
        cartItems.removeWhere((cartItem) => cartItem.id == item.id);
      } else {
        cartItems.firstWhere((cartItem) => cartItem.id == item.id).quantity =
            quantity;
      }
      update();
    } else {
      utilsServices.showToast(
          message: 'Ocorreu um erro ao alterar a quantidade do produto',
          isError: true);
    }

    return result;
  }

  Future<void> getCartItems() async {
    final CartResult<List<CartItemModel>> result =
        await cartRepository.getCartItems(
            token: authController.user.token!, userId: authController.user.id!);
    result.when(success: (data) {
      cartItems = data;
      update();
    }, error: (message) {
      utilsServices.showToast(message: message, isError: true);
    });
  }

  int getItemIndex(ItemModel item) {
    return cartItems.indexWhere((itemInList) => itemInList.item.id == item.id);
  }

  Future<void> addItemToCart(
      {required ItemModel item, int quantity = 1}) async {
    int itemIndex = getItemIndex(item);

    if (itemIndex >= 0) {
      final product = cartItems[itemIndex];
      await changeItemQuantity(
          item: product, quantity: (product.quantity + quantity));
    } else {
      final CartResult<String> result = await cartRepository.addItemToCart(
          userId: authController.user.id!,
          token: authController.user.token!,
          productId: item.id,
          quantity: quantity);

      result.when(success: (data) {
        cartItems.add(CartItemModel(item: item, id: data, quantity: quantity));
        update();
      }, error: (message) {
        utilsServices.showToast(message: message, isError: true);
      });
    }
    update();
  }
}
