import 'package:app_cepamm/database/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app_cepamm/src/login/login.dart';
import 'package:flutter/material.dart';
//import 'login.dart'; // Asegúrate de importar tu archivo con LoginScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CEPAMM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}
