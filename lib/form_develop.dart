import 'package:combo_maker/manage_cloud/readfile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:combo_maker/common/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'common/moves.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ComboMaker extends StatefulWidget {
  const ComboMaker({super.key});

  @override
  State<ComboMaker> createState() => _SetDataState();
}

class _SetDataState extends State<ComboMaker> {
  String path = "";
  //Future<FirebaseFirestore> documents;
  //String documentName = "";
  String display1 = 'path = ';
  String display2 = 'Firebase Document';
  List<DocumentSnapshot> documentList = [];

  //double? _deviceWidth, _deviceHeight;

  //ファイル読み込み用
  //将来消す
  String importPath =
      "D:\\program\\flutter_projct\\combo_maker\\data"; //'data/'; //FrameData_Read.xlsx';
  String downloadFolderPath = '';
  String downloadFileFullPath = '';
  String fileName = 'FrameData_Read.xlsx';
  String sheetName = 'A.K.I.';
  String input = 'MP';
  var readExcel; // = await excelImport(importPath, fileName, sheetName);
  File? file;
  Directory? appDocDir;
  Uint8List? byteDlFile;
  Uint8List? byteLocalFile;

  _SetDataState() {
    //ファイル読み込み
    //readExcel = excelImport(importPath, fileName, sheetName);
  }

  void getDocumentList() async {
    List<String> dataList = List.empty();
    final collectionRef = FirebaseFirestore.instance
        .collection("StreetFighter6")
        .doc("Contents")
        .collection("Characters"); // CollectionReference
    final querySnapshot = await collectionRef.get(); // QuerySnapshot
    final queryDocSnapshot = querySnapshot.docs; // List<QueryDocumentSnapshot>
    for (final snapshot in queryDocSnapshot) {
      dataList = dataList.toList();
      dataList.add(snapshot.data().toString()); // `data()`で中身を取り出す
    }
    /*
    final document = FirebaseFirestore.instance
        .collection("StreetFighter6")
        .doc("Contents")
        .get()
        .then((DocumentSnapshot doc) {
      final documentName = doc..toString();
      setState(() {
        display2 = display2 + documentName;
        if (kDebugMode) {
          print(documentName);
        }
      });
    });
    */
  }

  void getPath() async {
    path = await _localPath;
    setState(() {
      display1 = display1 + path;
      if (kDebugMode) {
        //print(path);
      }
    });
  }

  Future<bool> setFirebaseStorageFile(
      String pathName, String fileName, String cloudURI) async {
    bool result = false;
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();
    // Create a reference with an initial file path and name
    final pathReference = storageRef.child(pathName + fileName);
    /*
    // Create a reference to a file from a Google Cloud Storage URI
    final gsReference = FirebaseStorage.instance
        .refFromURL("gs://combomaker-40efc.appspot.com/FrameData");
    */
    try {
      const oneMegabyte = 1024 * 1024;
      byteDlFile = await pathReference.getData(oneMegabyte);
      //ローカルにファイルの存在確認
      appDocDir = await getApplicationDocumentsDirectory();
      downloadFolderPath = appDocDir!.path;
      downloadFileFullPath = downloadFolderPath + fileName;
      //ローカルにファイルをDL
      if (file == null || file?.existsSync() == false) {
        file = File(downloadFileFullPath);
        await file!.create();
        final downloadTask = pathReference.writeToFile(file!);
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
          print("File DL is skipped");
        }
      }
      //本来はここにDL状態によるエラー処理が入るかも
      byteLocalFile = file!.readAsBytesSync();
      readExcel = excelImport2(byteLocalFile!, sheetName);
      result = true;
    } on FirebaseException catch (e) {
      //exceptionが発生した場合のことをかく
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // addBookToFirebase()のthrowで定義した文章を
            // e.toString()を使って表示している。
            title: Text(e.toString()),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return result;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
            //flex: flexRatioDisplayCombo,
            child: Container(
              width: double.infinity,
              //padding: const EdgeInsets.all(10),
              color: kWhite,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      display2,
                      style: const TextStyle(
                        color: kRed,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      display1,
                      style: const TextStyle(
                        color: kRed,
                        fontSize: 20,
                      ),
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () async {
                            getPath();
                          },
                          child: const Text("Path Set"),
                        ),
                        TextButton(
                          onPressed: () async {
                            getDocumentList();
                          },
                          child: const Text("FireBase Document List"),
                        ),
                        TextButton(
                          onPressed: () async {
                            //フレームデータの入ったEXCELファイル読み込み
                            readExcel =
                                //await excelImport(importPath, fileName, sheetName);
                                await excelImport(
                                    "$path\\", fileName, sheetName);
                            List<Move> moveList = readFrameData(readExcel);
                            setState(() {
                              display1 =
                                  "$display1\nRead ${moveList.length} Data";
                            });
                          },
                          child: const Text("Read Excel Data"),
                        ),
                        TextButton(
                          onPressed: () async {
                            final resultDL = setFirebaseStorageFile(
                                "FrameData/",
                                "FrameData_Read.xlsx",
                                "gs://combomaker-40efc.appspot.com/FrameData");
                          },
                          child: const Text("Download"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //Windowsアプリケーションではここでエラーが出る
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ComboMaker());
}
