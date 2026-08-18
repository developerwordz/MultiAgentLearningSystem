class LLMConfig {
  static const String provider = 'gemini';  // Make sure this is 'gemini'
  
  // Gemini API
  static const String geminiApiKey = 'REDACTED_GEMINI_KEY';  
  static const String geminiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';
  
  static const int maxTokens = 500;
  static const double temperature = 0.7;
}
