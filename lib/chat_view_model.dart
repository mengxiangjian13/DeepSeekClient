import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatViewModel extends ChangeNotifier {
  List<String> messages = [];

  void addMessage(String message) {
    messages.add(message);
    notifyListeners();
  }

  requestChat(String message) async {

    const String deepSeekApiUrl = 'https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions';
    const String deepSeekApiKey = 'sk-d0065a382c10409cad750dd4da8569ea';

    try {
      // 构造请求体
      final Map<String, dynamic> requestBody = {
        'model': 'deepseek-r1', // 模型名称
        'messages': [
          {'role': 'user', 'content': message}, // 用户消息
        ],
        'stream': true, // 启用流式输出
      };

      // 创建 HTTP 请求
      final request = http.Request('POST', Uri.parse(deepSeekApiUrl))
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $deepSeekApiKey', // 添加 API 密钥
        })
        ..body = jsonEncode(requestBody); // 将请求体编码为 JSON

      // 发送请求并获取流式响应
      final streamedResponse = await request.send();

      // 检查响应状态码
      if (streamedResponse.statusCode == 200) {
        // 监听数据流
        await for (var chunk in streamedResponse.stream.transform(utf8.decoder)) {
          // 解析数据块
          final lines = chunk.split('\n');
          for (var line in lines) {
            if (line.trim().isNotEmpty) {
              // 提取有效内容
              if (line.startsWith('data: ')) {
                final jsonString = line.substring(6); // 去掉 'data: ' 前缀
                try {
                  final Map<String, dynamic> data = jsonDecode(jsonString);
                  final String reasoningContent = data['choices'][0]['delta']['reasoning_content'] ?? '';
                  final String content = data['choices'][0]['delta']['content'] ?? '';
                  if (kDebugMode) {
                    print("推理内容: $reasoningContent");
                    print("回答内容: $content");
                  } // 实时输出内容
                } catch (e) {
                  if (kDebugMode) {
                    if (jsonString == "[DONE]") {
                      print('请求完成');
                    } else {
                      print('解析错误: $e');
                    }
                  }
                }
              }
            }
          }
        }
      } else {
        if (kDebugMode) {
          print('请求失败，状态码: ${streamedResponse.statusCode}，错误信息: ${streamedResponse.reasonPhrase}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('发生错误: $e');
      }
    }
  }
}