import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NetStreamDrawableTexture extends StatefulWidget {
  const NetStreamDrawableTexture(this.textureId, {Key? key}) : super(key: key);

  final int? textureId;

  @override
  State<StatefulWidget> createState() => _NetStreamDrawableState();
}

class _NetStreamDrawableState extends State<NetStreamDrawableTexture> {
  @override
  Widget build(BuildContext context) {
    if (widget.textureId == null) {
      return Text(
          '$defaultTargetPlatform is not yet supported by the text_view plugin');
    }
    return Texture(textureId: widget.textureId!);
  }
}
