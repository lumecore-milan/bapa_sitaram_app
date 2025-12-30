import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/utils/helper.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bapa_sitaram/constants/routes.dart';
import 'package:bapa_sitaram/services/download/download_helper_mobile.dart';
import 'package:bapa_sitaram/utils/route_generate.dart';
import 'package:bapa_sitaram/widget/image_widget.dart';

class ImageView extends StatelessWidget {
  const ImageView({required this.url, required this.showDownloadIcon, super.key});
  final String url;
  final bool showDownloadIcon;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Image',
        showDrawerIcon: false,
        onBackTap: () {
          Navigator.pop(context);
        },
        showDownloadButton: true,
        actions: showDownloadIcon == false
            ? []
            : [
                InkWell(
                  onTap: () async {
                    Helper.showLoader();
                    await DownloadServiceMobile().download(url: url).then((t) {
                      Helper.closeLoader();

                      if (t != null) {
                        navigate(context: context, replace: false, path: downloadPostRoute);
                      }
                    });
                  },
                  child: SvgPicture.asset('assets/images/ic_download.svg', height: 20, width: 30, color: CustomColors().white),
                ),
              ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Expanded(child: Container()),
            ImageWidget(url: url),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
