import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});
  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final List<String> _imagenes = [
    'assets/imagen1.jpeg',
    'assets/imagen2.jpeg',
    'assets/imagen3.jpg',
    'assets/imagen4.jpeg',
    'assets/imagen1.jpeg',
    'assets/imagen2.jpeg',
    'assets/imagen3.jpg',
    'assets/imagen4.jpeg',
  ];

  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        viewportFraction: 0.6); // Aumenta el tamaño de las imágenes

    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_currentPage < _imagenes.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.menu, size: 30),
                  SizedBox(width: 10),
                  Text(
                    '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "fundación CEPAMM",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[400],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Este es tu camino hacia una nueva sonrisa:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/app1.png',
                    width: 300,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Promociones:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 150, // Aumenta la altura del carrusel
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _imagenes.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(15), // Bordes redondeados
                        child: Image.asset(
                          _imagenes[index],
                          width: 150, // Aumenta el ancho de la imagen
                          height: 150, // Aumenta la altura de la imagen
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
