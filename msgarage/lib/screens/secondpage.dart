import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:msgarage/screens/client.dart';
import 'package:msgarage/screens/rendez_vous.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<String> mat = [];
  String selectedMat = ''; // Initialisez avec une valeur par défaut
  double sliderValue1 = 0.0;
  double sliderValue2 = 0.0;
  double sliderValue3 = 0.0;
  double sliderValue4 = 0.0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchImmatriculations();
  }

  Future<void> _fetchImmatriculations() async {
    try {
      // Récupérer la collection 'véhicules' depuis Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('vehicules').get();

      // Parcourir les documents de la collection
      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
        // Extraire l'immatriculation du document
        String immatriculation = doc.get('num');
        String etat = doc.get('Etat');

        // Ajouter l'immatriculation à la liste
        setState(() {
          mat.add(immatriculation);
          if (mat.isNotEmpty) {
            // Si la liste n'est pas vide, initialiser selectedMat avec la première valeur
            selectedMat = mat.first;
          }

          // Mettre à jour les sliders en fonction de l'état
          if (etat == 'Reception') {
            sliderValue1 = 0.0;
          } else if (etat == 'Devis') {
            sliderValue1 = 50.0;
          } else if (etat == 'Validation') {
            sliderValue1 = 100.0;
          }
          if (etat == 'Achat') {
            sliderValue2 = 0.0;
          } else if (etat == 'En attente des pieces') {
            sliderValue2 = 50.0;
          } else if (etat == 'Carrosserie et dressage') {
            sliderValue2 = 100.0;
          }
          if (etat == 'Preparation et peinture') {
            sliderValue3 = 0.0;
          } else if (etat == 'Montage') {
            sliderValue3 = 50.0;
          } else if (etat == 'Lustrage et finition') {
            sliderValue3 = 100.0;
          }
          if (etat == 'Lavage/Livraison') {
            sliderValue4 = 0.0;
          } else if (etat == '') {
            sliderValue4 = 100.0;
          }
        });
      });

    } catch (e) {
      print('Erreur lors de la récupération des immatriculations : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF002E7F),
        title: Text(
          'Avancement',
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
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Dropdown Field
            DropdownButtonFormField<String>(
              value: selectedMat,
              onChanged: (String? newValue) {
                setState(() {
                  selectedMat = newValue!;
                });
              },
              items: mat.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Immatriculation',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color(0xFF002E7F),
                  ),
                  child: Text(
                    '$selectedMat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 40.0),

            // Slider 1
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Reception',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('Devis',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('Validation',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                Slider(
                  value: sliderValue1,
                  onChanged: (value) {
                    setState(() {
                      sliderValue1 = value;
                    });
                  },
                  min: 0.0,
                  max: 100.0,
                  divisions: 100,
                  label: '$sliderValue1',
                  activeColor: Colors.green,
                  inactiveColor: Colors.grey,
                  onChangeEnd: (double value) {
                    // Add any specific actions when the slider interaction ends
                  },
                ),
              ],
            ),
            SizedBox(height: 20.0),

            // Slider 2
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Achat',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('En attente \n des pieces ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('Carrosserie\n et dressage',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                Slider(
                  value: sliderValue2,
                  onChanged: (value) {
                    setState(() {
                      sliderValue2 = value;
                    });
                  },
                  min: 0.0,
                  max: 100.0,
                  divisions: 100,
                  label: '$sliderValue2',
                  activeColor: Colors.green,
                  inactiveColor: Colors.grey,
                ),
              ],
            ),
            SizedBox(height: 20.0),

            // Slider 3
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Preparation \n et peinture',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('Montage',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('Lustrage \net finition',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                Slider(
                  value: sliderValue3,
                  onChanged: (value) {
                    setState(() {
                      sliderValue3 = value;
                    });
                  },
                  min: 0.0,
                  max: 100.0,
                  divisions: 100,
                  label: '$sliderValue3',
                  activeColor: Colors.green,
                  inactiveColor: Colors.grey,
                ),
              ],
            ),
            SizedBox(height: 20.0),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Lavage/Livraison',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(''),
                    Text(''),
                  ],
                ),
                Stack(
                  children: [
                    Slider(
                      value: sliderValue4,
                      onChanged: (value) {
                        setState(() {
                          sliderValue4 = value;
                        });
                      },
                      min: 0.0,
                      max: 100.0,
                      divisions: 100,
                      label: '$sliderValue4',
                      activeColor: Colors.green,
                      inactiveColor: Colors.grey,
                    ),
                    if (sliderValue4 == 100.0)
                      Positioned(
                        right: 8.0, // Adjust the position as needed
                        top: -5.0, // Adjust the position as needed
                        child: Icon(
                          Icons.directions_car,
                          color: Color(0xFF002E7F),
                          size: 30.0,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
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
                        vertical: 20, horizontal: 25),
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
                const SizedBox(width: 10),
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
        ),
      ),
    );
  }
}
