//flutter package
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:excel/excel.dart';
import 'dart:convert';

//firebase package
import 'package:firebase_storage/firebase_storage.dart';

//My package
import '../common/constants.dart';
import '../common/moves.dart';
import '../json/framedata.dart';

class FileManager {
  static String defaultFolderPath = '';
  String fileName = fileFrameData;
  String sheetName = 'A.K.I.';
  Directory? appDocDir;
  Uint8List? byteDlFile;
  Uint8List? byteLocalFile;
  List<Move> moveList = List.empty();

  FileManager(String appDefaultFolderPath) {
    if (false == Directory(appDefaultFolderPath).existsSync()) {
      if (kDebugMode) {
        print('In Constructer of FileManager, Input Path doesn\'t exist');
      }
      return;
    }
    defaultFolderPath = appDefaultFolderPath;
  }

  Future<bool> setFirebaseStorageFile(
      String targetPathName,
      String targetFileName,
      String downloadPathName,
      String downloadFileName) async {
    bool result = false;
    // Create a storage reference from our app
    final firebaseStorageRef = FirebaseStorage.instance.ref();
    // Create a reference with an initial file path and name
    final firebaseStoragePathReference =
        firebaseStorageRef.child(targetPathName + targetFileName);
    try {
      const oneMegabyte = 1024 * 1024;
      byteDlFile = await firebaseStoragePathReference.getData(oneMegabyte);
      final downloadFileFullPathName =
          '$defaultFolderPath$downloadPathName/$fileName';
      final file = File(downloadFileFullPathName);
      //ローカルにファイルの存在確認
      if (file.existsSync() == false) {
        await file.create();
        //ローカルにファイルをDL
        final downloadTask = firebaseStoragePathReference.writeToFile(file);
        downloadTask.snapshotEvents.listen((taskSnapshot) {
          switch (taskSnapshot.state) {
            case TaskState.running:
              if (kDebugMode) {
                print("File DL is running");
              }
              break;
            case TaskState.paused:
              if (kDebugMode) {
                print("File DL is paused");
              }
              break;
            case TaskState.success:
              if (kDebugMode) {
                print("File DL is success");
              }
              break;
            case TaskState.canceled:
              if (kDebugMode) {
                print("File DL is canceled");
              }
              break;
            case TaskState.error:
              if (kDebugMode) {
                print("File DL is errored");
              }
              break;
          }
        });
        result = true;
      } else {
        result = true;
        if (kDebugMode) {
          print("File has already downloaded");
        }
      }
      //本来はここにDL状態によるエラー処理が入るかも
      // byteLocalFile = file.readAsBytesSync();
      // readExcel = await importExcel2(byteLocalFile!, sheetName);
      result = true;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("In File DL, catch an error:$e");
      }
      //exceptionが発生した場合のことをかく
      // ignore: use_build_context_synchronously
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       // addBookToFirebase()のthrowで定義した文章を
      //       // e.toString()を使って表示している。
      //       title: Text(e.toString()),
      //       actions: <Widget>[
      //         ElevatedButton(
      //           child: const Text('OK'),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //         ),
      //       ],
      //     );
      //   },
      // );
    }

    return result;
  }

  // Import a csv flie
  Future<List<List>> importCsv(String folderName, String fileName) async {
    final File importFile = File(folderName + fileName);
    List<List> importList = [];
    Stream fread = importFile.openRead();
    // Read lines one by one, and split each ','
    await fread.transform(utf8.decoder).transform(const LineSplitter()).listen(
      (String line) {
        importList.add(line.split(','));
      },
    ).asFuture();
    return Future<List<List>>.value(importList);
  }

  // Import a Excel flie
  Future<List<List>> importExcel(
      String folderName, String fileName, String sheetName) async {
    String importPath = folderName + fileName;
    var bytes = File(importPath).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    List<List> importList = [];

    for (int line = 0; line < excel.tables[sheetName]!.rows.length; line++) {
      var rowData = excel.tables[sheetName]?.rows[line];
      for (int row = 0; row < rowData!.length; row++) {
        if (rowData[row]?.value == null) {
          rowData[row] ??= rowData[0];
          rowData[row]!.value = const FormulaCellValue("0");
        }
      }
      importList.add(rowData);
    }

    return Future<List<List>>.value(importList);
  }

  //引数にバイト化したファイルを渡したバージョン
  Future<List<List>> importExcel2(Uint8List fileBytes, String sheetName) async {
    var excel = Excel.decodeBytes(fileBytes);
    List<List> importList = [];

    for (int line = 0; line < excel.tables[sheetName]!.rows.length; line++) {
      var rowData = excel.tables[sheetName]?.rows[line];
      for (int row = 0; row < rowData!.length; row++) {
        if (rowData[row]?.value == null) {
          rowData[row] ??= rowData[0];
          rowData[row]!.value = const FormulaCellValue("0");
        }
      }
      importList.add(rowData);
    }

    return Future<List<List>>.value(importList);
  }

  //
  bool exportFrameDataFile(List<FrameData> framedataList, String exportFileName,
      String exportPathName) {
    //検証用Stringリスト
    List<String> jsonOutputList = List.empty();
    final exportFileFullPathName =
        defaultFolderPath + exportPathName + exportFileName;
    final File localFile = File(exportFileFullPathName);
    File saveFile;
    if (localFile.existsSync()) {
      if (kDebugMode) {
        print("In Saving JSON File, File has already saved");
      }
      final now = DateTime.now();
      localFile.rename("${exportFileFullPathName}_$now");
    } else {
      if (kDebugMode) {
        print("In Saveing JSON File, File has not saved");
      }
    }
    saveFile = File(exportFileFullPathName);
    saveFile.create();

    for (int i = 0; i < framedataList.length; i++) {
      saveFile.writeAsStringSync(jsonEncode(framedataList[i].toJson()).trim());
      //検証用処理（リストにファイルに出力された内容を格納）
      jsonOutputList = jsonOutputList.toList();
      jsonOutputList.add(jsonEncode(framedataList[i].toJson()).trim());
    }

    return true;
  }

  bool importFrameDataFile(List<FrameData> frameDataList, String importFileName,
      String importPathName) {
    String importFileFullPath = "$importPathName\\$importFileName";
    if (!File(importFileFullPath).existsSync()) {
      if (kDebugMode) {
        print("There is no FrameData file to import");
      }
      return false;
    }
    File importFile = File(importFileFullPath);
    final List<String> importDataList = importFile.readAsLinesSync();
    //listの初期化
    frameDataList = List.empty();
    for (int i = 0; i < importDataList.length; i++) {
      final decodeData = jsonDecode(importDataList[i]);
      frameDataList.add(FrameData.fromJson(decodeData));
    }
    return true;
  }
}
