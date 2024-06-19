import 'package:flutter/material.dart';

import './components/bottomBar.dart';

class MessagingScreen extends StatefulWidget {
  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class Message {
  final String message;
  final bool isMe;

  Message(this.message, this.isMe);
}

class _MessagingScreenState extends State<MessagingScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<Message> messages = [
    Message("Hello", true),
    Message("Hi", false),
    Message("How are you?", true),
    Message("I'm good, thanks!", false),
  ]; // This would be your actual message data.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("John"),
        actions: [IconButton(icon: const Icon(Icons.phone), onPressed: () {})],
      ),
      bottomNavigationBar: BottomBar(index: 3),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = messages[index].message;
                final bool isMe = messages[index].isMe; // Determine if the message was sent by the current user.
                return _buildMessage(message, isMe);
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessage(String message, bool isMe) {
    final msg = Container(
      margin: isMe
          ? const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Colors.green[400] : Colors.grey[400],
        borderRadius: isMe
            ? const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : const BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message,
            style: TextStyle(
              color: isMe ? Colors.black : Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    return msg;
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.grey[200],
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.photo),
            iconSize: 25.0,
            color: Colors.green[700],
            onPressed: () {
              // Implement image selection
            },
          ),
          Expanded(
            child: TextField(
              controller: _textEditingController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                setState(() {
                  // Update your message data
                });
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Type your message here...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            iconSize: 25.0,
            color: Colors.green[700],
            onPressed: () {
              // Implement sending text message
              setState(() {
                messages.insert(0, Message(_textEditingController.text, true));
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}

