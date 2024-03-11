import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:msgarage/screens/client.dart';
import 'package:msgarage/screens/navbar.chat.dart';
import 'package:msgarage/screens/rendez_vous.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<String> mat = [];
  String selectedMat = ''; // Initialisez avec une valeur par défaut
  double progressValue = 0.0; // Single progress tracker
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late QuerySnapshot<Map<String, dynamic>> snapshot;

  @override
  void initState() {
    super.initState();
    _fetchImmatriculations();
  }

  Future<void> _fetchImmatriculations() async {
    try {
      // Récupérer la collection 'véhicules' depuis Firestore
      snapshot = await _firestore.collection('vehicules').get();

      // Parcourir les documents de la collection
      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
        // Extraire l'immatriculation du document
        String immatriculation = doc.get('matricule');

        // Ajouter l'immatriculation à la liste
        setState(() {
          if (!mat.contains(immatriculation)) {
            // Add only if not already present to avoid duplicates
            mat.add(immatriculation);
          }

          if (mat.isNotEmpty) {
            // Si la liste n'est pas vide, initialiser selectedMat avec la première valeur
            selectedMat = mat.first;
          }
        });

        if (doc.get('matricule') == selectedMat) {
          // Mettre à jour le progress tracker en fonction de l'état
          _updateProgressValue(doc.get('Etat'));
        }
      });
    } catch (e) {
      print('Erreur lors de la récupération des immatriculations : $e');
    }
  }

  void _updateProgressValue(String etat) {
    switch (etat) {
      case 'Reception':
        progressValue = 0.0;
        break;
      case 'Devis':
        progressValue = 10.0;
        break;
      case 'Validation':
        progressValue = 20.0;
        break;
      case 'Achat':
        progressValue = 30.0;
        break;
      case 'En attente des pieces':
        progressValue = 40.0;
        break;
      case 'Carrosserie et dressage':
        progressValue = 50.0;
        break;
      case 'Préparation et peinture':
        progressValue = 60.0;
        break;
      case 'Montage':
        progressValue = 70.0;
        break;
      case 'Lustrage et finition':
        progressValue = 80.0;
        break;
      case 'Lavage/livraison':
        progressValue = 90.0;
        break;
      case 'Terminer':
        progressValue = 100.0;
        break;
      default:
        progressValue = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Avancement',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => StatPage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedMat,
              onChanged: (String? newValue) {
                setState(() {
                  selectedMat = newValue!;
                  // Update progressValue based on the selectedMat
                  _updateProgressValueForSelectedMat();
                });
              },
              items: mat.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Immatriculation',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.black,
                  ),
                  child: Text(
                    '$selectedMat',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
           Container(
  height: MediaQuery.of(context).size.height - 400,
  child: Row(
    children: [
      // Slider
      RotatedBox(
        quarterTurns: 3,
        child: Slider(
          value: progressValue,
          onChanged: null,
          min: 0.0,
          max: 100.0,
          divisions: 100,
          label: '$progressValue',
          activeColor: Colors.green,
          inactiveColor: Colors.grey,
        ),
      ),
      
      // Spacer between Slider and Vertical Text
      

      // Vertical Text
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '-------- Terminer',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              
            ),
          ),
          SizedBox(height: 9,),
          Text(
            '-------- Lavage et livraison',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            
            ),
          ),
          SizedBox(height: 9,),
          Text(
            '-------- Lustrage et finition',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            
            ),
          ),
          SizedBox(height: 10,),
           Text(
            '-------- Montage',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            
            ),
          ),
          SizedBox(height: 9,),
           Text(
            '-------- Preparation et peinture',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            
            ),
          ),
          SizedBox(height: 9,),
           Text(
            '-------- Carrosserie et dressage',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            
            ),
          ),
          SizedBox(height: 9,),
           Text(
            '-------- En attente des pieces',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            
            ),
          ),
          SizedBox(height: 9,),
           Text(
            '-------- Achat',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            
            ),
          ),
          SizedBox(height: 9,),
           Text(
            '-------- Validation',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            
            ),
          ),
          SizedBox(height: 9,),
           Text(
            '-------- Devis',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            
            ),
          ),
          SizedBox(height: 9,),
           Text(
            '-------- Reception',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            
            ),
          ),
        ],
      ),
    ],
  ),
),

            
          
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

  void _updateProgressValueForSelectedMat() {
    for (DocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      if (doc.get('matricule') == selectedMat) {
        _updateProgressValue(doc.get('Etat'));
        break;
      }
    }
  }

  Color _getSliderColor(double value) {
    if (value == 0.0) {
      return Colors.green; // Set initial color when the value is 0
    } else if (value == 100.0) {
      return Colors.green; // Set color when the value is 100
    } else {
      return Colors.green; // Set color for other values as needed
    }
  }
}
