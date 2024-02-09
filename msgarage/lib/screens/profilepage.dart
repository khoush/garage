import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:msgarage/screens/avancement.dart';
import 'package:msgarage/screens/loginpage.dart';


class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/pro.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                    imageUrl = data['imageUrl'];

                    return Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 100),
                          Center(
                            child: CircleAvatar(
                              radius: 70.0,
                              backgroundImage: AssetImage('assets/images/us.png'),
                            ),
                          ),
                          
                          _buildInfoRow("nom", data['nom'], Icons.person_2),
                          _buildInfoRow("username", data['username'], Icons.person),
                          _buildInfoRow("email", data['email'], Icons.email),
                         
                          
                          GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Se déconnecter',
                    style: TextStyle(
                      color: Color(0xFF002E7F),
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

                                 ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData iconData) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                iconData,
                color: Colors.grey,
                size: 20.0,
              ),
              SizedBox(width: 1.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.0),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
              
            ),
            padding: EdgeInsets.all(10.0),
            width: double.infinity,
            child: Text(
              value,
              style: TextStyle(fontSize: 13.0),
            ),
          ),
        ],
      ),
    );
  }
}