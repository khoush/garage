
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:msgarage/screens/client.dart'; 

import 'navbar.chat.dart';

class Rendezvous extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Prise de rendez-vous',
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
TextEditingController _heureController = TextEditingController(text: '00:00');
  TextEditingController _clientController = TextEditingController();
  TextEditingController _objetController = TextEditingController();
  TextEditingController _vehiculeController = TextEditingController();
  TextEditingController _immaController = TextEditingController();
    TextEditingController _serviceController = TextEditingController();


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  XFile? _pickedFile;

     late DateTime _selectedDate;
     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      
       List<String> _servicesList = ['Entretien', 'Carrosserie', 'Diagnostic'];
  List<String> _selectedServices = [];

  _MyFormState() {
    // Initialize _selectedDate with the current date
    _selectedDate = DateTime.now();
  }



  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
  TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (picked != null) {
    setState(() {
      _heureController.text = picked.format(context);
    });
  }
}



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
    List<String> Services = _selectedServices; 

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
          'services' : Services ,
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
          'service' : Services,
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
      _serviceController.clear();
      _pickedFile = null; // Clear the picked file

    } catch (e) {
      print('Error saving data to Firebase: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(

      
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
           
               Container(
                width: 90,
                height: 70, // Adjust the height as needed
                child: Image.asset(
                  "assets/images/kia.png", // Replace with your image path
                
                ),
              ), 
                 
              SizedBox(height: 1),
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
                      color: Colors.red,
                    ),
                  ),
                ),
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
                child: DropdownButtonFormField(
                  items: _servicesList.map((service) {
                    return DropdownMenuItem(
                      child: Row(
                        children: [
                          Checkbox(
                            value: _selectedServices.contains(service),
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  if (value) {
                                    _selectedServices.add(service);
                                  } else {
                                    _selectedServices.remove(service);
                                  }
                                }
                              });
                            },
                          ),
                          Text(service),
                        ],
                      ),
                      value: service,
                    );
                  }).toList(),
                  onChanged: (String? value) {},
                  decoration: InputDecoration(
                    hintText: "Services",
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
      suffixIcon: InkWell(
        onTap: () {
          _selectDate(context); // Define this function to show the date picker
        },
        child: Icon(
          Icons.calendar_today,
          color: Colors.red,
        ),
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
                   onTap: () {
                     _selectTime(context);
                             },
                  decoration: InputDecoration(
                    hintText: "Heure de rendez_vous",
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
                      color: Colors.red,
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
                    hintText: "Vehicule existant",
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
                          backgroundColor: Colors.black,
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
                          backgroundColor: Colors.black,
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
                height: 10,
                width: 20,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
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
                      color: Colors.black,
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
