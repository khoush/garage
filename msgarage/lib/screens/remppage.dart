import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:msgarage/screens/navbar.chat.dart';

class remplPage extends StatefulWidget {
  const remplPage(String title, {super.key});

  @override
  State<remplPage> createState() => _remplPageState();
}

class _remplPageState extends State<remplPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Color(0xFF002E7F),
           title: 
          Image.asset(
            'assets/images/igm.png', // Assurez-vous que le chemin est correct
            width: 70.0,
            height: 70.0,
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
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _numtelController = TextEditingController();
    TextEditingController _dateController = TextEditingController();
TextEditingController _heureController = TextEditingController(text: '00:00');

  
final TextEditingController _matrController = TextEditingController();
final TextEditingController _raisonController = TextEditingController();


 
    late DateTime _selectedDate;
     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  _MyFormState() {
    // Initialize _selectedDate with the current date
    _selectedDate = DateTime.now();
  }
 

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveDataToFirebase() async {
   
    String nom = _nomController.text;
  String raison = _raisonController.text;
    String date = _dateController.text;
    String heure = _heureController.text;
    String matr = _matrController.text;
    String numtel = _numtelController.text;

    try {
       
        


      await _firestore.collection('vehiculeremplacement').add({
        'nom': nom,
        'numtel': numtel,
        'date': date,
        'heure': heure,
        'matr': matr,
        'raison' : raison ,
      });

      // Clear text controllers after saving data
      _dateController.clear();
      _heureController.clear();
      _nomController.clear();
      _matrController.clear();
      _numtelController.clear();
      _raisonController.clear();

      _showSuccessDialog();
    } catch (e) {
      print('Error saving data to Firebase: $e');
      // Handle the error (show a message to the user or log it)
    }
  }

  Future<void> _showSuccessDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('demand added successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
    decoration: BoxDecoration(
  image: DecorationImage(
    image: AssetImage("assets/images/conn.jpg"),
     // Utilisez BoxFit.cover pour couvrir l'écran sans déformation
  ),
),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Demande de Vehicule \n   de remplacement',
                    style: TextStyle(
                      color: Color(0xFF7A99AC),
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                
                  
                ),
              ),
              SizedBox(height: 1,),
              Center(
               child: Text(
                    'Veuillez remplir le formulaire ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ),
              SizedBox(height: 20),
              Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.transparent,
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
                  controller: _nomController,
                  enabled: true,
                  decoration: InputDecoration(
                    hintText: "Nom et prenom",
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
              SizedBox(
                height: 20,
              ),
              Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.transparent,
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
                  controller: _numtelController,
                  enabled: true,
                  decoration: InputDecoration(
                    hintText: "Numéro de téléphone",
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
                  color: Colors.transparent,
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
                    hintText: "Date",
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
          color: Color(0xFF002E7F),
        ),
      ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.transparent,
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
                    hintText: "Heure",
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
                      color: Color(0xFF002E7F),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.transparent,
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
                  controller: _matrController,
                  enabled: true,
                  decoration: InputDecoration(
                    hintText: "Immatriculation de votre véhicule",
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
               SizedBox(
                height: 20,
              ),
               Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.transparent,
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
                  controller: _matrController,
                  enabled: true,
                  decoration: InputDecoration(
                    hintText: "Raison",
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
             
              
             
              SizedBox(
                height: 20,
              ),
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
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Envoyer la demande',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
           
            ],
          ),
        ),
      ),
    );
  }
}
