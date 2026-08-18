import 'package:dio/dio.dart';
import '../config/llm_config.dart';

class LLMService {
  final Dio _dio = Dio();
  final List<Message> _conversationHistory = [];

  // System prompt for Student Agent
  static const String studentSystemPrompt = '''You are Alex, a student trying to learn from the user.

CORE RULES:
1. You NEVER explain concepts yourself, even if you know them.
2. You ONLY ask questions to understand what the user is teaching.
3. You act confused when explanations are vague.
4. You ask follow-up "why" and "what if" questions.
5. You request examples when theory alone is given.
6. Express uncertainty: "I'm confused about...", "Can you clarify...", "I don't understand..."

BEHAVIOR:
- If good explanation: "That makes sense! But what about...?"
- If vague explanation: "Hmm, I'm not sure. Can you explain what you mean by...?"
- If wrong/incomplete: "Wait, but...?" and ask clarifying questions.
- NEVER say "Actually, the correct answer is..."

Remember: You are a LEARNER, not a teacher.''';

  LLMService() {
    // Add system message
    _conversationHistory.add(
      Message(role: 'system', content: studentSystemPrompt),
    );
  }

  // Send message and get response
  Future<String> sendMessage(String userMessage) async {
    try {
      // Add user message to history
      _conversationHistory.add(
        Message(role: 'user', content: userMessage),
      );

      // Call Gemini API
      final response = await _callGemini();

      // Add AI response to history
      _conversationHistory.add(
        Message(role: 'assistant', content: response),
      );

      return response;
    } catch (e) {
      print('LLM Error: $e');
      rethrow;
    }
  }

  // Call Gemini API
  Future<String> _callGemini() async {
  try {
    final payload = {
      'contents': [
        {
          'parts': [
            {'text': _conversationHistory.last.content}
          ]
        }
      ],
      'generationConfig': {
        'temperature': LLMConfig.temperature,
        'maxOutputTokens': LLMConfig.maxTokens,
      }
    };

    // Try with new key format
    final response = await _dio.post(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent',
      queryParameters: {
        'key': LLMConfig.geminiApiKey,
      },
      data: payload,
      options: Options(
        contentType: Headers.jsonContentType,
      ),
    );

    if (response.statusCode == 200) {
      final text = response.data['candidates'][0]['content']['parts'][0]['text'];
      return text.toString();
    } else {
      throw Exception('Gemini API error: ${response.statusCode} - ${response.data}');
    }
  } catch (e) {
    throw Exception('Failed to get Gemini response: $e');
  }
}

  List<Message> getConversationHistory() {
    return _conversationHistory;
  }

  void resetConversation() {
    _conversationHistory.clear();
    _conversationHistory.add(
      Message(role: 'system', content: studentSystemPrompt),
    );
  }
}

class Message {
  final String role;
  final String content;

  Message({required this.role, required this.content});

  Map<String, dynamic> toMap() {
    return {'role': role, 'content': content};
  }
}