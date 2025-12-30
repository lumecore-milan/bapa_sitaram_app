import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:flutter/material.dart';

import 'package:bapa_sitaram/extensions/size_box_extension.dart';
import 'package:bapa_sitaram/models/home_detail.dart';
import 'package:bapa_sitaram/utils/size_config.dart';

class AartiPage extends StatelessWidget {
  const AartiPage({required this.detail, super.key});

  final Arti detail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: detail.title,
        showDrawerIcon: false,
        onBackTap: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                12.h,
                Text(detail.description, style: bolder(fontSize: 16, color: CustomColors().black)),
                50.h,
                ListView.separated(
                  separatorBuilder: (_, index) => const SizedBox(height: 50),
                  itemCount: detail.data.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: SizeConfig().width,
                          padding: const EdgeInsets.fromLTRB(18, 40, 18, 22),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border(
                              left: BorderSide(color: CustomColors().primaryColorDark, width: 5),
                              right: BorderSide(color: CustomColors().primaryColorDark, width: 5),
                              bottom: BorderSide(color: CustomColors().primaryColorDark, width: 5),
                            ),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12, spreadRadius: 1, offset: const Offset(0, 5))],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(detail.data[index].title, style: semiBold(fontSize: 18, color: CustomColors().primaryColorDark)),
                              const SizedBox(height: 12),
                              Text(detail.data[index].descp, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, height: 1.4)),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -30,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.red, width: 1),
                                image: DecorationImage(image: AssetImage('assets/images/aarti_${index + 1}.png'), fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                50.h,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
