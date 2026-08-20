import 'package:dio/dio.dart';
import '../config/llm_config.dart';

class LLMService {
  final Dio _dio = Dio();

  final List<Message> _conversationHistory = [];

  static const String studentSystemPrompt = '''
You are Alex, a student trying to learn from the user.

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

Remember: You are a LEARNER, not a teacher.
''';

  LLMService() {
    resetConversation();
  }

  Future<String> sendMessage(String userMessage) async {
    try {
      _conversationHistory.add(
        Message(
          role: 'user',
          content: userMessage,
        ),
      );

      final response = await _callGemini();

      _conversationHistory.add(
        Message(
          role: 'model',
          content: response,
        ),
      );

      return response;
    } catch (e) {
      print('LLM Error: $e');
      rethrow;
    }
  }

  Future<String> _callGemini() async {
  final apiKey = LLMConfig.geminiApiKey;

  if (apiKey.isEmpty) {
    throw Exception('Gemini API key is missing.');
  }

  final contents = <Map<String, dynamic>>[];

  // Add conversation history.
  for (final message in _conversationHistory) {
    if (message.role == 'user' || message.role == 'model') {
      contents.add({
        'role': message.role,
        'parts': [
          {
            'text': message.content,
          }
        ],
      });
    }
  }

  try {
    final response = await _dio.post(
      LLMConfig.geminiUrl,
      
      data: {
        'systemInstruction': {
          'parts': [
            {
              'text': studentSystemPrompt,
            }
          ],
        },
        'contents': contents,
        'generationConfig': {
          'maxOutputTokens': LLMConfig.maxTokens,
        },
      },
     options: Options(
  contentType: Headers.jsonContentType,
  headers: {
    'x-goog-api-key': apiKey,
  },
),
    );

    print('Gemini status: ${response.statusCode}');
    print('Gemini response: ${response.data}');

    if (response.statusCode != 200) {
      throw Exception(
        'Gemini API ${response.statusCode}: ${response.data}',
      );
    }

    final candidates = response.data['candidates'];

    if (candidates == null || candidates.isEmpty) {
      throw Exception(
        'Gemini returned no candidates: ${response.data}',
      );
    }

    final parts = candidates[0]['content']['parts'];

    if (parts == null || parts.isEmpty) {
      throw Exception(
        'Gemini returned no text: ${response.data}',
      );
    }

    return parts[0]['text'].toString();
  } on DioException catch (e) {
    print('Dio error: ${e.response?.data}');
    throw Exception(
      'Gemini request failed: ${e.response?.data ?? e.message}',
    );
  }
}

  List<Message> getConversationHistory() {
    return List.unmodifiable(_conversationHistory);
  }

  void resetConversation() {
    _conversationHistory.clear();
  }
}

class Message {
  final String role;
  final String content;

  Message({
    required this.role,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'content': content,
    };
  }
}