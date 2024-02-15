import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:msgarage/screens/ajoutpage.dart';
import 'package:msgarage/screens/avancement.dart';
import 'package:msgarage/screens/client.dart';
import 'package:msgarage/screens/devis.dart';
import 'package:msgarage/screens/rendez_vous.dart';


class Acceuil extends StatefulWidget {
  const Acceuil({Key? key});

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF002E7F),
        title: Text(
          'Acceuil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Add your logic to handle the menu icon click here
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Add your logic to handle the notification icon click here
            },
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('vehicules').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<Map<String, dynamic>> vehiclesData = snapshot.data!.docs
              .map((DocumentSnapshot document) {
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
              for (var vehicleData in vehiclesData)
                Card(
                  elevation: 1,
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(vehicleData['imageUrl'] ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 7),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Véhicule: ${vehicleData['num']}',
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
                              '${vehicleData['Etat']}',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Entrée n: ${vehicleData['num']}',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  " Date d'entrée: ${vehicleData['date']}",
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Detailspage()),
                  );
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCard(context, "  Ajouter \nun véhicule", Colors.white),
                        _buildCardd(context, "  Tarifs  \net  devis     ", Colors.white),
                       
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 150,),
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
                          builder: (BuildContext context) => ClientPage(),
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
}

Widget _buildCard(BuildContext context, String title, Color color) {
  return GestureDetector(
    onTap: () {
      // Navigation vers une autre page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AnotherPage(title)),
      );
    },
    child: Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          title,
          style: TextStyle(color: Colors.grey[400], fontSize: 18.0),
        ),
      ),
    ),
  );
}
Widget _buildCardd(BuildContext context, String title, Color color) {
  return GestureDetector(
    onTap: () {
      // Navigation vers une autre page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AjoutPage(title)),
      );
    },
    child: Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          title,
          style: TextStyle(color: Colors.grey[400], fontSize: 18.0),
        ),
      ),
    ),
  );
}
