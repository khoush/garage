
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'client.dart';
import 'navbar.chat.dart';

class Rendezvous extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF002E7F),
        title: Text(
          'Prise des rendez-vous',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
          color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StatPage()));
          },
        ),
      ),
      body: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  TextEditingController _demandeController = TextEditingController();
  TextEditingController _datedController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _heureController = TextEditingController();
  TextEditingController _clientController = TextEditingController();
  TextEditingController _objetController = TextEditingController();
  TextEditingController _vehiculeController = TextEditingController();
  TextEditingController _immaController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  XFile? _pickedFile;

  Future<int> getLatestDemandNumber() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('rendezvous').orderBy('dated', descending: true).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs[0].get('demandeCounter') + 1;
      } else {
        return 1; // If no demands exist, start from 1
      }
    } catch (e) {
      print('Error getting latest demand number: $e');
      return 1; // Return 1 in case of an error
    }
  }

  Future<void> _pickFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }

  Future<void> saveDataToFirebase() async {
    int latestDemandNumber = await getLatestDemandNumber();
    String demande = 'Demande $latestDemandNumber';
    String dated = DateTime.now().toString();
    String client = _clientController.text;
    String date = _dateController.text;
    String heure = _heureController.text;
    String immatriculation = _immaController.text;
    String objet = _objetController.text;
    String vehicule = _vehiculeController.text;

    try {
      if (_pickedFile != null) {
        final file = File(_pickedFile!.path);
        final storageReference = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('files/${DateTime.now().millisecondsSinceEpoch}');
        await storageReference.putFile(file);
        final downloadURL = await storageReference.getDownloadURL();

        await _firestore.collection('rendezvous').add({
          'demande': demande,
          'dated': dated,
          'client': client,
          'date': date,
          'heure': heure,
          'immatriculation': immatriculation,
          'objet': objet,
          'vehicule': vehicule,
          'fileURL': downloadURL,
          'demandeCounter': latestDemandNumber,
        });
      } else {
        await _firestore.collection('rendezvous').add({
          'demande': demande,
          'dated': dated,
          'client': client,
          'date': date,
          'heure': heure,
          'immatriculation': immatriculation,
          'objet': objet,
          'vehicule': vehicule,
          'demandeCounter': latestDemandNumber,
        });
      }

      setState(() {
        _demandeController.text = '$latestDemandNumber';
      });

      _datedController.clear();
      _clientController.clear();
      _dateController.clear();
      _heureController.clear();
      _immaController.clear();
      _objetController.clear();
      _vehiculeController.clear();
      _pickedFile = null; // Clear the picked file

    } catch (e) {
      print('Error saving data to Firebase: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/conn.jpg"), // Replace with your image path
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 130,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _demandeController,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: "         Demande",
                        hintStyle: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 130,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _datedController,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: "      Date demande",
                        hintStyle: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _clientController,
                  enabled: true,
                  decoration: InputDecoration(
                    hintText: "Client",
                    hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    suffixIcon: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _dateController,
                  enabled: true,
                  decoration: InputDecoration(
                    hintText: "Selectionner la date",
                    hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _heureController,
                  enabled: true,
                  decoration: InputDecoration(
                    hintText: "Heure de rendz_vous",
                    hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    suffixIcon: Icon(
                      Icons.lock_clock,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _objetController,
                  enabled: true,
                  decoration: InputDecoration(
                    hintText: "objet",
                    hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _vehiculeController,
                  enabled: true,
                  decoration: InputDecoration(
                    hintText: "Vehicule exitant",
                    hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _immaController,
                  enabled: true,
                  decoration: InputDecoration(
                    hintText: "Nouveau vehicule (immatriculation)",
                    hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                width: 350,
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _pickFile,
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF002E7F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: Text(
                          'choisir un fichier',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (){
                          
                      saveDataToFirebase();
                      Navigator.push(
                      context,
                            MaterialPageRoute(builder: (context) => StatPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF002E7F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: Text(
                          'Terminer',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_pickedFile != null)
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Image.file(
            File(_pickedFile!.path),
            height: 100,
          ),
        ),
              const SizedBox(
                height: 100,
                width: 30,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
