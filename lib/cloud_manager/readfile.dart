import 'dart:convert';
//import 'dart:ffi';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import '../inputcheck.dart';
//import '../common/moves.dart';
import '../json/framedata.dart';

// Import a csv flie
Future<List<List>> importCsv(String folderName, String fileName) async {
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

void main() async {
  //テストシナリオ判別用定数
  const int testInputCheck = 1;
  //const int setCloud = 2;
  const int testConvertExcel = 3;

  const String importPath = 'data/';
  const String fileName = 'FrameData_Read.xlsx';
  //const String fileName = 'FrameData_Read.csv';
  const String sheetName = 'A.K.I.';
  String input = 'MP';

  //テストシナリオ設定
  int scenarioMain = testConvertExcel;

  //InputCheckクラス検証用
  if (scenarioMain == testInputCheck) {
    InputCheck inputCheck = InputCheck();

    var excel = await importExcel(importPath, fileName, sheetName);
    //var csv = await importCsv(importPath, fileName);
    bool result = inputCheck.judge(excel, input);
    //bool result = inputCheck.judge(csv, input);
    if (kDebugMode) {
      //print(csv);
      //print(excel);
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
    //フレームデータの入ったEXCELファイル読み込み
    var excel = await importExcel(importPath, fileName, sheetName);
    // ignore: unused_local_variable
    List<FrameData> moveList = readFrameData(excel);
  }
}