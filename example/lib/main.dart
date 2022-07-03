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
  int? _texureId;

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

    int? textureId = await _stream.registerTexture();

    if (!mounted) return;

    setState(() {
      _texureId = textureId;
      // netStreamDrawableViewStateKey.currentState?.attachStream(_stream);
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
          child: NetStreamDrawableView(_texureId,
              key: netStreamDrawableViewStateKey),
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
