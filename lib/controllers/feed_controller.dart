import 'dart:convert';

import 'package:bapa_sitaram/constants/api_constant.dart';
import 'package:bapa_sitaram/constants/app_constant.dart';

import 'package:get/get.dart';
import 'package:bapa_sitaram/models/feed_detail.dart';
import 'package:bapa_sitaram/services/loger_service.dart';

import 'package:bapa_sitaram/services/network/api_mobile.dart';
import 'package:bapa_sitaram/services/preference_service.dart';

class FeedController extends GetxController {
  int shareIndex = -1;
  final _apiInstance = NetworkServiceMobile();
  RxList<PostModel> posts = RxList();
  RxList<dynamic> currentPostDetail = RxList();
  Rx<bool> isLoading = false.obs;
  Rx<bool> isLoadMore = false.obs;
  bool canLoadMore = false;
  int initialPage = 50;
  int increment = 30;
  Future<void> getHomeDetail() async {
    try {
      if (canLoadMore == false) {
        isLoading.value = true;
      }
      await Future.wait([
        _apiInstance.post(
          url: APIConstant().apiFeeds,
          isFormData: true,
          requestBody: {
            'user_id': PreferenceService().getInt(
              key: AppConstants().prefKeyUserId,
            ),
            'no_of_post': initialPage,
          },
        ),
      ]).then((responses) {
        if (canLoadMore == false) {
          isLoading.value = false;
        }
        if (responses[0].isNotEmpty) {
          if (responses[0]['httpStatusCode'] == 200) {
            final temp = PostModel.fromJsonList(responses[0]['data']);
            if (isLoadMore.value = false) {
              posts.value = PostModel.fromJsonList(responses[0]['data']);
              if (posts.length >= initialPage) {
                canLoadMore = true;
              }
            } else {
              final int oldCount = posts.length;
              if (temp.length > oldCount) {
                temp.removeRange(0, oldCount);
              } else {
                temp.clear();
              }
              if (temp.isNotEmpty) {
                canLoadMore = true;
                posts.addAll(temp);
                //  posts.refresh();
              }
            }
          }
        }
      });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }

  Future<void> getPostBySpecificId({required String postId}) async {
    try {
      await Future.wait([
        _apiInstance.post(
          url: APIConstant().apiPostById,
          isFormData: true,
          requestBody: {
            if (PreferenceService().getInt(key: AppConstants().prefKeyUserId) !=
                0)
              'user_id': PreferenceService().getInt(
                key: AppConstants().prefKeyUserId,
              ),
            'post_id': postId,
          },
        ),
      ]).then((responses) {
        if (responses[0].isNotEmpty) {
          if (responses[0]['httpStatusCode'] == 200) {
            final temp = PostModel.fromJson(
              responses[0]['data'],
              hidedetail: true,
            );
            posts.add(temp);
            posts.refresh();
          }
        }
      });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }

  Future<void> like({required int postId}) async {
    try {
      await _apiInstance
          .post(
            url: APIConstant().apiPostLike,
            isFormData: true,
            requestBody: {
              'post_id': postId,
              'user_id': PreferenceService().getInt(
                key: AppConstants().prefKeyUserId,
              ),
            },
          )
          .then((resp) {
            LoggerService().log(message: json.encode(resp));
            if (resp.isNotEmpty) {
              if (resp['httpStatusCode'] == 200) {
                int temp = posts.indexWhere((e) => e.postId == postId);
                if (temp >= 0) {
                  posts[temp].isLiked = posts[temp].isLiked == 1 ? 0 : 1;

                  if (posts[temp].isLiked == 1) {
                    posts[temp].likeCount = posts[temp].likeCount + 1;
                  } else {
                    posts[temp].likeCount = posts[temp].likeCount - 1;
                  }

                  posts.refresh();
                }
              }
            }
          });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }

  Future<void> view({required int postId}) async {
    try {
      await _apiInstance
          .post(
            url: APIConstant().apiPostView,
            isFormData: true,
            requestBody: {
              'post_id': postId,
              'user_id': PreferenceService().getInt(
                key: AppConstants().prefKeyUserId,
              ),
            },
          )
          .then((resp) {
            LoggerService().log(message: json.encode(resp));
            if (resp.isNotEmpty) {
              if (resp['httpStatusCode'] == 200) {
                int temp = posts.indexWhere((e) => e.postId == postId);
                if (temp >= 0) {
                  posts[temp].viewCount = posts[temp].viewCount + 1;
                  posts.refresh();
                }
              }
            }
          });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }

  Future<void> share({required int postId}) async {
    try {
      await _apiInstance
          .post(
            url: APIConstant().apiPostShare,
            isFormData: true,
            requestBody: {
              'post_id': postId,
              'user_id': PreferenceService().getInt(
                key: AppConstants().prefKeyUserId,
              ),
            },
          )
          .then((resp) {
            if (resp.isNotEmpty) {
              if (resp['httpStatusCode'] == 200) {
                int temp = posts.indexWhere((e) => e.postId == postId);
                if (temp >= 0) {
                  posts[temp].shareCount = posts[temp].shareCount + 1;
                  posts.refresh();
                }
              }
            }
          });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }

  Future<bool> comment({required int postId, required String comment}) async {
    bool success = false;
    try {
      await _apiInstance
          .post(
            url: APIConstant().apiPostComment,
            isFormData: true,
            requestBody: {
              'post_id': postId,
              'user_id': PreferenceService().getInt(
                key: AppConstants().prefKeyUserId,
              ),
              'comment': comment,
            },
          )
          .then((resp) {
            if (resp.isNotEmpty) {
              if (resp['httpStatusCode'] == 200) {
                int temp = posts.indexWhere((e) => e.postId == postId);
                if (temp >= 0) {
                  posts[temp].commentCount = posts[temp].commentCount + 1;
                  posts.refresh();
                }
                success = true;
              }
            }
          });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
    return success;
  }

  Future<void> getCommentByPostId({required int postId}) async {
    try {
      currentPostDetail.clear();
      await _apiInstance
          .get(url: '${APIConstant().apiGetCommentByPost}/$postId')
          .then((resp) {
            if (resp.isNotEmpty) {
              if (resp['httpStatusCode'] == 200) {
                currentPostDetail.value = resp['data'];
                currentPostDetail.refresh();
              }
            }
          });
    } catch (e) {
      LoggerService().log(message: e.toString());
    }
  }
}
