import 'package:chat_app/core/app_image.dart';
import 'package:chat_app/presentation/pages/chat/chat_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class InputField extends ConsumerStatefulWidget {
  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends ConsumerState<InputField> {
  final TextEditingController _controller = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  Future<void> _startListening() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
        msg: "No internet connection. speech recognition requires Wi-Fi or data.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    try {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (error) {
          setState(() => _isListening = false);
          Fluttertoast.showToast(
            msg: "Speech Error: ${error.errorMsg}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.orangeAccent,
          );
        },
      );

      if (!available) {
        Fluttertoast.showToast(
          msg: "Speech recognition not available on this device",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orangeAccent,
        );
        return;
      }

      setState(() => _isListening = true);

      _speech.listen(
        onResult: (val) {
          setState(() {
            _controller.text = val.recognizedWords;
          });
        },
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error initializing speech recognition: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.redAccent,
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: _isListening ? _stopListening : _startListening,
          icon: _isListening ?  Image.asset(
            AppImages.waveGif,
            height: 28,
            width: 28,
            fit: BoxFit.contain,
          )
              : const Icon(Icons.mic, size: 28),
          color: _isListening ? Colors.red : Colors.black,
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            decoration:  InputDecoration(
              hintText: AppLocalizations.of(context)!.typeMessage,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            final text = _controller.text.trim();
            if (text.isNotEmpty) {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) return;

              ref.read(chatProvider.notifier).sendMessage(
                text,
                user.uid,
                user.email ?? 'Unknown',
              );
              _controller.clear();
            }
          },
          icon: Icon(Icons.send, color: Colors.pinkAccent.shade100,),
        ),
      ],
    );
  }
}
