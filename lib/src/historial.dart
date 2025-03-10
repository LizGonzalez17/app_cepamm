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

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('paciente')
          .where('uid', isEqualTo: user?.uid)
          .limit(1)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return Scaffold(
              body: Center(child: Text('Error al cargar el perfil')));
        }

        final userData =
            snapshot.data!.docs.first.data() as Map<String, dynamic>;
        final consultas = userData['consultas'] as Map<String, dynamic>? ?? {};

        return Scaffold(
          appBar: AppBar(
            title: Text('Historial de ${userData['nombres']}'),
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
                Divider(),
                Text('Historial Clínico',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),

                Expanded(
                  child: consultas.isNotEmpty
                      ? ListView.builder(
                          itemCount: consultas.length,
                          itemBuilder: (context, index) {
                            String key = consultas.keys.elementAt(index);
                            var consulta = consultas[key];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text("Fecha:  09/02/2025"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Especialida: Dentista"),
                                    Text("Tratamiento: Cambio de ligas"),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Center(child: Text('No hay consultas registradas.')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
