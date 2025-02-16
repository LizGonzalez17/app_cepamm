import 'package:app_cepamm/src/inicio/Inicio.dart';
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
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
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
                          //leer();
                          // Acción al presionar el botón
                          _iniciarSesion();
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

  Future<void> _iniciarSesion() async {
    //if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String username = ctrolU.text.trim();
      String password = ctrolP.text.trim();

      final userSnapshot = await FirebaseFirestore.instance
          .collection('paciente')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        throw FirebaseAuthException(
            code: 'user-not-found', message: 'Usuario no encontrado.');
      }

      final userData = userSnapshot.docs.first.data();
      String email = userData['email'] ?? "$username@example.com";

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Inicio()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.code);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String errorCode) {
    String errorMessage;
    switch (errorCode) {
      case 'user-not-found':
        errorMessage = 'No se encontró un usuario con este nombre.';
        break;
      case 'wrong-password':
        errorMessage = 'La contraseña es incorrecta.';
        break;
      default:
        errorMessage = 'Ocurrió un error inesperado.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
}
