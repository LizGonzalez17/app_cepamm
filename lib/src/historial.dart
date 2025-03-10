import 'package:app_cepamm/src/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Historial extends StatefulWidget {
  const Historial({super.key});

  @override
  State<Historial> createState() => _HistorialState();
}

class _HistorialState extends State<Historial> {
  final user = FirebaseAuth.instance.currentUser;
  String formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime date = timestamp.toDate();
      return DateFormat('dd/MM/yyyy').format(date);
    }
    return timestamp.toString();
  }

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

        // Convertir el mapa de consultas en una lista plana de consultas
        List<Map<String, dynamic>> consultaItems = [];
        consultas.forEach((especialidad, consultaMap) {
          if (consultaMap is Map<String, dynamic>) {
            consultaMap.forEach((consultaKey, consultaValue) {
              if (consultaValue is List && consultaValue.length >= 3) {
                consultaItems.add({
                  'fecha': consultaValue[0],
                  'especialidad': consultaValue[1],
                  'tratamiento': consultaValue[2],
                });
              }
            });
          }
        });

        return Scaffold(
          appBar: AppBar(
            title: Text('Historial de ${userData['nombres']}'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Foto de perfil
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
                // Nombre completo
                Text(
                  '${userData['nombres']} ${userData['aPaterno']} ${userData['aMaterno']}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                // Correo
                Text(user?.email ?? "Correo no disponible",
                    style: TextStyle(color: Colors.grey[600])),
                SizedBox(height: 20),
                Divider(),
                Text('Historial Clínico',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                // Lista de consultas
                Expanded(
                  child: consultaItems.isNotEmpty
                      ? ListView.builder(
                          itemCount: consultaItems.length,
                          itemBuilder: (context, index) {
                            var consulta = consultaItems[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(
                                    "Fecha: ${formatTimestamp(consulta['fecha'])}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Especialidad: ${consulta['especialidad']}"),
                                    Text(
                                        "Tratamiento: ${consulta['tratamiento']}"),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text('No hay consultas registradas.'),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
