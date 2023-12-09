//flutter package
import 'package:combo_maker/json/framedata.dart';
import 'package:flutter/foundation.dart';

//firebase package
import 'package:cloud_firestore/cloud_firestore.dart';

//My package
import '../common/constants.dart';
//import '../common/moves.dart';

class MyFirestore {
  //定数定義
  final String firestoreDefaultDocumentPath = "";

  //Static変数定義
  static String firestoreCurrentDocumentPath = '';
  static DocumentReference<Map<String, dynamic>>? firestoreWriteDocumentObject;
  static CollectionReference<Map<String, dynamic>>?
      firestoreCurrentCollectionObject;
  MyFirestore() {
    firestoreCurrentDocumentPath = firestoreDefaultDocumentPath;
  }

  // //データを書き込むドキュメントを開く関数
  // CollectionReference<Map<String, dynamic>> openFirestoreField(
  //     String characterID) {
  //   final collectionRef = FirebaseFirestore.instance
  //       .collection(collectionNameGames)
  //       .doc(documentNameSF6)
  //       .collection(collectionNameCharacters)
  //       .doc(characterID)
  //       .collection(collectionNameFrameData);

  //   return collectionRef;
  // }

  CollectionReference<Map<String, dynamic>> openFirestoreCollection(
      String characterID) {
    final collectionRef = FirebaseFirestore.instance
        .collection(collectionNameGames)
        .doc(documentNameSF6)
        .collection(collectionNameCharacters)
        .doc(characterID)
        .collection(collectionNameFrameData);
    return collectionRef;
  }

  writefirestoreField(
      CollectionReference<Map<String, dynamic>> firestoreCollecton,
      FrameData mFrameData) {
    // String documentID = mFrameData.command1;
    // if (mFrameData.command2 != "-") {
    //   documentID += mFrameData.command2;
    //   if (mFrameData.command3 != "-") {
    //     documentID += mFrameData.command3;
    //     if (mFrameData.command4 != "-") {
    //       documentID += mFrameData.command4;
    //     }
    //}
    //}
    String documentID = mFrameData.moveName;
    final firestoreDocumentField = <String, String>{
      frameDataNameList[0]: '',
      frameDataNameList[1]: '',
      frameDataNameList[2]: '',
      frameDataNameList[3]: '',
      frameDataNameList[4]: '',
      frameDataNameList[5]: mFrameData.moveName,
      frameDataNameList[6]: mFrameData.startUp.toString(),
      frameDataNameList[7]: mFrameData.active.toString(),
      frameDataNameList[8]: mFrameData.recovery.toString(),
      frameDataNameList[9]: mFrameData.hitStun.toString(),
      frameDataNameList[10]: mFrameData.blockStun.toString(),
      frameDataNameList[11]: mFrameData.cancelType,
      frameDataNameList[12]: mFrameData.damage.toString(),
      frameDataNameList[13]: mFrameData.scaling.toString(),
      frameDataNameList[14]: mFrameData.dGageUp.toString(),
      frameDataNameList[15]: mFrameData.dGageDown.toString(),
      frameDataNameList[16]: mFrameData.dGageCounter.toString(),
      frameDataNameList[17]: mFrameData.sGageUp.toString(),
      frameDataNameList[18]: mFrameData.detail
    };

    firestoreCollecton.doc(documentID).set(firestoreDocumentField);
  }

  uploadFrameData(List<FrameData> mFrameDataList) {
    //test用フロー
    try {
      //AKIのフレームデータドキュメントを開く
      firestoreCurrentCollectionObject =
          openFirestoreCollection(documentNameAKI);
      for (int i = 0; i < mFrameDataList.length; i++) {
        //フレームデータを書き込み
        writefirestoreField(
            firestoreCurrentCollectionObject!, mFrameDataList[i]);
      }
      // ignore: unused_catch_clause
    } on FirebaseException catch (e) {
      //exceptionが発生した場合のことをかく
      // ignore: use_build_context_synchronously
      if (kDebugMode) {
        print('Error');
      }
    }
  }
}
