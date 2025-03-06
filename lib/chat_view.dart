import 'package:deepseek_client/chat_view_model.dart';
import 'package:deepseek_client/session_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatView extends StatefulWidget {

  final int sessionId;

  const ChatView({super.key, required this.sessionId});

  @override
  State<StatefulWidget> createState() {
    return ChatViewState();
  }
}

class ChatViewState extends State<ChatView> {

  @override
  void initState() {
    super.initState();
    print("init current id: ${widget.sessionId}");
  }

  @override
  void didUpdateWidget(covariant ChatView oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget current id: ${widget.sessionId}");
  }

  @override
  Widget build(BuildContext context) {
    print("current id: ${widget.sessionId}");
    return Container(
      child: Center(
        child: TextButton(
          onPressed: () {
            // ChatViewModel chatViewModel = context.read<ChatViewModel>();
            // chatViewModel.requestChat("你是谁");
            SessionViewModel sessionViewModel = context.read<SessionViewModel>();
            sessionViewModel.addSession("你好");
          },
          child: const Text('Chat'),
        ),
      ),
    );
  }

}