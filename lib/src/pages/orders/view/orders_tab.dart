import 'package:app_quitanda/src/pages/orders/controller/all_orders_controller.dart';
import 'package:app_quitanda/src/pages/orders/view/components/order_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      body: GetBuilder<AllOrdersController>(
        builder: (controller) => RefreshIndicator(
          onRefresh: () => controller.getAllOrders(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (_, index) =>
                OrderTile(order: controller.allOrders[index]),
            itemCount: controller.allOrders.length,
          ),
        ),
      ),
    );
  }
}
