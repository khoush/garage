import 'package:flutter/material.dart';
import 'package:msgarage/screens/client.dart';

class ConversationScreen extends StatelessWidget {
  // Simulons une liste de données pour les messages
  final List<Map<String, dynamic>> messages = [
    {'user': 'Kamel abid', 'message': 'Salut !', 'time': '10:00PM'},
    // Ajoutez d'autres messages simulés au besoin
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF002E7F),
        title: Center(
          child: Text(
            'Messages',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ClientPage()));
          },
        ),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          // Extraire les données du message
          final user = messages[index]['user'];
          final message = messages[index]['message'];
          final time = messages[index]['time'];

         return Card(
  margin: EdgeInsets.all(8.0),
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        CircleAvatar(
          // Ajoutez ici l'URL ou le chemin de votre image
          backgroundImage: AssetImage('assets/images/us.png'),
          radius: 30.0, // Ajustez la taille du cercle à votre convenance
        ),
        SizedBox(width: 16.0), // Ajout d'un espace entre l'image et le contenu textuel
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
                  children: [
                    Text(
                      message,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 120), // Ajout d'un espace entre le message et l'heure
                Text(
                  time,
                  style: TextStyle(color: Colors.grey),
                ),
                  ],
                ),
            
          ],
        ),
      ],
    ),
  ),
);

        },
      ),
    );
  }
}
