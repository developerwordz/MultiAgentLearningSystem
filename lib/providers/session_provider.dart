import 'package:flutter/material.dart';
import '../models/session_model.dart';
import '../services/supabase_service.dart';
import '../services/llm_service.dart';

class ChatMessage {
  final String sender; // 'user' or 'student'
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.content,
    required this.timestamp,
  });
}

class SessionProvider extends ChangeNotifier {
  TeachingSession? _currentSession;
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;

  late LLMService _llmService;
  late SupabaseService _supabaseService;

  // Getters
  TeachingSession? get currentSession => _currentSession;
  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasActiveSession => _currentSession != null;

  SessionProvider() {
    _llmService = LLMService();
    _supabaseService = SupabaseService();
  }

  // Create new teaching session
  Future<void> createSession(String userId, String topic) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final session = await _supabaseService.createSession(userId, topic);
      _currentSession = session;
      _messages = [];
      
      // Reset LLM conversation for new session
      _llmService.resetConversation();
      
      // Get initial greeting from student
      await _getStudentGreeting();
      
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Get initial greeting from AI student
  Future<void> _getStudentGreeting() async {
    try {
      final greeting = await _llmService.sendMessage(
        'Hi, I need to learn about ${_currentSession?.topic}. Can you teach me?',
      );
      
      _messages.add(ChatMessage(
        sender: 'student',
        content: greeting,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      _error = 'Failed to get greeting: $e';
    }
    notifyListeners();
  }

  // Send message from user (teaching) to student
  Future<void> sendMessage(String userMessage) async {
    if (_currentSession == null) {
      _error = 'No active session';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Add user message to UI
      _messages.add(ChatMessage(
        sender: 'user',
        content: userMessage,
        timestamp: DateTime.now(),
      ));

      // Save user message to database
      await _supabaseService.saveMessage(
        _currentSession!.id,
        'user',
        userMessage,
      );

      // Get response from AI student
      final studentResponse = await _llmService.sendMessage(userMessage);

      // Add student response to UI
      _messages.add(ChatMessage(
        sender: 'student',
        content: studentResponse,
        timestamp: DateTime.now(),
      ));

      // Save student response to database
      await _supabaseService.saveMessage(
        _currentSession!.id,
        'student',
        studentResponse,
      );

      _error = null;
    } catch (e) {
      _error = 'Error sending message: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // End teaching session
  Future<void> endSession() async {
    _currentSession = null;
    _messages = [];
    _llmService.resetConversation();
    notifyListeners();
  }

  // Load previous session messages (for resuming)
  Future<void> loadSessionMessages(int sessionId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final dbMessages = await _supabaseService.fetchSessionMessages(sessionId);
      
      _messages = dbMessages.map((m) {
        return ChatMessage(
          sender: m['sender'] as String,
          content: m['content'] as String,
          timestamp: DateTime.parse(m['created_at'] as String),
        );
      }).toList();
      
      _error = null;
    } catch (e) {
      _error = 'Failed to load messages: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
  // Add to SessionProvider class

// Fetch all sessions for user
Future<List<TeachingSession>> fetchUserSessions(String userId) async {
  _isLoading = true;
  notifyListeners();

  try {
    final sessions = await _supabaseService.fetchUserSessions(userId);
    _error = null;
    return sessions;
  } catch (e) {
    _error = 'Failed to fetch sessions: $e';
    return [];
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

// Resume an existing session
Future<void> resumeSession(int sessionId, String userId) async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    // Load session from database
    final sessions = await _supabaseService.fetchUserSessions(userId);
    _currentSession = sessions.firstWhere((s) => s.id == sessionId);

    // Load messages
    await loadSessionMessages(sessionId);

    _error = null;
  } catch (e) {
    _error = 'Failed to resume session: $e';
  }

  _isLoading = false;
  notifyListeners();
}
}