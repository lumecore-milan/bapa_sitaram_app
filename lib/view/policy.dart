import 'package:bapa_sitaram/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:bapa_sitaram/widget/custom_html_widget.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({required this.detail, required this.title, super.key});

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
        child: SizedBox(
          height: SizeConfig().height,
          child: CustomHtmlWidget(content: detail, image: '', title: ''),
        ),
      ),
    );
  }
}
