import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_cepamm/src/perfil/perfilusuario.dart'; // Asegúrate de importar la pantalla
import 'package:app_cepamm/src/login/login.dart'; // Asegúrate de importar la pantalla de Login

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
    _pageController = PageController(viewportFraction: 0.6);

    // Cambiar la duración de la animación a más rápida
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      // Reducir el intervalo de tiempo
      if (_currentPage < _imagenes.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(
            milliseconds: 300), // Ajusta la duración a 300 ms para más rapidez
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

  // Método para detectar el deslizamiento hacia la izquierda
  void _onPageChanged(int index) {
    if (index == 0) {
      // Si se desliza hacia la izquierda hasta la primera imagen
      // Navegar al login cuando se desliza hacia la izquierda
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Login()), // Asegúrate de tener la pantalla de Login
      );
    }
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
                  IconButton(
                    icon: Icon(Icons.menu, size: 30),
                    onPressed: () {
                      // Navegar a la página de PerfilUsuario
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PerfilUsuario()),
                      );
                    },
                  ),
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
                height: 150,
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _imagenes.length,
                  onPageChanged: _onPageChanged, // Detectar el cambio de página
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          _imagenes[index],
                          width: 150,
                          height: 150,
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
