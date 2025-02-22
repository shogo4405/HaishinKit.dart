# HaishinKit Plugin

[![pub package](https://img.shields.io/pub/v/haishin_kit.svg)](https://pub.dev/packages/haishin_kit)

* A Flutter plugin for iOS, Android. Camera and Microphone streaming library via RTMP.

|                | Android | iOS       | 
|----------------|---------|-----------|
| **Support**    | SDK 21+ | iOS 13.0+ |

## 💖 Sponsors
Do you need additional support? Technical support on Issues and Discussions is provided only to contributors and academic researchers of HaishinKit. By becoming a sponsor, we can provide the support you need.

Sponsor: [$50 per month](https://github.com/sponsors/shogo4405): Technical support via GitHub Issues/Discussions with priority response.

## 💬 Communication
* GitHub Issues and Discussions are open spaces for communication among users and are available to everyone as long as [the code of conduct](https://github.com/shogo4405/HaishinKit.swift?tab=coc-ov-file) is followed.
* Whether someone is a contributor to HaishinKit is mainly determined by their GitHub profile icon. If you are using the default icon, there is a chance your input might be overlooked, so please consider setting a custom one. It could be a picture of your pet, for example. Personally, I like cats.
* If you want to support e-mail based communication without GitHub.
  * Consulting fee is [$50](https://www.paypal.me/shogo4405/50USD)/1 incident. I'm able to response a few days.

# 🌏 Dependencies

Project name    |Notes       |License
----------------|------------|--------------
[HaishinKit for iOS, macOS and tvOS.](https://github.com/shogo4405/HaishinKit.swift)|Camera and Microphone streaming library via RTMP, HLS for iOS, macOS and tvOS.|[BSD 3-Clause "New" or "Revised" License](https://github.com/shogo4405/HaishinKit.swift/blob/master/LICENSE.md)
[HaishinKit for Android.](https://github.com/shogo4405/HaishinKit.kt)|Camera and Microphone streaming library via RTMP for Android.|[BSD 3-Clause "New" or "Revised" License](https://github.com/shogo4405/HaishinKit.kt/blob/master/LICENSE.md)

## 🎨 Features

### RTMP

- [x] Authentication
- [x] Publish and Recording (H264/AAC)
- [x] _Playback (Beta)_
- [x] Adaptive bitrate streaming
    - [x] Automatic drop frames
- [ ] Action Message Format
    - [x] AMF0
    - [ ] AMF3
- [x] SharedObject
- [x] RTMPS
    - [x] Native (RTMP over SSL/TLS)

# 🐾 Example

Here is a small example flutter app displaying a camera preview.

```dart
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

```
