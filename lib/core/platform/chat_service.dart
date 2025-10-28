import 'package:flutter/services.dart';

class ChatService {
  static const platform = MethodChannel('com.example.chat_app/native');

  Future<String> sendMessage(String message) async {
    try {
      final String result = await platform.invokeMethod('sendMessage', {"message": message});
      return result;
    } on PlatformException catch (e) {
      return "Failed: '${e.message}'.";
    }
  }
}
