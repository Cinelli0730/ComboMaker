import 'package:combo_maker/manage_cloud/readfile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:combo_maker/common/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'common/moves.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
  String fileName = 'FrameData_Read.xlsx';
  String sheetName = 'A.K.I.';
  String input = 'MP';
  var readExcel; // = await excelImport(importPath, fileName, sheetName);

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
                        )
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
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ComboMaker());
}
