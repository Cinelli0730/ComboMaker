import 'dart:convert';
//import 'dart:ffi';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import '../inputcheck.dart';
import '../common/moves.dart';

// Import a csv flie
Future<List<List>> csvImport(String folderName, String fileName) async {
  //const String importPath = 'data/FrameData.csv';
  //final File importFile = File(importPath);
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

Future<List<List>> excelImport(
    String folderName, String fileName, String sheetName) async {
  String importPath = folderName + fileName; //'data/FrameData_Read.xlsx';
  //final File importFile = File(importPath);
  var bytes = File(importPath).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  List<List> importList = [];

  for (int line = 0; line < excel.tables[sheetName]!.rows.length; line++) {
    var rowData = excel.tables[sheetName]?.rows[line];
    for (int row = 0; row < rowData!.length; row++) {
      Data? data = rowData[row];
      Data? nullReplace;
      if (rowData[row]?.value == null) {
        rowData[row] ??= rowData[0];
        rowData[row]!.value = "0";
      }
      //var data = rowData[row]!.value;
      if (data != null) {
        //debugPrint(data.value); // 表示確認用
      }
    }
    importList.add(rowData);
  }

  return Future<List<List>>.value(importList);
}

void main() async {
  //テストシナリオ判別用定数
  const int testInputCheck = 1;
  const int setCloud = 2;
  const int testConvertExcel = 3;

  const String importPath = 'data/'; //FrameData_Read.xlsx';
  const String fileName = 'FrameData_Read.xlsx';
  //const String fileName = 'FrameData_Read.csv';
  const String sheetName = 'A.K.I.';
  String input = 'MP';

  //テストシナリオ設定
  int scenarioMain = testConvertExcel;

  //InputCheckクラス検証用
  if (scenarioMain == testInputCheck) {
    InputCheck inputCheck = InputCheck();

    //final csv = await csvImport();
    var excel = await excelImport(importPath, fileName, sheetName);
    //var csv = await csvImport(importPath, fileName);
    if (kDebugMode) {
      //print(csv);
      //print(excel);
      bool result = inputCheck.judge(excel, input);
      //bool result = inputCheck.judge(csv, input);
      print(result);
      if (result == true) {
        print('yatta-');
      } else {
        print('kuso-');
      }
    }
  }

  //Excelファイルデータ変換処理テスト用
  if (scenarioMain == testConvertExcel) {
    //late List<Move> moveList = List.empty();
    //フレームデータの入ったEXCELファイル読み込み
    var excel = await excelImport(importPath, fileName, sheetName);
    // ignore: unused_local_variable
    List<Move> moveList = readFrameData(excel);
  }
}
