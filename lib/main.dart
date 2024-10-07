import 'package:ConsultaExistenMDX/screen/actualizardatos.dart';
import 'package:ConsultaExistenMDX/screen/consultacompra.dart';
import 'package:ConsultaExistenMDX/screen/consultaprecio.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _paginaActual = 0;

  // Páginas del BottomNavigationBar
  final List<Widget> _paginas = [
    const ScreenConsulta(),
    const ScreenCompras(),
    const ScreenActualizarDatos(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _paginas[_paginaActual],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _paginaActual = index;
            });
          },
          currentIndex: _paginaActual,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black, // Color para el texto seleccionado
          unselectedItemColor: Colors.grey, // Color para el texto no seleccionado
          items: [
            _buildBottomNavItem(
              icon: Icons.search,
              label: "ConsultaExistencia",
              isSelected: _paginaActual == 0,
            ),
            _buildBottomNavItem(
              icon: Icons.shopping_cart,
              label: "ConsultaCompra",
              isSelected: _paginaActual == 1,
            ),
            _buildBottomNavItem(
              icon: Icons.update,
              label: "ActualizarDatos",
              isSelected: _paginaActual == 2,
            ),
          ],
        ),
      ),
    );
  }

  // Función para crear los ítems del BottomNavigationBar con animación de línea
  BottomNavigationBarItem _buildBottomNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 4.0,
            width: isSelected ? 20.0 : 0.0,
            decoration: BoxDecoration(
              color: isSelected ? Colors.black87 : Colors.transparent,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          Icon(
            icon,
            color: isSelected ? Colors.black87 : Colors.grey,
          ),
        ],
      ),
      label: label,
    );
  }
}
