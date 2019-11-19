import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_rtmp/flutter_rtmp.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
          body: Center(
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              RtmpView(
                manager: _manager,
              ),
              LiveMenuView(_manager)
            ],
          ),
        ),
      )),
    );
  }
}

class LiveMenuView extends StatelessWidget {
  int _livingTime;
  final RtmpManager manager;
  LiveMenuView(this.manager);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(),
          Container(
              child: Row(children: <Widget>[
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () {
                manager.living(url: "<your rtmp address>");
              },
            ),
            IconButton(
                icon: Icon(Icons.pause),
                onPressed: () {
                  manager.pauseLive();
                }),
            IconButton(
              icon: Icon(Icons.transform),
              onPressed: () {
                manager.switchCamera();
              },
            )
          ])),
        ],
      ),
    );
  }
}
