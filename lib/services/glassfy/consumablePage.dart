import 'package:flutter/material.dart';

import 'package:ielts/services/glassfy/glassfyUtils.dart';
import 'package:ielts/services/glassfy/paywall_widget.dart';
import 'package:ielts/services/glassfy/provider.dart';
import 'package:ielts/services/purchaseApi.dart';
import 'package:provider/provider.dart';

class ConsumablePage extends StatefulWidget {
  const ConsumablePage({super.key});

  @override
  State<ConsumablePage> createState() => _ConsumablePageState();
}

class _ConsumablePageState extends State<ConsumablePage> {
  @override
  Widget build(BuildContext context) {
    final coins = Provider.of<GlassfyProvider>(context).coins;
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildCoins(coins),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: fetchOffers,
            child: const Text(
              'Get More Coins',
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Text(
              'Spend 10 Coins',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCoins(int coins) => Column(
        children: [
          const Icon(
            Icons.monetization_on,
            color: Colors.green,
            size: 100,
          ),
          const SizedBox(height: 8),
          Text(
            'You have $coins Coins',
            style: const TextStyle(fontSize: 24),
          ),
        ],
      );

  Future fetchOffers() async {
    final offerings = await PurchaseApi.fetchOffers();
    final offer =
        offerings.singleWhere((offering) => offering.offeringId == '10_coins');
    if (!mounted) return;
    Utils.showSheet(
      context,
      (context) => PayWallWidget(
        title: 'Upgrade Your Plan',
        description: 'Upgrade to a new plan to enjoy more benefits',
        offer: offer,
        onClickedSku: (sku) async {
          final transaction = await PurchaseApi.purchaseSku(sku);
          if (!mounted) return;

          if (transaction != null) {
            final provider = context.read<GlassfyProvider>();
            provider.add10Coins();
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}
