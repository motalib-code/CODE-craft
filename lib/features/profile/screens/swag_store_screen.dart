import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/widgets/coin_badge.dart';
import '../../../core/utils/helpers.dart';
import '../../../models/reward_item_model.dart';
import '../../gamification/notifiers/points_notifier.dart';

class SwagStoreScreen extends ConsumerStatefulWidget {
  const SwagStoreScreen({super.key});

  @override
  ConsumerState<SwagStoreScreen> createState() => _SwagStoreScreenState();
}

class _SwagStoreScreenState extends ConsumerState<SwagStoreScreen> {
  RewardCategory _selectedCategory = RewardCategory.swag;

  @override
  Widget build(BuildContext context) {
    final pointsState = ref.watch(pointsNotifierProvider);
    final filteredRewards = pointsState.rewards
        .where((r) => r.category == _selectedCategory)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(pointsState.balance),
          SliverToBoxAdapter(
            child: _buildCategoryList(),
          ),
          if (pointsState.isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (filteredRewards.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text('No items in this category yet!',
                    style: AppTextStyles.body),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = filteredRewards[index];
                    return FadeInUp(
                      delay: Duration(milliseconds: index * 50),
                      child: _RewardCard(item: item),
                    );
                  },
                  childCount: filteredRewards.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar(int balance) {
    return SliverAppBar(
      expandedHeight: 120,
      backgroundColor: AppColors.bg,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: Row(
          children: [
            GradientText(
              text: 'Student Store',
              style: AppTextStyles.h2.copyWith(fontSize: 20),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CoinBadge(coins: balance, large: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: RewardCategory.values.length,
        itemBuilder: (context, index) {
          final category = RewardCategory.values[index];
          final isSelected = _selectedCategory == category;
          final name = category.toString().split('.').last.toUpperCase();

          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.gradPurpleBlue : null,
                color: isSelected ? null : AppColors.bgCard,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppColors.border,
                ),
              ),
              child: Center(
                child: Text(
                  name,
                  style: AppTextStyles.small.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RewardCard extends ConsumerWidget {
  final RewardItem item;
  const _RewardCard({required this.item});

  void _showRedeemDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(item.name, style: AppTextStyles.h2, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(item.description,
                style: AppTextStyles.body, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Cost: ', style: AppTextStyles.body),
                CoinBadge(coins: item.pointsPrice, large: true),
              ],
            ),
            const SizedBox(height: 24),
            GradientButton(
              label: 'Confirm Redemption',
              onTap: () async {
                final success = await ref
                    .read(pointsNotifierProvider.notifier)
                    .redeemReward(item, 'currentUser');
                
                if (success) {
                  Navigator.pop(ctx);
                  Helpers.showToast(context, '🎉 Successfully redeemed ${item.name}!');
                } else {
                  Helpers.showToast(context, '❌ Not enough coins!', isError: true);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(pointsNotifierProvider).balance;
    final canAfford = balance >= item.pointsPrice;

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(item.emoji, style: const TextStyle(fontSize: 48)),
              ),
            ),
            Text(
              item.name,
              style: AppTextStyles.h3.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              item.description,
              style: AppTextStyles.small.copyWith(fontSize: 10, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            CoinBadge(coins: item.pointsPrice),
            const SizedBox(height: 12),
            GradientButton(
              label: canAfford ? 'Redeem' : 'Locked',
              small: true,
              disabled: !canAfford,
              onTap: () => _showRedeemDialog(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

