// conversation_screen.dart

import 'package:flutter/material.dart';
import 'package:msgarage/screens/client.dart';
import 'package:msgarage/screens/navbar.chat.dart';

class ConversationScreen extends StatefulWidget {
  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF002E7F),
        title: Center(
          child: Text(
            'Messagerie',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
          color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ClientPage()));
          },
        ),
       
      ),
      body: Center(
        child: Text('List of conversations goes here.'),
      ),
    );
  }
}
