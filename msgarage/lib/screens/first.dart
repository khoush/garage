import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:msgarage/screens/ajoutpage.dart';
import 'package:msgarage/screens/assistance.dart';
import 'package:msgarage/screens/client.dart';
import 'package:msgarage/screens/detailscar.dart';
import 'package:msgarage/screens/devis.dart';
import 'package:msgarage/screens/not.dart';
import 'package:msgarage/screens/remppage.dart';
import 'package:msgarage/screens/rendez_vous.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Acceuil extends StatefulWidget {
  const Acceuil({Key? key}) : super(key: key);

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
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
   final List<CarInfo> carInfos = [
    CarInfo(name: 'EV6', power: '200 000DT', energy: '160 000DT' , rr: '190 980DT '),
    CarInfo(name: 'Kia sportage hybride', power: '200 000DT', energy: '160 000DT' , rr: '190 980DT '),
    CarInfo(name: 'Kia sportage', power: '200 000DT', energy: '160 000DT' , rr: '190 980DT '),
    CarInfo(name: 'Kia seltos', power: '200 000DT', energy: '160 000DT' , rr: '190 980DT '),
    CarInfo(name: 'Kia sorento', power: '200 000DT', energy: '160 000DT' , rr: '190 980DT '),
    CarInfo(name: 'Kia xceed', power: '200 000DT', energy: '160 000DT' , rr: '190 980DT '),
  ];

  final List<String> carouselImages = [
    'assets/images/kias.jpg',
    'assets/images/kia.jpg',
    'assets/images/ev.jpg',
    'assets/images/kiasel.jpg',
    'assets/images/kiaso.jpg',
    'assets/images/kiax.jpg',
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Accueil',
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
              vehiclesData.any((vehicle) =>
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
                      builder: (context) => const NotifiPage(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Bienvenue A Votre Agence Automobile\n                         AutoRepar',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AnotherPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        'AJOUTER UN\n VEHICULE',
                        style: TextStyle(fontSize: 9, color: Colors.white , fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AjoutPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: Text(
                      'TARIFS ET DEVIS',
                      style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => remplPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: Center(
                      child: Center(
                        child: Text(
                          ' VEHICULE DE\nREMPLACEMET',
                          style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AssistancePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  elevation: 3,
                  minimumSize: Size(350, 40),
                  side: BorderSide(color: Colors.red),
                ),
                child: Text(
                  'ASSISTANCE TECHNIQUE',
                  style: TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 5),
            Column(
              
               children: [
        YourCard(
          imagePath: 'assets/images/kiafir.jpg', text: '', subText: '', // Remplacez par le chemin de votre image
          
        ),
        // Ajoutez d'autres éléments à la colonne si nécessaire
      ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Découvrez les nouveautés KIA ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
           CarouselSlider(
              items: carouselImages.map((imagePath) {
                return GestureDetector(
                  onTap: () {
                    int index = carouselImages.indexOf(imagePath);
                    CarInfo carInfo = carInfos[index];
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NouvellePage(carInfo: carInfo, imagePath: imagePath)),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 200.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
            ),
            
           
            SizedBox(height: 20),
          ],
        ),
      ),
      
      floatingActionButton: Row(
        
        children: [
          
          Container(
            
            width: 250, // Set your desired width here
            height: 50,
            child: FloatingActionButton(
              heroTag: "btn1",
              
              onPressed: () {
                Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Rendezvous()),
                      );
              },
              mini: true,
              child: Text(
                "Prendre un rendez-vous",
                style: TextStyle(color: Colors.white),
              ),
              
              backgroundColor: Colors.red,
            ),
          ),
          SizedBox(width: 20,),
           Container(
            width: 60, // Set your desired width here
            height: 50,
            child: FloatingActionButton(
              onPressed: () {
             Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) =>UserListScreen()),
                      );
              },
              mini: true,
              child:  const Icon(
                        Icons.chat,
                        color: Colors.white,
                      ),
              backgroundColor: Colors.black,
            ),
            
          ),
         
        ],
      ),
      
      
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      
      
    );
   
  }
}
class YourCard extends StatelessWidget {
  final String imagePath;
  final String text;
  final String subText;

  YourCard({required this.imagePath, required this.text , required this.subText});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent, // Couleur transparente
      elevation: 0, // Aucune ombre
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white, // Couleur de fond de la carte
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.grey, // Couleur de la bordure
                  width: 2.0, // Largeur de la bordure
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  imagePath,
                  width: 350.0, // Ajustez la largeur de l'image selon vos besoins
                  height: 200.0, // Ajustez la hauteur de l'image selon vos besoins
                  fit: BoxFit.cover, // Ajustez la façon dont l'image est ajustée
                ),
              ),
            ),
           Positioned(
              left: 12.0, // Ajustez la position du texte à gauche
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
             Positioned(
              left: 16.0, // Ajustez la position du sous-texte à gauche
              bottom: 8.0, // Ajustez la position du sous-texte vers le bas
              child: Text(
                subText,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CarInfo {
  final String name;
  final String power;
  final String energy;
  final String rr;

  CarInfo({required this.name, required this.power, required this.energy , required this.rr});
}