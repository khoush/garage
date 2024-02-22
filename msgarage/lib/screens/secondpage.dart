import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:msgarage/screens/acceuil.dart';
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

  late QuerySnapshot<Map<String, dynamic>> snapshot;
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
          mat.add(immatriculation);
          if (mat.isNotEmpty) {
            // Si la liste n'est pas vide, initialiser selectedMat avec la première valeur
            selectedMat = mat.first;
          }
        });
        if (doc.get('matricule') == selectedMat) {
          // Mettre à jour les sliders en fonction de l'état
          if (doc.get('Etat') == 'Reception') {
            sliderValue1 = 0.0;
          } else if (doc.get('Etat') == 'Devis') {
            sliderValue1 = 50.0;
          } else if (doc.get('Etat') == 'Validation') {
            sliderValue1 = 100.0;
          }
          if (doc.get('Etat') == 'Achat') {
            sliderValue2 = 0.0;
          } else if (doc.get('Etat') == 'En attente des pieces') {
            sliderValue2 = 50.0;
          } else if (doc.get('Etat') == 'Carrosserie et dressage') {
            sliderValue2 = 100.0;
          }
          if (doc.get('Etat') == 'Preparation et peinture') {
            sliderValue3 = 0.0;
          } else if (doc.get('Etat') == 'Montage') {
            sliderValue3 = 50.0;
          } else if (doc.get('Etat') == 'Lustrage et finition') {
            sliderValue3 = 100.0;
          }
          if (doc.get('Etat') == 'Lavage/Livraison') {
            sliderValue4 = 0.0;
          } else if (doc.get('Etat') == 'Terminer') {
            sliderValue4 = 100.0;
          }
        }
      });
    } catch (e) {
      print('Erreur lors de la récupération des immatriculations : $e');
    }
  }

  //lazemha to5rej mn function athika 5ater athi enty ta3mlilha fi initianlistion donc howa resultat yod5el beha w ma3awdetch refraich tab9a hiya naffsha!!

  void test() {
    sliderValue1 = 0.0;
    sliderValue2 = 0.0;
    sliderValue3 = 0.0;
    sliderValue4 = 0.0;

    snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
      if (doc.get('matricule') == selectedMat) {
        // Mettreon mtea slider baad test tarjaa le 0 ?eyy bch tab9a ken resultat jdida behy fhemtek yatyk saha ena makhamtesh feha ama najmou mithel naamlouha par exemple moush yarj3ou lel 0 aka l point lekbira heki tetnaha completement w ela tarjaa le 0 khyr ?lmochkla howa slider manetssawerch thama faza bch tna7i beha athika!! aahfhemtek
        if (doc.get('Etat') == 'Reception') {
          sliderValue1 = 0.0;
        } else if (doc.get('Etat') == 'Devis') {
          sliderValue1 = 50.0;
        } else if (doc.get('Etat') == 'Validation') {
          sliderValue1 = 100.0;
        }
        if (doc.get('Etat') == 'Achat') {
          sliderValue2 = 0.0;
        } else if (doc.get('Etat') == 'En attente des pieces') {
          sliderValue2 = 50.0;
        } else if (doc.get('Etat') == 'Carrosserie et dressage') {
          sliderValue2 = 100.0;
        }
        if (doc.get('Etat') == 'Preparation et peinture') {
          sliderValue3 = 0.0;
        } else if (doc.get('Etat') == 'Montage') {
          sliderValue3 = 50.0;
        } else if (doc.get('Etat') == 'Lustrage et finition') {
          sliderValue3 = 100.0;
        }
        if (doc.get('Etat') == 'Lavage/Livraison') {
          sliderValue4 = 0.0;
        } else if (doc.get('Etat') == 'Terminer') {
          sliderValue4 = 100.0;
        }
      }
    });
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF002E7F),
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
          icon: Icon(Icons.arrow_back,
          color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Acceuil()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Dropdown Field
            DropdownButtonFormField<String>(
              value: selectedMat,
              onChanged: (String? newValue) {
                setState(() {
                  selectedMat = newValue!;
                  print(selectedMat); 
                  
                });
                test();
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
                    color: const Color(0xFF002E7F),
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

            const SizedBox(height: 40.0),

            // Slider 1
            Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Reception',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('Devis',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('Validation',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
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
                  activeColor: _getSliderColor(sliderValue1),
                 
                  inactiveColor: Colors.grey,
                  onChangeEnd: (double value) {
                    
                  },
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Slider 2
            Column(
              children: [
                const Row(
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
                 activeColor: _getSliderColor(sliderValue2),
                  inactiveColor: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Slider 3
            Column(
              children: [
                const Row(
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
                  activeColor: _getSliderColor(sliderValue3),
                  inactiveColor: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Lavage/Livraison',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(''),
                    Text('Terminer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12 , color: Colors.white))
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
                     activeColor: _getSliderColor(sliderValue4),
                      inactiveColor: Colors.grey,
                    ),
                    if (sliderValue4 == 100.0)
                      const Positioned(
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
            const SizedBox(height: 10),
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
                      color: const Color(0xFF002E7F),
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
                        builder: (BuildContext context) => ClientChatPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xFF002E7F),
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
Color _getSliderColor(double value) {
  if (value == 0.0) {
    return Colors.grey; // Set initial color when the value is 0
  } else if (value == 100.0) {
    return Colors.green; // Set color when the value is 100
  } else {
    return Colors.blue; // Set color for other values as needed
  }
}