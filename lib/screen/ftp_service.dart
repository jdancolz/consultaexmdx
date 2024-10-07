import 'dart:io';

import 'package:ftpconnect/ftpconnect.dart';
import 'package:path_provider/path_provider.dart';

class FTPService {
  final String ftpHost;
  final String ftpUser;
  final String ftpPassword;

  FTPService(this.ftpHost, this.ftpUser, this.ftpPassword);

  Future<String?> downloadFile(String remoteFilePath, String localFileName) async {
  FTPConnect ftpClient = FTPConnect(ftpHost, user: ftpUser, pass: ftpPassword);

  try {
    print('Conectando al servidor FTP...');
    bool isConnected = await ftpClient.connect();
    print('¿Conexión exitosa? $isConnected');

    if (!isConnected) {
      print('Error: No se pudo conectar al servidor FTP.');
      return null;
    }

    // Obtener la ruta del directorio local para guardar el archivo
    Directory directory = await getApplicationDocumentsDirectory();
    String localFilePath = '${directory.path}/$localFileName';
    print('Guardando archivo en: $localFilePath');

    // Descargar el archivo
    print('Intentando descargar el archivo...');
    bool result = await ftpClient.downloadFile(remoteFilePath, File(localFilePath));

    if (result) {
      print('Descarga exitosa.');
      return localFilePath;
    } else {
      print('Error: Falló la descarga.');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  } finally {
    // Asegurarse de cerrar la conexión
    await ftpClient.disconnect();
    print('Conexión FTP cerrada.');
  }
}
}