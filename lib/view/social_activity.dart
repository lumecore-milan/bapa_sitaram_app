import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/constants/routes.dart';
import 'package:bapa_sitaram/services/network/api_mobile.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/utils/route_generate.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:bapa_sitaram/widget/rounded_image.dart';
import 'package:flutter/material.dart';

import 'package:bapa_sitaram/constants/api_constant.dart';
import 'package:bapa_sitaram/services/loger_service.dart';

import 'package:bapa_sitaram/utils/size_config.dart';
import 'package:bapa_sitaram/widget/shimmer.dart';

class SocialActivities extends StatelessWidget {
  const SocialActivities({super.key});

  Future<List<dynamic>> getDetail() async {
    List<dynamic> list = List.empty(growable: true);
    try {
      final apiInstance = NetworkServiceMobile();
      await apiInstance.post(url: APIConstant().apiSocialActivity, requestBody: {'social_activities': true}, isFormData: true).then((data) {
        if (data.isNotEmpty) {
          if (data['httpStatusCode'] == 200) {
            list = data['data'];
          }
        }
      });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
    list = (list.reversed).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'સામાજિક પ્રવૃત્તિ',
        showDrawerIcon: false,
        onBackTap: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
          child: FutureBuilder(
            future: getDetail(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerDemo();
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final List<dynamic> data = snapshot.data ?? [];
                return ListView.separated(
                  shrinkWrap: true,
                  padding: .zero,
                  itemCount: data.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 10),
                  itemBuilder: (_, index) {
                    return InkWell(
                      onTap: () {
                        navigate(context: context, replace: false, path: socialActivityDetailRoute, param: {'title': data[index]['event_title'], 'data': data[index]});
                      },
                      child: Stack(
                        children: [
                          RoundedImage(height: 180, width: SizeConfig().width, url: data[index]['event_image'], fit: .cover),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.transparent, CustomColors().black1000.withOpacity(0.7)], stops: [0.0, 0.6, 1.0]),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 20,
                            child: Text(data[index]['event_title'], style: semiBold(fontSize: 14, color: CustomColors().white)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
