import 'dart:io';

import 'package:bapa_sitaram/widget/video_thumbnail.dart';
import 'package:flutter/material.dart';


import '../constants/routes.dart';
import '../services/helper_service.dart';
import '../services/loger_service.dart';
import '../services/permission_service.dart';
import '../utils/helper.dart';
import '../utils/route_generate.dart';
import '../utils/size_config.dart';
import '../widget/app_bar.dart';
import '../widget/rounded_image.dart';



class DownloadedPosts extends StatelessWidget {
  const DownloadedPosts({super.key});

  Future<List<String>> getDownloadedFile() async {
    List<String> list = List.empty(growable: true);
    try {
      final b = await PermissionService().manageExternalStorage();
      if (b) {
        String temp = await HelperService().getDownloadDirectory();
        if (temp.isNotEmpty) {
          final dir = Directory('$temp/bapaSitaram');
          if (dir.existsSync()) {
            final files = await dir.list();
            await for (var file in files) {
              list.add(file.path);
            }
          }
        }
      }
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'ડાઉનલોડ પોસ્ટ',
        showDrawerIcon: false,
        onBackTap: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
          child: FutureBuilder(
            future: getDownloadedFile(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                final List<String> data = snapshot.data ?? [];
                return Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: data.map((e) {
                    String type = Helper.getFileType(path: e);
                    return type == 'IMAGE'
                        ? InkWell(
                            onTap: () {
                              navigate(
                                context: context,
                                replace: false,
                                path: imageRoute,
                                param: e,
                              );
                            },
                            child: RoundedImage(
                              height: 180,
                              width: SizeConfig().width,
                              url: e,
                              fit: .cover,
                            ),
                          )
                        : type == 'VIDEO'
                        ? InkWell(
                            onTap: () {
                              navigate(
                                context: context,
                                replace: false,
                                path: videoRoute,
                                param: e,
                              );
                            },

                            child: getThumbNails(
                              url: e,
                              height: 150,
                              width: ((SizeConfig().width / 2) - 32).toInt(),
                              onTap: () {},
                            ),
                          )
                        : SizedBox.shrink();
                  }).toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
