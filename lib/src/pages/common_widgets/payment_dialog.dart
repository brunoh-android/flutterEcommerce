import 'package:app_quitanda/src/models/order_model.dart';
import 'package:app_quitanda/src/services/utlis_service.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class PaymentDialog extends StatelessWidget {
  final OrderModel order;

  PaymentDialog({super.key, required this.order});

  final UtilsService utilsService = UtilsService();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Pagamento com Pix',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Image.memory(utilsService.decodeQrCodeImage(order.qrCodeImage),
                    height: 200, width: 200),
                Text(
                    'Vencimento: ${utilsService.formatDateTime(order.overdueDateTime)}',
                    style: const TextStyle(fontSize: 12)),
                Text(
                  'Total: ${utilsService.priceToCurrency(order.total)}',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side:
                              const BorderSide(width: 2, color: Colors.green))),
                  onPressed: () {
                    FlutterClipboard.copy(order.copyAndPaste);
                  },
                  icon: const Icon(
                    Icons.copy,
                    size: 15,
                  ),
                  label: const Text(
                    'Copiar código Pix',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ))
        ],
      ),
    );
  }
}
