import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'set_data.dart';

//setdata
Future<void> main() async {
  // Fireabse初期化
  await Firebase.initializeApp();
  runApp(const MyApp());
}
