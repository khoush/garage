import 'package:flutter/material.dart';
import 'package:msgarage/screens/navbar.chat.dart';
import 'package:url_launcher/url_launcher.dart';

class AssistancePage extends StatefulWidget {

  @override
  State<AssistancePage> createState() => _AssistancePageState();
}

class _AssistancePageState extends State<AssistancePage> {
  // Méthode pour lancer l'appel téléphonique
  void _launchPhoneCall() async {
    const phoneNumber = 'tel:+21693709028'; 
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Impossible de lancer l\'appel';
    }
  }
  void _launchPhoneCalll() async {
    const phoneNumber = 'tel:+21693709022'; 
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Impossible de lancer l\'appel';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Assistance technique',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StatPage()));
          },
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ajouter l'image au-dessus du texte
              Image.asset(
                'assets/images/ass.png', // Remplacez par le chemin de votre image
                height: 150, // Ajustez la hauteur selon vos besoins
              ),

              SizedBox(height: 20), // Espace entre l'image et le texte

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text("Votre assistance sera traitée par téléphone", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text(" Nous sommes à votre disposition pour\ntoute aide dont vous pourriez avoir besoin", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13))),
                ],
              ),
              
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StatPage()));
                    },
                    child: Text('Retour', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: _launchPhoneCall, // Bouton "Appeler directement"
                    child: Text('Appeler directement', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              Image.asset(
                'assets/images/remo.png', // Remplacez par le chemin de votre image
                height: 150, // Ajustez la hauteur selon vos besoins
              ),
              SizedBox(height: 20), // Espace entre l'image et le texte
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text("    Faire appel à un service de remorquage\npour déplacer votre véhicule en panne ou pour\n                     toute autre raison", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13))),
                ],
              ),

              
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StatPage()));
                    },
                    child: Text('Retour', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: _launchPhoneCalll, // Bouton "Appeler directement"
                    child: Text('Appeler directement', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
