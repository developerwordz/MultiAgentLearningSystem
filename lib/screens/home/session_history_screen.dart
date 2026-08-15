import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/session_provider.dart';
import '../../providers/auth_provider.dart';
import '../teaching/teaching_screen.dart';

class SessionHistoryScreen extends StatefulWidget {
  const SessionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<SessionHistoryScreen> createState() => _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends State<SessionHistoryScreen> {
  late Future<List> _sessionsFuture;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    final sessionProvider = context.read<SessionProvider>();
    
    if (authProvider.user != null) {
      _sessionsFuture = sessionProvider.fetchUserSessions(authProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teaching History')),
      body: FutureBuilder<List>(
        future: _sessionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final sessions = snapshot.data ?? [];

          if (sessions.isEmpty) {
            return const Center(
              child: Text('No teaching sessions yet. Start a new one!'),
            );
          }

          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return ListTile(
                title: Text('Teaching: ${session.topic}'),
                subtitle: Text('Created: ${session.createdAt}'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TeachingScreen(
                        topic: session.topic,
                        existingSessionId: session.id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}