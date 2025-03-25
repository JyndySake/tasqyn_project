import 'package:flutter/material.dart';
import 'package:project_app/feature/main/admin_panel/admin_panel_add_news/admin_panel_add_news.dart' as news;
import 'package:project_app/feature/main/admin_panel/admin_panel_dashboard/admin_panel_dashboard.dart' as dashboard;
void main() {
  runApp(const AdminMessageApp());
}

class AdminMessageApp extends StatelessWidget {
  const AdminMessageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const AdminMessagePage(),
    );
  }
}

class AdminMessagePage extends StatefulWidget {
  const AdminMessagePage({super.key});

  @override
  _AdminMessagePageState createState() => _AdminMessagePageState();
}

class _AdminMessagePageState extends State<AdminMessagePage> {
  final List<Map<String, String>> messages = [
    {"name": "John Doe", "time": "10:30 AM", "message": "Hello, I need help!"},
    {"name": "Alice Brown", "time": "11:15 AM", "message": "How do I update my flood data?"},
    {"name": "Michael Lee", "time": "12:00 PM", "message": "Can you check the new alerts?"},
    {"name": "Sarah Connor", "time": "12:45 PM", "message": "The system seems slow today."},
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1D26),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1D26),
        elevation: 0,
        title: const Text(
          "Received Messages",
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildMessageList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFBD784),
        onPressed: () {
          // Future functionality for refreshing or adding new messages
        },
        child: const Icon(Icons.refresh, color: Colors.black),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search messages...",
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (query) {
          setState(() {
            searchQuery = query.toLowerCase();
          });
        },
      ),
    );
  }

  Widget _buildMessageList() {
    final filteredMessages = messages
        .where((msg) =>
            msg["name"]!.toLowerCase().contains(searchQuery) ||
            msg["message"]!.toLowerCase().contains(searchQuery))
        .toList();

    if (filteredMessages.isEmpty) {
      return const Center(
        child: Text("No messages found.", style: TextStyle(color: Colors.white70, fontSize: 16)),
      );
    }

    return ListView.builder(
      itemCount: filteredMessages.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final msg = filteredMessages[index];
        return _buildMessageCard(msg["name"]!, msg["time"]!, msg["message"]!);
      },
    );
  }

  Widget _buildMessageCard(String name, String time, String message) {
    return Card(
      color: Colors.white10,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFFBD784),
          child: Icon(Icons.person, color: Colors.black),
        ),
        title: Text(
          name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          message,
          style: const TextStyle(color: Colors.white70),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          time,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0B1D26),
      selectedItemColor: const Color(0xFFFBD784),
      unselectedItemColor: Colors.white70,
      currentIndex: 2,
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const news.AddNewsPage()),
          );
        } 
        if (index == 0){
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const dashboard.AdminDashboardApp()));
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: "Add news"),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
      ],
    );
  }
}
