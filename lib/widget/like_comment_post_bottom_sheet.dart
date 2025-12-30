import 'package:bapa_sitaram/controllers/feed_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/extensions/size_box_extension.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:bapa_sitaram/utils/size_config.dart';
import 'package:bapa_sitaram/widget/custom_text_field.dart';
import 'package:bapa_sitaram/widget/image_widget.dart';

class LikeCommentPostBottomSheet extends StatefulWidget {
  const LikeCommentPostBottomSheet({required this.onSend, required this.message, super.key});

  final TextEditingController message;
  final Function(String) onSend;

  @override
  State<LikeCommentPostBottomSheet> createState() => _LikeCommentPostBottomSheetState();
}

class _LikeCommentPostBottomSheetState extends State<LikeCommentPostBottomSheet> {
  final controller = Get.find<FeedController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: SizeConfig().width,
          height: SizeConfig().height,
          color: CustomColors().white1000,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const .only(top: 60, left: 16, right: 16, bottom: 80),
                  child: Obx(
                    () => ListView.separated(
                      itemCount: controller.currentPostDetail.length,
                      shrinkWrap: true,
                      separatorBuilder: (_, index) => const SizedBox(height: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        return Container(
                          padding: const .all(10),
                          decoration: BoxDecoration(color: CustomColors().layoutPrimaryBackground, borderRadius: .circular(5)),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: ImageWidget(url: controller.currentPostDetail[index]['user_image'] ?? '', height: 40, width: 40),
                              ),
                              10.w,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: .start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: .spaceBetween,
                                      crossAxisAlignment: .center,
                                      mainAxisSize: .max,
                                      children: [
                                        Expanded(
                                          child: Text(controller.currentPostDetail[index]['user_name'] ?? '', style: bolder(fontSize: 16, color: CustomColors().blue700)),
                                        ),
                                        Text(controller.currentPostDetail[index]['comment_time'] ?? '', style: semiBold(fontSize: 12, color: CustomColors().grey600)),
                                      ],
                                    ),
                                    Text(controller.currentPostDetail[index]['comment_description'] ?? '', style: semiBold(fontSize: 14, color: CustomColors().grey600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const .all(10),
                  width: SizeConfig().width,
                  margin: const .only(bottom: 10),
                  color: CustomColors().white1000,
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text('Comment', style: bolder(fontSize: 20)),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close, size: 24, color: CustomColors().black1000),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: CustomColors().white1000,
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    padding: const .symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: CustomColors().grey600),
                      borderRadius: .circular(30),
                    ),
                    width: SizeConfig().width,
                    margin: const .symmetric(horizontal: 16, vertical: 10),
                    alignment: .centerLeft,
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            autoValidateMode: AutovalidateMode.disabled,
                            validator: (val) {
                              if ((val ?? '').trim().isEmpty) {
                                return 'Add Comment';
                              }
                              return null;
                            },
                            removeBorder: true,

                            fillColor: Colors.white,
                            showMainTitle: false,
                            controller: widget.message,
                            label: 'Add Comment',
                            hint: 'Add Comment',
                            errorMessage: '',
                          ),
                        ),
                        5.w,
                        InkWell(
                          onTap: () {
                            if (widget.message.text.trim().isNotEmpty) {
                              widget.onSend(widget.message.text.trim());
                            }
                          },

                          child: Text('Send', style: bolder(fontSize: 18, color: CustomColors().primaryColorDark)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
