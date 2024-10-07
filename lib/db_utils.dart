import 'package:sqflite/sqflite.dart';
import 'database.dart';  // Importa tu archivo de base de datos

Future<void> verificarEstructuraTabla() async {
  // Abre la conexión a la base de datos
  Database db = await openDatabaseConnection();

  // Ejecuta la consulta para obtener la estructura de la tabla
  List<Map<String, dynamic>> result = await db.rawQuery('PRAGMA table_info(inventarioc)');

  // Imprime la información de las columnas de la tabla
  print('Estructura de la tabla inventarioc:');
  for (var row in result) {
    print('Columna: ${row['name']}, Tipo: ${row['type']}');
  }
}



