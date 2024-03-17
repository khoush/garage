import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:msgarage/screens/navbar.chat.dart';

class ChatScreen extends StatefulWidget {
  final User currentUser;
  final QueryDocumentSnapshot<Object?> user;

  ChatScreen({required this.currentUser, required this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.user['username'], style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => StatPage()));
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(widget.currentUser.uid)
                  .collection(widget.user.id)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(
                        '${message['username']} • ${_formatTimestamp(message['timestamp'])}',
                      ),
                      subtitle: Text(message['text']),
                     
                      leading: CircleAvatar(
                        radius: 10.0,
                        backgroundImage: AssetImage('assets/images/cc.png'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildInputField(),
         
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_camera,color: Colors.red,),
            onPressed: _getImageFromCamera,
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Introduire votre message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send,color: Colors.red,),
            onPressed: () {
        _sendMessage(widget.currentUser.uid, widget.user.id);
        _textController.clear();
      },
          ),
        ],
      ),
    );
  }

 

void _sendMessage(String senderId, String receiverId) async {
  String text = _textController.text.trim();
  if (text.isNotEmpty || _imageFile != null) {
    String? username = widget.currentUser.email; // Utilisateur actuel

    // Upload image if available
    if (_imageFile != null) {
      String imageUrl = await _uploadImage(_imageFile!);
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(senderId)
          .collection(receiverId)
          .add({
        'imageUrl': imageUrl,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'senderId': senderId, // Expéditeur
        'receiverId': receiverId, // Destinataire
        'username': username,
      });

      await FirebaseFirestore.instance
          .collection('messages')
          .doc(receiverId)
          .collection(senderId)
          .add({
        'imageUrl': imageUrl,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'senderId': senderId, // Expéditeur
        'receiverId': receiverId, // Destinataire
        'username': username,
      });
    }
    // Upload text message if available
    if (text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(senderId)
          .collection(receiverId)
          .add({
        'text': text,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'senderId': senderId, // Expéditeur
        'receiverId': receiverId, // Destinataire
        'username': username,
      });

      await FirebaseFirestore.instance
          .collection('messages')
          .doc(receiverId)
          .collection(senderId)
          .add({
        'text': text,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'senderId': senderId, // Expéditeur
        'receiverId': receiverId, // Destinataire
        'username': username,
      });
    }
    setState(() {
      _imageFile = null;
    });
  }
}


  Future<String> _uploadImage(File imageFile) async {
    // Implement your image uploading logic here (e.g., using Firebase Storage)
    return 'image_url_placeholder'; // Placeholder for the image URL
  }

  void _getImageFromGallery() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  setState(() {
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
    }
  });
}

void _getImageFromCamera() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.camera);
  setState(() {
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
    }
  });
}

  String _formatTimestamp(int timestamp) {
    // Convert timestamp to DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    // Format DateTime to your desired format
    return '${dateTime.hour}:${dateTime.minute}';
  }
}
