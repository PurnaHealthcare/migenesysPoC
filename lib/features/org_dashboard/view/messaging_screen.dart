import 'package:flutter/material.dart';
import 'package:migenesys_poc/features/dashboard/view/dashboard_screen.dart';

class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Messages'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Patients'),
              Tab(text: 'Providers'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMessageList(context, isPatient: true),
            _buildMessageList(context, isPatient: false),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(BuildContext context, {required bool isPatient}) {
    final messages = isPatient
        ? [
            {'name': 'James T. Kirk', 'msg': 'Thanks for the update, Doc!', 'time': '10:30 AM', 'unread': true},
            {'name': 'Sarah Connor', 'msg': 'When should I take the Plavix?', 'time': 'Yesterday', 'unread': false},
          ]
        : [
            {'name': 'Dr. McCoy', 'msg': 'Patient vitals look stable.', 'time': '9:00 AM', 'unread': true},
            {'name': 'Nurse Chapel', 'msg': 'Labs are ready for review.', 'time': 'Yesterday', 'unread': false},
          ];

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final item = messages[index];
        return ListTile(
          leading: CircleAvatar(child: Text((item['name'] as String)[0])),
          title: Text(item['name'] as String, style: TextStyle(fontWeight: (item['unread'] as bool) ? FontWeight.bold : FontWeight.normal)),
          subtitle: Text(item['msg'] as String),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item['time'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              if (item['unread'] as bool)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                ),
            ],
          ),
          onTap: () {
            // Navigate to Chat or Patient Profile
             _showMessageActionSheet(context, item['name'] as String, isPatient);
          },
        );
      },
    );
  }

  void _showMessageActionSheet(BuildContext context, String name, bool isPatient) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Actions for $name', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Open Chat'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(name: name)));
              },
            ),
            if (isPatient)
              ListTile(
                leading: const Icon(Icons.medical_services),
                title: const Text('View Patient Portal (Edit Mode)'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Accessing Patient Portal (Edit Mode)...')));
                },
              ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final String name;
  const ChatScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with $name')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildBubble('Hello, I have a question about my results.', false),
                _buildBubble('Sure, what would you like to know?', true),
                _buildBubble('Are my cholesterol levels ok?', false),
              ],
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        children: [
          const Expanded(child: TextField(decoration: InputDecoration(hintText: 'Type a message...'))),
          IconButton(icon: const Icon(Icons.send), onPressed: () {}),
        ],
      ),
    );
  }
}
