import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:msgarage/components/buton.dart';
import 'package:msgarage/screens/admin/admin.dart';

import 'package:msgarage/screens/navbar.chat.dart';
import 'package:msgarage/screens/resetpw.dart';
import 'package:msgarage/screens/signup.dart';
import 'package:msgarage/screens/testpage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

 void signUserIn(BuildContext context) async {
  setState(() {
    isLoading = true;
  });

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ).then((value) async {
      // Récupérer le rôle de l'utilisateur depuis la base de données Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid)
          .get();

String userRole = (userSnapshot.data() as Map<String, dynamic>)['role'] ?? 'user';

      // Vérifier le rôle de l'utilisateur
      if (userRole == 'admin') {
        // Rediriger vers la page d'administration
        // Utilisez Navigator.of(context).pushReplacement pour remplacer l'écran actuel
      
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => AdminChatPage()));
      } else {
        // Rediriger vers la page utilisateur normale
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StatPage()));
      }
    });
  } on FirebaseAuthException {
    wrongMessage(); // Appeler la méthode pour afficher le message d'erreur
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


  void wrongMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Données incorrectes ',
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
         leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => Acceuill()));
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/nn.png'),
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
                
                SizedBox(height: 70),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Avant d'accéder s'il vous plaît \nidentifiez-vous ! ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CustomTextField(
                  label: 'Email',
                  isPassword: false,
                  prefixIcon: Icons.email,
                  focusNode: emailFocusNode,
                  controller: emailController,
                ),
                CustomTextField(
                  label: 'Mot de passe',
                  isPassword: true,
                  prefixIcon: Icons.lock,
                  focusNode: passwordFocusNode,
                  controller: passwordController,
                ),
                Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PasswordResetScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          "Mot de passe oublié",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
            
          ),
        ),
      ),
    ),
  ],
),

                
                SizedBox(height: 50),
                MyButton(
                  onTap: () {
                    signUserIn(context); // Call the sign-in method
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      "Vous n'avez pas de compte? Inscrivez-vous",
                      style: TextStyle(
                        color: Colors.black,
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
  final FocusNode? focusNode;
  final TextEditingController controller;

  const CustomTextField({
    required this.label,
    this.isPassword = false,
    this.prefixIcon,
    required this.focusNode,
    required this.controller,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      padding: EdgeInsets.symmetric(horizontal: 1),
      child: TextField(
        obscureText: widget.isPassword,
        style: TextStyle(color: Colors.black),
        focusNode: widget.focusNode,
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            color: widget.focusNode?.hasFocus == true
                ? Colors.transparent
                : Colors.grey,
            fontSize: 12,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: Colors.black)
              : null,
        ),
      ),
    );
  }
}

