import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';



class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AdminChatScreen(),
    );
  }
}

class AdminChatScreen extends StatefulWidget {
  @override
  _AdminChatScreenState createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  final TextEditingController _messageController = TextEditingController();
    final ImagePicker _imagePicker = ImagePicker();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User _adminUser;
  late String _selectedUserId;
void _pickImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      _sendMessage(imageUrl: pickedFile.path);
    }
  }
   void _sendMessage({String? imageUrl}) async {
    String text = _messageController.text.trim();

    if (text.isNotEmpty || imageUrl != null) {
      await _firestore.collection('messages').add({
        'text': text,
        
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    }
  }
  @override
  void initState() {
    super.initState();
    _adminUser = _auth.currentUser!;
    _selectedUserId = "9vft2CVTjGeA2IWNWv6PlFUQayH3"; // Initialiser avec l'ID de l'utilisateur sélectionné
  }

  void _sendMessageToUser() async {
    String text = _messageController.text.trim();

    if (_selectedUserId.isNotEmpty && text.isNotEmpty) {
      await _firestore
          .collection('admin_messages')
          .doc(_selectedUserId)
          .collection('messages')
          .add({
        'text': text,
        'sender': 'admin',
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Chat'),
      ),
      body: Column(
        children: <Widget>[
          // Liste des utilisateurs
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              var users = snapshot.data!.docs;
              List<DropdownMenuItem<String>> userDropdownItems = [];

              for (var user in users) {
                var userId = user.id;
                var userName = user['nom'];

                var dropdownItem =
                    DropdownMenuItem<String>(child: Text(userName), value: userId);

                userDropdownItems.add(dropdownItem);
              }

              return DropdownButton<String>(
                value: _selectedUserId,
                items: userDropdownItems,
                onChanged: (value) {
                  setState(() {
                    _selectedUserId = value!;
                  });
                },
              );
            },
          ),
          // Liste des messages de l'utilisateur sélectionné
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('admin_messages')
                  .doc(_selectedUserId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];

                for (var message in messages) {
                  var messageText = message['text'];
                  var messageSender = message['sender'];
                  var imageUrl = message['imageUrl'];


                  var messageWidget =
                      MessageWidget(messageSender, messageText, null);
                  messageWidgets.add(messageWidget);
                }

                return ListView(
                  reverse: true,
                  children: messageWidgets,
                );
              },
            ),
          ),
          // Zone de saisie de message
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
