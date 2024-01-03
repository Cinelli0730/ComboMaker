//flutter package
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//firebase package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_options.dart';

//My package
import 'cloud_manager/readfile.dart';
import 'common/constants.dart';
//import 'common/moves.dart';
import 'firestore/firestore.dart';
import 'package:combo_maker/json/framedata.dart';

final pageNumProvider = StateProvider<double>((ref) => -1.0);
final displayComboProvider = StateProvider<String>((ref) => "");

class ComboMaker2 extends ConsumerStatefulWidget {
  const ComboMaker2({super.key});

  @override
  ConsumerState<ComboMaker2> createState() => _SetDataState();
}

class _SetDataState extends ConsumerState<ComboMaker2> {
  String appDefaultPath = "";
  String display1 = 'path = ';
  String display2 = 'Firebase Document';
  List<DocumentSnapshot> documentList = [];

  //double? _deviceWidth, _deviceHeight;

  //ファイル読み込み用
  String downloadFolderPath = '';
  String downloadFileFullPath = '';
  String fileName = fileFrameData;
  String sheetName = 'A.K.I.';
  List<List<dynamic>> readExcel =
      List.empty(); // = await importExcel(importPath, fileName, sheetName);
  File? file;
  Directory? appDocDir;
  Uint8List? byteDlFile;
  Uint8List? byteLocalFile;
  String displayCombo = "";
  List<FrameData> mFrameDataList = List.empty();

  //firestore用
  MyFirestore myFirestore = MyFirestore();

  _SetDataState();
  void buttonPressed(String text) {
    setState(() {
      displayCombo += text;
    });
  }

