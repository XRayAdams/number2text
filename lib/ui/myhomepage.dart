import 'package:flutter/material.dart';
import 'package:number2text/converter/converter.dart';
import 'package:number2text/converter/lng/base_converter.dart';
import 'package:number2text/preferences_service.dart';
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
  BaseConverter? _selectedLanguage;
  final _inputController = TextEditingController();
  final _outputController = TextEditingController();
  final _preferencesService = PreferencesService();
  final _converter = NumberConverter();

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _inputController.addListener(_onInputChanged);
  }

  void _loadLanguage() async {
    final languageName = await _preferencesService.getLanguage();
    setState(() {
      _selectedLanguage = _converter.baseConverters.firstWhere(
        (element) => element.name == languageName,
        orElse: () => _converter.baseConverters.first,
      );
    });
  }

  @override
  void dispose() {
    _inputController.removeListener(_onInputChanged);
    _inputController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    final text = _inputController.text;
    if (text.isEmpty) {
      _outputController.clear();
      return;
    }
    final number = int.tryParse(text);
    if (number != null) {
      _outputController.text = _selectedLanguage!.convert(number);
    } else {
      _outputController.text = _selectedLanguage!.native_number_too_large_error_text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YaruWindowTitleBar(
        actions: [
          YaruOptionButton(
            child: const Icon(YaruIcons.menu),
            onPressed: () {
              final RenderBox renderBox = context.findRenderObject() as RenderBox;
              final Offset offset = renderBox.localToGlobal(Offset.zero);
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  offset.dx + renderBox.size.width - 190,
                  offset.dy + 50,
                  offset.dx + renderBox.size.width,
                  offset.dy,
                ),
                items: [const PopupMenuItem(value: "about", child: Text("About..."))],
              ).then((value) {
                if (value == "about") {
                  showDialog(context: context, builder: (context) => const CustomAboutDialog());
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(kYaruPagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Enter a number'),
                  ),
                ),
                const SizedBox(width: kYaruPagePadding),
                const Text('Select Language'),
                const SizedBox(width: kYaruPagePadding),
                SizedBox(
                  width: 150,
                  child: DropdownButton<BaseConverter>(
                    isExpanded: true,
                    value: _selectedLanguage,
                    onChanged: (BaseConverter? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedLanguage = newValue;
                        });
                        _preferencesService.saveLanguage(newValue.name);
                        _onInputChanged();
                      }
                    },
                    items: _converter.baseConverters.map<DropdownMenuItem<BaseConverter>>((BaseConverter value) {
                      return DropdownMenuItem<BaseConverter>(value: value, child: Text(value.name));
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: kYaruPagePadding),
            Expanded(
              child: TextField(
                controller: _outputController,
                readOnly: true,
                maxLines: null,
                expands: true,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                  labelText: 'Output',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
