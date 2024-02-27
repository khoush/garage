import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:msgarage/screens/ajoutpage.dart';
import 'package:msgarage/screens/client.dart';
import 'package:msgarage/screens/devis.dart';
import 'package:msgarage/screens/notifpage.dart';
import 'package:msgarage/screens/remppage.dart';
import 'package:msgarage/screens/rendez_vous.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class Acceuil extends StatefulWidget {
  const Acceuil({Key? key});

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  int initiallyDisplayedVehicles = 2;
  bool notificationsSeen = false;
  late SharedPreferences _prefs;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      // Charger la valeur de notificationSeen depuis les préférences
      notificationsSeen = _prefs.getBool('notificationsSeen') ?? false;
    });
  }

  _updatePreferences() async {
    // Mettre à jour la valeur de notificationSeen dans les préférences
    await _prefs.setBool('notificationsSeen', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF002E7F),
        title: const Text(
          'Acceuil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('vehicules')
                .where('client_id',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return IconButton(
                  icon: Icon(
                    Icons.notification_add,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                );
              }

              if (snapshot.hasError || snapshot.data == null) {
                return IconButton(
                  icon: Icon(
                    Icons.notification_add,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                );
              }

              List<Map<String, dynamic>> vehiclesData =
                  snapshot.data!.docs.map((DocumentSnapshot document) {
                return document.data() as Map<String, dynamic>;
              }).toList();

              // Check if any vehicle has an 'Etat' that requires notification
              bool showNotification = vehiclesData.any((vehicle) =>
                  vehicle['Etat'] == 'Validation' ||
                  vehicle['Etat'] == 'En attentes des pieces' ||
                  vehicle['Etat'] == 'Carrosserie et dressage' ||
                  vehicle['Etat'] == 'Validation' ||
                  vehicle['Etat'] == 'Achat' ||
                  vehicle['Etat'] == 'Preparation et peinture' ||
                  vehicle['Etat'] == 'Lustrage et finition' ||
                  vehicle['Etat'] == 'Reception' ||
                  vehicle['Etat'] == 'Devis' ||
                  vehicle['Etat'] == 'Terminer' ||
                  vehicle['Etat'] == 'Lavage/Livraison');

              return IconButton(
                icon: Icon(
                  Icons.notification_add,
                  color: notificationsSeen ? Colors.white : Colors.red,
                ),
                onPressed: () {
                  _updatePreferences();
                  // Set notificationsSeen to true when the notification icon is pressed.
                  setState(() {
                    notificationsSeen = true;
                  });

                  // Navigate to the notification page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationPage(),
                    ),
                  );
                },
              );
            },
          ),
        ],
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
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<Map<String, dynamic>> vehiclesData =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            return document.data() as Map<String, dynamic>;
          }).toList();

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'AVANCEMENT VEHICULES',
                  style: TextStyle(
                    color: Color(0xFF002E7F),
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              for (var i = 0;
                  i < min(initiallyDisplayedVehicles, vehiclesData.length);
                  i++)
                Card(
                  elevation: 3,
                  child: Container(
                    height: 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(vehiclesData[i]['imageUrl'] ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '     Véhicule: ${vehiclesData[i]['matricule']}',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF002E7F),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '     Etat : ${vehiclesData[i]['Etat']}',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color:
                                    _getColorForEtat(vehiclesData[i]['Etat']),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  '      Entrée n: ${vehiclesData[i]['matricule']}',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  " Date d'entrée: ${vehiclesData[i]['date']}",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    initiallyDisplayedVehicles = vehiclesData.length;
                  });
                },
                child: Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Voir Tout',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildCard(context, "     Ajouter \n un véhicule     ",
                            Colors.white),
                        _buildCardd(
                            context,
                            "       Tarifs    \n     et devis          ",
                            Colors.white),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildCarddd(context, "  Vehicule de\nremplacement",
                            Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => Rendezvous(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 22, horizontal: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xFF002E7F),
                      ),
                      child: const Text(
                        'Prendre un rendez-vous',
                        style: TextStyle(
                          inherit: false,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => ClientChatPage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xFF002E7F),
                      ),
                      child: const Icon(
                        Icons.chat,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AnotherPage(title)),
        );
      },
      child: Card(
        color: Colors.white,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Color(0xFF7A99AC),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardd(BuildContext context, String title, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AjoutPage(title)),
        );
      },
      child: Card(
        color: Colors.white,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Color(0xFF7A99AC),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarddd(BuildContext context, String title, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => remplPage(title)),
        );
      },
      child: Card(
        color: Colors.white,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Color(0xFF7A99AC),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForEtat(String Etat) {
    switch (Etat) {
      case 'Terminer':
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}
