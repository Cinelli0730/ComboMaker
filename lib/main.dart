import 'package:flutter/material.dart';
//import 'package:combo_maker/constants.dart';
//import 'package:math_expressions/math_expressions.dart';
import 'form_9_6button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ComboMaker());
}
