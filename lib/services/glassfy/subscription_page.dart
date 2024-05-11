import 'package:flutter/material.dart';
import 'package:glassfy_flutter/glassfy_flutter.dart';
import 'package:ielts/services/glassfy/glassfyUtils.dart';
import 'package:ielts/services/glassfy/paywall_widget.dart';
import 'package:ielts/services/glassfy/provider.dart';
import 'package:ielts/services/purchaseApi.dart';
import 'package:provider/provider.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  Widget build(BuildContext context) {
    final isPremium = context.watch<GlassfyProvider>().isPremium;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          buildEntitlement(isPremium),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: fetchOffers,
            child: const Text('Plans'),
          ),
        ],
      ),
    );
  }

  Widget buildEntitlement(bool isPremium) => isPremium
      ? buildEntitlementIcon(
          text: 'You are on Paid plan',
          icon: Icons.paid,
          color: Colors.green,
        )
      : buildEntitlementIcon(
          text: 'You are on Free plan',
          icon: Icons.lock,
          color: Colors.red,
        );

  Widget buildEntitlementIcon({
    required String text,
    required IconData icon,
    required Color color,
  }) =>
      Column(
        children: [
          Icon(icon, color: color, size: 100),
          const SizedBox(height: 8),
          Text(text),
        ],
      );

  Future fetchOffers() async {
    final offerings = await PurchaseApi.fetchOffers();
    final offer = offerings
        .singleWhere((offering) => offering.offeringId == 'All Courses');
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
            final permissions = transaction.permissions!.all!;
            final permission = permissions.firstWhere(
                (permission) => permission.permissionId == 'premium');

            if (permission.isValid!) {
              final provider = context.read<GlassfyProvider>();
              provider.isPremium = true;
            }
          }
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
