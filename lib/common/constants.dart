import 'package:flutter/material.dart';

const Color kBackground = Color(0xFF121212);
const Color kLightGray = Color(0xFFB7B7B7);
const Color kDarkGray = Color(0xFF414141);
const Color kRed = Color(0xFFB60000);
const Color kAmber = Color(0xFFf7921e);
const Color kBlue = Colors.blue;

const Color kBlack = Color(0x00000000);
const Color kWhite = Color(0xFFFFFFFF);

//入力用ボタンの行数、列数
const int lineMax = 3;
const int rowMax = 6;

//入力中のコンボ確認画面のサイズ比
const double ratioDisplayCombo = 0.4;
//入力中の技確認画面のサイズ比
const double ratioDisplayArts = 0.2;
//入力用ボタンのサイズ比
const double ratioInputButtons = 0.4;

//入力中のコンボ確認画面のサイズ比
const int flexRatioDisplayCombo = 4;
//入力中の技確認画面のサイズ比
const int flexRatioDisplayArts = 2;
//入力用ボタンのサイズ比
const int flexRatioInputButtons = 4;

//コマンドの入力の長さ
const int commandLength = 5;

//フレームデータの列インデックス
const int indexCommand1 = 0;
const int indexCommand2 = 1;
const int indexCommand3 = 2;
const int indexCommand4 = 3;
const int indexCommand5 = 4;
const int indexMoveName = 5;
const int indexStartUp = 6;
const int indexActive = 7;
const int indexRecovery = 8;
const int indexHitStun = 9;
const int indexBlockStun = 10;
const int indexCancel = 11;
const int indexDamage = 12;
const int indexScaling = 13;
const int indexDGageUp = 14;
const int indexDGageDown = 15;
const int indexDGageCounter = 16;
const int indexSAGageUp = 17;
const int indexProperties = 18;
const int indexDetail = 19;

const List<String> listCharacter = <String>['A.K.I.', 'RASHID'];
const List<String> listTypeCM = <String>['CLASSIC', 'MODERN'];
const List<String> listMove = <String>['通常技', '特殊技', '必殺技', 'SA', '共通行動'];
