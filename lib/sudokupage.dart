import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:sudoku/sudoku.dart';

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
  final Box _sudokuBox = Hive.box('sudoku');
  String _sudokuString;
  //Timer _sayac;
  List _sudoku = [];
  //List _sudokuHistory = [];
  //bool _note = false;

  void _sudokuOlustur() {
    int gorulecekSayisi =
        sudokulevels[_sudokuBox.get('level', defaultValue: lang['level2'])];

    _sudokuString = sudoku[Random().nextInt(sudoku.length)];
    _sudokuBox.put('sudokuString', _sudokuString);

    _sudoku = List.generate(
      9,
      (i) => List.generate(
        9,
        (j) => "e" + _sudokuString.substring(i * 9, (i + 1) * 9).split('')[j],
      ),
    );

    int i = 0;
    while (i < 81 - gorulecekSayisi) {
      int x = Random().nextInt(9);
      int y = Random().nextInt(9);

      if (_sudoku[x][y] != "0") {
        print(_sudoku[x][y]);
        _sudoku[x][y] = "0";
        i++;
      }
    }

    _sudokuBox.put('sudokuRows', _sudoku);
    _sudokuBox.put('xy', "99");
    _sudokuBox.put('ipucu', 3);
    _sudokuBox.put('sure', 0);

    print(_sudokuString);
    print(gorulecekSayisi);
  }

  @override
  void initState() {
    _sudokuOlustur();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lang['sudokupage'],
            style: GoogleFonts.playfairDisplaySc(
                textStyle: TextStyle(fontSize: 20))),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: _sudokuOlustur)
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              _sudokuBox.get('level', defaultValue: lang['level2']),
            ),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: Colors.blue[900],
                padding: EdgeInsets.all(3.0),
                margin: EdgeInsets.all(6.0),
                child: Column(
                  children: <Widget>[
                    for (int x = 0; x < 9; x++)
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  for (int y = 0; y < 9; y++)
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                                margin: EdgeInsets.all(1.0),
                                                color: Colors.blue[300],
                                                alignment: Alignment.center,
                                                child: Text(
                                                  _sudoku[x][y] > 0
                                                      ? _sudoku[x][y].toString()
                                                      : "",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                )),
                                          ),
                                          if (y == 2 || y == 5)
                                            SizedBox(
                                              width: 3,
                                            )
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (x == 2 || x == 5)
                              SizedBox(
                                height: 3,
                              )
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Card(
                                  child: Container(
                                    margin: EdgeInsets.all(1.0),
                                    color: Colors.blue[900],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  child: Container(
                                    margin: EdgeInsets.all(1.0),
                                    color: Colors.blue[900],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Card(
                                  child: Container(
                                    margin: EdgeInsets.all(1.0),
                                    color: Colors.blue[900],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  child: Container(
                                    margin: EdgeInsets.all(1.0),
                                    color: Colors.blue[900],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        for (int i = 1; i < 10; i += 3)
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                for (int j = 0; j < 3; j++)
                                  Expanded(
                                    child: Card(
                                      color: Colors.blue[900],
                                      shape: CircleBorder(),
                                      child: InkWell(
                                        onTap: () {
                                          print("${i + j}");
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(3.0),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "${i + j}",
                                            style: TextStyle(
                                                fontSize: 23.0,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
