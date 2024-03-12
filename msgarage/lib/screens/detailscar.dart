import 'package:flutter/material.dart';
import 'package:msgarage/screens/first.dart';
import 'package:msgarage/screens/navbar.chat.dart';

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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => StatPage()));
          },
        ),
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
