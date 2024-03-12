import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:msgarage/screens/ajoutpage.dart';
import 'package:msgarage/screens/assistance.dart';
import 'package:msgarage/screens/client.dart';
import 'package:msgarage/screens/devis.dart';
import 'package:msgarage/screens/remppage.dart';
import 'package:msgarage/screens/rendez_vous.dart';


class Acceuil extends StatefulWidget {
  const Acceuil({Key? key}) : super(key: key);

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  final List<String> carouselImages = [
    'assets/images/evv.jpg',
    'assets/images/evvv.jpg',
    'assets/images/ev.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Accueil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
                      'TARIFS Et DEVIS',
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
          imagePath: 'assets/images/ha.jpg', // Remplacez par le chemin de votre image
          text: 'UN SERVICE PERSONNALISE\n ET DANS LES NORMES',
          subText:'Autorepar........\n hsgsgtzsuduzi'
        ),
        // Ajoutez d'autres éléments à la colonne si nécessaire
      ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Véhicules Neufs KIA',
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NouvellePage(imagePath: imagePath)),
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
                        MaterialPageRoute(builder: (context) => ClientChatPage()),
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
class NouvellePage extends StatelessWidget {
  final String imagePath;

  NouvellePage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle Page'),
      ),
      body: Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}