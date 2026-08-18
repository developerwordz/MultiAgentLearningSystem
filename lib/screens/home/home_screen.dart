import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../teaching/teaching_screen.dart';
import 'session_history_screen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Protégé Effect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome, ${authProvider.user?.email}!'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TeachingScreen(
                          topic: 'OOP Inheritance',
                        ),
                      ),
                    );
                  },
                  child: const Text('Start Teaching: OOP Inheritance'),
                ),
                
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TeachingScreen(
                          topic: 'Recursion',
                        ),
                      ),
                    );
                  },
                  child: const Text('Start Teaching: Recursion'),
                ),
                FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SessionHistoryScreen(),
      ),
    );
  },
  child: const Icon(Icons.history),
),
              ],
            );
          },
        ),
      ),
    );
  }
}