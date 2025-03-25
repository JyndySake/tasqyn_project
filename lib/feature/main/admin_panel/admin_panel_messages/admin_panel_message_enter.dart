import 'package:flutter/material.dart';

void main() {
  runApp(const AdminReplyApp());
}

class AdminReplyApp extends StatelessWidget {
  const AdminReplyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const AdminReplyPage(userName: "John Doe"),
    );
  }
}

class AdminReplyPage extends StatefulWidget {
  final String userName;

  const AdminReplyPage({super.key, required this.userName});

  @override
  _AdminReplyPageState createState() => _AdminReplyPageState();
}

class _AdminReplyPageState extends State<AdminReplyPage> {
  final List<Map<String, String>> messages = [
    {"sender": "user", "text": "Hello, I need help!"},
    {"sender": "admin", "text": "Sure, how can I assist you?"},
  ];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        messages.add({"sender": "admin", "text": _controller.text.trim()});
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1D26),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1D26),
        elevation: 0,
        title: Text(
          "Chat with ${widget.userName}",
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: _buildChatMessages()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        return _buildMessageBubble(msg["sender"]!, msg["text"]!);
      },
    );
  }

  Widget _buildMessageBubble(String sender, String text) {
    bool isAdmin = sender == "admin";

    return Align(
      alignment: isAdmin ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isAdmin ? const Color(0xFFFBD784) : Colors.white12,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isAdmin ? const Radius.circular(12) : Radius.zero,
            bottomRight: isAdmin ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isAdmin ? Colors.black : Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Type your reply...",
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            backgroundColor: const Color(0xFFFBD784),
            onPressed: _sendMessage,
            child: const Icon(Icons.send, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
