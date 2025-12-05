import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import '../extensions/size_box_extension.dart';
import '../utils/size_config.dart';
import '../widget/rounded_image.dart';

class SocialActivityDetail extends StatefulWidget {
  const SocialActivityDetail({
    super.key,
    required this.title,
    required this.detail,
  });

  final String title;
  final dynamic detail;

  @override
  State<SocialActivityDetail> createState() => _SocialActivityDetailState();
}

class _SocialActivityDetailState extends State<SocialActivityDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: widget.title,
        showDrawerIcon: false,
        onBackTap: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(child: _getBody()),
    );
  }

  Widget _getBody() {
    return Container(
      height: SizeConfig().height,
      width: SizeConfig().width,
      padding: .symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: .min,
          children: [
            20.h,
            Column(children: [RoundedImage(
                height: 180,
                width: SizeConfig().width,
                fit: .cover,
                url: widget.detail['event_image'])]),

            Html(
              data: widget.detail['event_desc'],
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
          ],
        ),
      ),
    );
  }
}
