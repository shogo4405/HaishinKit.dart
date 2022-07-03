# HaishinKit Plugin
[![pub package](https://img.shields.io/pub/v/haishin_kit.svg)](https://pub.dev/packages/haihsin_kit)
* A Flutter plugin for iOS, Android. Camera and Microphone streaming library via RTMP.

|                | Android | iOS      | 
|----------------|---------|----------|
| **Support**    | SDK 21+ | iOS 9.0+ |

# 🐾 Example
Here is a small example flutter app displaying a camera preview.
```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haishin_kit/audio_source.dart';
import 'package:haishin_kit/net_stream_drawable_view.dart';
import 'package:haishin_kit/rtmp_connection.dart';
import 'package:haishin_kit/rtmp_stream.dart';
import 'package:haishin_kit/video_source.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late RtmpConnection _connection;
  late RtmpStream _stream;

  GlobalKey<NetStreamDrawableState> netStreamDrawableViewStateKey =
  GlobalKey<NetStreamDrawableState>();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await Permission.camera.request();
    await Permission.microphone.request();

    _connection = await RtmpConnection.create();
    _stream = await RtmpStream.create(_connection);
    _stream.attachAudio(AudioSource());
    _stream.attachVideo(VideoSource());

    if (!mounted) return;

    setState(() {
      netStreamDrawableViewStateKey.currentState?.attachStream(_stream);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: NetStreamDrawableView(key: netStreamDrawableViewStateKey),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _connection.connect("rtmp://192.168.1.9/live");
            _stream.publish("live");
          },
        ),
      ),
    );
  }
}
```
