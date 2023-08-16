import 'package:flutter/material.dart';

class DiscoverScreenPortrait extends StatelessWidget {
  final BoxConstraints cons;
  final Color color;

  const DiscoverScreenPortrait(
      {super.key, required this.cons, required this.color});

  @override
  Widget build(BuildContext context) {
    final ht = cons.maxHeight;
    final wd = cons.maxWidth;
    final pageController = PageController(initialPage: 0);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: color,
        body: Container(
            width: wd,
            child: const Column(
              children: [
                TabBar(
                  indicatorColor: Colors.lightBlue,
                  labelColor: Colors.lightBlue,
                  tabs: [
                    Tab(
                      text: "new",
                    ),
                    Tab(
                      text: "following",
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(children: [
                    Center(
                      child: Text("new"),
                    ),
                    Center(
                      child: Text("following"),
                    ),
                  ]),
                ),
              ],
            )),
      ),
    );
  }
}
