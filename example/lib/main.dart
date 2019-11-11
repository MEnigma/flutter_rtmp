import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_rtmp/flutter_rtmp.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  RtmpManager _manager;
  @override
  void initState() {
    super.initState();
    _manager = RtmpManager(onCreated: () {
      print("--- view did created ---");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () {
                  _manager.living(url: "rtmp://122.225.234.90/live/mark");
                },
              ),
              IconButton(
                icon: Icon(Icons.stop),
                onPressed: () {
                  _manager.stopLive();
                },
              ),
              IconButton(icon: Icon(Icons.transform),onPressed: (){
                _manager.switchCamera();
              },)
            ],
          ),
          body: Center(
            child: SizedBox(
              width: 100,
              height: 300,
              child: RtmpView(
                manager: _manager,
              ),
            ),
          )),
    );
  }
}
