import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io';

import '../constants/app_colors.dart';
import '../services/helper_service.dart';
import '../services/loger_service.dart';
import 'image_widget.dart';

Future<String?> generateThumbnail({
  required String videoPath,
  required int height,
  required int width,
}) async {
  try {
    late final tempDir;
    if (Platform.isAndroid) {
      tempDir = Directory.systemTemp;
    } else {
      String t = await HelperService().getApplicationDirectory();
      tempDir=Directory(t);
    }
    String fileName = videoPath.substring(
      videoPath.lastIndexOf('/') + 1,
      videoPath.lastIndexOf('.'),
    );
    fileName = fileName.trim().replaceAll(' ', '');
    fileName = fileName.trim().replaceAll('-', '_');
    fileName = '${tempDir.path}/$fileName.jpg';
    final bool exist = await File(fileName).exists();
    if (exist) {
      return fileName;
    }
    final thumbPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      quality: 100,
      maxHeight: height,
      thumbnailPath: fileName,
      maxWidth: width,
    );
    return thumbPath;
  } catch (e) {
    LoggerService().log(message: e.toString());
  }
  return null;
}

Widget getThumbNails({
  required String url,
  required int height,
  required int width,
  required VoidCallback onTap,
}) {
  return FutureBuilder(
    future: generateThumbnail(videoPath: url, width: width, height: height),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting ||
          snapshot.data == null) {
        return SizedBox(
          height: height.toDouble(),
          width: width.toDouble(),
          child: Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      } else {
        //   generated(true);
        return InkWell(
          onTap: (){
            onTap();
          },
          child: Stack(
            children: [
              Image.file(
                File(snapshot.data!),
                height: height.toDouble(),
                width: width.toDouble(),
                fit: BoxFit.cover,
              ),
              Positioned(
                top: (height / 2) - 37,
                left: (width / 2) - 37,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(12),
                    child: ImageWidget(
                      url: 'assets/images/ic_play.svg',
                      height: 50,
                      width: 50,
                      color: CustomColors().white1000,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    },
  );
}
