import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/widgets/coin_badge.dart';
import '../../../core/utils/helpers.dart';

class SwagStoreScreen extends StatefulWidget {
  const SwagStoreScreen({super.key});

  @override
  State<SwagStoreScreen> createState() => _SwagStoreScreenState();
}

class _SwagStoreScreenState extends State<SwagStoreScreen> {
  int _coins = 1200;

  final _items = [
    {'name': 'CodeCraft T-Shirt', 'emoji': '👕', 'price': 500, 'desc': 'Premium cotton tee with CodeCraft logo'},
    {'name': 'Sticker Pack', 'emoji': '🎨', 'price': 100, 'desc': '10 coding stickers for your laptop'},
    {'name': 'Premium Badge', 'emoji': '🏆', 'price': 300, 'desc': 'Gold profile badge - show off your status'},
    {'name': 'Custom Theme', 'emoji': '🎨', 'price': 200, 'desc': 'Unlock exclusive app themes'},
    {'name': 'Coffee Mug', 'emoji': '☕', 'price': 400, 'desc': 'CodeCraft branded developer mug'},
    {'name': 'GitHub Pro', 'emoji': '💻', 'price': 800, 'desc': '1 month GitHub Pro subscription'},
    {'name': 'Notebook', 'emoji': '📓', 'price': 250, 'desc': 'Premium coding notebook'},
    {'name': 'Hoodie', 'emoji': '🧥', 'price': 1000, 'desc': 'CodeCraft developer hoodie'},
  ];

  void _redeem(Map<String, dynamic> item) {
    final price = item['price'] as int;
    if (_coins < price) {
      Helpers.showToast(context, 'Not enough coins! 😅', isError: true);
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Redeem ${item['name']}?', style: AppTextStyles.h2),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item['emoji'] as String, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text('This will cost $price coins', style: AppTextStyles.body),
            const SizedBox(height: 8),
            CoinBadge(coins: _coins, large: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _coins -= price);
              Navigator.pop(ctx);
              Helpers.showToast(context, '🎉 Redeemed ${item['name']}!');
            },
            child: const Text('Redeem', style: TextStyle(color: AppColors.green)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        title: GradientText(
          text: '🏪 Swag Store',
          style: AppTextStyles.h2,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CoinBadge(coins: _coins, large: true),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: _items.length,
        itemBuilder: (_, i) {
          final item = _items[i];
          final canAfford = _coins >= (item['price'] as int);
          return FadeInUp(
            delay: Duration(milliseconds: i * 60),
            child: GlassCard(
              borderColor: canAfford
                  ? AppColors.green.withOpacity(0.2)
                  : AppColors.border,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item['emoji'] as String,
                      style: const TextStyle(fontSize: 36)),
                  const SizedBox(height: 10),
                  Text(item['name'] as String,
                      style: AppTextStyles.h3.copyWith(fontSize: 13),
                      textAlign: TextAlign.center,
                      maxLines: 2),
                  const SizedBox(height: 4),
                  Text(item['desc'] as String,
                      style: AppTextStyles.small.copyWith(fontSize: 9),
                      textAlign: TextAlign.center,
                      maxLines: 2),
                  const SizedBox(height: 10),
                  CoinBadge(coins: item['price'] as int),
                  const SizedBox(height: 8),
                  GradientButton(
                    label: canAfford ? 'Redeem' : 'Locked',
                    small: true,
                    disabled: !canAfford,
                    onTap: canAfford ? () => _redeem(item) : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
