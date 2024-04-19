import 'dart:io';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class spaceToText extends StatefulWidget {
  const spaceToText({super.key});

  @override
  State<spaceToText> createState() => _spaceToTextState();
}

class _spaceToTextState extends State<spaceToText> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;
  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // Setting background color to teal
        title: Text(
          "Space to text", // Setting the title text
          style: TextStyle(
            fontSize: 20, // Adjusting font size
            fontWeight: FontWeight.bold, // Applying bold font weight
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    _speechToText.isListening ? Colors.blueAccent : Colors.grey,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _speechToText.isListening ? Icons.volume_up : Icons.mic,
                    color:
                        _speechToText.isListening ? Colors.white : Colors.teal,
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      _speechToText.isListening
                          ? "Listening..."
                          : _speechEnabled
                              ? "Tap to the microphone button..."
                              : "Speech not available",
                      style: TextStyle(
                        fontSize: 20,
                        color: _speechToText.isListening
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines:
                          2, // Set maxLines to 2 for two-line text if needed
                      overflow: TextOverflow
                          .ellipsis, // Add ellipsis if text exceeds two lines
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _wordsSpoken,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            )),
            if (_speechToText.isNotListening && _confidenceLevel > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Text(
                  "Confidence : ${(_confidenceLevel * 100).toStringAsFixed(1)}",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        tooltip: 'listen',
        backgroundColor: Colors.red,
        child: Icon(
          _speechToText.isListening ? Icons.mic_off : Icons.mic,
          color: Colors.white,
        ),
      ),
    );
  }
}
