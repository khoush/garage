
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:msgarage/screens/navbar.chat.dart';

class AnotherPage extends StatefulWidget {
  const AnotherPage(String title, {super.key});

  @override
  State<AnotherPage> createState() => _AnotherPageState();
}

class _AnotherPageState extends State<AnotherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF002E7F),
        title: Center(
          child: Image.asset(
            'assets/images/log.png', // Assurez-vous que le chemin est correct
            width: 50.0,
            height: 50.0,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => StatPage()));
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _clientController = TextEditingController();
    final TextEditingController _marqueController = TextEditingController();
      final TextEditingController _modeleController = TextEditingController();
        final TextEditingController _matrController = TextEditingController();
          final TextEditingController _objetController = TextEditingController();
            final TextEditingController _vehiculeController = TextEditingController();
              final TextEditingController _numchController = TextEditingController();
                final TextEditingController _numchhController = TextEditingController();







  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveDataToFirebase() async {
    String email = _emailController.text;
    String client = _clientController.text;
    String numch =_numchhController.text; 
    String numchh =_numchController.text;
    String vehicule =_vehiculeController.text;
    String objet =_objetController.text;
    String matr =_matrController.text;
    String modele = _modeleController.text;
    String marque = _marqueController.text;

    try {
      await _firestore.collection('rendezvous').add({
        'email': email,
        'client': client,
        'numch':numch,
        'numchh':numchh,
        'vehicule':vehicule,
        'objet':objet,
        'matr':matr,
        'modele':modele,
        'marque' :marque,


      });

      // Clear text controllers after saving data
      _emailController.clear();
      _clientController.clear();
      _marqueController.clear();
      _matrController.clear();
      _modeleController.clear();
      _objetController.clear();
      _numchController.clear();
      _numchhController.clear();
      _vehiculeController.clear();

      // Show a success message or navigate to a different screen if needed
    } catch (e) {
      print('Error saving data to Firebase: $e');
      // Handle the error (show a message to the user or log it)
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
                  controller: _emailController,
                  enabled: true,
                  decoration: InputDecoration(
                    hintText: "Email",
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
                child: TextFormField(
                  controller: _emailController,
                  enabled: true,
                  decoration: InputDecoration(
                    hintText: "Email",
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
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    saveDataToFirebase();
                    // Additional logic or navigation if needed
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF002E7F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: Text(
                    'Enregistrer',
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
      ),
    );
  }
}