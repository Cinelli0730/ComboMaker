import 'package:flutter/foundation.dart';
import 'constants.dart';

class InputCheck {
  InputCheck();
  bool judge(List<List> moveTable, var input) {
    //const int commandLength = 3;
    int moveLength = moveTable.length; //フレームデータ内のMove数
    for (int i = 0; i < moveLength; i++) {
      for (int j = 0; j < commandLength; j++) {
        if (moveTable[i][j].value.toString() == '-') {
          //1以上の長さのコマンドを認識していて入力なしを読み込むとtrueを返す
          if (j != 0) {
            return true;
          } else {
            break;
          }
        }
        if (kDebugMode) {
          print(moveTable[i][j].value.toString());
        }
        if (kDebugMode) {
          print(moveTable[i][j].value);
        }
        if (kDebugMode) {
          print(moveTable[i][j]);
        }
      }
    }
    return false;
  }
}
