// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_quitanda/src/config/custom_colors.dart';
import 'package:app_quitanda/src/models/cart_item_model.dart';
import 'package:app_quitanda/src/pages/cart/controller/cart_controller.dart';
import 'package:app_quitanda/src/pages/common_widgets/quantity_widget.dart';
import 'package:app_quitanda/src/services/utlis_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartTile extends StatefulWidget {
  final CartItemModel cartItem;

  const CartTile({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  final UtilsService utilsService = UtilsService();
  final controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Image.network(
          widget.cartItem.item.imgUrl,
          height: 60,
          width: 60,
        ),
        title: Text(
          widget.cartItem.item.itemName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          utilsService.priceToCurrency(widget.cartItem.totalPrice()),
          style: TextStyle(
              color: CustomColors.customSwatchColor,
              fontWeight: FontWeight.bold),
        ),
        trailing: QuantityWidget(
          value: widget.cartItem.quantity,
          suffixText: widget.cartItem.item.unit,
          result: (quantity) {
            controller.changeItemQuantity(
                item: widget.cartItem, quantity: quantity);
          },
          isRemovable: true,
        ),
      ),
    );
  }
}
