import 'package:flutter/material.dart';
import 'package:glassfy_flutter/models.dart';

class PayWallWidget extends StatefulWidget {
  const PayWallWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.offer,
    required this.onClickedSku,
  }) : super(key: key);

  final String title;
  final String description;
  final GlassfyOffering offer;
  final ValueChanged<GlassfySku> onClickedSku;

  @override
  State<PayWallWidget> createState() => _PayWallWidgetState();
}

class _PayWallWidgetState extends State<PayWallWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.deepOrange),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: widget.offer.skus?.length,
              itemBuilder: (context, index) {
                final sku = widget.offer.skus![index];
                return Card(
                  color: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    title: Text(
                      '${widget.offer.offeringId}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${sku.product?.description}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: Text(
                      '${sku.product?.price}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => widget.onClickedSku(sku),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
