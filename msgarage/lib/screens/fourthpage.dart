import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:msgarage/screens/client.dart';
import 'package:msgarage/screens/rendez_vous.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({super.key});

  @override
  State<FourthPage> createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  List<String> mat = ['2022', '2057', '2000'];
  String selectedMat = '2022';

  Future<List<DocumentSnapshot>> getVehicleData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('vehicules').get();

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
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Add your logic to handle the menu icon click here
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
              SizedBox(height: 10.0), // Add some spacing between dropdown and cards
              FutureBuilder<List<DocumentSnapshot>>(
                future: getVehicleData(),
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
