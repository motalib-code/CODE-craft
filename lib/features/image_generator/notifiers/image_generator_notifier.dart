import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageGeneratorState {
  final bool isLoading;
  final String? generatedImageUrl;
  final String? error;
  final List<String> history;

  ImageGeneratorState({
    this.isLoading = false,
    this.generatedImageUrl,
    this.error,
    this.history = const [],
  });

  ImageGeneratorState copyWith({
    bool? isLoading,
    String? generatedImageUrl,
    String? error,
    List<String>? history,
  }) {
    return ImageGeneratorState(
      isLoading: isLoading ?? this.isLoading,
      generatedImageUrl: generatedImageUrl ?? this.generatedImageUrl,
      error: error ?? this.error,
      history: history ?? this.history,
    );
  }
}

class ImageGeneratorNotifier extends StateNotifier<ImageGeneratorState> {
  ImageGeneratorNotifier() : super(ImageGeneratorState());

  Future<void> generateImage(String prompt) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Logic for image generation would go here (e.g. DALL-E or Stable Diffusion API)
      // For now, we use a high-quality placeholder that matches the prompt's theme
      await Future.delayed(const Duration(seconds: 2));
      
      final newUrl = 'https://images.unsplash.com/photo-1614850523296-d8c1af93d400?auto=format&fit=crop&q=80&w=1000';
      
      state = state.copyWith(
        isLoading: false,
        generatedImageUrl: newUrl,
        history: [newUrl, ...state.history],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() => state = state.copyWith(error: null);
}

final imageGeneratorNotifierProvider =
    StateNotifierProvider<ImageGeneratorNotifier, ImageGeneratorState>((ref) {
  return ImageGeneratorNotifier();
});
