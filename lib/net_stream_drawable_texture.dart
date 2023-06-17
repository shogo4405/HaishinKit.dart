import 'package:flutter/material.dart';
import 'package:haishin_kit/net_stream.dart';

class NetStreamDrawableTexture extends StatefulWidget {
  const NetStreamDrawableTexture(this.netStream, {Key? key}) : super(key: key);

  final NetStream? netStream;

  @override
  State<StatefulWidget> createState() => _NetStreamDrawableState();
}

class _NetStreamDrawableState extends State<NetStreamDrawableTexture> {
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
    widget.netStream?.registerTexture({
      "width": mediaQueryData.size.width,
      "height": mediaQueryData.size.height,
      "orientation": mediaQueryData.orientation.name
    });
  }
}
