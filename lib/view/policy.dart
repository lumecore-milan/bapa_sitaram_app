import 'package:bapa_sitaram/utils/size_config.dart';
import 'package:flutter/material.dart';
import '../widget/app_bar.dart';
import '../widget/custom_html_widget.dart';

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
        child: SizedBox(
          height: SizeConfig().height,
          child: CustomHtmlWidget(content: detail,image: '',title: '',),
        ),
      ),
    );
  }
}
