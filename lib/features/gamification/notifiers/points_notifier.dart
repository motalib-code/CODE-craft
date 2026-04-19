import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/reward_item_model.dart';
import '../../../models/points_transaction_model.dart';

final pointsNotifierProvider = StateNotifierProvider<PointsNotifier, PointsState>((ref) {
  return PointsNotifier();
});

class PointsState {
  final int balance;
  final List<RewardItem> rewards;
  final List<PointsTransaction> transactions;
  final bool isLoading;
  final String? error;

  const PointsState({
    this.balance = 0,
    this.rewards = const [],
    this.transactions = const [],
    this.isLoading = false,
    this.error,
  });

  PointsState copyWith({
    int? balance,
    List<RewardItem>? rewards,
    List<PointsTransaction>? transactions,
    bool? isLoading,
    String? error,
  }) {
    return PointsState(
      balance: balance ?? this.balance,
      rewards: rewards ?? this.rewards,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class PointsNotifier extends StateNotifier<PointsState> {
  PointsNotifier() : super(const PointsState()) {
    _init();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _init() async {
    await fetchRewards();
    // In a real app, we'd listen to the user's points in Firestore
    // For now, we simulate a balance
    state = state.copyWith(balance: 1500);
  }

  Future<void> fetchRewards() async {
    state = state.copyWith(isLoading: true);
    try {
      // Simulation of fetching rewards
      final List<RewardItem> mockRewards = [
        const RewardItem(
          id: '1',
          name: 'Premium T-Shirt',
          description: 'High-quality cotton tee with StudentHub logo.',
          emoji: '👕',
          pointsPrice: 500,
          category: RewardCategory.swag,
        ),
        const RewardItem(
          id: '2',
          name: 'Sticker Pack',
          description: '10+ waterproof stickers for your laptop.',
          emoji: '🎨',
          pointsPrice: 100,
          category: RewardCategory.swag,
        ),
        const RewardItem(
          id: '3',
          name: 'DSA Mastery Course',
          description: 'Full access to our top-rated DSA course.',
          emoji: '🎓',
          pointsPrice: 2000,
          category: RewardCategory.digital,
        ),
        const RewardItem(
          id: '4',
          name: 'Resume Review',
          description: 'Get your resume reviewed by experts.',
          emoji: '📄',
          pointsPrice: 800,
          category: RewardCategory.career,
        ),
        const RewardItem(
          id: '5',
          name: '₹500 Amazon Voucher',
          description: 'Redeemable on Amazon India.',
          emoji: '🎫',
          pointsPrice: 1500,
          moneyPrice: 500,
          category: RewardCategory.lifestyle,
        ),
      ];
      
      state = state.copyWith(rewards: mockRewards, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> redeemReward(RewardItem item, String userId) async {
    if (state.balance < item.pointsPrice) return false;

    state = state.copyWith(isLoading: true);
    try {
      // 1. Logic would involve a transaction in Firestore
      // await _firestore.runTransaction((transaction) async { ... });
      
      // Update local state for now
      state = state.copyWith(
        balance: state.balance - item.pointsPrice,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> addPoints(int amount, String reason, String userId) async {
    // This should ideally be a Cloud Function call for security
    // But for the logic show:
    state = state.copyWith(balance: state.balance + amount);
  }
}
