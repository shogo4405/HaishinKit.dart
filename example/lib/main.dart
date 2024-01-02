import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:haishin_kit/audio_settings.dart';
import 'package:haishin_kit/audio_source.dart';
import 'package:haishin_kit/net_stream_drawable_texture.dart';
import 'package:haishin_kit/rtmp_connection.dart';
import 'package:haishin_kit/rtmp_stream.dart';
import 'package:haishin_kit/video_settings.dart';
import 'package:haishin_kit/video_source.dart';
import 'package:haishin_kit_example/camera_live_controller.dart';
import 'package:haishin_kit_example/models/live_stream_state.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  const String server = "rtmp://192.168.1.3/live";
  const streamKey = "live";

  runApp(
    const MaterialApp(
      home: Scaffold(
        body: WidgetWrapper(
          child: Example2(
            server: server,
            streamKey: streamKey,
          ),
        ),
      ),
    ),
  );
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
  String _mode = "publish";
  CameraPosition currentPosition = CameraPosition.back;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    _stream?.dispose();
    _connection?.dispose();
    super.dispose();
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
      print("event: $event");
      switch (event["data"]["code"]) {
        case 'NetConnection.Connect.Success':
          if (_mode == "publish") {
            _stream?.publish("live");
          } else {
            _stream?.play("live");
          }
          setState(() {
            _recording = true;
          });
          break;
      }
    });

    RtmpStream stream = await RtmpStream.create(connection);
    stream.audioSettings = AudioSettings(bitrate: 64 * 1000);
    stream.videoSettings = VideoSettings(
      width: 480,
      height: 272,
      bitrate: 512 * 1000,
    );
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
        appBar: AppBar(title: const Text('HaishinKit'), actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              if (_mode == "publish") {
                _mode = "playback";
                _stream?.attachVideo(null);
                _stream?.attachAudio(null);
              } else {
                _mode = "publish";
                _stream?.attachAudio(AudioSource());
                _stream?.attachVideo(VideoSource(position: currentPosition));
              }
            },
          ),
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
              _connection?.connect("rtmp://192.168.1.3/live");
            }
          },
        ),
      ),
    );
  }
}

class WidgetWrapper extends StatefulWidget {
  final Widget child;

  const WidgetWrapper({
    super.key,
    required this.child,
  });

  @override
  State<WidgetWrapper> createState() => _WidgetWrapperState();
}

class _WidgetWrapperState extends State<WidgetWrapper> {
  bool _audioSessionConfigured = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await Permission.camera.request();
    await Permission.microphone.request();

    _audioSessionConfigured = await configureAudioSession();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _audioSessionConfigured
        ? Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => widget.child,
                  ),
                );
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Use Camera"),
            ),
          )
        : const Center(
            child: Text("Configuring audio session..."),
          );
  }
}

class Example2 extends StatefulWidget {
  final String server;
  final String streamKey;

  const Example2({
    super.key,
    required this.server,
    required this.streamKey,
  });

  @override
  State<Example2> createState() => Example2State();
}

class Example2State extends State<Example2> {
  late final CameraLiveStreamController _controller;

  late StreamSubscription<LiveStreamState> _subscription;

  late LiveStreamState _currentState;

  @override
  void initState() {
    super.initState();
    _controller = CameraLiveStreamController(
      widget.server,
      widget.streamKey,
    )..initialize();

    _subscription = _controller.stateStream.listen((event) {
      if (_currentState != event) {
        setState(() {
          _currentState = event;
        });
      }
    });

    _currentState = _controller.state;
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Stream Example"),
      ),
      body: _buildBodyView(),
      floatingActionButton: _buildControlButton(),
    );
  }

  Widget _buildBodyView() {
    if (_currentState.status == LiveStreamStatus.idle) {
      return const Center(
        child: Text("Configuring Camera..."),
      );
    } else if (_currentState.status == LiveStreamStatus.connected ||
        _currentState.status == LiveStreamStatus.initialized ||
        _currentState.status == LiveStreamStatus.living) {
      return LiveStreamPreview(
        textureManager: _controller,
        state: _currentState,
      );
    } else {
      return const Center(
        child: Text("Live stream stopped or disconnected."),
      );
    }
  }

  Widget? _buildControlButton() {
    if (_currentState.status == LiveStreamStatus.idle) {
      return FloatingActionButton(
        onPressed: _controller.initialize,
        child: const Text("Initialize"),
      );
    } else if (_currentState.status == LiveStreamStatus.connected) {
      return FloatingActionButton(
        onPressed: _controller.startStreaming,
        child: const Text("Publish"),
      );
    } else if (_currentState.status == LiveStreamStatus.living) {
      return FloatingActionButton(
        onPressed: () async {
          await _controller.stopStreaming();
          Navigator.of(context).pop();
        },
        child: const Text("Stop"),
      );
    }

    return null;
  }
}

class LiveStreamPreview extends StatefulWidget {
  final LiveStreamTextureMixin textureManager;
  final LiveStreamState state;

  const LiveStreamPreview({
    super.key,
    required this.textureManager,
    required this.state,
  });

  @override
  State<LiveStreamPreview> createState() => _LiveStreamPreviewState();
}

class _LiveStreamPreviewState extends State<LiveStreamPreview> {
  int? _textureId;

  @override
  void initState() {
    super.initState();

    if (widget.textureManager.textureId == null) {
      _registerTexture();
    } else {
      _textureId = widget.textureManager.textureId;
    }
  }

  void _updateTextureSize() {
    final mediaSize = MediaQuery.of(context).size;

    widget.textureManager.updateTextureSize(mediaSize);
  }

  void _registerTexture() async {
    final textureId = await widget.textureManager.registerTexture();
    setState(() {
      _textureId = textureId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_textureId == null) {
      return const Center(
        child: Text("No available video preview.\nProbably this device "
            "does not support video preview."),
      );
    }
    _updateTextureSize();

    final orientation = MediaQuery.of(context).orientation;

    final resolution = widget.state.videoResolution;

    final aspectRatio = orientation == Orientation.portrait
        ? 1 / resolution.aspectRatio
        : resolution.aspectRatio;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Colors.black),
          Align(
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: Texture(
                textureId: _textureId!,
              ),
            ),
          )
        ],
      ),
    );
  }
}
