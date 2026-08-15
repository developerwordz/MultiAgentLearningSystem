class LLMConfig {
  // IMPORTANT: In production, move this to environment variables
  // For now, we'll hardcode for testing
  
  // Choose your AI provider
  static const String provider = 'gemini'; // or 'gpt'
  
  // Gemini API

  
  static const int maxTokens = 500;
  static const double temperature = 0.4;
}
