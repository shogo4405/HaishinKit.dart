import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:haishin_kit/audio_source.dart';
import 'package:haishin_kit/net_stream_drawable_texture.dart';
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
  RtmpConnection? _connection;
  RtmpStream? _stream;
  bool _recording = false;
  CameraPosition currentPosition = CameraPosition.back;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await Permission.camera.request();
    await Permission.microphone.request();

    // Set up AVAudioSession for iOS.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth,
    ));

    RtmpConnection connection = await RtmpConnection.create();
    connection.eventChannel.receiveBroadcastStream().listen((event) {
      switch (event["data"]["code"]) {
        case 'NetConnection.Connect.Success':
          _stream?.publish("live");
          setState(() {
            _recording = true;
          });
          break;
      }
    });
    RtmpStream stream = await RtmpStream.create(connection);
    stream.attachAudio(AudioSource());
    stream.attachVideo(VideoSource(position: currentPosition));

    if (!mounted) return;

    setState(() {
      _connection = connection;
      _stream = stream;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('HaishinKit example app'), actions: [
          IconButton(
            icon: const Icon(Icons.flip_camera_android),
            onPressed: () {
              if (currentPosition == CameraPosition.front) {
                currentPosition = CameraPosition.back;
              } else {
                currentPosition = CameraPosition.front;
              }
              _stream?.attachVideo(VideoSource(position: currentPosition));
            },
          )
        ]),
        body: Center(
          child: _stream == null
              ? const Text("")
              : NetStreamDrawableTexture(_stream),
        ),
        floatingActionButton: FloatingActionButton(
          child: _recording
              ? const Icon(Icons.fiber_smart_record)
              : const Icon(Icons.not_started),
          onPressed: () {
            if (_recording) {
              _connection?.close();
              setState(() {
                _recording = false;
              });
            } else {
              _connection?.connect("rtmp://192.168.1.9/live");
            }
          },
        ),
      ),
    );
  }
}
