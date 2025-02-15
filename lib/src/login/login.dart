import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  TextEditingController ctrolU = TextEditingController();
  TextEditingController ctrolP = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CEPAMM',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black.withOpacity(0.5),
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.grey[200], // Gris más suave
        elevation: 5, // Sombra del AppBar
        centerTitle: true, // Centrar el título
      ),
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/alineadores.jpg', // Ruta de la imagen en assets
              fit: BoxFit.cover,
            ),
          ),
          // Contenido encima de la imagen
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              // Campos de entrada
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    buildTextField('Usuario:', ctrolU),
                    SizedBox(height: 10),
                    buildTextField('Contraseña:', ctrolP, obscureText: true),
                    SizedBox(height: 10),
                    // Botón "Iniciar sesión"
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          leer();
                          // Acción al presionar el botón
                        },
                        child: Text(
                          'Iniciar sesión',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Función para construir los TextField personalizados
  Widget buildTextField(String label, TextEditingController t,
      {bool obscureText = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        obscureText: obscureText,
        controller: t,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void leer() async {
    String usuario = ctrolU.text;
    String pass = ctrolP.text;

    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(email: usuario, password: pass);

    CollectionReference col = FirebaseFirestore.instance.collection("paciente");
    DocumentReference doc = col.doc(usuario);
    print((await doc.get()).exists);
    Map<String, dynamic> data =
        (await doc.get()).data() as Map<String, dynamic>;
    print(data);
  }
}
