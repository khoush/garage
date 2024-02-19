import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:msgarage/screens/loginpage.dart';

class AdminChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AdminChatScreen(),
    );
  }
}

class AdminChatScreen extends StatefulWidget {
  @override
  State createState() => AdminChatScreenState();
}

class AdminChatScreenState extends State<AdminChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();

  late User _user;
  late List<String> _availableUsers;
Future<void> _handleSignOut() async {
  try {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  } catch (e) {
    print('Erreur lors de la déconnexion : $e');
  }
}


  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _availableUsers = [];
    _getAvailableUsers();
  }

  Future<void> _getAvailableUsers() async {
    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      setState(() {
        _availableUsers = usersSnapshot.docs.map((user) => (user.data() as Map<String, dynamic>)['nom'] as String?)  
          .where((name) => name != null)
          .cast<String>()
          .toList();
      });
    } catch (e) {
      print('Error fetching available users: $e');
    }
  }

  void _sendMessage({String? imageUrl, required String recipient}) async {
    String text = _messageController.text.trim();

    if (text.isNotEmpty || imageUrl != null) {
      await _firestore.collection('all_messages').add({
        'text': text,
        'sender': _user.email,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'recipient': recipient,
        'role':
            'admin', // Assurez-vous que le rôle du destinataire est correctement défini
      });

      _messageController.clear();
    }
  }

  void _pickImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      _sendMessage(imageUrl: pickedFile.path, recipient: _selectedUser);
    }
  }

  String _selectedUser = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF002E7F),
        title: const Text(
          'Admin Chat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.people,
              color: Colors.white,
            ),
            onPressed: () {
              _showAvailableUsersDialog();
            },
          ),
           IconButton(
            icon: const Icon(
              Icons.exit_to_app, // Icône de déconnexion
              color: Colors.white,
            ),
            onPressed: () {
              _handleSignOut(); // Fonction pour gérer la déconnexion
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _selectedUser.isNotEmpty
                ? StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('all_messages')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      var messages = snapshot.data!.docs.reversed;

                      List<Widget> messageWidgets = [];
                      for (var message in messages) {
                        var messageText = message['text'];
                        var messageSender = message['sender'];
                        var imageUrl = message['imageUrl'];

                        var messageWidget =
                            MessageWidget(messageSender, messageText, imageUrl);
                        messageWidgets.add(messageWidget);
                      }

                      return ListView(
                        reverse: true,
                        children: messageWidgets,
                      );
                    },
                  )
                : const Center(
                    child: Text('Select a user to start a conversation.'),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.camera,
                    color: Color(0xFF002E7F),
                  ),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Color(0xFF002E7F),
                  ),
                  onPressed: () {
                    if (_selectedUser.isNotEmpty) {
                      _sendMessage(recipient: _selectedUser);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Please select a user to send a message.'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAvailableUsersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Available Users'),
          content: _availableUsers.isNotEmpty
              ? ListView.builder(
                  itemCount: _availableUsers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_availableUsers[index]),
                      onTap: () {
                        setState(() {
                          _selectedUser = _availableUsers[index];
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  },
                )
              : const Text('No available users.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
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
