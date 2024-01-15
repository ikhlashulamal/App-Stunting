import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  List<String> messages = [];
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Bot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(messages[index]),
                );
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _handleSubmitted(_textController.text);
            },
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String message) async {
    if (message.isNotEmpty) {
      setState(() {
        messages.add('You: $message');
      });

      var apiUrl = 'http://192.168.56.78:5000/mobile_chat';

      try {
        var response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'message': message}),
        );

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          var botResponse = jsonResponse['response'];

          setState(() {
            messages.add('Chat Bot: $botResponse');
          });
        } else {
          print('Request failed with status: ${response.statusCode}.');
          setState(() {
            messages.add(
                'Chat Bot: Sorry, I am not able to respond at the moment.');
          });
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          messages.add(
              'Chat Bot: Sorry, an error occurred while processing your request.');
        });
      }

      _textController.clear();
    }
  }
}
