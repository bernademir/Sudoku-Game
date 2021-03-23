import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sudoku/view/sudoku_view.dart';
import '../string.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeView createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  String mainString =
      "Sudoku sorularında belirlenmiş miktarda rakam sudoku içine yerleştirilmiş olarak verilir. Daha sonra belirlenmiş 3 temel kurala uygun olacak şekilde rakamları yerleştirmemiz istenir.\n\n* Her satırda tüm rakamlar bulunmalı ve bu rakamlar sadece birer defa yer almalıdır.\n\n* Her sütunda tüm rakamlar bulunmalı ve bu rakamlar sadece birer defa yer almalıdır.\n\n* Her 9 bölgede tüm rakamlar bulunmalı ve bu rakamlar sadece birer defa yer almalıdır.";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box>(
      future: _openbox(),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return Scaffold(
            appBar: _appBarWidget(),
            body: Container(
              padding: EdgeInsets.all(5.0),
              child: Center(
                child: Text(
                  mainString,
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

  Widget _appBarWidget() {
    return AppBar(
      title: Text(
        lang['homeViewTitle'],
        style: GoogleFonts.playfairDisplaySc(
          textStyle: TextStyle(fontSize: 20),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => Hive.box('settings').put(
            'darktheme',
            !Hive.box('settings').get('darktheme', defaultValue: false),
          ),
        ),
        if (_sudokubox.get('sudokuRows') != null)
          IconButton(
            icon: Icon(Icons.play_circle_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SudokuView(),
                ),
              );
            },
          ),
        PopupMenuButton(
          icon: Icon(Icons.add),
          onSelected: (value) {
            if (_sudokubox.isOpen) {
              _sudokubox.put('level', value);
              _sudokubox.put('sudokuRows', null);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SudokuView(),
                ),
              );
            }
          },
          itemBuilder: (context) => <PopupMenuEntry>[
            PopupMenuItem(
              value: lang['selectLevel'],
              child: Text(
                lang['selectLevel'],
                style: GoogleFonts.playfairDisplaySc(
                    textStyle: TextStyle(fontSize: 20),
                    color: Theme.of(context).textTheme.bodyText1.color),
              ),
              enabled: false,
            ),
            for (String k in sudokuLevels.keys)
              PopupMenuItem(
                value: k,
                child: Text(k),
              ),
          ],
        ),
      ],
    );
  }

  Box _sudokubox;
  Future<Box> _openbox() async {
    _sudokubox = await Hive.openBox('sudoku');
    return await Hive.openBox('completed');
  }
}
