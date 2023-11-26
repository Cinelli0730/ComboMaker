//flutter package
import 'package:flutter/foundation.dart';

//firebase package
import 'package:cloud_firestore/cloud_firestore.dart';

//My package
import '../common/constants.dart';
import '../common/moves.dart';

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
      CollectionReference<Map<String, dynamic>> firestoreCollecton, Move move) {
    String documentID = move.command1;
    if (move.command2 != "-") {
      documentID += move.command2;
      if (move.command3 != "-") {
        documentID += move.command3;
        if (move.command4 != "-") {
          documentID += move.command4;
        }
      }
    }
    final firestoreDocumentField = <String, String>{
      frameDataNameList[0]: '',
      frameDataNameList[1]: '',
      frameDataNameList[2]: '',
      frameDataNameList[3]: '',
      frameDataNameList[4]: '',
      frameDataNameList[5]: move.moveName,
      frameDataNameList[6]: move.startUp.toString(),
      frameDataNameList[7]: move.active.toString(),
      frameDataNameList[8]: move.recovery.toString(),
      frameDataNameList[9]: move.hitStun.toString(),
      frameDataNameList[10]: move.blockStun.toString(),
      frameDataNameList[11]: move.cancelType,
      frameDataNameList[12]: move.damage.toString(),
      frameDataNameList[13]: move.scaling.toString(),
      frameDataNameList[14]: move.dGageUp.toString(),
      frameDataNameList[15]: move.dGageDown.toString(),
      frameDataNameList[16]: move.dGageCounter.toString(),
      frameDataNameList[17]: move.sGageUp.toString(),
      frameDataNameList[18]: move.detail
    };

    firestoreCollecton.doc(documentID).set(firestoreDocumentField);
  }

  uploadFrameData(List<Move> moveList) {
    Move move = moveList[0];

    //test用フロー
    try {
      //AKIのフレームデータドキュメントを開く
      firestoreCurrentCollectionObject =
          openFirestoreCollection(documentNameAKI);
      //フレームデータを書き込み
      writefirestoreField(firestoreCurrentCollectionObject!, move);
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
