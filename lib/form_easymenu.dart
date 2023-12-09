import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:combo_maker/common/constants.dart';
import 'json/framedata.dart';

class HomeScreen extends ConsumerWidget {
  // 今回解説しておりませんがriverpodを使用しております。
  // あくまで緑色のステータスバー的なものを動かすためだけですので、
  // なくてもスクロールページは実装できます。
  final alignmentProvider = StateProvider<double>((ref) => -1.0);

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String result = 'test\\nl2\\nl3\\nl4\\n';
    //final _deviceWidth = MediaQuery.of(context).size.width; //画面の横幅
    //final _deviceHeight = MediaQuery.of(context).size.height; //画面の縦幅
    FrameData mFrameData = FrameData();
    mFrameData.command1 = "LP";
    mFrameData.moveName = "立ち弱P （蛇突）";
    mFrameData.startUp = 5;
    mFrameData.active = 2;
    mFrameData.recovery = 7;
    mFrameData.hitStun = 4;
    mFrameData.blockStun = -1;
    mFrameData.cancelType = "C";
    mFrameData.damage = 300;
    mFrameData.scaling = 10;
    mFrameData.dGageUp = 250;
    mFrameData.dGageDown = -500;
    mFrameData.dGageCounter = -2000;
    mFrameData.sGageUp = 300;
    mFrameData.properties = "上";
    FrameData mFrameData2 = FrameData();
    mFrameData2.command1 = "LK";
    mFrameData2.moveName = "立ち弱K （蛇咬脚）";
    mFrameData2.startUp = 5;
    mFrameData2.active = 3;
    mFrameData2.recovery = 11;
    mFrameData2.hitStun = 4;
    mFrameData2.blockStun = -2;
    mFrameData2.cancelType = "C";
    mFrameData2.damage = 300;
    mFrameData2.scaling = 10;
    mFrameData2.dGageUp = 250;
    mFrameData2.dGageDown = -500;
    mFrameData2.dGageCounter = -2000;
    mFrameData2.sGageUp = 300;
    mFrameData2.properties = "上";
    List<FrameData> testFrameDataList = List.empty();
    testFrameDataList = testFrameDataList.toList();
    testFrameDataList.add(mFrameData);
    testFrameDataList.add(mFrameData2);
    return Directionality(
        textDirection: TextDirection.ltr,
        //body: SafeArea(
        child: Scaffold(
            body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 60,
                child: Container(
                  width: double.infinity,
                  color: Colors.black,
                  constraints: const BoxConstraints.tightForFinite(
                      width: double.infinity),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Text(
                        result,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 5,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.yellow,
                          constraints: const BoxConstraints.tightForFinite(
                              width: double.infinity),
                          alignment: Alignment.center,
                          child: const Text("通常技"),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.red,
                          constraints: const BoxConstraints.tightForFinite(
                              width: double.infinity),
                          alignment: Alignment.center,
                          child: const Text("特殊技"),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.blue,
                          constraints: const BoxConstraints.tightForFinite(
                              width: double.infinity),
                          alignment: Alignment.center,
                          child: const Text("必殺技"),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.green,
                          constraints: const BoxConstraints.tightForFinite(
                              width: double.infinity),
                          alignment: Alignment.center,
                          child: const Text("通常行動"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  return AnimatedAlign(
                    alignment: Alignment(ref.watch(alignmentProvider), 0),
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
                  return CarouselSlider(
                    options: CarouselOptions(
                      //enableInfiniteScroll: false,
                      height: 200,
                      viewportFraction: 1,
                      onScrolled: (value) {
                        double revalue = value! % 4;
                        double result = (revalue * 2 / 3 - 1);
                        //stateは-1～+1,resultは0～item要素数の間で変化する
                        ref
                            .read(alignmentProvider.notifier)
                            .update((state) => result);
                      },
                    ),
                    // このitemsの中に表示したいウィジェットを入れてください。
                    items: [
                      Page(
                        name: 'Page1',
                        frameDataList: testFrameDataList,
                      ),
                      Page(
                        name: 'Page2',
                        frameDataList: testFrameDataList,
                      ),
                      Page(
                        name: 'Page3',
                        frameDataList: testFrameDataList,
                      ),
                      Page(
                        name: 'Page4',
                        frameDataList: testFrameDataList,
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
}

class Page extends StatelessWidget {
  final String name;
  final List<FrameData> frameDataList;
  const Page({super.key, required this.name, required this.frameDataList});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhite,
      child: Row(children: [
        BtnParts(name: frameDataList[0].moveName),
        BtnParts(name: frameDataList[0].moveName),
        /*Text(
          name,
          style: const TextStyle(fontSize: 24.0, color: kRed),
        ),*/
      ]),
    );
  }
}

class BtnParts extends StatelessWidget {
  final String name;
  const BtnParts({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        if (kDebugMode) {
          print("btn is pushed");
        }
      },
      child: Text(name),
    );
  }
}

void main(List<String> args) {
  runApp(ProviderScope(child: HomeScreen()));
}
