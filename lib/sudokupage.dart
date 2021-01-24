import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'language.dart';

class SudokuPage extends StatefulWidget {
  @override
  _SudokuPage createState() => _SudokuPage();
}

class _SudokuPage extends State<SudokuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lang['sudokupage']),
      ),
      body: Center(),
    );
  }
}
