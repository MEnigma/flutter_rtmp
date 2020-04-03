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
  int count = 0;
  Timer _timer;

  @override
  void initState() {
    _manager = RtmpManager(onCreated: () {
      print("--- view did created ---");
    });
    super.initState();

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
              Container(
                padding: EdgeInsets.only(top: 20),
                alignment: Alignment.topLeft,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () {
                        _manager.living(
                            url: "<rtmp address>");
                        if (_timer == null)
                          _timer ??= Timer.periodic(Duration(seconds: 1), (_) {
                            setState(() {
                              count += 1;
                            });
                          });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.pause),
                      onPressed: () {
                        _manager.pauseLive();
                        if (_timer != null) {
                          _timer.cancel();
                          _timer = null;
                        }
                        ;
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.switch_camera),
                      onPressed: () {
                        _manager.switchCamera();
                      },
                    ),
                    Container(
                      child: Text(
                        "${count ~/ 60}:${count % 60}",
                        style: TextStyle(fontSize: 17, color: Colors.blue),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
