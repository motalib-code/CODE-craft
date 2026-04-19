import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../core/services/gemini_service.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});
  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final GeminiService _gemini = GeminiService();
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isTyping = false;
  bool _isListening = false;
  String _interviewStatus = "normal"; // normal or interview

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _messages.add({
      'role': 'ai',
      'content': 'Namaste bhai! 👋\nMain CodeCraft AI hoon. Kya help chahiye aaj? Coding, Mock Interview, ya koi file/image dikhao!',
    });
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text.trim();
    setState(() {
      _messages.add({'role': 'user', 'content': userMessage});
      _isTyping = true;
      _controller.clear();
    });

    try {
      final response = await _gemini.chat(
        message: userMessage,
        history: _messages
            .map((m) =>
                {'role': m['role'].toString(), 'content': m['content'].toString()})
            .toList(),
      );

      setState(() {
        _messages.add({'role': 'ai', 'content': response});
        _isTyping = false;

        // Auto detect interview mode
        if (response.contains('[INTERVIEW_MODE]') ||
            userMessage.toLowerCase().contains('interview')) {
          _interviewStatus = "interview";
        }
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'ai',
          'content': 'Yaar kuch gadbad ho gaya. Phir se try karo! 😅'
        });
        _isTyping = false;
      });
    }
  }

  // Mic Button
  Future<void> _toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            _controller.text = result.recognizedWords;
            if (result.finalResult) {
              setState(() => _isListening = false);
              _sendMessage();
            }
          },
        );
      }
    } else {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  // File Upload (Image + Code)
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['dart', 'py', 'java', 'cpp', 'js', 'txt', 'json'],
    );

    if (result != null) {
      // For demo - send file name as message
      setState(() {
        _messages.add({
          'role': 'user',
          'content': '📎 File uploaded: ${result.files.first.name}',
          'isFile': true
        });
      });

      // Gemini ko bhej sakte ho (fileBytes ke saath)
      final response = await _gemini.chat(
        message: "Analyze this uploaded file: ${result.files.first.name}",
        history: _messages
            .map((m) =>
                {'role': m['role'].toString(), 'content': m['content'].toString()})
            .toList(),
      );

      setState(() => _messages.add({'role': 'ai', 'content': response}));
    }
  }

  // Image Upload (Camera + Gallery)
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _messages.add({'role': 'user', 'content': '📸 Image uploaded'});
      });

      final bytes = await image.readAsBytes();
      final response = await _gemini.chat(
        message: "Analyze this image/screenshot",
        history: _messages
            .map((m) =>
                {'role': m['role'].toString(), 'content': m['content'].toString()})
            .toList(),
        fileType: 'image',
        fileBytes: bytes,
      );

      setState(() => _messages.add({'role': 'ai', 'content': response}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CodeCraft AI', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Online • Neural Engine v4.2',
                style: TextStyle(fontSize: 12, color: Colors.green)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.psychology_outlined, color: Colors.orange),
            onPressed: () {
              setState(() => _interviewStatus = "interview");
              _messages.add({
                'role': 'ai',
                'content':
                    'Interview mode ON! 🎤 Batao kaunsi company ke liye prepare kar rahe ho?'
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('CodeCraft AI soch raha hai...',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  );
                }

                final msg = _messages[index];
                final isUser = msg['role'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8),
                    child: GlassCard(
                      gradient: isUser ? AppColors.gradPurpleBlue : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MarkdownBody(
                            data: msg['content'].toString(),
                            styleSheet: MarkdownStyleSheet(
                              p: AppTextStyles.body.copyWith(
                                  color: isUser ? Colors.white : Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Input Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.bgSurface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.attach_file), onPressed: _pickFile),
                IconButton(icon: const Icon(Icons.image), onPressed: _pickImage),
                IconButton(
                  icon: Icon(_isListening ? Icons.mic_off : Icons.mic,
                      color: _isListening ? Colors.red : AppColors.purple),
                  onPressed: _toggleListening,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: AppTextStyles.body,
                    decoration: InputDecoration(
                      hintText: "Message CodeCraft AI...",
                      hintStyle: AppTextStyles.small,
                      filled: true,
                      fillColor: AppColors.bgInput,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.purple),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
