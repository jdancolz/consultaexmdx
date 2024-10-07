import 'dart:io';
import 'package:xml/xml.dart' as xml;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'database.dart';  // Importa tu archivo de base de datos

// Función para insertar datos del XML en SQLite
Future<void> insertXmlDataToSQLite() async {
  // Abre la conexión a la base de datos
  Database db = await openDatabaseConnection();

  // Obtiene el directorio donde se almacenó el archivo descargado
  Directory directory = await getApplicationDocumentsDirectory();
  String filePath = '${directory.path}/Archivo.xml';
  File file = File(filePath);
  
  // Lee el contenido del archivo XML
  String fileContent = await file.readAsString();
  print('Contenido del archivo XML:\n$fileContent');  // Imprimir el contenido del XML

  // Luego, intenta analizar el contenido
  try {
    var document = xml.XmlDocument.parse(fileContent);

    // Extraer los elementos del XML y agregarlos a la base de datos
    var items = document.findAllElements('Table1');

    for (var item in items) {
      // Extraer los valores de cada campo del XML
      String? codigobarra = item.findElements('CodigoBarra').isNotEmpty 
          ? item.findElements('CodigoBarra').single.text 
          : null;
      String? nombre = item.findElements('Nombre').isNotEmpty 
          ? item.findElements('Nombre').single.text 
          : null;

      // Imprimir los valores extraídos para depurar
      print('Código de barra extraído: $codigobarra');
      print('Nombre extraído: $nombre');

      // Inserta los valores extraídos en la base de datos SQLite
      await db.insert('inventarioc', {
        'codigobarra': codigobarra,
        'nombre': nombre,
        'MATRIZ_G4': item.findElements('MATRIZ_G4').isNotEmpty 
            ? item.findElements('MATRIZ_G4').single.text 
            : '',
        'ACROPOLIS': item.findElements('ACROPOLIS').isNotEmpty 
            ? item.findElements('ACROPOLIS').single.text 
            : '',
        'ALFA': item.findElements('ALFA').isNotEmpty 
            ? item.findElements('ALFA').single.text 
            : '',
        'ALFA_2': item.findElements('ALFA_2').isNotEmpty 
            ? item.findElements('ALFA_2').single.text 
            : '',
        'GALPON_7': item.findElements('GALPON_7').isNotEmpty 
            ? item.findElements('GALPON_7').single.text 
            : '',
        'UNICENTRO': item.findElements('UNICENTRO').isNotEmpty 
            ? item.findElements('UNICENTRO').single.text 
            : '',
        'VIRGINIA': item.findElements('VIRGINIA').isNotEmpty 
            ? item.findElements('VIRGINIA').single.text 
            : '',
        'COMERCIO': item.findElements('COMERCIO').isNotEmpty 
            ? item.findElements('COMERCIO').single.text 
            : '',
        'SANTAROSA1': item.findElements('SANTAROSA1').isNotEmpty 
            ? item.findElements('SANTAROSA1').single.text 
            : '',
        'SANTAROSA2': item.findElements('SANTAROSA2').isNotEmpty 
            ? item.findElements('SANTAROSA2').single.text 
            : '',
        'SANTATERESADELTUY': item.findElements('SANTATERESADELTUY').isNotEmpty 
            ? item.findElements('SANTATERESADELTUY').single.text 
            : '',
        'GUANARE': item.findElements('GUANARE').isNotEmpty 
            ? item.findElements('GUANARE').single.text 
            : '',
        'CONSTITUCION1': item.findElements('CONSTITUCION1').isNotEmpty 
            ? item.findElements('CONSTITUCION1').single.text 
            : '',
        'CEMENTERIO': item.findElements('CEMENTERIO').isNotEmpty 
            ? item.findElements('CEMENTERIO').single.text 
            : '',
        'LAMARRON': item.findElements('LAMARRON').isNotEmpty 
            ? item.findElements('LAMARRON').single.text 
            : '',
        'MARACAY': item.findElements('MARACAY').isNotEmpty 
            ? item.findElements('MARACAY').single.text 
            : '',
        'SANJUAN': item.findElements('SANJUAN').isNotEmpty 
            ? item.findElements('SANJUAN').single.text 
            : '',
        'SAN_FELIPE': item.findElements('SAN_FELIPE').isNotEmpty 
            ? item.findElements('SAN_FELIPE').single.text 
            : '',
        'AVBOLIVAR': item.findElements('AVBOLIVAR').isNotEmpty 
            ? item.findElements('AVBOLIVAR').single.text 
            : '',
        'SANTAROSA3': item.findElements('SANTAROSA3').isNotEmpty 
            ? item.findElements('SANTAROSA3').single.text 
            : '',
        'BARQUISIMETO': item.findElements('BARQUISIMETO').isNotEmpty 
            ? item.findElements('BARQUISIMETO').single.text 
            : '',
        'ACARIGUA2': item.findElements('ACARIGUA2').isNotEmpty 
            ? item.findElements('ACARIGUA2').single.text 
            : '',
        'CONSTITUCION2': item.findElements('CONSTITUCION2').isNotEmpty 
            ? item.findElements('CONSTITUCION2').single.text 
            : '',
        'LASFERIAS': item.findElements('LASFERIAS').isNotEmpty 
            ? item.findElements('LASFERIAS').single.text 
            : '',
        'ACARIGUA1': item.findElements('ACARIGUA1').isNotEmpty 
            ? item.findElements('ACARIGUA1').single.text 
            : '',
        'PROPATRIA': item.findElements('PROPATRIA').isNotEmpty 
            ? item.findElements('PROPATRIA').single.text 
            : '',
        'LAHOYADA': item.findElements('LAHOYADA').isNotEmpty 
            ? item.findElements('LAHOYADA').single.text 
            : ''
      });
    }
  } catch (e) {
    print('Error durante el análisis del XML: $e');
  }
}
