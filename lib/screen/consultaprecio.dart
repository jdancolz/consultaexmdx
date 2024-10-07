import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:async';

class ScreenConsulta extends StatefulWidget {
  const ScreenConsulta({super.key});

  @override
  State<ScreenConsulta> createState() => _ScreenConsultaState();
}

class _ScreenConsultaState extends State<ScreenConsulta> {
  List<Map<String, dynamic>> _registros = []; // Lista para guardar los registros
  final TextEditingController _searchController = TextEditingController(); // Controlador para el campo de búsqueda
  final FocusNode _focusNode = FocusNode(); // Declara un FocusNode

  // Método para abrir o crear la base de datos SQLite
  Future<Database> _openDatabaseConnection() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'my_database.db');

    return await openDatabase(
      dbPath,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS inventarioc (
            CodigoBarra TEXT PRIMARY KEY,
            Nombre TEXT,
            Referencia TEXT,
            PrecioDetal TEXT,
            PrecioMayor TEXT,
            PrecioPromocion TEXT,
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
      where: 'CodigoBarra = ?',
      whereArgs: [codigoBarra],
    );

    setState(() {
      _registros = result;
      _searchController.clear(); // Limpiar el texto del campo de búsqueda
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose(); // Libera el FocusNode cuando no es necesario
    super.dispose();
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
        _buscarRegistroPorCodigo(barcode);
      } else {
        print("Escaneo cancelado");
      }
    } catch (e) {
      print("Error durante el escaneo: $e");
    }
  }

  // Mostrar los campos importantes como TextFields con un diseño más moderno
  Widget _buildImportantFields(Map<String, dynamic> registro) {
    return Column(
      children: [
        _buildStyledTextField(
          labelText: 'Código de Barra',
          value: registro['CodigoBarra'],
          icon: Icons.qr_code,
        ),
        const SizedBox(height: 2), // Añade un espaciado entre los campos
        _buildStyledTextField(
          labelText: 'Referencia',
          value: registro['Referencia'],
          icon: Icons.article,
        ),
        const SizedBox(height: 2),
        _buildStyledTextField(
          labelText: 'Nombre',
          value: registro['Nombre'],
          icon: Icons.label,
        ),
        const SizedBox(height: 2),
        _buildStyledTextField(
          labelText: 'Precio Detal',
          value: registro['PrecioDetal'],
          icon: Icons.attach_money,
        ),
        const SizedBox(height: 2),
        _buildStyledTextField(
          labelText: 'Precio Mayor',
          value: registro['PrecioMayor'],
          icon: Icons.attach_money,
        ),
        const SizedBox(height: 5),
        _buildStyledTextField(
          labelText: 'Precio Promoción',
          value: registro['PrecioPromocion'],
          icon: Icons.local_offer,
        ),
      ],
    );
  }

  // Función auxiliar para crear un TextField con estilo moderno
  Widget _buildStyledTextField({
    required String labelText,
    required String value,
    required IconData icon,
  }) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        prefixIcon: Icon(icon, color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Método para generar una lista de widgets con las columnas restantes con el valor a la derecha
  List<Widget> _generarListaDeColumnasRestantes(Map<String, dynamic> registro) {
    List<Widget> columnasConDatos = [];

    registro.forEach((key, value) {
      // Evitar mostrar los campos que ya están en los TextFields
      if (['CodigoBarra', 'Referencia', 'Nombre', 'PrecioDetal', 'PrecioMayor', 'PrecioPromocion'].contains(key)) {
        return;
      }

      if (value != null && value.toString().isNotEmpty) {
        columnasConDatos.add(
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.grey.shade100, // Fondo suave
              borderRadius: BorderRadius.circular(12), // Bordes redondeados
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Sombra suave
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Texto de la columna (nombre de la propiedad)
                Expanded(
                  flex: 2,
                  child: Text(
                    key,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Valor de la columna (existencia)
                Expanded(
                  flex: 2,
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right, // Alineación a la derecha
                    maxLines: 1, // Solo una línea para evitar desbordamientos
                    overflow: TextOverflow.ellipsis, // Cortar texto si es demasiado largo
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });

    return columnasConDatos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Solución para hacer scroll en toda la pantalla
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Campo de texto para buscar el código de barras con los botones
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  focusNode: _focusNode, // Vincula el FocusNode al TextField
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: "Buscar código de barras",
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: InputBorder.none,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            _buscarRegistroPorCodigo(_searchController.text);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.qr_code_scanner),
                          onPressed: _scanBarcode, // Llama al método de escaneo
                        ),
                      ],
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) {
                    _buscarRegistroPorCodigo(_searchController.text);
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Mostrar los campos importantes (TextFields)
              if (_registros.isNotEmpty) _buildImportantFields(_registros.first),
              const SizedBox(height: 20),
              // ListView para mostrar las columnas restantes
              if (_registros.isNotEmpty) ..._generarListaDeColumnasRestantes(_registros.first),
            ],
          ),
        ),
      ),
    );
  }
}
