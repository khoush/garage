import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DetailsPage extends StatelessWidget {
  String documentID;

  DetailsPage({required this.documentID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Fiche ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            // Ajoutez ici la logique pour fermer la page
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('vehicules')
                .doc(documentID)
                .get(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(
                      child: Text("Chargement..."),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: buildDetailRow(
                                  'matricule', snapshot.data!['matricule']),
                            ),
                            SizedBox(
                                width:
                                    16.0), // Ajoutez un espacement entre les deux boîtes
                            Expanded(
                              child: buildDetailRow(
                                  'Client', snapshot.data!['client']),
                            ),
                          ],
                        ),
                        SizedBox(
                            height:
                                16.0), // Ajoutez un espacement entre les deux rangées

                        SizedBox(
                          height: 5,
                        ),

                        buildDetailRow(
                            'Date', snapshot.data!['date']),
                        SizedBox(
                          height: 5,
                        ),

                    
                   

                     
                  
                       
                     

                       
                       
                      ],
                    );
            }),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget buildDetailRow(String label, String value,
      {bool isBold = false, double Containerheight = 60.0}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF9F9F9F),
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          width: 330.0,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade500,
              width: 1.0,
            ),
            
            borderRadius: BorderRadius.circular(10.0),
            
          ),
          
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),

        // Ajoutez un espacement entre les boîtes
      ],
    );
  }
}