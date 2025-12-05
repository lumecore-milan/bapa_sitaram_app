import 'package:flutter/material.dart';

import '../widget/image_widget.dart';


class ImageView extends StatelessWidget {
  const ImageView({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(
        mainAxisAlignment: .center,
        children: [
          Expanded(child: Container()),
           ImageWidget(url: url,),
          Expanded(child: Container()),
        ],
      )),
    );
  }
}
