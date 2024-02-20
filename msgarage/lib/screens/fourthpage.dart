import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:msgarage/screens/client.dart';
import 'package:msgarage/screens/rendez_vous.dart';
import 'package:msgarage/screens/test.dart';

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
      snapshot = await _firestore.collection('vehicules').get();

      // Parcourir les documents de la collection
      snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
        // Extraire l'immatriculation du document
        String immatriculation = doc.get('num');

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
   Future<List<DocumentSnapshot>> getVehicleDataByMatricule(String matricule) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('vehicules')
        .where('num', isEqualTo: matricule)
        .get();

    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF002E7F),
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
          icon: Icon(Icons.arrow_back,
          color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ThirdPage()));
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
              SizedBox(height: 10.0), // Add some spacing between dropdown and cards
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
                        String num = vehicleData['num'] ?? '';
                        String km = vehicleData['km'] ?? '';
                        String vidange = vehicleData['vidange'] ?? '';
                        String controle = vehicleData['controle'] ?? '';

                        // Use the data in your UI
                        return buildCardWithBar(
                          'assets/images/bleu.png',
                          '$num                      $km ',
                          '$vidange vidange                           $controle Controle techniques',
                        );
                        
                      },
                      
                    );
                  }
                },
              ),
               SizedBox(height: 150,),
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
                          vertical: 22, horizontal: 30),
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
                  const SizedBox(width: 20),
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
      ),
    );
  }

  Widget buildCardWithBar(String imagePath, String title, String subtitle) {
  return Row(
    children: [
      Container(
        height: 100.0, // Set the desired height for the bar
        width: 7.0, // Set the desired width for the bar
        color: Color(0xFF002E7F), // Set the color of the bar
      ),
      Expanded(
        child: Card(
          child: Container(
            height: 100.0,
            width: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
            child: ListTile(
              title: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Image.asset(
                    'assets/images/km.png',
                    width: 25.0,
                    height: 22.0,
                  ),
                ],
              ),
              subtitle: Text(
                subtitle,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      
    ],
  );
}

}
