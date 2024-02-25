import 'package:flutter/material.dart';
import 'package:haishin_kit/stream.dart';

class StreamViewTexture extends StatefulWidget {
  const StreamViewTexture(this.netStream, {super.key});

  final Stream? netStream;

  @override
  State<StatefulWidget> createState() => _StreamViewTextureState();
}

class _StreamViewTextureState extends State<StreamViewTexture> {
  int? _textureId;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    int? textureId = await widget.netStream?.registerTexture({});
    setState(() {
      _textureId = textureId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_textureId == null) {
      return Container(
        color: Colors.black,
      );
    }
    _updatePlatformState(MediaQuery.of(context));
    return Texture(textureId: _textureId!);
  }

  Future<void> _updatePlatformState(MediaQueryData mediaQueryData) async {
    widget.netStream?.updateTextureSize({
      "width": mediaQueryData.size.width,
      "height": mediaQueryData.size.height,
    });
  }
}
