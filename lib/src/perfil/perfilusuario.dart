import 'package:flutter/material.dart';

class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({super.key});

  @override
  _PerfilUsuarioState createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  String imageUrl =
      ""; // Aquí se almacenará la URL de la imagen que se bajará desde la base de datos
  String name =
      ""; // Aquí se almacenará el nombre que se tomará de la base de datos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Citas', textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: Center(
        // Center para centrar todo el contenido vertical y horizontal
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start, // Alinea todo hacia la parte superior
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centra todo horizontalmente
          children: [
            // Cuadro para la imagen
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 8.0), // Menos espacio entre la imagen y el nombre
              child: imageUrl.isEmpty
                  ? CircularProgressIndicator() // Muestra un cargando mientras se descarga la imagen
                  : Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Image.network(imageUrl, fit: BoxFit.cover),
                    ),
            ),

            // Nombre tomado de la base de datos
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                name.isEmpty ? "Cargando nombre..." : name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método que simula la descarga de la imagen y el nombre desde la base de datos
  void getDataFromDatabase() {
    // Aquí puedes poner la lógica para obtener la URL de la imagen y el nombre desde tu base de datos
    setState(() {
      imageUrl =
          "https://blog.tohuman.dk/wp-content/uploads/2018/09/faceyoga-guide.jpg"; // URL de ejemplo
      name = "Lizbeth González"; // Nombre de ejemplo
    });
  }

  @override
  void initState() {
    super.initState();
    getDataFromDatabase(); // Llamada para obtener la imagen y el nombre desde la base de datos
  }
}
