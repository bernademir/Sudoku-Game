import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sudoku/sudokupage.dart';
import 'language.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPage createState() => _FirstPage();
}

class _FirstPage extends State<FirstPage> {
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
            appBar: AppBar(
              title: Text(
                lang['firstpage'],
                style: GoogleFonts.playfairDisplaySc(
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () => Hive.box('ayarlar').put(
                    'darktheme',
                    !Hive.box('ayarlar').get('darktheme', defaultValue: false),
                  ),
                ),
                if (_sudokubox.get('sudokuRows') != null)
                  IconButton(
                    icon: Icon(Icons.play_circle_outline),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SudokuPage(),
                        ),
                      );
                    },
                  ),
                PopupMenuButton(
                  icon: Icon(Icons.add),
                  onSelected: (deger) {
                    if (_sudokubox.isOpen) {
                      _sudokubox.put('seviye', deger);
                      _sudokubox.put('sudokuRows', null);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SudokuPage(),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      value: lang['selectlevel'],
                      child: Text(
                        lang['selectlevel'],
                        style: GoogleFonts.playfairDisplaySc(
                            textStyle: TextStyle(fontSize: 20),
                            color: Theme.of(context).textTheme.bodyText1.color),
                      ),
                      enabled: false,
                    ),
                    for (String k in sudokulevels.keys)
                      PopupMenuItem(
                        value: k,
                        child: Text(k),
                      ),
                  ],
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.all(5.0),
              child: Center(
                child: Text(
                  'Sudoku sorularında belirlenmiş miktarda rakam sudoku içine yerleştirilmiş olarak verilir. Daha sonra belirlenmiş 3 temel kurala uygun olacak şekilde rakamları yerleştirmemiz istenir.\n\n* Her satırda tüm rakamlar bulunmalı ve bu rakamlar sadece birer defa yer almalıdır.\n\n* Her sütunda tüm rakamlar bulunmalı ve bu rakamlar sadece birer defa yer almalıdır.\n\n* Her 9 bölgede tüm rakamlar bulunmalı ve bu rakamlar sadece birer defa yer almalıdır.',
                  style: GoogleFonts.playfairDisplaySc(
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          );
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
