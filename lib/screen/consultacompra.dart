import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:async';

class ScreenCompras extends StatefulWidget {
  const ScreenCompras({super.key});

  @override
  State<ScreenCompras> createState() => _ScreenConsultaState();
}

class _ScreenConsultaState extends State<ScreenCompras> {
  List<Map<String, dynamic>> _registros = []; // Lista para guardar los registros
  final TextEditingController _searchController = TextEditingController(); // Controlador para el campo de búsqueda

  // Método para abrir o crear la base de datos SQLite
  Future<Database> _openDatabaseConnection() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'my_database.db');

    return await openDatabase(
      dbPath,
      version: 3,
      onCreate: (db, version) async {
        // Crear la tabla si no existe cuando se crea la base de datos
        await db.execute('''
          CREATE TABLE IF NOT EXISTS inventarioc (
            codigobarra TEXT PRIMARY KEY,
            nombre TEXT,
            MATRIZ_G4 TEXT,
            ACROPOLIS TEXT,
            ALFA TEXT,
            ALFA_2 TEXT,
            GALPON_7 TEXT,
            UNICENTRO TEXT,
            VIRGINIA TEXT,
            COMERCIO TEXT,
            SANTAROSA1 TEXT,
            SANTAROSA2 TEXT,
            SANTATERESADELTUY TEXT,
            GUANARE TEXT,
            CONSTITUCION1 TEXT,
            CEMENTERIO TEXT,
            LAMARRON TEXT,
            MARACAY TEXT,
            SANJUAN TEXT,
            SAN_FELIPE TEXT,
            AVBOLIVAR TEXT,
            SANTAROSA3 TEXT,
            BARQUISIMETO TEXT,
            ACARIGUA2 TEXT,
            CONSTITUCION2 TEXT,
            LASFERIAS TEXT,
            ACARIGUA1 TEXT,
            PROPATRIA TEXT,
            LAHOYADA TEXT
          )
        ''');
      },
    );
  }

  // Método para buscar un registro por código de barras
  Future<void> _buscarRegistroPorCodigo(String codigoBarra) async {
    final Database db = await _openDatabaseConnection();

    // Realizar la consulta para obtener el registro con el código de barras ingresado
    final List<Map<String, dynamic>> result = await db.query(
      'inventarioc',
      where: 'codigobarra = ?',
      whereArgs: [codigoBarra],
    );

    // Actualizar la interfaz con los registros obtenidos
    setState(() {
      _registros = result;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Método para generar una lista de widgets con las columnas que tienen información
  List<Widget> _generarListaDeColumnas(Map<String, dynamic> registro) {
    List<Widget> columnasConDatos = [];

    // Recorrer todas las columnas del registro
    registro.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        // Si la columna tiene un valor, mostrarla
        columnasConDatos.add(
          Text('$key: $value', style: const TextStyle(fontSize: 14)),
        );
      }
    });

    return columnasConDatos;
  }

  // Método para escanear el código de barras
  Future<void> _scanBarcode() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", // Color del borde del escáner
        "Cancelar", // Texto del botón de cancelar
        true, // Mostrar flash de la cámara
        ScanMode.BARCODE, // Modo de escaneo: código de barras
      );

      if (barcode != "-1") {
        // Buscar el código de barras escaneado en la base de datos
        _buscarRegistroPorCodigo(barcode);
      } else {
        print("Escaneo cancelado");
      }
    } catch (e) {
      print("Error durante el escaneo: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Campo de texto para buscar el código de barras
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Buscar código de barras",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _buscarRegistroPorCodigo(_searchController.text); // Buscar cuando se presiona el ícono de búsqueda
                  },
                ),
              ),
              keyboardType: TextInputType.text,
              onSubmitted: (value) {
                _buscarRegistroPorCodigo(_searchController.text); // Buscar cuando se presiona Enter
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scanBarcode, // Llama al método de escaneo de código de barras
              child: const Text("Escanear Código de Barras"),
            ),
            const SizedBox(height: 20),
            // ListView para mostrar los registros de la tabla
            Expanded(
              child: _registros.isNotEmpty
                  ? ListView.builder(
                      itemCount: _registros.length,
                      itemBuilder: (context, index) {
                        final registro = _registros[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _generarListaDeColumnas(registro), // Mostrar columnas con datos
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: Text('No hay registros disponibles')),
            ),
          ],
        ),
      ),
    );
  }
}
