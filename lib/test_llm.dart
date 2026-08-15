import 'services/llm_service.dart';

void main() async {
  final llm = LLMService();
  
  // Test the service
  print('Testing LLM Service...\n');
  
  final response = await llm.sendMessage('Hi, can you teach me about inheritance in OOP?');
  print('Student: $response\n');
  
  final response2 = await llm.sendMessage('Inheritance is when a child class gets properties from a parent class.');
  print('Student: $response2\n');
}