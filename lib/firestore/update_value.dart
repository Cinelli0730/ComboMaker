import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'set_data.dart';

class _MyFirestorePageState extends State<MyFirestorePage> {
  /* --- 省略 --- */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            //ElevatedButton( /* --- 省略 --- */ ),
            //ElevatedButton( /* --- 省略 --- */ ),
            //ElevatedButton( /* --- 省略 --- */ ),
            const Column(/* --- 省略 --- */),
            //ElevatedButton( /* --- 省略 --- */ ),
            const ListTile(/* --- 省略 --- */),
            ElevatedButton(
              child: const Text('ドキュメント更新'),
              onPressed: () async {
                // ドキュメント更新
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc('id_abc')
                    .update({'age': 41});
              },
            ),
          ],
        ),
      ),
    );
  }
}
