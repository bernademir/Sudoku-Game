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
    return Scaffold(
      appBar: AppBar(
        title: Text(lang['firstpage'],
            style: GoogleFonts.playfairDisplaySc(
                textStyle: TextStyle(fontSize: 20))),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Hive.box('ayarlar').put('darktheme',
                  !Hive.box('ayarlar').get('darktheme', defaultValue: false))),
          PopupMenuButton(
            icon: Icon(Icons.add),
            onSelected: (deger) {
              if (_sudokubox.isOpen) {
                _sudokubox.put('seviye', deger);
                _sudokubox.put('sudokuRows', null);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SudokuPage()),
                );
              }
            },
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                value: lang['selectlevel'],
                child: Text(lang['selectlevel'],
                    style: GoogleFonts.playfairDisplaySc(
                        textStyle: TextStyle(fontSize: 20),
                        color: Theme.of(context).textTheme.bodyText1.color)),
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
      body: FutureBuilder<Box>(
          future: _openbox(),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (snapshot.data.length == 0)
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(lang['notcompleted'],
                              style: GoogleFonts.playfairDisplaySc(
                                  textStyle: TextStyle(fontSize: 22)))),
                    for (var eleman in snapshot.data.values)
                      Center(
                        child: Text('$eleman'),
                      )
                  ],
                ),
              );
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
