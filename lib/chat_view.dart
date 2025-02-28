import 'package:deepseek_client/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: TextButton(
          onPressed: () {
            ChatViewModel chatViewModel = context.read<ChatViewModel>();
            chatViewModel.requestChat("你是谁");
          },
          child: const Text('Chat'),
        ),
      ),
    );
  }
}