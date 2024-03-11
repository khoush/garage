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
              children: articles.map((article) {
                return ArticleWidget(article: article);
              }).toList(),
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
              items: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Image.asset(
                    'assets/images/evv.jpg', // Ajoutez le chemin de votre image
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Image.asset(
                    'assets/images/evvv.jpg', // Ajoutez le chemin de votre image
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Image.asset(
                    'assets/images/ev.jpg', // Ajoutez le chemin de votre image
                    fit: BoxFit.cover,
                  ),
                ),
              ],
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

class ArticleWidget extends StatelessWidget {
  final Article article;

  ArticleWidget({required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                article.image,
                width: 150,
                height: 150,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Colors.black.withOpacity(0.5),
                ),
                padding: EdgeInsets.all(8.0),
                child: Text(
                  article.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          article.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            article.description,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ),
        onTap: () {
          // Ajoutez la fonctionnalité lorsque l'article est cliqué
        },
      ),
    );
  }
}

class Article {
  final String title;
  final String description;
  final String image;

  Article(
      {required this.title, required this.description, required this.image});
}

List<Article> articles = [
  Article(
    title: "AutoRepar",
    description:
        "Dans le but de renforcer sa présence et sahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh  ",
    image: "assets/images/ha.jpg",
  ),
  // Ajoutez d'autres articles si nécessaire
];
