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

  bool _createNewSession = false;

  @override
  void initState() {
    super.initState();
    print("init current id: ${widget.sessionId}");
    ChatViewModel chatViewModel = context.read<ChatViewModel>();
    chatViewModel.updateSession(widget.sessionId);
  }

  @override
  void didUpdateWidget(covariant ChatView oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget current id: ${widget.sessionId}");

    ChatViewModel chatViewModel = context.read<ChatViewModel>();
    if (_createNewSession) {
      chatViewModel.saveNewSessionMessages(widget.sessionId);
      _createNewSession = false;
    } else {
      chatViewModel.updateSession(widget.sessionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("current id: ${widget.sessionId}");
    ChatViewModel chatViewModel = context.watch<ChatViewModel>();
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatViewModel.messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(chatViewModel.messages[index].content),
                  subtitle: Text(chatViewModel.messages[index].reasoningContent),
                );
              },
            )
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: '输入你的问题',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                _sendMessage(value);
              },
            ),
          )
        ],
      ),
    );
  }

  _sendMessage(String message) {
    ChatViewModel chatViewModel = context.read<ChatViewModel>();
    chatViewModel.addMessage("你好");
    if (widget.sessionId == 0) {
      _createNewSession = true;
      SessionViewModel sessionViewModel = context.read<SessionViewModel>();
      sessionViewModel.createNewSession("你好");
    }
  }

}