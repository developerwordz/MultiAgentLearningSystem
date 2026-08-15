import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/session_model.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  // Create a new session
  Future<TeachingSession> createSession(String userId, String topic) async {
    final response = await supabase
        .from('sessions')
        .insert({
          'user_id': userId,
          'topic': topic,
        })
        .select()
        .single();

    return TeachingSession.fromMap(response);
  }

  // Fetch all sessions for user
  Future<List<TeachingSession>> fetchUserSessions(String userId) async {
    final response =
        await supabase.from('sessions').select().eq('user_id', userId);

    return (response as List)
        .map((item) => TeachingSession.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  // Save message
  Future<void> saveMessage(
    int sessionId,
    String sender,
    String content,
  ) async {
    await supabase.from('messages').insert({
      'session_id': sessionId,
      'sender': sender,
      'content': content,
    });
  }

  // Fetch messages for session
  Future<List<Map<String, dynamic>>> fetchSessionMessages(int sessionId) async {
    final response = await supabase
        .from('messages')
        .select()
        .eq('session_id', sessionId)
        .order('created_at', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  // Update mastery score
  Future<void> updateMasteryScore(
    String userId,
    String concept,
    int masteryPercentage,
  ) async {
    await supabase.from('mastery_scores').insert({
      'user_id': userId,
      'concept': concept,
      'mastery_percentage': masteryPercentage,
    });
  }
}