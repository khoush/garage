import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:msgarage/screens/conversation.dart';
import 'package:msgarage/screens/navbar.chat.dart';

class ClientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();

  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  void _sendMessage({String? imageUrl}) async {
    String text = _messageController.text.trim();

    if (text.isNotEmpty || imageUrl != null) {
      await _firestore.collection('messages').add({
        'text': text,
        'sender': _user!.email,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    }
  }

  void _pickImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      _sendMessage(imageUrl: pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF002E7F),
        title: Text(
          'Kamel abid',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
          color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StatPage()));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.chat,
            color: Colors.white,
            ),
           onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ConversationScreen()));
          },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            
            child: StreamBuilder<QuerySnapshot>(
  stream: _firestore.collection('messages')
    .where('sender', isEqualTo: _user!.email)
    .orderBy('timestamp', descending: true)
    .snapshots(),

  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    var messages = snapshot.data!.docs.reversed;

    List<Widget> messageWidgets = [];
    for (var message in messages) {
      var messageText = message['text'];
      var messageSender = message['sender'];
      var imageUrl = message['imageUrl'];

      var messageWidget = MessageWidget(messageSender, messageText, imageUrl);
      messageWidgets.add(messageWidget);
    }

    return ListView(
      reverse: true,
      children: messageWidgets,
    );
  },
),

          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.camera,
                  color: Color(0xFF002E7F),),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send,
                  color: Color(0xFF002E7F),),
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String sender;
  final String text;
  final String? imageUrl;

  MessageWidget(this.sender, this.text, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          if (imageUrl != null && imageUrl!.isNotEmpty)
            _isNetworkImage(imageUrl!)
                ? Image.network(
                    imageUrl!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(imageUrl!),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )
          else if (text.isNotEmpty)
            Text(text),
        ],
      ),
    );
  }

  bool _isNetworkImage(String path) {
    return path.startsWith('http') || path.startsWith('https');
  }
}
