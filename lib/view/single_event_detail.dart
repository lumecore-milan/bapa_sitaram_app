/*import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../extensions/size_box_extension.dart';
import '../utils/font_styles.dart';
import '../utils/size_config.dart';
import '../widget/custom_html_widget.dart';
import '../widget/rounded_image.dart';

class SingleDetailPage extends StatelessWidget {
  const SingleDetailPage({super.key,required this.imageUrl,required this.content,required this.title});

  final String imageUrl,title,content;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'પ્રસંગ', showDrawerIcon: false, onBackTap: () { Navigator.pop(context); },),
      body: SafeArea(child: _getBody()),
    );
  }

  Widget _getBody(){
    return Container(
      height: SizeConfig().height,
      width: SizeConfig().width,
      child: SingleChildScrollView(
        child:
        Column(
          mainAxisSize: .min,
          children: [
            16.h,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: .center,
                children: [
                  RoundedImage(
                      url:
                      imageUrl,
                    ),

                  16.h,
                  Text(
                    title,
                    style: bolder(
                      fontSize: 18,
                      color: CustomColors().black,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                  padding: .symmetric(horizontal:16),
                  child:
                  CustomHtmlWidget(content:content)
              ),

          ],
        ),
      ),
    );
  }
}
*/