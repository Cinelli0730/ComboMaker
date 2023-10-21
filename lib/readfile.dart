import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

// Import a csv flie
Future<List<List>> csvImport() async {
  const String importPath = 'data/FrameData.xlsx';
  final File importFile = File(importPath);
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

Future<List<List>> excelImport() async {
  const String importPath = 'data/FrameData_Read.xlsx';
  //final File importFile = File(importPath);
  var bytes = File(importPath).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  List<List> importList = [];

  for (int line = 0; line < excel.tables['Sheet1']!.rows.length; line++) {
    var rowData = excel.tables['Sheet1']!.rows[line];
    for (int row = 0; row < rowData.length; row++) {
      Data? data = rowData[row];
      if (data != null) {
        //debugPrint(data.value); // 表示確認用
      }
    }
    importList.add(rowData);
  }

  return Future<List<List>>.value(importList);
}

void main() async {
  //final csv = await csvImport();
  var excel = await excelImport();
  if (kDebugMode) {
    //print(csv);
    print(excel);
  }
}
