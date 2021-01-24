import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'language.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPage createState() => _FirstPage();
}

class _FirstPage extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lang['firstpage']),
      ),
      body: Center(),
    );
  }
}
