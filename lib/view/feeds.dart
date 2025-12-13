import 'dart:io';

import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/constants/app_constant.dart';
import 'package:bapa_sitaram/constants/routes.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/utils/route_generate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../controllers/feed_controller.dart';
import '../extensions/size_box_extension.dart';
import '../services/app_events.dart';
import '../services/download/download_helper_mobile.dart';
import '../services/enums.dart';
import '../services/helper_service.dart';
import '../services/loger_service.dart';
import '../services/permission_service.dart';
import '../services/preference_service.dart';
import '../utils/custom_dialogs.dart';
import '../utils/helper.dart';
import '../utils/size_config.dart';
import '../widget/custom_html_widget.dart';
import '../widget/image_widget.dart';
import '../widget/like_comment_post_bottom_sheet.dart';
import '../widget/shimmer.dart';
import '../widget/video_thumbnail.dart';

class FeedsPage extends StatefulWidget {
  const FeedsPage({super.key, this.detailId = ''});

  final String detailId;

  @override
  State<FeedsPage> createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  final FeedController _controller = Get.put(FeedController());
  final TextEditingController message = TextEditingController();
  final ScrollController _scrollController=ScrollController();
  Rx<double> progress = (0.0).obs;
  String downloadPath = '';

  bool shareDialogOpen = false;

  @override
  void dispose() {
    _scrollController.dispose();
    Get.delete<FeedController>();
    super.dispose();
  }

