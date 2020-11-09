import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter_rtmp/flutter_rtmp.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  RtmpManager _manager;
  Timer _timer;
  int seconds = 0;

  @override
  void initState() {
    super.initState();
    _manager = RtmpManager(config: RtmpConfig(debugmode: true));
  }

  startCount() {
    _timer ??= Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        seconds += 1;
      });
    });
  }

  stopCount() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
        child: SafeArea(
          child: Stack(
            // fit: StackFit.expand,
            children: <Widget>[
              RtmpView(
                manager: _manager,
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.topLeft,
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            ActionChip(
                                label: Text("开始"),
                                onPressed: () async {
                                  String config = await rootBundle
                                      .loadString("src/testfile.json");
                                  Map param = jsonDecode(config);
                                  await _manager
                                      .startLive(param["rtmpurl"] ?? "");
                                  setState(() {});
                                  startCount();
                                }),
                            ActionChip(
                                label: Text("暂停"),
                                onPressed: () async {
                                  await _manager.pauseLive();
                                  setState(() {});
                                  stopCount();
                                }),
                            ActionChip(
                                label: Text("恢复"),
                                onPressed: () async {
                                  await _manager.resumeLive();
                                  setState(() {});
                                  startCount();
                                }),
                            ActionChip(
                                label: Text("结束"),
                                onPressed: () async {
                                  await _manager.stopLive();
                                  setState(() {});
                                  stopCount();
                                }),
                            ActionChip(
                                label: Text("切换摄像头"),
                                onPressed: () async {
                                  await _manager.switchCamera();
                                  setState(() {});
                                }),
                          ],
                        )),
                    Container(
                      alignment: Alignment.topLeft,
                      child: RichText(
                          text: TextSpan(
                              text:
                                  "快照信息 \n STATUS : ${_manager.snapShot?.status ?? 'NO'}\t\t",
                              children: [TextSpan(text: "sec : $seconds")])),
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
