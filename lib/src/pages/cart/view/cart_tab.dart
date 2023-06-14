// ignore_for_file: use_build_context_synchronously

import 'package:app_quitanda/src/config/custom_colors.dart';
import 'package:app_quitanda/src/pages/cart/view/components/cart_tile.dart';
import 'package:app_quitanda/src/services/utlis_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/cart_controller.dart';

class CartaTab extends StatefulWidget {
  const CartaTab({super.key});

  @override
  State<CartaTab> createState() => _CartaTabState();
}

class _CartaTabState extends State<CartaTab> {
  final UtilsService utilsService = UtilsService();
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<CartController>(builder: (controller) {
              if (controller.cartItems.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.remove_shopping_cart,
                        size: 40, color: CustomColors.customSwatchColor),
                    const Text('Não há itens no carrinho')
                  ],
                );
              }
              return ListView.builder(
                itemCount: controller.cartItems.length,
                itemBuilder: (_, index) {
                  return CartTile(
                    cartItem: controller.cartItems[index],
                  );
                },
              );
            }),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 3,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 12),
                ),
                GetBuilder<CartController>(
                  builder: (controller) => Text(
                    utilsService.priceToCurrency(controller.cartTotalPrice()),
                    style: TextStyle(
                        fontSize: 23,
                        color: CustomColors.customSwatchColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: GetBuilder<CartController>(
                    builder: (controller) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.customSwatchColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: (controller.isCheckoutLoading ||
                              controller.cartItems.isEmpty)
                          ? null
                          : () async {
                              bool? result = await showOrderConfirmation();

                              if (result ?? false) {
                                cartController.checkoutCart();
                              } else {
                                utilsService.showToast(
                                    message: 'Pedido não confirmado');
                              }
                            },
                      child: controller.isCheckoutLoading
                          ? const CircularProgressIndicator()
                          : const Text('Concluir pedido'),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<bool?> showOrderConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Confirmação'),
          content: const Text('Deseja concluir o pedido?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Nao'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Sim'),
            )
          ],
        );
      },
    );
  }
}
