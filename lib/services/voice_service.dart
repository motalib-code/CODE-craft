import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  static final VoiceService _instance = VoiceService._internal();

  factory VoiceService() {
    return _instance;
  }

  VoiceService._internal();

  final _speechToText = SpeechToText();
  bool _isListening = false;
  String _lastWords = '';

  bool get isListening => _isListening;
  String get lastWords => _lastWords;

  Future<bool> initialize() async {
    try {
      final available = await _speechToText.initialize(
        onError: (error) => print('Speech error: $error'),
        onStatus: (status) => print('Speech status: $status'),
      );
      return available;
    } catch (e) {
      print('Voice init error: $e');
      return false;
    }
  }

  void startListening({
    required Function(String) onResult,
    String localeId = 'en_US',
  }) {
    if (_isListening) return;

    try {
      _isListening = true;
      _speechToText.listen(
        onResult: (result) {
          _lastWords = result.recognizedWords;
          onResult(_lastWords);
          if (result.finalResult) {
            _isListening = false;
          }
        },
        localeId: localeId,
      );
    } catch (e) {
      print('Listen error: $e');
      _isListening = false;
    }
  }

  void stopListening() {
    _speechToText.stop();
    _isListening = false;
  }

  void cancel() {
    _speechToText.cancel();
    _isListening = false;
  }

  bool get isAvailable => _speechToText.isAvailable;
}
