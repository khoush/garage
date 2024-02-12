import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:msgarage/components/buton.dart';
import 'package:msgarage/screens/loginpage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nomController = TextEditingController();
  TextEditingController _nomutilController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addUserToFirestore(
      String userId, String email, String nom, String username) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': email,
        'nom': nom,
        'username': username,
      });
    } catch (e) {
      print("Erreur lors de l'ajout de l'utilisateur à Firestore : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/insc.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  width: 150,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "S'inscrire comme un client ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CustomTextField(
                  controller: _nomController,
                  label: 'Nom et prenom',
                  isPassword: false,
                  prefixIcon: Icons.person,
                ),
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  isPassword: false,
                  prefixIcon: Icons.email,
                ),
                CustomTextField(
                  controller: _nomutilController,
                  label: "Nom d'utilisateur",
                  isPassword: false,
                  prefixIcon: Icons.person,
                ),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Mot de passe',
                  isPassword: true,
                  prefixIcon: Icons.lock,
                ),
                SizedBox(height: 50),
                MyyButton(
                  onTap: () async {
                    if (_emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty &&
                        _nomController.text.isNotEmpty &&
                        _nomutilController.text.isNotEmpty) {
                      try {
                        UserCredential userCredential =
                            await _auth.createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );

                        // User is successfully registered
                        print("User registered: ${userCredential.user?.uid}");

                        // Ajouter l'utilisateur à Firestore
                        await addUserToFirestore(
                          userCredential.user!.uid,
                          _emailController.text,
                          _nomController.text,
                          _nomutilController.text,
                        );
                      } catch (e) {
                        // Handle registration errors
                        if (e is FirebaseAuthException) {
                          print("Error during registration - ${e.message}");
                          if (e.code == 'email-already-in-use') {
                            // User is already registered
                            print("Email is already in use");
                            // Ajouter ici le code pour informer l'utilisateur de l'erreur
                          } else {
                            // Autres erreurs d'authentification
                            print("Autre erreur d'authentification");
                            // Ajouter ici le code pour informer l'utilisateur de l'erreur
                          }
                        } else {
                          // Autres erreurs non liées à Firebase Auth
                          print("Erreur inattendue: $e");
                        }
                      }
                    } else {
                      // Afficher un message d'erreur pour informer l'utilisateur
                      print("Veuillez remplir tous les champs");
                    }
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      "Vous avez un compte? Connectez-vous",
                      style: TextStyle(
                        color: Color(0xFF002E7F),
                        fontSize: 9,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final IconData? prefixIcon;
  final TextEditingController controller;

  const CustomTextField({
    required this.label,
    this.isPassword = false,
    this.prefixIcon,
    required this.controller,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        obscureText: widget.isPassword,
        style: TextStyle(color: Colors.black),
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            color: Colors.grey,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: Color(0xFF003888))
              : null,
        ),
      ),
    );
  }
}