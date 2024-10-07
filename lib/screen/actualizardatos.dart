import 'package:flutter/material.dart';
import 'ftp_service.dart';
import 'package:ConsultaExistenMDX/import_csv.dart';  // Importa la clase que maneja la importación de CSV a SQLite
import 'package:intl/intl.dart';  // Para manejar fechas y formatearlas

class ScreenActualizarDatos extends StatefulWidget {
  const ScreenActualizarDatos({super.key});

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<ScreenActualizarDatos> {
  bool isDownloading = false;
  String? downloadedFilePath;
  String? downloadDate; // Para almacenar la fecha de la descarga

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isDownloading
                    ? const Column(
                        children: [
                          CircularProgressIndicator(),  // Muestra un indicador mientras se descarga
                          SizedBox(height: 20),
                          Text('Descargando archivo...'),
                        ],
                      )
                    : downloadedFilePath != null
                        ? const Column(
                            children: [
                              Text('Archivo descargado'),
                              SizedBox(height: 20),
                            ],
                          )
                        : ElevatedButton(
                            onPressed: _downloadFile,
                            child: const Text('Actualizar Datos'),
                          ),
              ],
            ),
            if (isDownloading)
              AbsorbPointer(
                absorbing: true,
                child: Container(
                  color: Colors.black.withOpacity(0.3), // Bloquear la interacción
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadFile() async {
    setState(() {
      isDownloading = true;
    });

    FTPService ftpService = FTPService(
      'ftp.textilesmadutex.com.ve',
      'madutexc@textilesmadutex.com.ve',
      'cpanel123456789',
    );

    print('Intentando conectar al servidor FTP...');
    String? result = await ftpService.downloadFile(
      '/datosapp/InventarioTiendaGalpones.csv',  // Cambiar a la ruta del CSV en el servidor FTP
      'InventarioTiendaGalpones.csv',           // Nombre del archivo local
    );

    if (result != null) {
      print('Archivo CSV descargado con éxito en: $result');
      setState(() {
        downloadedFilePath = result;
        downloadDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()); // Guardar la fecha de la descarga
      });

      if (downloadedFilePath != null) {
        await _importCsvToDatabase(downloadedFilePath!);
      } else {
        print('Error: Ruta del archivo descargado es nula.');
      }
    } else {
      print('Error: Falló la descarga del archivo.');
    }

    setState(() {
      isDownloading = false;
    });
  }

  // Método para importar el CSV descargado a la base de datos SQLite
  Future<void> _importCsvToDatabase(String filePath) async {
    try {
      print('Iniciando la importación del archivo CSV a SQLite...');
      CsvImporter csvImporter = CsvImporter();
      await csvImporter.importCsvToSqlite(filePath);  // Pasar la ruta del archivo CSV
      print('Importación del CSV completada.');
    } catch (e) {
      print('Error durante la importación: $e');
    }
  }
}
