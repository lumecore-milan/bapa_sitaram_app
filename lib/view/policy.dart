import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../extensions/size_box_extension.dart';
import '../widget/app_bar.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key, required this.detail, required this.title});

  final String detail;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: title,
        showDrawerIcon: false,
        onBackTap: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left:16,right:16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                10.h,
                Html(
                  data: detail,
                  style: {
                    "p": Style(
                      fontSize: FontSize(18),
                      color: Colors.black87,
                      textAlign: TextAlign.justify,
                      lineHeight: LineHeight(1.5),
                      fontFamily: "Hind Vadodara",
                    ),
                    "h4": Style(
                      fontSize: FontSize(20),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF962020),
                    ),
                    "div": Style(textAlign: TextAlign.justify),
                    "span": Style(fontSize: FontSize(18)),
                  },
                ),
                50.h
              ],
            ),
          ),
        ),
      ),
    );
  }
}
