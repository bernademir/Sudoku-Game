import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'language.dart';

class ResultPage extends StatefulWidget {
  @override
  _ResultPage createState() => _ResultPage();
}

class _ResultPage extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lang['resultpage']),
      ),
      body: Center(),
    );
  }
}
