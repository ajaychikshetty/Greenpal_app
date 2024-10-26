import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/models/chatbot_model.dart';
import '../core/utils/app_colors.dart';
import '../core/utils/app_contants.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final Dio dio = Dio();
  final TextEditingController textEditingController = TextEditingController();

  String? id_;
  String? _userImage;
  List<ChatMessageModel> messages = [];
  bool generating = false;

  // Speech recognition and text-to-speech
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    getSession();
    _initializeTTS();
  }

  Future<void> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id_ = prefs.getString("userId") ?? "";
      _userImage = prefs.getString("image") ?? "";
    });
  }

  Future<void> _initializeTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
  }

  Future<void> sendMessage(String inputMessage) async {
    // Add user's message to the messages list
    setState(() {
      messages.add(ChatMessageModel(
          role: "user", parts: [ChatPartModel(text: inputMessage)]));
      generating = true;
    });

    // Call the FastAPI service
    try {
      String generatedText = await chatTextGenerationRepo(inputMessage);

      // Add the generated response to the messages list
      if (generatedText.isNotEmpty) {
        setState(() {
          messages.add(ChatMessageModel(
              role: 'model', parts: [ChatPartModel(text: generatedText)]));
        });
        // Speak the generated response
        await _flutterTts.speak(generatedText);
      } else {
        // Handle error case
        setState(() {
          messages.add(ChatMessageModel(
              role: 'model',
              parts: [ChatPartModel(text: 'Sorry, I couldn\'t generate a response.')]));
        });
      }
    } catch (e) {
      log('Error in sendMessage: ${e.toString()}');
      setState(() {
        messages.add(ChatMessageModel(
            role: 'model',
            parts: [ChatPartModel(text: 'An error occurred while trying to respond.')]));
      });
    } finally {
      setState(() {
        generating = false;
        textEditingController.clear(); // Clear input after sending
      });
    }
  }

  Future<String> chatTextGenerationRepo(String inputMessage) async {
    try {
      final response = await dio.post(
        "http://10.1.213.184:8000/generate/", // Your FastAPI endpoint
        data: {
          "prompt": inputMessage,
        },
      );

      // Check for a successful response
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data['response'] ?? 'Sorry, I didn\'t understand that.';
      }

      // Log unexpected response status
      log('Unexpected response status: ${response.statusCode}');
      return 'There was an issue processing your request. Please try again.';
    } catch (e) {
      // Log any errors that occur during the request
      log('Error in chatTextGenerationRepo: ${e.toString()}');
      return 'An error occurred while trying to respond. Please try again later.';
    }
  }

  void _listen() async {
    if (_isListening) {
      setState(() {
        _isListening = false;
      });
      await _speechToText.stop();
    } else {
      setState(() {
        _isListening = true;
      });

      bool available = await _speechToText.initialize();
      if (available) {
        _speechToText.listen(onResult: (result) {
          setState(() {
            textEditingController.text = result.recognizedWords;
            if (result.hasConfidenceRating && result.confidence > 0) {
              sendMessage(result.recognizedWords);
              _isListening = false; // Stop listening after getting input
            }
          });
        });
      } else {
        setState(() {
          _isListening = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "WasteBot",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _userImage != null && _userImage!.isNotEmpty
                ? CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: ClipOval(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: _userImage == "null" || _userImage!.isEmpty
                            ? Image.asset(
                                "assets/images/villager.png",
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                "${AppConstants.IP}/userImages/$_userImage",
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        width: double.maxFinite,
        height: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 12,
                      left: 16,
                      right: 16,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: messages[index].role == "user"
                          ? Theme.of(context).brightness == Brightness.dark
                              ? TColors.white
                              : TColors.primaryYellow.withOpacity(.7)
                          : Theme.of(context).brightness == Brightness.dark
                              ? TColors.accentGreen
                              : TColors.primaryGreen.withOpacity(.6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          messages[index].role == "user"
                              ? "User"
                              : "Waste Bot",
                          style: TextStyle(
                            fontSize: 14,
                            color: messages[index].role == "user"
                                ? TColors.info
                                : TColors.error,
                          ),
                        ),
                        const Divider(
                          color: TColors.darkerGrey,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          messages[index].parts.first.text,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  height: 1.2, color: TColors.black),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (generating)
              Row(
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Lottie.asset('assets/loader.json'),
                  ),
                ],
              ),
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 30, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      style: const TextStyle(color: Colors.black),
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: "Ask Something From WasteBot",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      if (textEditingController.text.isNotEmpty) {
                        sendMessage(textEditingController.text);
                      }
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Center(
                          child: Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: _listen,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Center(
                          child: Icon(Icons.mic, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
