import 'package:flutter/material.dart';
import 'package:combo_maker/constants.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const ComboMaker());
}

class ComboMaker extends StatefulWidget {
  const ComboMaker({super.key});

  @override
  State<ComboMaker> createState() => _ComboMakerState();
}

class _ComboMakerState extends State<ComboMaker> {
  var result = '';
  var inputUser = '';
  double? _deviceWidth, _deviceHeight;

  void buttonPressed(String text) {
    setState(() {
      inputUser = inputUser + text;
    });
  }

  Widget getRow(String text1, String text2, String text3, String text4,
      String text5, String text6) {
    //画面サイズを取得
    _deviceWidth = MediaQuery.of(context).size.width; //画面の横幅
    _deviceHeight = MediaQuery.of(context).size.height; //画面の縦幅
    debugPrint('width: $_deviceWidth' 'height: $_deviceHeight');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: _deviceWidth! / rowMax, //横幅
          //height: _deviceHeight! * ratioInputButtons / lineMax, //高さ
          child: RawMaterialButton(
            onPressed: () {
              if (text1 == 'AC') {
                setState(() {
                  inputUser = '';
                  result = '';
                });
              } else {
                buttonPressed(text1);
              }
            },
            elevation: 2.0,
            fillColor: getButtonColor(text1),
            padding: const EdgeInsets.all(20.0),
            shape: const CircleBorder(),
            child: Text(
              text1,
              style: TextStyle(
                  color: getTextColor(text1),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          width: _deviceWidth! / rowMax, //横幅
          //height: _deviceHeight! * ratioInputButtons / lineMax, //高さ
          child: RawMaterialButton(
            onPressed: () {
              if (text2 == 'CE') {
                setState(() {
                  if (inputUser.isNotEmpty) {
                    inputUser = inputUser.substring(0, inputUser.length - 1);
                  }
                });
              } else {
                buttonPressed(text2);
              }
            },
            elevation: 2.0,
            fillColor: getButtonColor(text2),
            padding: const EdgeInsets.all(20.0),
            shape: const CircleBorder(),
            child: Text(
              text2,
              style: TextStyle(
                  color: getTextColor(text2),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          width: _deviceWidth! / rowMax, //横幅
          //height: _deviceHeight! * ratioInputButtons / lineMax, //高さ
          child: RawMaterialButton(
            onPressed: () {
              buttonPressed(text3);
            },
            elevation: 2.0,
            fillColor: getButtonColor(text3),
            padding: const EdgeInsets.all(20.0),
            shape: const CircleBorder(),
            child: Text(
              text3,
              style: TextStyle(
                  color: getTextColor(text3),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
            width: _deviceWidth! / rowMax, //横幅
            //height: _deviceHeight! * ratioInputButtons / lineMax, //高さ
            child: RawMaterialButton(
              onPressed: () {
                if (text4 == '=') {
                  Parser parser = Parser();
                  Expression expression = parser.parse(inputUser);
                  ContextModel contextModel = ContextModel();
                  double eval =
                      expression.evaluate(EvaluationType.REAL, contextModel);

                  setState(() {
                    result = eval.toString();
                  });
                } else {
                  buttonPressed(text4);
                }
              },
              elevation: 2.0,
              fillColor: getButtonColor(text4),
              padding: const EdgeInsets.all(15.0),
              shape: const CircleBorder(),
              child: Text(
                text4,
                style: const TextStyle(
                    fontSize: 30, color: kWhite, fontWeight: FontWeight.bold),
              ),
            )),
        SizedBox(
          width: _deviceWidth! / rowMax, //横幅
          //height: _deviceHeight! * ratioInputButtons / lineMax, //高さ
          child: RawMaterialButton(
            onPressed: () {
              if (text5 == 'AC') {
                setState(() {
                  inputUser = '';
                  result = '';
                });
              } else {
                buttonPressed(text5);
              }
            },
            elevation: 2.0,
            fillColor: getButtonColor(text5),
            padding: const EdgeInsets.all(20.0),
            shape: const CircleBorder(),
            child: Text(
              text5,
              style: TextStyle(
                  color: getTextColor(text5),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          width: _deviceWidth! / rowMax, //横幅
          //height: _deviceHeight! * ratioInputButtons / lineMax, //高さ
          child: RawMaterialButton(
            onPressed: () {
              if (text6 == 'AC') {
                setState(() {
                  inputUser = '';
                  result = '';
                });
              } else if (text6 == 'NX') {
                setState(() {
                  if (result == '') {
                    result = inputUser;
                  } else {
                    result = '$result→$inputUser';
                  }
                  inputUser = '';
                });
              } else {
                buttonPressed(text6);
              }
            },
            elevation: 2.0,
            fillColor: getButtonColor(text6),
            padding: const EdgeInsets.all(20.0),
            shape: const CircleBorder(),
            child: Text(
              text6,
              style: TextStyle(
                  color: getTextColor(text6),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kBlack,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: flexRatioDisplayCombo,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      color: kBlue,
                      child: Text(
                        result,
                        style: const TextStyle(
                          backgroundColor: kRed,
                          color: kWhite,
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: flexRatioDisplayArts,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        inputUser,
                        style: const TextStyle(
                          color: kLightGray,
                          fontSize: 40,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: flexRatioInputButtons,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(
                      height: 3,
                    ),
                    getRow('7', '8', '9', 'HP', 'HK', 'AC'),
                    getRow('4', '5', '6', 'MP', 'MK', 'BK'),
                    getRow('1', '2', '3', 'LP', 'LK', 'NX'),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isOprator(String text) {
    var list = ['AC', 'BK', 'NX'];

    for (var item in list) {
      if (text == item) {
        return true;
      }
    }
    return false;
  }

  Color getBackgroundColor(String text) {
    if (isOprator(text)) {
      return kLightGray;
    } else {
      return kDarkGray;
    }
  }

  Color getButtonColor(String text) {
    if (isOprator(text)) {
      return kLightGray;
    } else {
      if ((text == "HP") || (text == "HK")) {
        return kRed;
      } else if ((text == "MP") || (text == "MK")) {
        return kAmber;
      } else if ((text == "LP") || (text == "LK")) {
        return kBlue;
      } else {
        return kDarkGray;
      }
    }
  }

  // ignore: non_constant_identifier_names
  bool TextOprator(String text) {
    var list = ['AC', 'BK', 'NX'];

    for (var item in list) {
      if (text == item) {
        return true;
      }
    }
    return false;
  }

  Color getTextColor(String text) {
    if (isOprator(text)) {
      return Colors.black;
    } else {
      return kWhite;
    }
  }
}
