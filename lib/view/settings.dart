import 'dart:io';

import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/constants/app_constant.dart';
import 'package:bapa_sitaram/constants/routes.dart';
import 'package:bapa_sitaram/controllers/home_controller.dart';
import 'package:bapa_sitaram/services/loger_service.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/utils/helper.dart';
import 'package:bapa_sitaram/utils/route_generate.dart';
import 'package:bapa_sitaram/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:bapa_sitaram/extensions/size_box_extension.dart';
import 'package:bapa_sitaram/services/preference_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  RxBool isSwitchOn = true.obs;
  Rx<String> cacheSize = ''.obs;
  @override
  void initState() {
    super.initState();
    isSwitchOn.value = PreferenceService().getString(key: AppConstants().prefKeyNotificationEnabled) != 'false';

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getCacheSize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Bapa Sitaram',
        showDrawerIcon: false,
        onBackTap: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              12.h,
              Text('Device Settings', style: bolder(fontSize: 16, color: CustomColors().blue700)),
              10.h,
              Obx(
                () => detailList(
                  context: context,
                  title: 'Notification',
                  image: Switch(
                    padding: .zero,
                    activeThumbColor: CustomColors().primaryColorDark,
                    activeTrackColor: CustomColors().red50,
                    inactiveThumbColor: CustomColors().grey500,
                    inactiveTrackColor: CustomColors().grey50,
                    value: isSwitchOn.value,
                    onChanged: (value) {
                      isSwitchOn.value = value;
                      PreferenceService().setString(key: AppConstants().prefKeyNotificationEnabled, value: value == false ? 'false' : 'true');
                    },
                  ),
                ),
              ),
              10.h,
              detailList(
                context: context,
                title: 'Clear Cache',
                image: Obx(() => Text(cacheSize.value, style: semiBold(fontSize: 12))),
              ),
              20.h,
              Text('Policy', style: bolder(fontSize: 16, color: CustomColors().blue700)),
              10.h,
              detailList(context: context, title: 'Refund Policy', image: const Icon(Icons.arrow_forward_ios, size: 16)),
              10.h,
              detailList(context: context, title: 'Privacy Policy', image: const Icon(Icons.arrow_forward_ios, size: 16)),
              10.h,
              detailList(context: context, title: 'Terms & Condition', image: const Icon(Icons.arrow_forward_ios, size: 16)),
              10.h,
              detailList(context: context, title: 'version:8', image: const Icon(Icons.mobile_friendly_sharp, size: 16)),
              10.h,
            ],
          ),
        ),
      ),
    );
  }

  Widget detailList({required String title, required Widget image, required BuildContext context}) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(4),
      child: GestureDetector(
        onTap: () {
          if (['Privacy Policy', 'Refund Policy', 'Terms & Condition'].indexOf(title) >= 0) {
            final cnt = Get.find<HomeDetailController>();

            navigate(
              context: context,
              replace: false,
              path: policyRoute,
              param: {
                'title': 'Privacy Policy',
                if (title == 'Privacy Policy') 'data': cnt.aboutUs['privacypolicy'] else if (title == 'Refund Policy') 'data': cnt.aboutUs['refundpolicy'] else if (title == 'Terms & Condition') 'data': cnt.aboutUs['term_condition'],
              },
            );
          } else if (title == 'Clear Cache') {
            clearCache();
          }
        },
        child: Container(
          height: 50,
          alignment: .centerLeft,
          padding: const .all(10),
          decoration: BoxDecoration(
            borderRadius: .circular(4),
            color: CustomColors().white,
            boxShadow: [
              BoxShadow(
                color: CustomColors().grey50,
                blurRadius: 4,
                spreadRadius: 2, // keep this 0 for OUTSIDE only
                offset: Offset.zero,
              ),
            ],
          ),

          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(title, style: semiBold(fontSize: 14, color: CustomColors().black)),
              image,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> clearCache() async {
    try {
      Helper.showLoader();
      Directory tempDir = await getTemporaryDirectory();
      Directory appCacheDir = await getApplicationSupportDirectory();

      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }

      if (appCacheDir.existsSync()) {
        await appCacheDir.delete(recursive: true);
      }
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
    await getCacheSize();
    Helper.closeLoader();
  }

  Future<void> getCacheSize() async {
    Directory tempDir = await getTemporaryDirectory();
    Directory appCacheDir = await getApplicationSupportDirectory();

    int totalBytes = await _getDirectorySize(tempDir);
    totalBytes += await _getDirectorySize(appCacheDir);

    cacheSize.value = _formatBytes(totalBytes);
    cacheSize.refresh();
  }

  Future<int> _getDirectorySize(Directory dir) async {
    int size = 0;

    if (dir.existsSync()) {
      try {
        await for (FileSystemEntity entity in dir.list(recursive: true)) {
          if (entity is File) size += await entity.length();
        }
      } catch (_) {}
    }

    return size;
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 KB';
    const kb = 1024;
    const mb = kb * 1024;

    if (bytes < mb) return '${(bytes / kb).toStringAsFixed(2)} KB';
    return '${(bytes / mb).toStringAsFixed(2)} MB';
  }
}
