import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:flutter/material.dart';

import '../extensions/size_box_extension.dart';
import '../utils/size_config.dart';
import '../widget/rounded_image.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.showAppbar});
 final bool showAppbar;

  @override
  Widget build(BuildContext context) {
    return showAppbar==false ? Scaffold(
      appBar: CustomAppbar(title: 'પ્રસંગ', showDrawerIcon: false, onBackTap: () { Navigator.pop(context); },),
      body: SafeArea(child: _getBody()),
    ):_getBody();
  }

  Widget _getBody(){
    return Container(
      height: SizeConfig().height,
      width: SizeConfig().width,
      padding: .all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:16),
              child: RoundedImage(
                url: 'https://picsum.photos/200/300',
                height: 250,
                width: SizeConfig().width,
              ),
            ),
            16.h,

          ],
        ),
      ),
    );
  }
}
