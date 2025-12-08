import 'dart:convert';
import 'dart:math';

import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/constants/routes.dart';

import 'package:bapa_sitaram/utils/custom_dialogs.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/utils/route_generate.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:bapa_sitaram/widget/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../constants/api_constant.dart';
import '../constants/app_constant.dart';
import '../extensions/size_box_extension.dart';
import '../services/loger_service.dart';
import '../services/network/api_mobile.dart';
import '../services/preference_service.dart';
import '../utils/helper.dart';
import '../widget/shimmer.dart';

class MyDonationList extends StatefulWidget {
  MyDonationList({super.key});

  @override
  State<MyDonationList> createState() => _MyDonationListState();
}

class _MyDonationListState extends State<MyDonationList> {
  Rx<double> total = (0.0).obs;

String donationUrl='';


  @override
  void initState() {
    super.initState();

  }

  Future<List<dynamic>> getDetail() async {
    Map<String, dynamic> userDetail = {};
    String temp = PreferenceService().getString(
      key: AppConstants().prefKeyUserDetail,
    );
    if (temp.isNotEmpty) {
      userDetail = json.decode(temp);
    }
    List<dynamic> list = List.empty(growable: true);
    try {
      final apiInstance = NetworkServiceMobile();
      await apiInstance
          .post(
            url: APIConstant().apiMyDonation,
            isFormData: true,
            requestBody: {
              'mobile_no': 1 > 0 ? '9685748596' : userDetail['mobile'],
            },
          )
          .then((data) {
            if (data.isNotEmpty) {
              if (data['httpStatusCode'] == 200) {
                list = data['data'];
              }
            }
          });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
    return list;
  }

  Future<String> downloadReceipt({required int id}) async {
    String url='';
    try {
      final apiInstance = NetworkServiceMobile();
      await apiInstance
          .post(
        url: APIConstant().apiDownloadInvoice,
        isFormData: true,
        requestBody: {
          'id': 1 > 0 ? 1 : id,
        },
      )
          .then((data) {
        if (data.isNotEmpty) {
          if (data['httpStatusCode'] == 200) {
            url = data['invoice']??'';
          }
        }
      });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'My Donation',
        showDrawerIcon: false,
        onBackTap: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: getDetail(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerDemo();
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                final list = snapshot.data ?? [];
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: CustomColors().blue700,
                        borderRadius: .circular(10),
                      ),
                      padding: .all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Text(
                                'My Total Donation',
                                style: semiBold(
                                  fontSize: 14,
                                  color: CustomColors().white,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  navigate(
                                    context: context,
                                    replace: false,
                                    path: donationRoute,
                                    param: true,
                                  );
                                },
                                child: Icon(
                                  Icons.add,
                                  size: 24,
                                  color: CustomColors().white,
                                ),
                              ),
                            ],
                          ),
                          50.h,
                          Center(
                            child: Column(
                              mainAxisSize: .min,
                              children: [
                                Text(
                                  'Donation',
                                  style: semiBold(
                                    fontSize: 16,
                                    color: CustomColors().white1000,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    NumberFormat.currency(
                                      locale: "en_IN",
                                      symbol: "₹",
                                    ).format(total.value),
                                    style: semiBold(
                                      fontSize: 22,
                                      color: CustomColors().white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          20.h,
                        ],
                      ),
                    ),
                    10.h,
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      separatorBuilder: (_, index) => 10.h,
                      itemBuilder: (_, index) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          total.value =
                              total.value +
                              (double.tryParse(
                                    list[index]['amount'] as String,
                                  ) ??
                                  0);
                        });

                        return InkWell(
                          onTap: (){
                            Helper.showLoader();
                            downloadReceipt(id: list[index]['id']).then((url){
                                  Helper.closeLoader();
                              if(url.isNotEmpty){
                                downloadReceiptDialog(context: context, detail: list[index],url: url);
                              }
                            });
                          },
                          child: Container(
                            padding: .all(10),
                            alignment: .centerLeft,
                            decoration: BoxDecoration(
                              color: CustomColors().white,
                              borderRadius: .circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: CustomColors().grey200,
                                  blurRadius: 4,
                                  spreadRadius: 2, // keep this 0 for OUTSIDE only
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: .center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  padding: .all(5),
                                  alignment: .center,
                                  decoration: BoxDecoration(
                                    borderRadius: .circular(10),
                                    color: getRandomColor(),
                                  ),
                                  child: ImageWidget(
                                    url: 'assets/images/ic_payment.svg',
                                    color: CustomColors().white,
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                                10.w,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      Text(
                                        'Donation for',
                                        style: semiBold(fontSize: 14),
                                      ),
                          
                                      Text(
                                        list[index]['donation_type'] ?? '',
                                        style: bolder(fontSize: 18),
                                      ),
                          
                                      Text(
                                        list[index]['payment_date'] ?? '',
                                        style: medium(
                                          fontSize: 10,
                                          color: CustomColors().grey600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '₹${list[index]['amount'] ?? ''}',
                                  style: bolder(
                                    fontSize: 18,
                                    color: CustomColors().green600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