  @override
  void initState() {
    try {
      AppEventsStream().stream.listen((event) async {
        if (event.type == AppEventType.downloadProgress) {
          final d = event.data as DownloadMessage;
          progress.value = d.progress;

          if (d.filePath != null && shareDialogOpen==false) {
            shareDialogOpen=true;
            final result = await SharePlus.instance.share(
              ShareParams(files: [XFile(d.filePath ?? '')]),
            );
            if (result.status == ShareResultStatus.success && _controller.shareIndex>=0) {
              shareDialogOpen=false;
              Helper.showLoader();
              await _controller
                  .share(postId: _controller.posts[_controller.shareIndex].postId)
                  .then((t) {
                    Helper.closeLoader();
                  });
            }else if(result.status == ShareResultStatus.dismissed){
              shareDialogOpen=false;
            }
          }
        }
      });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }

    _scrollController.addListener(() async {

        var maxScroll = _scrollController.position.maxScrollExtent;
        var currentPosition = _scrollController.position.pixels;
        if (maxScroll == currentPosition) {
          if(_controller.canLoadMore=true) {
            _controller.isLoadMore.value = true;
            _controller.initialPage=_controller.initialPage+_controller.increment;
            await _controller.getHomeDetail().then((value) {

            });
          }
        }
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.getHomeDetail().then((t) {
        if (_controller.posts.isNotEmpty && widget.detailId.isNotEmpty) {
          int ind = _controller.posts.indexWhere(
            (e) => e.postImage == widget.detailId,
          );
          if (ind >= 0) {
            navigate(
              context: context,
              replace: false,
              path: videoRoute,
              param: _controller.posts[ind].postImage,
            );
          }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: SizeConfig().height,
          padding: const EdgeInsets.all(16),
          child: Obx(
            () => _controller.isLoading.value && _controller.isLoadMore.value==false
                ? ShimmerDemo()
                : 
                   SingleChildScrollView(
                     controller: _scrollController,
                     child: ListView.separated(
                      separatorBuilder: (_, index) => SizedBox(height: 10),
                      itemCount:_controller.isLoadMore.value==false ? _controller.posts.length:
                      _controller.posts.length+1
                       ,
                      physics: NeverScrollableScrollPhysics(),
                     shrinkWrap: true,
                     // controller: _scrollController,
                      itemBuilder: (_, index) {

                        if (index >= _controller.posts.length) {
                          return _controller.isLoadMore.value ==
                              false
                              ? const SizedBox.shrink()
                              :  ShimmerDemo(count: 1);
                        }

                        return Column(
                          crossAxisAlignment: .start,
                          children: [
                            Padding(
                              padding: const .symmetric(horizontal: 10),
                              child: Row(
                                crossAxisAlignment: .center,
                                mainAxisAlignment: .center,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: CustomColors().white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: ImageWidget(
                                      url: _controller
                                          .posts[index]
                                          .userData
                                          .userProfile,
                                    ),
                                  ),
                                  10.w,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: .start,
                                      children: [
                                        Text(
                                          _controller
                                              .posts[index]
                                              .userData
                                              .userName,
                                          style: bolder(
                                            fontSize: 16,
                                            color: CustomColors().black1000,
                                          ),
                                        ),
                                        2.h,
                                        Row(
                                          children: [
                                            ImageWidget(
                                              url: 'assets/images/ic_time.svg',
                                              height: 14,
                                              width: 14,
                                              color: CustomColors().grey600,
                                            ),
                                            5.w,
                                            Text(
                                              _controller
                                                  .posts[index]
                                                  .addedDate,
                                              style: medium(
                                                fontSize: 12,
                                                color: CustomColors().grey600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            10.h,
                           /* Padding(
                              padding: const .symmetric(horizontal: 10),
                              child: CustomHtmlWidget(
                                showHtml: true,
                                content: _controller.posts[index].postDesc,
                                title: '',
                                image: '',
                              ),
                            ),*/
                            10.h,
                            _controller.posts[index].postType.toLowerCase() ==
                                    'image'
                                ? InkWell(
                              onTap: (){
                                navigate(
                                  context: context,
                                  replace: false,
                                  path: videoRoute,
                                  param:
                                  _controller.posts[index].postImage,
                                );
                              },
                                  child: ImageWidget(
                                      url: _controller.posts[index].postImage,
                                      width: SizeConfig().width,
                                    ),
                                )
                                : _controller.posts[index].postImage.isEmpty
                                ? SizedBox.shrink()
                                : getThumbNails(
                                    onTap: () {
                                      navigate(
                                        context: context,
                                        replace: false,
                                        path: videoRoute,
                                        param:
                                            _controller.posts[index].postImage,
                                      );
                                    },
                                    url: _controller.posts[index].postImage,
                                    height: 400,
                                    width: SizeConfig().width.toInt(),
                                  ),
                            10.h,
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '${_controller.posts[index].likeCount} Likes',
                                    style: semiBold(
                                      fontSize: 14,
                                      color: CustomColors().grey500,
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: .max,
                                      mainAxisAlignment: .end,
                                      children: [
                                        Text(
                                          '${_controller.posts[index].commentCount} Comments',
                                          style: semiBold(
                                            fontSize: 14,
                                            color: CustomColors().grey500,
                                          ),
                                        ),
                                        10.w,
                                        Text(
                                          '${_controller.posts[index].shareCount} Shares',
                                          style: semiBold(
                                            fontSize: 14,
                                            color: CustomColors().grey500,
                                          ),
                                        ),
                                        10.w,
                                        Text(
                                          '${_controller.posts[index].viewCount} Views',
                                          style: semiBold(
                                            fontSize: 14,
                                            color: CustomColors().grey500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            10.h,
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      message.clear();
                                      if (PreferenceService().getBoolean(
                                        key: AppConstants().prefKeyIsLoggedIn,
                                      )) {
                                        Helper.showLoader();
                                        await _controller
                                            .like(
                                              postId: _controller
                                                  .posts[index]
                                                  .postId,
                                            )
                                            .then((t) {
                                              Helper.closeLoader();
                                            });
                                      } else {
                                        showLoginDialog(context: context);
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Obx(
                                          () => ImageWidget(
                                            url:
                                                _controller
                                                        .posts[index]
                                                        .isLiked ==
                                                    1
                                                ? 'assets/images/redHeart.svg'
                                                : 'assets/images/heart.svg',
                                            height: 24,
                                            width: 24,
                                            color:
                                                _controller
                                                        .posts[index]
                                                        .isLiked ==
                                                    1
                                                ? CustomColors().red500
                                                : CustomColors().grey600,
                                          ),
                                        ),
                                        5.w,
                                        Text(
                                          'Like',
                                          style: semiBold(
                                            fontSize: 14,
                                            color: CustomColors().grey700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (PreferenceService().getBoolean(
                                        key: AppConstants().prefKeyIsLoggedIn,
                                      )) {
                                        _controller.getCommentByPostId(
                                          postId:
                                              _controller.posts[index].postId,
                                        );

                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: CustomColors()
                                              .layoutPrimaryBackground,
                                          enableDrag: true,
                                          useSafeArea: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero,
                                          ),
                                          constraints: BoxConstraints(
                                            minHeight: SizeConfig().height,
                                            maxHeight: SizeConfig().height,
                                          ),
                                          context: context,
                                          builder: (context) =>
                                              LikeCommentPostBottomSheet(
                                                message: message,

                                                onSend: (msg) async {
                                                  Helper.showLoader();
                                                  await _controller
                                                      .comment(
                                                        comment: msg,
                                                        postId: _controller
                                                            .posts[index]
                                                            .postId,
                                                      )
                                                      .then((t) {
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
                                    child: Row(
                                      children: [
                                        ImageWidget(
                                          url: 'assets/images/ic_comment.svg',
                                          height: 24,
                                          width: 24,
                                          color: CustomColors().grey600,
                                        ),
                                        5.w,
                                        Text(
                                          'Comment',
                                          style: semiBold(
                                            fontSize: 14,
                                            color: CustomColors().grey700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (PreferenceService().getBoolean(
                                        key: AppConstants().prefKeyIsLoggedIn,
                                      )) {
                                        try {
                                          final b = await PermissionService()
                                              .manageExternalStorage();
                                          if (b) {
                                            final downloadPath =
                                                await HelperService()
                                                    .getDownloadDirectory();
                                            final directory = Directory(
                                              '$downloadPath/bapaSitaram',
                                            );
                                            bool isExist = await directory
                                                .exists();
                                            if (!isExist) {
                                              await directory.create(
                                                recursive: false,
                                              );
                                            }
                                            downloadProgress(
                                              progress: progress,
                                              context: context,
                                            );
                                            _controller.shareIndex=index;
                                            DownloadServiceMobile().download(
                                              url: _controller
                                                  .posts[index]
                                                  .postImage,
                                            );
                                          } else {
                                            Helper.showMessage(
                                              title: 'Error',
                                              message:
                                                  'Storage permission not found',
                                              isSuccess: false,
                                            );
                                          }
                                        } catch (e) {
                                          LoggerService().log(
                                            message: e.toString(),
                                          );
                                        }
                                      } else {
                                        showLoginDialog(context: context);
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        ImageWidget(
                                          url: 'assets/images/whatsapp.svg',
                                          height: 22,
                                          width: 22,
                                          color: CustomColors().grey600,
                                        ),
                                        5.w,
                                        Text(
                                          'Share',
                                          style: semiBold(
                                            fontSize: 14,
                                            color: CustomColors().grey700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                                       ),
                   ),
          ),
        ),
      ),
    );
  }
}
