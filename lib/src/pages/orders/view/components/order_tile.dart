import 'package:app_quitanda/src/models/order_model.dart';
import 'package:app_quitanda/src/pages/common_widgets/payment_dialog.dart';
import 'package:app_quitanda/src/pages/orders/view/components/order_status_widget.dart';
import 'package:app_quitanda/src/services/utlis_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/order_controller.dart';

class OrderTile extends StatelessWidget {
  final OrderModel order;

  OrderTile({super.key, required this.order});

  final UtilsService utilsService = UtilsService();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: GetBuilder<OrderController>(
          init: OrderController(order),
          global: false,
          builder: (controller) => ExpansionTile(
            onExpansionChanged: (value) {
              if (value && order.items.isEmpty) {
                controller.getOrderItems();
              }
            },
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pedido: ${order.id}'),
                Text(
                  utilsService.formatDateTime(order.createdDateTime!),
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            children: controller.isLoading
                ? [
                    Container(
                      height: 80,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    )
                  ]
                : [
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: SizedBox(
                              height: 150,
                              child: ListView(
                                children: order.items.map(
                                  (orderItem) {
                                    return Row(
                                      children: [
                                        Text(
                                          '${orderItem.quantity} ${orderItem.item.unit} ',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                            child:
                                                Text(orderItem.item.itemName)),
                                        Text(utilsService.priceToCurrency(
                                            orderItem.totalPrice()))
                                      ],
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.grey.shade300,
                            thickness: 2,
                            width: 8,
                          ),
                          Expanded(
                            flex: 2,
                            child: OrderStatusWidget(
                              isOverdue: order.overdueDateTime
                                  .isBefore(DateTime.now()),
                              status: order.status,
                            ),
                          )
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        style: const TextStyle(fontSize: 20),
                        children: [
                          const TextSpan(
                            text: 'Total ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: utilsService.priceToCurrency(order.total),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible:
                          order.status == 'pending_payment' && !order.isOverDue,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return PaymentDialog(
                                    order: order,
                                  );
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: Image.asset(
                            'assets/app_images/pix.png',
                            height: 18,
                          ),
                          label: const Text('Ver Qr Code Pix')),
                    )
                  ],
          ),
        ),
      ),
    );
  }
}
