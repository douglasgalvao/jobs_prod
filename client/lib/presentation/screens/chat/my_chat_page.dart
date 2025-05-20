import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:my_jobs/infrastructure/chat/pusher_service.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyChatPage extends StatefulWidget {
  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  final List<types.Message> _messages = [];

  final types.User _currentUser = types.User(id: '1');

  @override
  void initState() {
    super.initState();
    _loadMessagesFromBackend();
    final pusherService = PusherService();
    pusherService.initPusher("1", "1");
  }

  void _loadMessagesFromBackend() async {
    // Suponha que essas mensagens vieram do backend

    final response = await http
        .get(Uri.parse('http://72.14.201.238:8000/chat-sessions/1/history'));
    if (response.statusCode == 200) {
      final List<dynamic> messagesFromBackend = json.decode(response.body);
      final converted = messagesFromBackend.map((msg) {
        return types.TextMessage(
          id: msg['id'] as String,
          author: types.User(id: msg['sender_id'] as String),
          createdAt: msg['timestamp'] as int,
          text: msg['text'] as String,
        );
      }).toList();

      print(converted);


      setState(() {
        _messages.insertAll(0, converted);
      });
      return;
    }
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      id: const Uuid().v4(), // gera um id único
      author: _currentUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      text: message.text,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });

    // Aqui você pode enviar para o backend via POST ou WebSocket
  }

  @override
  Widget build(BuildContext context) {
    return Chat(
      messages: _messages,
      onSendPressed: _handleSendPressed,
      user: _currentUser,
    );
  }
}
