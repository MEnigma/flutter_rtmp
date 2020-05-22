/*
* Copyright 2019 mark , All right reserved
* author : mark
* date : 2019-11-05
* ide : VSCode
*/

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rtmp/flutter_rtmp.dart';
import 'package:flutter_rtmp/src/rtmp_manager.dart';

import 'def.dart';

class RtmpView extends StatefulWidget {
  RtmpView({@required this.manager, this.onCreated});

  final RtmpManager manager;

  final VoidCallback onCreated;

  @override
  _RtmpViewState createState() => _RtmpViewState();
}

class _RtmpViewState extends State<RtmpView> {
  List orientations = [];

  initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Widget _platformView() {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: DEF_CAMERA_RTMP_VIEW,
        onPlatformViewCreated: (_) {
            widget.manager?.initConfig();
          if (widget.onCreated != null) {
            widget.onCreated();
          }
        },
      );
    } else if (Platform.isAndroid) {
      return AndroidView(
        viewType: DEF_CAMERA_RTMP_VIEW,
        onPlatformViewCreated: (_) {
            widget.manager?.initConfig();
          if (widget.onCreated != null) {
            widget.onCreated();
          }
        },
      );
    } else {
      if (widget.onCreated != null) {
        widget.onCreated();
      }
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _platformView();
  }
}
