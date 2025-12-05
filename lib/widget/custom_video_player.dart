import 'dart:io';

import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../controllers/feed_controller.dart';
import '../extensions/size_box_extension.dart';
import '../utils/font_styles.dart';
import '../utils/size_config.dart';
import 'image_widget.dart';
import 'like_comment_post_bottom_sheet.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({super.key, required this.path});
  final String path;
  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;
  late final FeedController controller;
  int existingIndex=-1;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if(widget.path.startsWith('http')==false){
      _controller = VideoPlayerController.file(
        File(widget.path),
        viewType: VideoViewType.platformView,
      );
    }else {
      controller = Get.find<FeedController>();
      existingIndex=controller.posts.indexWhere((e)=>e.postImage==widget.path);
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.path),
        viewType: VideoViewType.platformView,
      );
    }
    _controller.addListener(() {});
    _controller.setLooping(false);
    _controller.initialize().then((_) {
      _controller.play();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Stack(
          fit: StackFit.expand,
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.fitHeight,
                // or BoxFit.contain if you want letterboxing
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
            /* SizedBox(
              height: SizeConfig().height,
              width: SizeConfig().width,
              child: VideoPlayer(_controller),
            ),*/
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: .symmetric(horizontal: 16),
                height: 60,
                width: SizeConfig().width,
                decoration: BoxDecoration(color: Colors.transparent),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: CustomColors().white,
                        size: 24,
                      ),
                    ),

                    Stack(
                      alignment: .center,
                      children: [
                        Text(
                          "બાપા સીતારામ",
                          style: bolder(fontSize: 18).copyWith(
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = CustomColors().black,
                          ),
                        ),
                        Text(
                          "બાપા સીતારામ",
                          style: bolder(
                            fontSize: 18,
                          ).copyWith(color: CustomColors().white),
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: CustomColors().white,
                        shape: BoxShape.circle,
                      ),
                      child: ImageWidget(url: 'assets/images/asram_logo.png'),
                    ),
                  ],
                ),
              ),
            ),
            if(existingIndex>=0)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: .only(left: 16, right: 16, bottom: 10),
                width: SizeConfig().width,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Center(
                      child: Stack(
                        alignment: .center,
                        children: [
                          Text(
                            "સંધ્યા આરતી",
                            style: bolder(fontSize: 22).copyWith(
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 4
                                ..color = Colors.black,
                            ),
                          ),
                          Text(
                            "સંધ્યા આરતી",
                            style: bolder(
                              fontSize: 22,
                            ).copyWith(color: Colors.yellow),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: CustomColors().white,
                            shape: BoxShape.circle,
                          ),
                          child: ImageWidget(
                            url: 'assets/images/asram_logo.png',
                          ),
                        ),
                        20.w,
                        Text(
                          "Bapa Sitaram Temple",
                          style: bolder(
                            fontSize: 16,
                            color: CustomColors().white1000,
                          ),
                        ),
                        8.w,
                        ImageWidget(
                          url: 'assets/images/check.svg',
                          height: 16,
                          width: 16,
                        ),
                      ],
                    ),
                    10.h,
                    Text(
                      "સંધ્યા આરતી",
                      style: bolder(
                        fontSize: 14,
                        color: CustomColors().white1000,
                      ),
                    ),
                    10.h,
                    Row(
                      children: [
                        ImageWidget(
                          url: 'assets/images/ic_view.svg',
                          height: 20,
                          width: 20,
                          color: CustomColors().grey400,
                        ),

                        10.w,
                        Text(
                          "181",
                          style: bolder(
                            fontSize: 14,
                            color: CustomColors().grey400,
                          ),
                        ),
                        10.w,
                        Text(
                          "13 hour ago",
                          style: medium(
                            fontSize: 14,
                            color: CustomColors().grey400,
                          ),
                        ),
                      ],
                    ),
                    10.h,
                    InkWell(
                      onTap: () {
                        _showBottomSheet();
                      },
                      child: Container(
                        width: SizeConfig().width,
                        padding: .all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: CustomColors().white1000,
                            width: 1,
                          ),
                          borderRadius: .circular(30),
                        ),
                        child: Text(
                          "Add Comment",
                          style: bolder(
                            fontSize: 16,
                            color: CustomColors().white1000,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if(existingIndex>=0)
            Positioned(
              bottom: 80,
              right: 10,
              child: Container(
                alignment: .topCenter,
                width: 40,
                child: Column(
                  crossAxisAlignment: .center,
                  children: [
                    ImageWidget(
                      url: 'assets/images/heart.svg',
                      height: 24,
                      width: 24,
                      color: CustomColors().white,
                    ),
                    5.h,
                    Text(
                      '39',
                      style: semiBold(
                        fontSize: 12,
                        color: CustomColors().white,
                      ),
                    ),
                    5.h,
                    ImageWidget(
                      url: 'assets/images/heart.svg',
                      height: 24,
                      width: 24,
                      color: CustomColors().white,
                    ),
                    5.h,
                    Text(
                      'Save',
                      style: semiBold(
                        fontSize: 12,
                        color: CustomColors().white,
                      ),
                    ),
                    5.h,
                    ImageWidget(
                      url: 'assets/images/ic_comment.svg',
                      height: 24,
                      width: 24,
                      color: CustomColors().white,
                    ),
                    5.h,
                    Text(
                      '39',
                      style: semiBold(
                        fontSize: 12,
                        color: CustomColors().white,
                      ),
                    ),
                    5.h,
                    ImageWidget(
                      url: 'assets/images/whatsapp.svg',
                      height: 20,
                      width: 24,
                      color: CustomColors().white,
                    ),
                    5.h,
                    Text(
                      '39',
                      style: semiBold(
                        fontSize: 12,
                        color: CustomColors().white,
                      ),
                    ),
                    5.h,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet() {
    final TextEditingController message = TextEditingController();
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: CustomColors().layoutPrimaryBackground,
      enableDrag: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      constraints: BoxConstraints(
        minHeight: SizeConfig().height,
        maxHeight: SizeConfig().height,
      ),
      context: context,
      builder: (context) => LikeCommentPostBottomSheet(
        message: message,
        onSend: (msg) async {

          await controller
              .comment(
                comment: msg,
                postId: controller.posts[existingIndex].postId,
              )
              .then((t) {
                   message.clear();
              });
        },
      ),
    );
  }
}
