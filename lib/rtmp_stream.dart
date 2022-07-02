import 'package:haishin_kit/audio_source.dart';
import 'package:haishin_kit/rtmp_connection.dart';
import 'package:haishin_kit/rtmp_stream_platform_interface.dart';
import 'package:haishin_kit/video_source.dart';

class RtmpStream {
  static Future<RtmpStream> create(RtmpConnection connection) async {
    var object = RtmpStream();
    final Map<String, dynamic> params = {"memory": connection.memory};
    object._memory = await RtmpStreamPlatform.instance.create(params);
    return object;
  }

  double? _memory;

  RtmpStream();

  Future<void> attachAudio(AudioSource? audio) async {
    assert(_memory != null);
    final Map<String, dynamic> params = {
      "memory": _memory,
      "source": audio?.toMap()
    };
    RtmpStreamPlatform.instance.attachAudio(params);
  }

  Future<void> attachVideo(VideoSource? video) async {
    assert(_memory != null);
    final Map<String, dynamic> params = {
      "memory": _memory,
      "source": video?.toMap()
    };
    RtmpStreamPlatform.instance.attachVideo(params);
  }

  Future<void> publish(String name) async {
    assert(_memory != null);
    final Map<String, dynamic> params = {"memory": _memory, "name": name};
    RtmpStreamPlatform.instance.publish(params);
  }

  Future<void> play(String name) async {
    assert(_memory != null);
    final Map<String, dynamic> params = {"memory": _memory, "name": name};
    RtmpStreamPlatform.instance.play(params);
  }

  Future<void> close() async {
    assert(_memory != null);
    final Map<String, dynamic> params = {"memory": _memory};
    RtmpStreamPlatform.instance.close(params);
  }
}
