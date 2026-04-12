import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/gemini_service.dart';
import '../../../core/services/groq_service.dart';

final aiMentorNotifierProvider =
    StateNotifierProvider<AiMentorNotifier, AiChatState>((ref) {
  return AiMentorNotifier();
});

class AiChatState {
  final List<Map<String, String>> messages;
  final bool isTyping;
  final String? error;

  const AiChatState({
    this.messages = const [],
    this.isTyping = false,
    this.error,
  });
}

class AiMentorNotifier extends StateNotifier<AiChatState> {
  final _gemini = GeminiService();
  final _groq = GroqService();

  AiMentorNotifier() : super(const AiChatState());

  Future<void> sendMessage(String message) async {
    final updatedMessages = [
      ...state.messages,
      {'role': 'user', 'content': message},
    ];

    state = AiChatState(messages: updatedMessages, isTyping: true);

    try {
      String response;
      try {
        // Try Gemini first
        response = await _gemini.chat(
          message: message,
          history: state.messages,
        );
      } catch (e) {
        // Fallback to Groq if Gemini fails
        response = await _groq.chat(
          message: message,
          history: state.messages,
          context: 'You are CodeCraft AI. Gemini failed, so you are picking up. Maintain the same friendly persona.',
        );
      }

      state = AiChatState(
        messages: [
          ...updatedMessages,
          {'role': 'assistant', 'content': response},
        ],
        isTyping: false,
      );
    } catch (e) {
      state = AiChatState(
        messages: [
          ...updatedMessages,
          {'role': 'assistant', 'content': 'Sorry bhai, full network error hai. Groq aur Gemini dono fail ho gaye. Check connection!'},
        ],
        isTyping: false,
        error: e.toString(),
      );
    }
  }

  void clearChat() {
    state = const AiChatState();
  }

  @override
  void dispose() {
    _gemini.dispose();
    _groq.dispose();
    super.dispose();
  }
}
