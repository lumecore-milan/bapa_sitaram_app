import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/services/network/api_mobile.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:flutter/material.dart';

import '../constants/api_constant.dart';
import '../extensions/size_box_extension.dart';
import '../services/loger_service.dart';

import '../utils/size_config.dart';
import '../widget/image_widget.dart';

class PressMedia extends StatelessWidget {
  const PressMedia({super.key});

  Future<List<dynamic>> getDetail() async {
    List<dynamic> list = List.empty(growable: true);
    try {
      final apiInstance = NetworkServiceMobile();
      await apiInstance.get(url: APIConstant().apiPresMedia).then((data) {
        if (data.isNotEmpty) {
          if (data['httpStatusCode'] == 200) {
              list=data['data'];
          }
        }
      });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'પ્રેસ મીડિયા',
        showDrawerIcon: false,
        onBackTap: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:16.0),
          child: FutureBuilder(
            future: getDetail(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                final List<dynamic> data = snapshot.data ?? [];
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: data.length,
                  separatorBuilder: (_,index)=>SizedBox(height: 10),
                  itemBuilder: (_, index) {
                    return Column(
                      mainAxisSize: .min,
                      children: [
                        if(index==0)
                          10.h,
                        Container(
                          width: SizeConfig().width,
                          decoration: BoxDecoration(
                            color: CustomColors().primaryColorDark,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          padding: .all(10),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(data[index]['title'],
                              style: semiBold(fontSize: 20,color: CustomColors().white),
                              ),
                              5.h,
                              Text(data[index]['date'],
                                style: medium(fontSize: 14,color: CustomColors().white),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: .all(10),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            border:.all(color:CustomColors().grey600,width:1)
                          ),
                          width: SizeConfig().width,
                          child: ImageWidget(url: data[index]['image'],fit: .cover),
                        ),
                        if(index==data.length-1)
                          50.h,
                      ],
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
