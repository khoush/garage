import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:msgarage/screens/client.dart';
import 'package:msgarage/screens/navbar.chat.dart';
import 'package:msgarage/screens/rendez_vous.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({super.key});

  @override
  State<FourthPage> createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  List<String> mat = [];
  String selectedMat = '';
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
      snapshot = await _firestore.collection('vehicules')
       .where('client_id',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get();

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
      });
    } catch (e) {
      print('Erreur lors de la récupération des immatriculations : $e');
    }
  }

  Future<List<DocumentSnapshot>> getVehicleData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('vehicules').get();

    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> getVehicleDataByMatricule(
      String matricule) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('vehicules')
        .where('matricule', isEqualTo: matricule)
        .get();

    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Historiques',
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
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => StatPage()));
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                value: selectedMat,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMat = newValue!;
                    print(selectedMat); //haw ybadel !!
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
              SizedBox(
                  height: 10.0), // Add some spacing between dropdown and cards
              FutureBuilder<List<DocumentSnapshot>>(
                future: getVehicleDataByMatricule(selectedMat),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<DocumentSnapshot> vehicleList = snapshot.data!;

                    // Example: Displaying data in a ListView
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: vehicleList.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> vehicleData =
                            vehicleList[index].data() as Map<String, dynamic>;

                        // Extracting relevant data
                        String matricule = vehicleData['matricule'] ?? '';
                        String km = vehicleData['Kilométrage'] ?? '';
                        String vidange = vehicleData['vidange'] ?? '';
                        String controle = vehicleData['controle'] ?? '';
                        String derniere = vehicleData['derniere'] ?? '';

                        // Use the data in your UI
                        return buildCardWithBar(
                          'assets/images/bleu.png',
                          '   $matricule              ','$km' ,
                          '\n $controle Controle techniques             $vidange vidange\n\n  Dernière visite : $derniere',
                      

                        );
                      },
                    );
                  }
                },
              ),
              
             
            ],
          ),
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
              heroTag: "btn3",
              onPressed: () {
               Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => UserListScreen()),
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

  Widget buildCardWithBar(String imagePath, String title, String titlee, String subtitle) {
   
    
    return Row(
      children: [
        Container(
          height: 115.0, // Set the desired height for the bar
          width: 7.0, // Set the desired width for the bar
          color: Colors.black, // Set the color of the bar
        ),
        Expanded(
          child: Card(
            color: Colors.white,
            elevation: 2, 
            child: Container(
              height: 120.0,
              width: 55,
             
              child: ListTile(
                title:  Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.black,
                  ),
                  child: Text(
                    '$selectedMat',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                ),
                SizedBox(width: 91 ,),
                Image.asset(
                      'assets/images/km.png',
                      width: 25.0,
                      height: 25.0,
                      
                    ),
                    SizedBox(width: 5,),
                     Container(
                  
                 
                  child: Text(
                    
                    ' $titlee ',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      
                    ),
                  ),
                  
                ),
              ],
            ),
                subtitle: Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold ),
                ),
                
              ),
            ),
          ),
        ),
      ],
    );
  }
}
