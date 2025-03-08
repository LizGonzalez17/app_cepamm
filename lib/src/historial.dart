import 'package:app_cepamm/src/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Historial extends StatefulWidget {
  const Historial({super.key});

  @override
  State<Historial> createState() => _HistorialState();
}

class _HistorialState extends State<Historial> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Login();
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('paciente')
          .doc(user?.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
              body: Center(child: Text('Error al cargar el perfil')));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          appBar: AppBar(
            title: Text('Perfil de ${userData['nombres']}'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 📷 Foto de perfil
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: userData['image_url'] != null &&
                          userData['image_url'].isNotEmpty
                      ? NetworkImage(userData['image_url'])
                      : null,
                  child: userData['image_url'] == null ||
                          userData['image_url'].isEmpty
                      ? Icon(Icons.person, size: 50, color: Colors.grey[700])
                      : null,
                ),
                SizedBox(height: 10),

                // 🔤 Nombre completo
                Text(
                  '${userData['nombres']} ${userData['aPaterno']} ${userData['aMaterno']}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),

                // 📧 Correo
                Text(user?.email ?? "Correo no disponible",
                    style: TextStyle(color: Colors.grey[600])),

                SizedBox(height: 20),

                // 📝 Botón para editar perfil
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text("Editar perfil"),
                  onTap: () {
                    // Aquí puedes llevar a la pantalla de edición de perfil
                  },
                ),

                // 🔑 Cambiar contraseña
                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text("Cambiar contraseña"),
                  onTap: () {
                    // Aquí puedes agregar la lógica para cambiar la contraseña
                  },
                ),

                // 🚪 Cerrar sesión
                ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.red),
                  title: Text("Cerrar sesión",
                      style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
