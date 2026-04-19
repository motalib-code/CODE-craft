import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/voice_service.dart';

class VoiceNotifier extends StateNotifier<bool> {
  VoiceNotifier() : super(false);

  final _voiceService = VoiceService();

  Future<void> initialize() async {
    await _voiceService.initialize();
  }

  void toggleListening(Function(String) onResult) {
    if (state) {
      stopListening();
    } else {
      startListening(onResult);
    }
  }

  void startListening(Function(String) onResult) {
    state = true;
    _voiceService.startListening(
      onResult: (text) {
        onResult(text);
        state = false;
      },
    );
  }

  void stopListening() {
    _voiceService.stopListening();
    state = false;
  }

  void cancel() {
    _voiceService.cancel();
    state = false;
  }

  bool get isAvailable => _voiceService.isAvailable;
}

final voiceProvider = StateNotifierProvider<VoiceNotifier, bool>(
  (ref) => VoiceNotifier()..initialize(),
);

// Last voice command
final lastVoiceCommandProvider = StateProvider<String>((ref) => '');

// Voice recognized text in real-time
final voiceTextProvider = StateProvider<String>((ref) => '');
