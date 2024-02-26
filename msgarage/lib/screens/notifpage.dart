import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:msgarage/screens/navbar.chat.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF002E7F),
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
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('vehicules')
            .where('client_id',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          List<Map<String, dynamic>> vehiclesData =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            return document.data() as Map<String, dynamic>;
          }).toList();

          return ListView.builder(
            itemCount: vehiclesData.length,
            itemBuilder: (context, index) {
              String? dateString = vehiclesData[index]['date'];

              if (dateString == null) {
                // Gérer le cas où la date est nulle
                return Card(
                  elevation: 1,
                  child: ListTile(
                    title: Text("Véhicule sans date"),
                  ),
                );
              }

              DateTime date = DateFormat('dd/MM/yyyy').parse(dateString);

              // Vérifier que la date est valide
              if (date == null) {
                // Gérer le cas où la conversion de la chaîne en DateTime échoue
                return Card(
                  elevation: 1,
                  child: ListTile(
                    title: Text("Date invalide pour ce véhicule"),
                  ),
                );
              }

              int joursDifference = DateTime.now().difference(date).inDays;

              return Card(
                elevation: 1,
                child: ListTile(
                  leading: Icon(
                    Icons.notifications_active,
                    color: Colors.red,
                  ),
                  title: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: "il y a $joursDifference jour(s) \n",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        
                        TextSpan(
                          text: 'Véhicule ',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: vehiclesData[index]['matricule'],
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: " est dans l'etat ",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: vehiclesData[index]['Etat'],
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        
                      ],
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
}
