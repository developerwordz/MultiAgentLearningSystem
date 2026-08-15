import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/session_provider.dart';
import '../../providers/auth_provider.dart';

class TeachingScreen extends StatefulWidget {
  final String topic;
  final int? existingSessionId; // NEW: for resuming

  const TeachingScreen({
    Key? key,
    required this.topic,
    this.existingSessionId,
  }) : super(key: key);

  @override
  State<TeachingScreen> createState() => _TeachingScreenState();
}

class _TeachingScreenState extends State<TeachingScreen> {
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  @override
   void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final sessionProvider = context.read<SessionProvider>();
      
      if (authProvider.user != null) {
        if (widget.existingSessionId != null) {
          // Resume existing session
          sessionProvider.resumeSession(
            widget.existingSessionId!,
            authProvider.user!.id,
          );
        } else {
          // Create new session
          sessionProvider.createSession(
            authProvider.user!.id,
            widget.topic,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teaching: ${widget.topic}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<SessionProvider>().endSession();
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<SessionProvider>(
        builder: (context, sessionProvider, _) {
          return Column(
            children: [
              // Messages List
              Expanded(
                child: sessionProvider.messages.isEmpty
                    ? Center(
                        child: Text(
                          'Start teaching ${widget.topic}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: sessionProvider.messages.length,
                        itemBuilder: (context, index) {
                          final message = sessionProvider.messages[index];
                          final isUser = message.sender == 'user';

                          return Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? Colors.blue[500]
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.75,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isUser ? 'You' : 'Alex (Student)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isUser ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    message.content,
                                    style: TextStyle(
                                      color: isUser ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Error message
              if (sessionProvider.error != null)
                Container(
                  color: Colors.red[100],
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Error: ${sessionProvider.error}',
                    style: TextStyle(color: Colors.red[900]),
                  ),
                ),

              // Input box
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: 'Teach me...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        enabled: !sessionProvider.isLoading,
                        maxLines: null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: sessionProvider.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.send, color: Colors.white),
                              onPressed: () async {
                                if (messageController.text.trim().isEmpty) {
                                  return;
                                }

                                await sessionProvider
                                    .sendMessage(messageController.text);
                                messageController.clear();
                                _scrollToBottom();
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}