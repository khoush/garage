import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:msgarage/screens/details.dart';
import 'package:msgarage/screens/secondpage.dart';

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF002E7F),
        title: Text(
          'Ordre de reception',
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
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => SecondPage()));
          },
        ),
      ),
      body: Column(
        children: [
          // Search Bar Container
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
            ),
            child: Container(
              width: 200,
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              decoration: BoxDecoration(
                color: const Color(0xFF002E7F),
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'chercher un véhicule',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: const Color(0xFF002E7F),
                ),
                onChanged: (value) {
                  // Trigger the rebuild of the FutureBuilder with the new query
                  setState(() {});
                },
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          // Expanded ListView for displaying vehicles
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('vehicules').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Erreur de chargement des données"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("Aucun véhicule trouvé"));
                }

                // Filter the data based on the search query
                var filteredData = snapshot.data!.docs.where((vehicule) {
                  // Assuming 'matricule' is the field you want to filter
                  String matricule = vehicule['matricule'] ?? '';
                  return matricule.toLowerCase().contains(searchController.text.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    var vehicule = filteredData[index];

                    return Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildRichText(
                                  "Véhicule   ", vehicule['matricule'], FontWeight.bold),
                              buildRichText("Date          ", vehicule['date']),
                              SizedBox(
                                height: 20,
                              ),
                              buildRichText("Client        ", vehicule['client']),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.visibility, color: Color(0xFF002E7F)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailsPage(documentID: vehicule.id),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  RichText buildRichText(
      String label, String value, [FontWeight fontWeight = FontWeight.bold]) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
                fontSize: 16.0, fontWeight: fontWeight, color: Color(0xFF002E7F)),
          ),
          TextSpan(
            text: value,
            style: TextStyle(fontSize: 16.0, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
