import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var textSpeech = "CLICK ON MIC TO SPEECH";
  SpeechToText speechToText = SpeechToText();
  var isListening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  if (!isListening) {
                    bool micAvailable =
                        await speechToText.initialize(onError: (error) {
                      if (kDebugMode) {
                        print("Error: $error");
                      }
                      setState(() {
                        isListening = false;
                      });
                    });

                    if (micAvailable) {
                      setState(() {
                        isListening = true;
                      });

                      speechToText.listen(
                          listenFor: const Duration(seconds: 20),
                          onResult: (result) => setState(() {
                                textSpeech = result.recognizedWords;
                                isListening = false;
                              }),
                          localeId: 'ta_IN');
                    } else {
                      if (kDebugMode) {
                        print("Microphone not available");
                      }
                    }
                  } else {
                    setState(() {
                      isListening = false;
                      speechToText.stop();
                    });
                  }
                },
                child: CircleAvatar(
                  child: isListening
                      ? const Icon(Icons.record_voice_over)
                      : const Icon(Icons.mic),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child:
                    Container(color: Colors.white54, child: Text(textSpeech)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