  @override
  Widget build(BuildContext context) {
    CarouselController buttonCarouselController = CarouselController();
    //final _deviceWidth = MediaQuery.of(context).size.width; //画面の横幅
    final _deviceHeight = MediaQuery.of(context).size.height; //画面の縦幅
    final dataList = [
      [
        "5LP",
        "5LK",
        "5MP",
        "5MK",
        "5HP",
        "5HK",
        "2LP",
        "2LK",
        "2MP",
        "2MK",
        "2HP",
        "2HK",
        "5LP>5LP",
        "5HP>5HP"
      ],
      // [
      //   "ジャンプ弱P （空蛇突）",
      //   "ジャンプ弱K （空蛇蹴）",
      //   "ジャンプ中P （回旋蛇）",
      //   "ジャンプ中K （蛇天蹴）",
      //   "ジャンプ強P （騰空双蛇突）",
      //   "ジャンプ強K （騰空双蹴蛇）",
      //   "蒲牢",
      //   "?吻",
      //   "囚牛",
      //   "蚣蝮",
      //   "渾沌 （2段目）",
      //   "窮奇 （2段目）",
      // ],
      [
        "⇩⇘⇨P",
        "↓↘→K",
        "↓↙←P",
        "↓↙←K",
        "↓PP",
        "↓PP>P",
        "↓PP>K",
        "↓PP>PK",
      ],
      [
        "SA1 死屍累々",
        "SA2 紫煙裂爪",
        "SA3 睚眦",
        "CA 睚眦",
      ],
      [
        "贔屓",
        "饕餮",
        "前方ステップ",
        "後方ステップ",
        "ドライブインパクト （鑿歯）",
        "ドライブリバーサル （封豕）",
        "ドライブパリィ",
        "ジャストパリィ（打撃）",
        "ジャストパリィ（飛び道具）",
        "パリィドライブラッシュ",
        "キャンセルドライブラッシュ",
      ]
    ];
    List<List<FrameData>> testFrameDataList = List.empty(growable: true);
    for (int i = 0; i < dataList.length; i++) {
      testFrameDataList.add(List.empty(growable: true));
      for (int j = 0; j < dataList[i].length; j++) {
        FrameData mFrameData = FrameData();
        mFrameData.moveName = dataList[i][j];
        testFrameDataList[i].add(mFrameData);
      }
    }
    return Directionality(
        textDirection: TextDirection.ltr,
        //body: SafeArea(
        child: Scaffold(
            body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: _deviceHeight * 0.55,
                width: double.infinity,
                child: Container(
                  color: Colors.black,
                  constraints: const BoxConstraints.tightForFinite(
                      width: double.infinity),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Consumer(
                        builder: (context, ref, child) {
                          return Text(
                            ref.watch(displayComboProvider),
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 30,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: _deviceHeight * 0.05,
                child: Consumer(builder: (context, ref, child) {
                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.yellow,
                          constraints: const BoxConstraints.tightForFinite(
                              width: double.infinity),
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () =>
                                buttonCarouselController.jumpToPage(0),
                            child: const Text("通常技"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.red,
                          constraints: const BoxConstraints.tightForFinite(
                              width: double.infinity),
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () =>
                                buttonCarouselController.jumpToPage(1),
                            child: const Text("特殊技"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.blue,
                          constraints: const BoxConstraints.tightForFinite(
                              width: double.infinity),
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () =>
                                buttonCarouselController.jumpToPage(2),
                            child: const Text("必殺技"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.green,
                          constraints: const BoxConstraints.tightForFinite(
                              width: double.infinity),
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () =>
                                buttonCarouselController.jumpToPage(3),
                            child: const Text("通常行動"),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              Consumer(
                builder: (context, ref, child) {
                  return AnimatedAlign(
                    alignment: Alignment(ref.watch(pageNumProvider), 0),
                    duration: const Duration(milliseconds: 1),
                    child: Container(
                      color: Colors.green,
                      height: 5.0,
                      width: MediaQuery.of(context).size.width / 4,
                    ),
                  );
                },
              ),
              Consumer(
                builder: (context, ref, child) {
                  return Column(
                    children: [
                      CarouselSlider(
                        carouselController: buttonCarouselController,
                        options: CarouselOptions(
                          //enableInfiniteScroll: false,
                          height: _deviceHeight * 0.3,
                          viewportFraction: 1,
                          onScrolled: (value) {
                            double revalue = value! % 4;
                            double result = (revalue * 2 / 3 - 1);
                            //stateは-1～+1,resultは0～item要素数の間で変化する
                            ref
                                .read(pageNumProvider.notifier)
                                .update((state) => result);
                          },
                        ),
                        // このitemsの中に表示したいウィジェットを入れてください。
                        items: [
                          Page(
                            name: 'Page1',
                            frameDataList: testFrameDataList[0],
                            btnCarouselController: buttonCarouselController,
                          ),
                          Page(
                            name: 'Page2',
                            frameDataList: testFrameDataList[1],
                            btnCarouselController: buttonCarouselController,
                          ),
                          Page(
                            name: 'Page3',
                            frameDataList: testFrameDataList[2],
                            btnCarouselController: buttonCarouselController,
                          ),
                          Page(
                            name: 'Page4',
                            frameDataList: testFrameDataList[3],
                            btnCarouselController: buttonCarouselController,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        )));
    //);
  }

  void getDocumentList() async {
    List<String> dataList = List.empty();
    final collectionRef = FirebaseFirestore.instance
        .collection("StreetFighter6")
        .doc("Contents")
        .collection("Characters"); // CollectionReference
    final querySnapshot = await collectionRef.get(); // QuerySnapshot
    final queryDocSnapshot = querySnapshot.docs; // List<QueryDocumentSnapshot>
    for (final snapshot in queryDocSnapshot) {
      dataList = dataList.toList();
      dataList.add(snapshot.data().toString()); // `data()`で中身を取り出す
    }
  }

  void getPath() async {
    appDefaultPath = await _localPath;
    setState(() {
      display1 = display1 + appDefaultPath;
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}

class Page extends StatelessWidget {
  final String name;
  final List<FrameData> frameDataList;
  final CarouselController btnCarouselController;
  const Page(
      {super.key,
      required this.name,
      required this.frameDataList,
      required this.btnCarouselController});
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = List.empty();
    //画面サイズを取得
    final _deviceWidth = MediaQuery.of(context).size.width; //画面の横幅
    final _deviceHeight = MediaQuery.of(context).size.height; //画面の縦幅
    for (int i = 0; i < frameDataList.length; i++) {
      widgetList = widgetList.toList();
      widgetList.add(BtnParts(name: frameDataList[i].moveName));
    }
    return Row(
      children: [
        // SizedBox(
        //   height: double.infinity,
        //   width: _deviceWidth * 0.05,
        //   child: TextButton(
        //     onPressed: () => btnCarouselController.previousPage(
        //         duration: const Duration(milliseconds: 1),
        //         curve: Curves.linear),
        //     child: const Text("<"),
        //   ),
        // ),
        SizedBox(
          width: _deviceWidth, // * 0.9, //* 70 / 100,
          height: _deviceHeight * 0.5,
          //color: kWhite,
          child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: widgetList),
        ),
        // SizedBox(
        //   height: double.infinity,
        //   width: _deviceWidth * 0.05,
        //   child: TextButton(
        //     onPressed: () => btnCarouselController.nextPage(
        //         duration: const Duration(milliseconds: 1),
        //         curve: Curves.linear),
        //     child: const Text(">"),
        //   ),
        // ),
      ],
    );
  }
}

class BtnParts extends ConsumerWidget {
  final String name;
  static String comboDisplay = "";
  const BtnParts({super.key, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //画面サイズを取得
    final _deviceWidth = MediaQuery.of(context).size.width; //画面の横幅
    final _deviceHeight = MediaQuery.of(context).size.height; //画面の縦幅
    final _btnRowNum = 5;
    return Consumer(
      builder: (context, ref, child) {
        return SizedBox(
          width: _deviceWidth / 4, //* 0.9,
          height: _deviceHeight / (4 * _btnRowNum + 1),
          // child: Text(
          //   name,
          //   style: const TextStyle(color: Colors.black),
          //)
          // child: FittedBox(
          //   fit: BoxFit.fitHeight,
          child: TextButton(
            onPressed: () {
              comboDisplay = ref.read(displayComboProvider);
              if (comboDisplay == "") {
                ref.read(displayComboProvider.notifier).update((state) => name);
              } else {
                ref
                    .read(displayComboProvider.notifier)
                    .update((state) => "$state->$name");
              }
            },
            style: TextButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0))
                //padding: const EdgeInsets.all(0),
                //textStyle: TextStyle(color: Colors.black),
                ),
            child: Text(
              name,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          //),
        );
      },
    );
  }
}

void main(List<String> args) {
  runApp(const ProviderScope(child: ComboMaker2()));
}
