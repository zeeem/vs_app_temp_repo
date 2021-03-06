// import 'package:ext_storage/ext_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:async';

/// A file manager
/// - each class instance can only handle one file.
class FileManager {
  // === Attributes ===
  String fileName;
  bool onCache;
  File file;

  // === helper getters ===
  Future<String> get _docPath async {
    final directory =
        await getExternalStorageDirectory(); //getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<String> get _cachePath async {
    final directory = await getTemporaryDirectory();

    return directory.path;
  }

  // === Constructors ===
  FileManager(String fileName, {bool onCache: true}) {
    this.fileName = fileName;
    this.onCache = onCache;
  }

  Future<File> getFile() async {
    return this.file;
  }

  // === Methods ===

  // Method to create and return a file on documents
  Future<File> createFile() async {
    String path;

    // get path based on onCache
    if (this.onCache) {
      path = await _cachePath;
    } else {
      path = await _docPath;
    }

    this.file = File('$path/$fileName');
    await this.flush();
    print("The file is stored at $path/$fileName");
    return this.file;
  }

  /// Clear the content of the file
  Future<File> flush() async {
    if (this.file == null) {
      await this.createFile();
    }
    return this.file.writeAsString("", mode: FileMode.write);
  }

  /// Test method for writing the position information
  Future<File> writePosition(double longitude, double latitude) async {
    if (this.file == null) {
      await this.createFile();
    }
    var now = DateTime.now();
    return this
        .file
        .writeAsString('$longitude, $latitude, $now\n', mode: FileMode.append);
  }

  /// append the given string to the end of the file
  Future<File> writeLine(String str) async {
    if (this.file == null) {
      await this.createFile();
    }
    return this.file.writeAsString("$str\n", mode: FileMode.append);
  }

  /// Method to write to the file
  Future<File> write(
      int Tem, int ACX, int ACZ, int BAT, int RED, int IR) async {
    if (this.file == null) {
      await this.createFile();
    }
    // write the file
    return this.file.writeAsString('$Tem, $ACX, $ACZ, $BAT, $RED, $IR\n',
        mode: FileMode.append);
  }

  /// Read all content of the given file
  Future<String> readAll() async {
    if (this.file == null) {
      print("Creating file");
      await this.createFile();
    }
    return this.file.readAsString();
  }

  Future<File> write_v3(
      int Tem, int ACX, int ACZ, int BAT, int RED, int IR, String TIME) async {
    if (this.file == null) {
      await this.createFile();
    }
    // write the file
    return this.file.writeAsString('$Tem, $ACX, $ACZ, $BAT, $RED, $IR, $TIME\n',
        mode: FileMode.append);
  }

  Future<File> writeString(String stringData) async {
    if (this.file == null) {
      await this.createFile();
    }
    // write the file
    return this.file.writeAsString('$stringData\n', mode: FileMode.append);
  }

  // Method to write to the file
  Future<File> write_old(
      int Tem, int ACX, int ACZ, int BAT, int RED, int IR, String TIME) async {
    // write the file
    return this.file.writeAsString('$Tem, $ACX, $ACZ, $BAT, $RED, $IR, $TIME\n',
        mode: FileMode.append);
  }

  // Method to write to the processed comparison file
  //hr_1, rr_1, spo2_1, hr_2o, rr_2o, rr_2o, spo2_2o
  Future<File> write_v2(int hr_1, int rr_1, int spo2_1, int cal_data_len1,
      int hr_2o, int rr_2o, int spo2_2o, int cal_data_len2) async {
    // write the file
    return this.file.writeAsString(
        '$hr_1, $rr_1, $spo2_1, $cal_data_len1,  $hr_2o, $rr_2o, $spo2_2o, $cal_data_len2\n',
        mode: FileMode.append);
  }
}
