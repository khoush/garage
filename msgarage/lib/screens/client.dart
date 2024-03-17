import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:msgarage/screens/chat.dart';
import 'package:msgarage/screens/navbar.chat.dart';

class UserListScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messagerie',
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => StatPage()));
          },
        ),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        user: user,
                        currentUser: _auth.currentUser!,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 10.0,
                        backgroundImage: AssetImage('assets/images/cc.png'),
                      ),
                      title: Text(
                        user['username'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                     
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<DateTime?> _getLastMessageTime(String userId) async {
    final querySnapshot = await _firestore
        .collection('messages')
        .doc(userId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final lastMessage = querySnapshot.docs.first;
      return (lastMessage['timestamp'] as Timestamp).toDate();
    }

    return null;
  }

  String _formatLastMessageTime(DateTime? lastMessageTime) {
    if (lastMessageTime == null) {
      return 'Aucun message';
    } else {
      final now = DateTime.now();
      final difference = now.difference(lastMessageTime);
      if (difference.inDays > 0) {
        return '${difference.inDays} jours';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} heures';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minutes';
      } else {
        return 'Quelques secondes';
      }
    }
  }
}
