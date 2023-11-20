import 'package:combo_maker/manage_cloud/readfile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:combo_maker/common/constants.dart';
//import 'package:math_expressions/math_expressions.dart';
//import 'form_9_6button.dart';
import 'package:path_provider/path_provider.dart';
import 'common/moves.dart';

class ComboMaker extends StatefulWidget {
  const ComboMaker({super.key});

  @override
  State<ComboMaker> createState() => _SetDataState();
}

class _SetDataState extends State<ComboMaker> {
  var result = '';
  var inputUser = '';
  String directory = "";
  String path = "";
  String path1 = "";
  String display = 'path = ';
  //double? _deviceWidth, _deviceHeight;

  //ファイル読み込み用
  //将来消す
  String importPath =
      "D:\\program\\flutter_projct\\combo_maker\\data"; //'data/'; //FrameData_Read.xlsx';
  String fileName = 'FrameData_Read.xlsx';
  String sheetName = 'A.K.I.';
  String input = 'MP';
  //入力判定用クラス
  //InputCheck inputCheck = InputCheck();
  var readExcel; // = await excelImport(importPath, fileName, sheetName);

  _SetDataState() {
    //ファイル読み込み
    //readExcel = excelImport(importPath, fileName, sheetName);
  }

  void getPath() async {
    path = await _localPath;
    setState(() {
      display = display + path;
      if (kDebugMode) {
        //print(path);
      }
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void buttonPressed(String text) {
    setState(() {
      inputUser = inputUser + text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kBlack,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                //flex: flexRatioDisplayCombo,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  color: kRed,
                  child: Text(
                    display,
                    style: const TextStyle(
                      backgroundColor: kBlack,
                      color: kWhite,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  getPath();
                },
                child: const Text("Path Set"),
              ),
              TextButton(
                onPressed: () async {
                  //フレームデータの入ったEXCELファイル読み込み
                  readExcel =
                      //await excelImport(importPath, fileName, sheetName);
                      await excelImport("$path\\", fileName, sheetName);
                  // ignore: unused_local_variable
                  List<Move> moveList = readFrameData(readExcel);
                },
                child: const Text("Read Excel Data"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const ComboMaker());
}
