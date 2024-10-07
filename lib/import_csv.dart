import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CsvImporter {
  // Método para importar el archivo CSV a la base de datos SQLite
  Future<void> importCsvToSqlite(String csvFilePath) async {
    try {
      // Leer el archivo CSV
      File csvFile = File(csvFilePath);
      String csvContent = await csvFile.readAsString();

      // Convertir el contenido del CSV en una lista de listas usando el delimitador ";"
      List<List<dynamic>> csvTable = const CsvToListConverter(fieldDelimiter: ';').convert(csvContent);

      // Abrir la conexión a la base de datos SQLite
      Database db = await _openDatabaseConnection();

      // Borrar la tabla si ya existe y crearla de nuevo
      await db.execute('DROP TABLE IF EXISTS inventarioc');
      await db.execute('''
        CREATE TABLE inventarioc (
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

      // Recorrer cada fila del CSV e insertar en la base de datos
      for (var row in csvTable) {
        if (row.length < 29) {
          print('Fila inválida: $row');  // Opcional: Para depuración
          continue;  // Saltar las filas inválidas
        }

        await db.insert('inventarioc', {
          'CodigoBarra': row[0],
          'Nombre': row[1],
          'Referencia': row[2],
          'PrecioDetal': row[3],
          'PrecioMayor': row[4],
          'PrecioPromocion': row[5],
          'MATRIZ_G4': row[6],
          'ACROPOLIS': row[7],
          'ALFA': row[8],
          'ALFA_2': row[9],
          'GALPON_7': row[10],
          'UNICENTRO': row[11],
          'VIRGINIA': row[12],
          'COMERCIO': row[13],
          'SANTAROSA1': row[14],
          'SANTAROSA2': row[15],
          'SANTATERESADELTUY': row[16],
          'GUANARE': row[17],
          'CONSTITUCION1': row[18],
          'CEMENTERIO': row[19],
          'LAMARRON': row[20],
          'MARACAY': row[21],
          'SANJUAN': row[22],
          'SAN_FELIPE': row[23],
          'AVBOLIVAR': row[24],
          'SANTAROSA3': row[25],
          'BARQUISIMETO': row[26],
          'ACARIGUA2': row[27],
          'CONSTITUCION2': row[28],
          'LASFERIAS': row[29],
          'ACARIGUA1': row[30],
          'PROPATRIA': row[31],
          'LAHOYADA': row[32],
        });
      }

      print("Importación de CSV completada con éxito.");
    } catch (e) {
      print("Error durante la importación del CSV: $e");
    }
  }

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
}
