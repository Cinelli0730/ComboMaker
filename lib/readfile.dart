import 'dart:convert';
//import 'dart:ffi';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'inputcheck.dart';

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
    var rowData = excel.tables[sheetName]!.rows[line];
    for (int row = 0; row < rowData.length; row++) {
      Data? data = rowData[row];
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
  const String importPath = 'data/'; //FrameData_Read.xlsx';
  const String fileName = 'FrameData_Read.xlsx';
  //const String fileName = 'FrameData_Read.csv';
  const String sheetName = 'A.K.I.';
  String input = 'MP';

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
