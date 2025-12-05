import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class CustomHtmlWidget extends StatelessWidget {
  const CustomHtmlWidget({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: content,
      style: {
        "p": Style(
          fontSize: FontSize(18),
          color: Colors.black87,
          textAlign: TextAlign.justify,
          lineHeight: LineHeight(1),
          fontFamily: "Hind Vadodara",
        ),
        "h4": Style(
          fontSize: FontSize(18),
          fontWeight: FontWeight.bold,
          color: const Color(0xFF962020),
        ),
        "div": Style(textAlign: TextAlign.justify),
        "span": Style(fontSize: FontSize(18)),
      },
    );
  }
}
