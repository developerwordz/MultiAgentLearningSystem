class LLMService {
  final List<String> _mockResponses = [
    'I\'m confused about what you mean. Can you explain that differently?',
    'That makes sense! But what if we had a different scenario?',
    'Why would you use that approach instead of another method?',
    'Can you give me a concrete code example of that?',
    'Oh! That makes sense now. What comes next?',
    'Interesting! How does that relate to what you said before?',
    'I think I understand this concept now. Do you think I\'m ready for an exam?',
  ];

  int _responseIndex = 0;
  final List<Message> _conversationHistory = [];

  LLMService();

  Future<String> sendMessage(String userMessage) async {
    // Add user message to history
    _conversationHistory.add(
      Message(role: 'user', content: userMessage),
    );

    // Simulate network delay (1-2 seconds)
    await Future.delayed(const Duration(milliseconds: 1500));

    // Get response
    final response = _mockResponses[_responseIndex % _mockResponses.length];
    _responseIndex++;

    // Add to history
    _conversationHistory.add(
      Message(role: 'assistant', content: response),
    );

    return response;
  }

  void resetConversation() {
    _responseIndex = 0;
    _conversationHistory.clear();
  }

  List<Message> getConversationHistory() {
    return _conversationHistory;
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