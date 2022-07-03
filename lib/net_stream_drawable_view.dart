import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'net_stream.dart';

class NetStreamDrawableView extends StatefulWidget {
  const NetStreamDrawableView(this.textureId, {Key? key}) : super(key: key);

  final int? textureId;

  @override
  State<StatefulWidget> createState() => NetStreamDrawableState();
}

class NetStreamDrawableState extends State<NetStreamDrawableView> {
  late _NetStreamDrawableController _controller;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'plugins.haishinkit.com/netstreamdrawablebiew',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      if (widget.textureId == null) {
        return Text(
            '$defaultTargetPlatform is not yet supported by the text_view plugin');
      }
      return Texture(textureId: widget.textureId!);
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the text_view plugin');
  }

  void attachStream(NetStream netStream) {
    _controller.attachStream(netStream);
  }

  void _onPlatformViewCreated(int id) {
    _controller = _NetStreamDrawableController(id);
  }
}

class _NetStreamDrawableController {
  _NetStreamDrawableController(
    int id,
  ) : _channel = MethodChannel('plugins.haishinkit.com/view_$id');

  final MethodChannel _channel;

  Future<void> attachStream(NetStream netStream) async {
    return _channel.invokeMethod("attachStream", {"memory": netStream.memory});
  }
}
