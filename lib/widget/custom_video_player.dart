import 'dart:io';
import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/services/helper_service.dart';
import 'package:bapa_sitaram/widget/custom_html_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:bapa_sitaram/constants/app_constant.dart';
import 'package:bapa_sitaram/controllers/feed_controller.dart';
import 'package:bapa_sitaram/extensions/size_box_extension.dart';
import 'package:bapa_sitaram/services/download/download_helper_mobile.dart';
import 'package:bapa_sitaram/services/loger_service.dart';
import 'package:bapa_sitaram/services/permission_service.dart';
import 'package:bapa_sitaram/services/preference_service.dart';
import 'package:bapa_sitaram/utils/custom_dialogs.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/utils/helper.dart';
import 'package:bapa_sitaram/utils/size_config.dart';
import 'package:bapa_sitaram/widget/image_widget.dart';
import 'package:bapa_sitaram/widget/like_comment_post_bottom_sheet.dart';

final List<String> videoExtensions = ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv', 'webm', 'm4v', '3gp', 'ts', 'mpeg', 'mpg'];

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({required this.path, super.key});

  final String path;

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late final FeedController controller;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = Get.find<FeedController>();
    int existingIndex = controller.posts.indexWhere((e) => e.postImage == widget.path);
    _pageController = PageController(initialPage: existingIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.view(postId: controller.posts[existingIndex].postId);
    });
  }

  late PageController _pageController;
  final TextEditingController message = TextEditingController();
  Future<void> view({required int index}) async {
    await controller.view(postId: controller.posts[index].postId);
  }

  @override
  Widget build(BuildContext rootContext) {
    return SafeArea(
      child: Material(
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: controller.posts.length,
          onPageChanged: (index) async {
            await view(index: index);
          },
          itemBuilder: (context, index) {
            bool isVideo = false;
            String ext = controller.posts[index].postImage.substring(controller.posts[index].postImage.lastIndexOf('.') + 1);
            if (videoExtensions.indexOf(ext.toLowerCase()) >= 0) {
              isVideo = true;
            } else {
              isVideo = false;
            }
            return SizedBox.expand(
              // height: SizeConfig().height,
              //  width: SizeConfig().width,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Obx(
                    () => isVideo == false
                        ? ImageWidget(url: controller.posts[index].postImage, fit: .fitWidth, loadIndicatorHeight: 100, loadIndicatorWidth: 100)
                        : FittedBox(
                            fit: .cover,
                            child: CustomPlayer(url: controller.posts[index].postImage),
                          ),
                  ),
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const .symmetric(horizontal: 16),
                      height: 60,
                      width: SizeConfig().width,
                      decoration: const BoxDecoration(color: Colors.transparent),
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back, color: CustomColors().white, size: 24),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (index >= 0)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const .only(left: 16, right: 16, bottom: 10, top: 16),
                        width: SizeConfig().width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              //  Colors.transparent,
                              // CustomColors().black.withAlpha(0),
                              CustomColors().black.withAlpha(30),
                              CustomColors().black.withAlpha(127),
                              CustomColors().black,
                            ],
                            /*stops: [
                              0.0,
                              1.0,
                            ],*/
                          ),

                          // color: Colors.black.withOpacity(0.4),
                        ),
                        child: Column(
                          mainAxisSize: .min,
                          crossAxisAlignment: .start,
                          children: [
                            /* Center(
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
                                  Text("સંધ્યા આરતી", style: bolder(fontSize: 22).copyWith(color: Colors.yellow)),
                                ],
                              ),
                            ),*/
                            Row(
                              mainAxisAlignment: .start,
                              crossAxisAlignment: .center,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(color: CustomColors().white, shape: BoxShape.circle),
                                  child: const ImageWidget(url: 'assets/images/asram_logo.png'),
                                ),
                                20.w,
                                Text('Bapa Sitaram Temple', style: bolder(fontSize: 16, color: CustomColors().white1000)),
                                8.w,
                                const ImageWidget(url: 'assets/images/check.svg', height: 16, width: 16),
                              ],
                            ),

                            if (controller.posts[index].postDesc.isNotEmpty)
                              Container(
                                // height: controller.posts[index].postDesc.isNotEmpty? 40:0,
                                padding: const .only(right: 20),
                                child: CustomHtmlWidget(showHtml: true, fontColor: CustomColors().white, content: controller.posts[index].postDesc, title: '', image: ''),
                              ),
                            /* CustomHtmlWidget(
                              title: '',
                                image: '',

                                fontWeight: FontWeight.w600,
                                content: controller.posts[index].postDesc,fontColor: CustomColors().white),*/
                            if (controller.posts[index].postDesc.isNotEmpty)
                              Row(
                                children: [
                                  ImageWidget(url: 'assets/images/ic_view.svg', height: 20, width: 20, color: CustomColors().white1000),
                                  10.w,
                                  Obx(() => Text('${controller.posts[index].viewCount}', style: bolder(fontSize: 14, color: CustomColors().white1000))),
                                  10.w,
                                  Text(controller.posts[index].addedDate, style: bolder(fontSize: 14, color: CustomColors().white1000)),
                                ],
                              ),
                            10.h,
                            InkWell(
                              onTap: () async {
                                if (PreferenceService().getBoolean(key: AppConstants().prefKeyIsLoggedIn)) {
                                  Helper.showLoader();
                                  await controller.getCommentByPostId(postId: controller.posts[index].postId).then((r) {
                                    Helper.closeLoader();
                                    _showBottomSheet(index: index);
                                  });
                                } else {
                                  showLoginDialog(context: context);
                                }
                              },
                              child: Container(
                                width: SizeConfig().width,
                                padding: const .all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: CustomColors().white1000, width: 1),
                                  borderRadius: .circular(30),
                                ),
                                child: Text('Add Comment', style: bolder(fontSize: 16, color: CustomColors().white1000)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (index >= 0)
                    Positioned(
                      bottom: 80,
                      right: 10,
                      child: Container(
                        alignment: .topCenter,
                        width: 40,
                        child: Column(
                          crossAxisAlignment: .center,
                          children: [
                            Obx(
                              () => InkWell(
                                onTap: () async {
                                  if (PreferenceService().getBoolean(key: AppConstants().prefKeyIsLoggedIn)) {
                                    Helper.showLoader();
                                    await controller.like(postId: controller.posts[index].postId).then((t) {
                                      Helper.closeLoader();
                                    });
                                  } else {
                                    showLoginDialog(context: context);
                                  }
                                },
                                child: ImageWidget(
                                  url: controller.posts[index].isLiked == 1 ? 'assets/images/redHeart.svg' : 'assets/images/heart.svg',
                                  height: 24,
                                  width: 24,
                                  color: controller.posts[index].isLiked == 1 ? CustomColors().red500 : CustomColors().white1000,
                                ),
                              ),
                            ),
                            5.h,
                            Obx(() => Text('${controller.posts[index].likeCount}', style: semiBold(fontSize: 12, color: CustomColors().white))),
                            10.h,
                            InkWell(
                              onTap: () async {
                                Helper.showLoader();
                                await HelperService().downloadFile(url: controller.posts[index].postImage).then((r) {
                                  Helper.closeLoader();
                                });
                              },

                              child: ImageWidget(url: 'assets/images/ic_download.svg', height: 24, width: 24, color: CustomColors().white),
                            ),
                            5.h,
                            Text('Save', style: semiBold(fontSize: 12, color: CustomColors().white)),
                            10.h,
                            InkWell(
                              onTap: () {
                                if (PreferenceService().getBoolean(key: AppConstants().prefKeyIsLoggedIn)) {
                                  controller.getCommentByPostId(postId: controller.posts[index].postId);

                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: CustomColors().layoutPrimaryBackground,
                                    enableDrag: true,
                                    useSafeArea: true,
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                    constraints: BoxConstraints(minHeight: SizeConfig().height, maxHeight: SizeConfig().height),
                                    context: context,
                                    builder: (context) => LikeCommentPostBottomSheet(
                                      message: message,

                                      onSend: (msg) async {
                                        Helper.showLoader();
                                        await controller.comment(comment: msg, postId: controller.posts[index].postId).then((t) {
                                          Helper.closeLoader();
                                          if (t == true) {
                                            message.clear();
                                          }
                                        });
                                      },
                                    ),
                                  );
                                } else {
                                  showLoginDialog(context: context);
                                }
                              },

                              child: ImageWidget(url: 'assets/images/ic_comment.svg', height: 24, width: 24, color: CustomColors().white),
                            ),
                            5.h,
                            Obx(() => Text('${controller.posts[index].commentCount}', style: semiBold(fontSize: 12, color: CustomColors().white))),
                            10.h,
                            InkWell(
                              onTap: () async {
                                // if (PreferenceService().getBoolean(key: AppConstants().prefKeyIsLoggedIn))
                                {
                                  try {
                                    final b = await PermissionService().manageExternalStorage();
                                    if (b) {
                                      final downloadPath = await HelperService().getDownloadDirectory();
                                      final directory = Directory('$downloadPath/bapaSitaram');
                                      bool isExist = await directory.exists();
                                      if (!isExist) {
                                        await directory.create(recursive: false);
                                      }
                                      if (mounted && rootContext.mounted) {
                                        downloadProgress(progress: controller.progress, context: rootContext);
                                      }
                                      controller.shareIndex = index;
                                      await DownloadServiceMobile().download(url: controller.posts[index].postImage);
                                    } else {
                                      Helper.showMessage(title: 'Error', message: 'Storage permission not found', isSuccess: false);
                                    }
                                  } catch (e) {
                                    LoggerService().log(message: e.toString());
                                  }
                                } /*else {
                                  showLoginDialog(context: context);
                                }*/
                              },
                              child: ImageWidget(url: 'assets/images/whatsapp.svg', height: 20, width: 24, color: CustomColors().white),
                            ),
                            5.h,
                            Obx(() => Text('${controller.posts[index].shareCount}', style: semiBold(fontSize: 12, color: CustomColors().white))),
                            5.h,
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showBottomSheet({required int index}) {
    final TextEditingController message = TextEditingController();
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: CustomColors().layoutPrimaryBackground,
      enableDrag: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      constraints: BoxConstraints(minHeight: SizeConfig().height, maxHeight: SizeConfig().height),
      context: context,
      builder: (context) => LikeCommentPostBottomSheet(
        message: message,

        onSend: (msg) async {
          Helper.showLoader();
          await controller.comment(comment: msg, postId: controller.posts[index].postId).then((t) {
            Helper.closeLoader();
            if (t == true) {
              message.clear();
            }
          });
        },
      ),
    );
  }
}

class CustomPlayer extends StatefulWidget {
  const CustomPlayer({required this.url, super.key});

  final String url;

  @override
  State<CustomPlayer> createState() => _CustomPlayerState();
}

class _CustomPlayerState extends State<CustomPlayer> {
  late VideoPlayerController _controller;
  Rx<bool> isPlaying = false.obs;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.url.startsWith('http') == false) {
      _controller = VideoPlayerController.file(File(widget.url), viewType: VideoViewType.platformView);
    } else {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url), viewType: VideoViewType.platformView);
    }
    _controller.initialize().then((r) {
      _controller.play();
      isPlaying.value = true;
      _controller.setLooping(true);
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _controller.value.size.width,
      height: _controller.value.size.height,
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              if (_controller.value.isPlaying) {
                isPlaying.value = false;
                _controller.pause();
              } else {
                isPlaying.value = true;
                _controller.play();
              }
              isPlaying.refresh();
            },
            child: VideoPlayer(_controller),
          ),
          Obx(
            () => (isPlaying.value == true || _controller.value.isInitialized == false)
                ? const SizedBox.shrink()
                : Positioned(
                    top: (SizeConfig().height / 2) + 100,
                    left: (SizeConfig().width / 2) + 100,
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.25), shape: BoxShape.circle),
                        padding: const EdgeInsets.all(12),
                        child: ImageWidget(url: 'assets/images/ic_play.svg', height: 50, width: 50, color: CustomColors().white1000),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
