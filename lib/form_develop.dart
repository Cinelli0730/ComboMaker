//flutter package
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

//firebase package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_options.dart';

//My package
import 'cloud_manager/readfile.dart';
import 'common/constants.dart';
//import 'common/moves.dart';
import 'firestore/firestore.dart';
import 'package:combo_maker/json/framedata.dart';

class ComboMaker extends StatefulWidget {
  const ComboMaker({super.key});

  @override
  State<ComboMaker> createState() => _SetDataState();
}

class _SetDataState extends State<ComboMaker> {
  String appDefaultPath = "";
  String display1 = 'path = ';
  String display2 = 'Firebase Document';
  List<DocumentSnapshot> documentList = [];

  //double? _deviceWidth, _deviceHeight;

  //ファイル読み込み用
  String downloadFolderPath = '';
  String downloadFileFullPath = '';
  String fileName = fileFrameData;
  String sheetName = 'A.K.I.';
  List<List<dynamic>> readExcel =
      List.empty(); // = await importExcel(importPath, fileName, sheetName);
  File? file;
  Directory? appDocDir;
  Uint8List? byteDlFile;
  Uint8List? byteLocalFile;
  List<FrameData> mFrameDataList = List.empty();

  //firestore用
  MyFirestore myFirestore = MyFirestore();

  _SetDataState();

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
  }

  void getPath() async {
    appDefaultPath = await _localPath;
    setState(() {
      display1 = display1 + appDefaultPath;
    });
  }

  Future<bool> setFirebaseStorageFile(String pathName, String fileName) async {
    bool result = false;
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();
    // Create a reference with an initial file path and name
    final pathReference = storageRef.child(pathName + fileName);
    try {
      const oneMegabyte = 1024 * 1024;
      byteDlFile = await pathReference.getData(oneMegabyte);
      //ローカルにファイルの存在確認
      appDocDir = await getApplicationDocumentsDirectory();
      downloadFolderPath = appDocDir!.path;
      downloadFileFullPath = '$downloadFolderPath/$fileName';
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
      readExcel = await importExcel2(byteLocalFile!, sheetName);
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
                            readExcel = await importExcel(
                                "$appDefaultPath/", fileName, sheetName);
                            mFrameDataList = readFrameData(readExcel);
                            setState(() {
                              display1 =
                                  "$display1\nRead ${mFrameDataList.length} Data";
                            });
                          },
                          child: const Text("Read Excel Data"),
                        ),
                        TextButton(
                          onPressed: () async {
                            setFirebaseStorageFile(
                                "FrameData/", "FrameData_Read.xlsx");
                          },
                          child: const Text("Download"),
                        ),
                        TextButton(
                          onPressed: () async {
                            myFirestore.uploadFrameData(mFrameDataList);
                          },
                          child: const Text("Upload FrameData"),
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
