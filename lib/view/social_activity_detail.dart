import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:bapa_sitaram/widget/custom_html_widget.dart';
import 'package:flutter/material.dart';
import 'package:bapa_sitaram/utils/size_config.dart';

class SocialActivityDetail extends StatefulWidget {
  const SocialActivityDetail({required this.title, required this.detail, super.key});

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
    return SizedBox(
      height: SizeConfig().height,
      width: SizeConfig().width,
      child: CustomHtmlWidget(content: widget.detail['event_desc'], title: widget.title, image: widget.detail['event_image']),
    );
  }
}
