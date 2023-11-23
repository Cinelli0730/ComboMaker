// File generated by FlutterFire CLI.

// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

import 'package:flutter/foundation.dart'

    show defaultTargetPlatform, kIsWeb, TargetPlatform;


/// Default [FirebaseOptions] for use with your Firebase apps.

///

/// Example:

/// ```dart

/// import 'firebase_options.dart';

/// // ...

/// await Firebase.initializeApp(

///   options: DefaultFirebaseOptions.currentPlatform,

/// );

/// ```

class DefaultFirebaseOptions {

  static FirebaseOptions get currentPlatform {

    if (kIsWeb) {

      return web;

    }

    switch (defaultTargetPlatform) {

      case TargetPlatform.android:

        return android;

      case TargetPlatform.iOS:

        return ios;

      case TargetPlatform.macOS:

        return macos;

      case TargetPlatform.windows:

        throw UnsupportedError(

          'DefaultFirebaseOptions have not been configured for windows - '

          'you can reconfigure this by running the FlutterFire CLI again.',

        );

      case TargetPlatform.linux:

        throw UnsupportedError(

          'DefaultFirebaseOptions have not been configured for linux - '

          'you can reconfigure this by running the FlutterFire CLI again.',

        );

      default:

        throw UnsupportedError(

          'DefaultFirebaseOptions are not supported for this platform.',

        );

    }

  }


  static const FirebaseOptions web = FirebaseOptions(

    apiKey: 'AIzaSyCir-13iJX6rbNNtPzxLExGWdoQfqJHlhU',

    appId: '1:261163419236:web:7ae5705a48ab7656abc171',

    messagingSenderId: '261163419236',

    projectId: 'combomaker-40efc',

    authDomain: 'combomaker-40efc.firebaseapp.com',

    storageBucket: 'combomaker-40efc.appspot.com',

    measurementId: 'G-H1MMHQSET2',

  );


  static const FirebaseOptions android = FirebaseOptions(

    apiKey: 'AIzaSyDoyeArrBjH05DqUepqiHgTGf_dYKVcCKw',

    appId: '1:261163419236:android:ecad6d33e9e8ef8babc171',

    messagingSenderId: '261163419236',

    projectId: 'combomaker-40efc',

    storageBucket: 'combomaker-40efc.appspot.com',

  );


  static const FirebaseOptions ios = FirebaseOptions(

    apiKey: 'AIzaSyAp-UILV55kLl00j2SkfHaP-7Gz9mtTndk',

    appId: '1:261163419236:ios:590e5b467b513eafabc171',

    messagingSenderId: '261163419236',

    projectId: 'combomaker-40efc',

    storageBucket: 'combomaker-40efc.appspot.com',

    iosBundleId: 'com.example.comboMaker',

  );


  static const FirebaseOptions macos = FirebaseOptions(

    apiKey: 'AIzaSyAp-UILV55kLl00j2SkfHaP-7Gz9mtTndk',

    appId: '1:261163419236:ios:0fe23e07e5cc0a4fabc171',

    messagingSenderId: '261163419236',

    projectId: 'combomaker-40efc',

    storageBucket: 'combomaker-40efc.appspot.com',

    iosBundleId: 'com.example.comboMaker.RunnerTests',

  );

}

