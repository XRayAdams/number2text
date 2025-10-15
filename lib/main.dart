// Copyright (c) 2025 Konstantin Adamov. Licensed under the MIT license.

import 'package:flutter/material.dart';
import 'package:number2text/ui/myhomepage.dart';
import 'package:yaru/yaru.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await YaruWindowTitleBar.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruTheme(
      builder: (context, yaru, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          // Assign the GlobalKey
          title: 'Number 2 Text',
          theme: yaru.theme,
          darkTheme: yaru.darkTheme,
          themeMode: ThemeMode.system,
          home: const MyHomePage(title: 'Number 2 Text'),
        );
      },
    );
  }
}
