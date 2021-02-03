import 'dart:convert';
import 'dart:math';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:sudoku/resultpage.dart';
import 'package:sudoku/sudoku.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wakelock/wakelock.dart';
import 'package:intl/intl.dart';
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
  Timer _sayac;
  List _sudoku = [];
  List _sudokuHistory = [];
  bool _note = false;

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
    _sudokuBox.put('ipucu', 39);
    _sudokuBox.put('sure', 0);

    print(_sudokuString);
    print(gorulecekSayisi);
  }

  void _adimKaydet() {
    String sonDurum = _sudokuBox.get('sudokuRows').toString();
    if (sonDurum.contains("0")) {
      Map historyItem = {
        'sudokuRows': _sudokuBox.get('sudokuRows'),
        'xy': _sudokuBox.get('xy'),
        'ipucu': _sudokuBox.get('ipucu')
      };

      _sudokuHistory.add(jsonEncode(historyItem));
      _sudokuBox.put('sudokuHistory', _sudokuHistory);
    } else {
      _sudokuString = _sudokuBox.get('sudokuString');
      String kontrol = sonDurum.replaceAll(RegExp(r'[e, \][]'), '');
      String mesaj = "Yanlış çözüm lütfen çözümünüzü gözden geçiriniz";
      if (kontrol == _sudokuString) {
        mesaj = "Tebrikler sudokuyu başarıyla çözdünüz";
        Box completedBox = Hive.box('completed');
        DateTime now = DateTime.now();
        Map completedSudoku = {
          'tarih': DateFormat('yyyy-MM-dd – kk:mm').format(now),
          'cozulmus': _sudokuBox.get('sudokuRows'),
          'sure': _sudokuBox.get('sure'),
          'sudokuHistory': _sudokuBox.get('sudokuHistory'),
        };
        completedBox.add(completedSudoku);
        _sudokuBox.put('sudokuRows', null);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(),
          ),
        );
      }
      Fluttertoast.showToast(
          msg: mesaj, toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 3);
    }
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    if (_sudokuBox.get('sudokuRows') == null)
      _sudokuOlustur();
    else
      _sudoku = _sudokuBox.get('sudokuRows');
    _sayac = Timer.periodic(Duration(seconds: 1), (timer) {
      int sure = _sudokuBox.get('sure');
      _sudokuBox.put('sure', ++sure);
    });
  }

  @override
  void dispose() {
    if (_sayac != null && _sayac.isActive) _sayac.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lang['sudokupage'],
            style: GoogleFonts.playfairDisplaySc(
                textStyle: TextStyle(fontSize: 20))),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: _sudokuOlustur),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ValueListenableBuilder<Box>(
                  valueListenable: _sudokuBox.listenable(keys: ['sure']),
                  builder: (context, box, _) {
                    String sure = Duration(seconds: box.get('sure')).toString();
                    return Text(
                      sure.split('.').first,
                      style: GoogleFonts.playfairDisplaySc(
                          textStyle: TextStyle(fontSize: 20)),
                    );
                  }),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: ValueListenableBuilder<Box>(
                valueListenable:
                    _sudokuBox.listenable(keys: ['xy', 'sudokuRows']),
                builder: (context, box, widget) {
                  String xy = box.get('xy', defaultValue: "99");
                  int xC = int.parse(xy.substring(0, 1)),
                      yC = int.parse(xy.substring(1));
                  List sudokuRows = box.get('sudokuRows');
                  return Container(
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
                                                  color: xC == x && yC == y
                                                      ? Colors.purple[800]
                                                      : xC == x || yC == y
                                                          ? Colors.purple[200]
                                                              .withOpacity(0.4)
                                                          : Colors.blue[300],
                                                  alignment: Alignment.center,
                                                  child:
                                                      "${sudokuRows[x][y]}"
                                                              .startsWith('e')
                                                          ? Text(
                                                              "${sudokuRows[x][y]}"
                                                                  .substring(1),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 18),
                                                            )
                                                          : InkWell(
                                                              onTap: () {
                                                                print("$x$y");
                                                                _sudokuBox.put(
                                                                    'xy',
                                                                    "$x$y");
                                                              },
                                                              child: Center(
                                                                child: "${sudokuRows[x][y]}"
                                                                            .length >
                                                                        8
                                                                    ? Column(
                                                                        children: <
                                                                            Widget>[
                                                                          for (int i = 0;
                                                                              i < 9;
                                                                              i += 3)
                                                                            Expanded(
                                                                              child: Center(
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    for (int j = 0; j < 3; j++)
                                                                                      Expanded(
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            "${sudokuRows[x][y]}".split('')[i + j] == "0" ? "" : "${sudokuRows[x][y]}".split('')[i + j],
                                                                                            style: TextStyle(fontSize: 10, color: Colors.white),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                        ],
                                                                      )
                                                                    : Text(
                                                                        sudokuRows[x][y] !=
                                                                                "0"
                                                                            ? sudokuRows[x][y]
                                                                            : "",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                              ),
                                                            ),
                                                ),
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
                  );
                },
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
                              //silme
                              Expanded(
                                child: Card(
                                  color: Colors.blue[900],
                                  margin: EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      String xy = _sudokuBox.get('xy',
                                          defaultValue: "99");
                                      if (xy != "99") {
                                        int xC = int.parse(xy.substring(0, 1)),
                                            yC = int.parse(xy.substring(1));
                                        _sudoku[xC][yC] = "0";
                                        _sudokuBox.put('sudokuRows', _sudoku);
                                        _adimKaydet();
                                      }
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Sil",
                                          style: GoogleFonts.playfairDisplaySc(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              //ipucu
                              Expanded(
                                child: ValueListenableBuilder<Box>(
                                    valueListenable:
                                        _sudokuBox.listenable(keys: ['ipucu']),
                                    builder: (context, box, widget) {
                                      return Card(
                                        color: Colors.blue[900],
                                        margin: EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            String xy = _sudokuBox.get('xy',
                                                defaultValue: "99");
                                            if (xy != "99" &&
                                                box.get('ipucu') > 0) {
                                              int xC = int.parse(
                                                      xy.substring(0, 1)),
                                                  yC = int.parse(
                                                      xy.substring(1));
                                              String cozumString =
                                                  box.get('sudokuString');
                                              List cozumSudoku = List.generate(
                                                9,
                                                (i) => List.generate(
                                                  9,
                                                  (j) => cozumString
                                                      .substring(
                                                          i * 9, (i + 1) * 9)
                                                      .split('')[j],
                                                ),
                                              );

                                              if (_sudoku[xC][yC] !=
                                                  cozumSudoku[xC][yC]) {
                                                _sudoku[xC][yC] =
                                                    cozumSudoku[xC][yC];
                                                box.put('sudokuRows', _sudoku);
                                                box.put('ipucu',
                                                    box.get('ipucu') - 1);
                                                _adimKaydet();
                                              }
                                            }
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.lightbulb,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                    " : ${box.get('ipucu')}",
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "Ipucu",
                                                style: GoogleFonts
                                                    .playfairDisplaySc(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              //geri alma
                              Expanded(
                                child: Card(
                                  color: _note
                                      ? Colors.blue.withOpacity(0.6)
                                      : Colors.blue[900],
                                  margin: EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      if (_sudokuHistory.length > 1) {
                                        _sudokuHistory.removeLast();
                                        Map onceki =
                                            jsonDecode(_sudokuHistory.last);
                                        _sudokuBox.put(
                                            'sudokuRows', onceki['sudokuRows']);
                                        _sudokuBox.put('xy', onceki['xy']);
                                        _sudokuBox.put(
                                            'ipucu', onceki['ipucu']);

                                        _sudokuBox.put(
                                            'sudokuHistory', _sudokuHistory);
                                        _sudoku = onceki['sudokuRows'];
                                      }

                                      print(_sudokuHistory.length);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.undo,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Geri Al",
                                          style: GoogleFonts.playfairDisplaySc(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        ),
                                        ValueListenableBuilder<Box>(
                                          valueListenable: _sudokuBox
                                              .listenable(
                                                  keys: ['sudokuHistory']),
                                          builder: (context, box, _) {
                                            return Text(
                                                "${box.get('sudokuHistory', defaultValue: []).length}");
                                          },
                                        ),
                                      ],
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
                                          String xy = _sudokuBox.get('xy',
                                              defaultValue: "99");
                                          if (xy != "99") {
                                            int xC = int.parse(
                                                    xy.substring(0, 1)),
                                                yC = int.parse(xy.substring(1));
                                            if (!_note)
                                              _sudoku[xC][yC] = "${i + j}";
                                            else {
                                              if ("${_sudoku[xC][yC]}".length <
                                                  8)
                                                _sudoku[xC][yC] = "000000000";
                                              if ("${_sudoku[xC][yC]}"
                                                      .substring(
                                                          i + j - 1, i + j) ==
                                                  "${i + j}")
                                                _sudoku[xC][yC] =
                                                    "${_sudoku[xC][yC]}"
                                                        .replaceRange(i + j - 1,
                                                            i + j, "0");
                                              else
                                                _sudoku[xC][yC] =
                                                    "${_sudoku[xC][yC]}"
                                                        .replaceRange(i + j - 1,
                                                            i + j, "${i + j}");
                                            }
                                            _sudokuBox.put(
                                                'sudokuRows', _sudoku);
                                            _adimKaydet();
                                            print("${i + j}");
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(3.0),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "${i + j}",
                                            style: TextStyle(
                                                fontSize: 25.0,
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
