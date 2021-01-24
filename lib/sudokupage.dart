import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'language.dart';

final Map<String, int> sudokulevels = {
  lang['level1']: 62,
  lang['level2']: 53,
  lang['level3']: 44,
  lang['level4']: 35,
  lang['level5']: 26,
  lang['level6']: 17,
};

class SudokuPage extends StatefulWidget {
  @override
  _SudokuPage createState() => _SudokuPage();
}

class _SudokuPage extends State<SudokuPage> {
  final List ornekSudoku =
      List.generate(9, (i) => List.generate(9, (j) => j + 1));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lang['sudokupage'],
            style: GoogleFonts.playfairDisplaySc(
                textStyle: TextStyle(fontSize: 20))),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              Hive.box('sudoku').get('level', defaultValue: "Kolay"),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  for (List satir in ornekSudoku)
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          for (int sayi in satir)
                            Expanded(
                                child: Center(child: Text(satir.toString()))),
                        ],
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
