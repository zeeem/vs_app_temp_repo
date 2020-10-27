import 'package:ext_storage/ext_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:async';
import 'package:toast/toast.dart';

/// A file manager
/// - each class instance can only handle one file.
class FileManager {
  // === Attributes ===
  String fileName;
  bool onCache;
  File file;

  // === helper getters ===
  Future<String> get _docPath async {
//    PermissionHandler().requestPermissions([PermissionGroup.storage]);
//
//    final String download_dir =
//        await ExtStorage.getExternalStoragePublicDirectory(
//            ExtStorage.DIRECTORY_DOWNLOADS);

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
    print("The file is stored at $path/$fileName");

//    Toast.show("The raw data csv will be stored at $path/$fileName", context,
//        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

    return this.file;
  }

  // Method to write to the file
  Future<File> write(
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
