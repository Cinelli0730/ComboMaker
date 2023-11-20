import 'package:flutter/material.dart';
import 'constants.dart';

class Move {
  String moveName = ''; //技名
  int startUp = 0; //発生フレーム
  int active = 0; //持続フレーム
  int recovery = 0; //硬直フレーム
  int hitStun = 0; //ヒット時の硬直差
  int blockStun = 0; //ガード時の硬直差
  String cancelType = ''; //キャンセルタイプ
  int damage = 0; //単発ダメージ量
  int scaling = 0; //補正
  int dGageUp = 0; //ドライブゲージ増加量
  int dGageDown = 0; //ドライブゲージ減少量（ガード時）
  int dGageCounter = 0; //ドライブゲージ減少量（パニッシュカウンター時）
  int sGageUp = 0; //SAゲージ増加量
  String properties = ''; //上・中・下段 or 投げ
  String detail = ''; //備考
}

List<Move> readFrameData(List<List> frameData) {
  late List<Move> moves = List.empty();
  for (int i = 0; i < frameData.length; i++) {
    moves = moves.toList();
    moves.add(list2Move(frameData[i]));
  }
  return moves;
}

Move list2Move(List moveData) {
  Move move = Move();

  move.moveName = moveData[indexMoveName].value.toString();
  move.startUp = var2int(moveData[indexStartUp].value.toString());
  //H27がNULLになる
  move.active = convertActiveVlue(moveData[indexActive].value.toString());
  move.recovery =
      convertRecoveryValue(moveData[indexRecovery].value.toString());
  move.hitStun = convertHitStunValue(moveData[indexHitStun].value.toString());
  move.blockStun = var2int(moveData[indexBlockStun].value.toString());
  move.cancelType = moveData[indexCancel].value.toString();
  move.damage = var2int(moveData[indexDamage].value.toString());
  move.scaling = convertScalingValue(moveData[indexScaling].value.toString());
  move.dGageUp = var2int(moveData[indexDGageUp].value.toString());
  move.dGageDown = var2int(moveData[indexDGageDown].value.toString());
  move.dGageCounter = var2int(moveData[indexDGageCounter].value.toString());
  move.sGageUp = var2int(moveData[indexSAGageUp].value.toString());
  move.properties = moveData[indexProperties].value.toString();
  move.detail = moveData[indexDetail].value.toString();

  return move;
}

int var2int(var value) {
  int result = 0;
  if (value.runtimeType == String) {
    if (value == "-") {
      result = 0;
    } else {
      value = removeWords(value, ["※", " "]);
      result = int.parse(value.toString().trim());
    }
  } else {
    result = value;
  }
  return result;
}

//エラーの場合-1を返す
int convertActiveVlue(String activeValue) {
  int result = 0;
  String tmp;
  tmp = removeWords(activeValue, ["-", "※", " "]);
  if (tmp.isEmpty) {
    result = 0;
  } else {
    result = int.parse(tmp);
  }
  /*
  if (activeValue.length <= 1) {
    result = int.parse(activeValue);
  } else {
    List<String> activeFrame = activeValue.split('-');
    if (activeFrame.length != 2) {
      result = -1;
    } else {
      result = int.parse(activeFrame[1]) - int.parse(activeFrame[0]) + 1;
    }
  }
  */
  return result;
}

//エラーの場合-1を返す
//威力増加の場合+,減少の場合は-の値 (補正タイプ項目の追加とともに改善予定)
int convertScalingValue(String scalingValue) {
  int result = 0;
  int sign = 0;
  if ((scalingValue == "") || (scalingValue.trim() == "-")) {
    result = 100;
  } else {
    if (true == scalingValue.contains("乗算")) {
      sign = -1;
    } else {
      sign = 1;
    }
    List<String> annoyWords = [
      "乗算",
      "即時",
      "始動",
      "コンボ",
      "※",
      "補正",
      "  % ".trim(),
      "  ％ ".trim(),
    ];
    String tmp = removeWords(scalingValue, annoyWords);
    result = int.parse(tmp.trim());
  }
  return sign * result;
}

//ダウンの場合10000を返す
int convertHitStunValue(String hitStunValue) {
  int result = 0;
  if (hitStunValue == 'D') {
    result = 10000;
  }
  return result;
}

int convertRecoveryValue(String recoveryValue) {
  int result = 0;
  List<String> annoyWords = ["着地後", "全体", "※", "-"];
  String tmp = removeWords(recoveryValue, annoyWords);
  if (tmp.isEmpty) {
    result = 0;
  } else {
    result = int.parse(tmp.trim());
  }
  return result;
}

String removeWords(String text, List<String> words) {
  for (int i = 0; i < words.length; i++) {
    text = text.replaceAll(words[i], "");
  }
  return text;
}