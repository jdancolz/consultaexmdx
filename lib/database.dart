import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Método para abrir o crear la base de datos SQLite
Future<Database> openDatabaseConnection() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, 'my_database.db');

  return openDatabase(
    path,
    version: 3,
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < newVersion) {
        print('onUpgrade called');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS inventarioc (
            codigobarra TEXT,
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
        print('Tabla inventarioc creada o ya existe');
      }
    },
    onOpen: (db) async {
      print('Base de datos abierta');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS inventarioc (
          codigobarra TEXT,
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
      print('Tabla inventarioc creada o ya existe al abrir');
    },
  );
}
