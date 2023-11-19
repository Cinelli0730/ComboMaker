import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:combo_maker/common/constants.dart';

class HomeScreen extends ConsumerWidget {
  // 今回解説しておりませんがriverpodを使用しております。
  // あくまで緑色のステータスバー的なものを動かすためだけですので、
  // なくてもスクロールページは実装できます。
  final alignmentProvider = StateProvider<double>((ref) => -1.0);

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String result = 'test';
    return Directionality(
        textDirection: TextDirection.ltr,
        //body: SafeArea(
        child: Scaffold(
            body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    //flex: flexRatioDisplayCombo,
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
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text("page1"),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text("page2"),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text("page3"),
                    ),
                  ),
                ],
              ),
              Consumer(
                builder: (context, ref, child) {
                  return AnimatedAlign(
                    alignment: Alignment(ref.watch(alignmentProvider), 0),
                    duration: const Duration(milliseconds: 1),
                    child: Container(
                      color: Colors.green,
                      height: 5.0,
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                  );
                },
              ),
              Consumer(
                builder: (context, ref, child) {
                  return CarouselSlider(
                    options: CarouselOptions(
                      enableInfiniteScroll: false,
                      height: 400,
                      viewportFraction: 1,
                      onScrolled: (value) {
                        double result = value! - 1;
                        ref
                            .read(alignmentProvider.notifier)
                            .update((state) => result);
                      },
                    ),
                    // このitemsの中に表示したいウィジェットを入れてください。
                    items: const [
                      Page1(),
                      Page2(),
                      Page3(),
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
  const Page({Key? key}) : super(key: key);
  static String combo = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhite,
      child: const Center(
        child: Text(
          "page1",
          style: TextStyle(fontSize: 24.0, color: kRed),
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBlack,
      child: const Center(
        child: Text(
          "page1",
          style: TextStyle(fontSize: 24.0, color: kWhite),
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: const Center(
        child: Text(
          "page1",
          style: TextStyle(fontSize: 24.0, color: kAmber),
        ),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: const Center(
        child: Text(
          "page1",
          style: TextStyle(fontSize: 24.0, color: Colors.red),
        ),
      ),
    );
  }
}

void main(List<String> args) {
  runApp(ProviderScope(child: HomeScreen()));
}
