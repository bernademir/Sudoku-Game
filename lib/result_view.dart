import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'string.dart';

class ResultView extends StatefulWidget {
  @override
  _ResultViewState createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  Box _sudokubox;
  Future<Box> _openbox() async {
    _sudokubox = await Hive.openBox('sudoku');
    return await Hive.openBox('completed');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box>(
      future: _openbox(),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return Scaffold(
            appBar: _appBarWidget(),
            body: ValueListenableBuilder<Box>(
                valueListenable: snapshot.data.listenable(),
                builder: (context, box, _) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (box.length == 0)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            lang['notcompleted'],
                            style: GoogleFonts.playfairDisplaySc(
                              textStyle: TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                      for (Map eleman in box.values.toList().take(30))
                        ListTile(
                          title: Text(
                            "${eleman['tarih']}",
                            style: GoogleFonts.playfairDisplaySc(
                              textStyle: TextStyle(fontSize: 22),
                            ),
                          ),
                          subtitle: Text(
                              "${Duration(seconds: eleman['sure']).toString()}"
                                  .split('.')
                                  .first),
                        ),
                    ],
                  );
                }),
          );
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  AppBar _appBarWidget() {
    return AppBar(
      title: Text(
        lang['resultView'],
        style: GoogleFonts.playfairDisplaySc(
          textStyle: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
