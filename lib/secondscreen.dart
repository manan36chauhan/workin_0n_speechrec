import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/cupertino.dart';

class SecondScreen extends StatefulWidget {
  final String text;

  SecondScreen({required this.text});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String _spokenText = "";
  String _targetText = "Your predefined text to compare";
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  final TextEditingController _controller = TextEditingController();
  bool _isListening = false;

  bool _isMicOn = false;

  void _toggleMic() {
  
    setState(() {
      _isMicOn = !_isMicOn;
    });
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _startListening();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    print("898989898989898989");
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _spokenText = _lastWords;
    });
  }

  List<TextSpan> _highlightText(String text, String spokenText) {
    List<TextSpan> spans = [];
    for (int i = 0; i < text.length; i++) {
      if (i < spokenText.length && text[i] == spokenText[i]) {
        spans.add(TextSpan(
          text: text[i],
          style: const TextStyle(
              color: Colors.black, backgroundColor: Colors.white),
        ));
      } else {
        spans.add(TextSpan(
          text: text[i],
          style: const TextStyle(color: Colors.white),
        ));
      }
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.white),
                              children:
                                  _highlightText(widget.text, _spokenText),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.5),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          minimumSize: const Size(180, 60),
                        ),
                        onPressed: () {
                          _isListening ? _stopListening() : _startListening();
                          _toggleMic();
                        },
                        child: Icon(
                          _isMicOn ? Icons.mic : Icons.mic_off,
                          color: _isMicOn ? Colors.red : Colors.black,
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
