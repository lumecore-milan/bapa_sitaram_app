import 'package:flutter/material.dart';

import 'image_widget.dart';

class RoundedImage extends StatelessWidget {
  const RoundedImage({super.key, required this.url, this.height, this.width, this.fit});
  final String url;
  final double? height, width;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: ImageWidget(url: url, width: width, height: height, fit: fit),
    );
  }
}
