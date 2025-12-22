import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:bapa_sitaram/widget/custom_html_widget.dart';
import 'package:flutter/material.dart';
import '../extensions/size_box_extension.dart';
import '../utils/size_config.dart';
import '../widget/rounded_image.dart';

class SocialActivityDetail extends StatefulWidget {
  const SocialActivityDetail({super.key, required this.title, required this.detail});

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
            Column(
              children: [RoundedImage(height: 180, width: SizeConfig().width, fit: .cover, url: widget.detail['event_image'])],
            ),
            CustomHtmlWidget(content: widget.detail['event_desc'], title: widget.title, image: ''),
          ],
        ),
      ),
    );
  }
}
