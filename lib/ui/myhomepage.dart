import 'package:flutter/material.dart';
import 'package:yaru/constants.dart';
import 'package:yaru/icons.dart';
import 'package:yaru/widgets.dart';

import 'about_dialog.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YaruWindowTitleBar(
        actions: [
          YaruOptionButton(
            child: const Icon(YaruIcons.menu),
            onPressed: () {
              final RenderBox renderBox =
                  context.findRenderObject() as RenderBox;
              final Offset offset = renderBox.localToGlobal(Offset.zero);
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  offset.dx + renderBox.size.width - 190,
                  offset.dy + 50,
                  offset.dx + renderBox.size.width,
                  offset.dy,
                ),
                items: [
                  const PopupMenuItem(value: "about", child: Text("About...")),
                ],
              ).then((value) {
                if (value == "about") {
                  showDialog(
                    context: context,
                    builder: (context) => const CustomAboutDialog(),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: Padding(padding: const EdgeInsets.all(kYaruPagePadding)),
    );
  }
}
