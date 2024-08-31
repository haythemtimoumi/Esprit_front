import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'Messages.dart'; // Assuming MessagesScreen is defined in this file

class Chatbot extends StatefulWidget {
  const Chatbot({Key? key}) : super(key: key);

  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    initializeDialogFlowtter();
    super.initState();
  }

  void initializeDialogFlowtter() async {
    try {
      // Assuming you're initializing DialogFlowtter using a different method
      dialogFlowtter = DialogFlowtter();
    } catch (e) {
      print('Error initializing DialogFlowtter: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chatbot',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red.shade700,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(child: MessagesScreen(messages: messages)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        hintText: "Type your message...",
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage(_controller.text);
                      _controller.clear();
                    },
                    icon: Icon(
                      Icons.send_rounded,
                      color: Colors.red.shade700,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
      return;
    }

    try {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      // Send message to Dialogflow (example implementation)
      DetectIntentResponse response = await dialogFlowtter.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text)),
      );

      setState(() {
        addMessage(response.message!);
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    setState(() {
      messages.add({'message': message, 'isUserMessage': isUserMessage});
    });
  }
}
