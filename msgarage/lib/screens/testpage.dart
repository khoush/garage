
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:msgarage/screens/loginpage.dart';



class Acceuill extends StatefulWidget {
  const Acceuill({Key? key}) : super(key: key);

  @override
  State<Acceuill> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuill> {

  
 
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
        leading: IconButton(
          icon: Icon(
            Icons.account_circle, // Choisissez l'icône appropriée pour la connexion
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
          },
        ),
       
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
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
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



class NouvellePage extends StatelessWidget {
  final String imagePath;
  final CarInfo carInfo;

  NouvellePage({required this.imagePath, required this.carInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Vehicules neufs',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      
      ),
      body: Column(
        
        children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Positioned(
              right: 160,
              bottom: 10,
              child: Icon(
               Icons.linear_scale, 
               color: Colors.black, 
               size: 55, // Augmenter la taille de l'icône
             ),
                       ),
           ),
           SizedBox(height: 1,),
           Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(
            imagePath,
            width: 250,
            height: 150,
          ),
        ),
          
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Positioned(
              right: 160,
              bottom: 10,
              child: Icon(
               Icons.linear_scale, 
               color: Colors.black, 
               size: 55, // Augmenter la taille de l'icône
             ),
                       ),
           ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                _buildInfoCard(
                  label: 'GT-Line Standard\n      Range:',
                  value: '${carInfo.rr}',
                ),
                _buildInfoCard(
                  label: 'GT-Line Long\n      Range:',
                  value: '${carInfo.power}',
                ),
                _buildInfoCard(
                  label: 'GT-Line Dual\npower 4WD:',
                  value: '${carInfo.energy}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildInfoCard({required String label, required String value}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(Icons.remove_red_eye, color: Colors.black), // Ajout de l'icône "eye"
            SizedBox(width: 50), // Espace entre l'icône et la valeur
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
