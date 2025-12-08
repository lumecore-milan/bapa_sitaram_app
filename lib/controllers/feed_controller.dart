import 'dart:convert';

import 'package:bapa_sitaram/constants/api_constant.dart';
import 'package:bapa_sitaram/constants/app_constant.dart';

import 'package:get/get.dart';
import '../models/feed_detail.dart';
import '../services/loger_service.dart';

import '../services/network/api_mobile.dart';
import '../services/preference_service.dart';
class FeedController extends GetxController
{

  int shareIndex = -1;
  final _apiInstance=NetworkServiceMobile();
  RxList<PostModel> posts=RxList();
  RxList<dynamic> currentPostDetail=RxList();
  Rx<bool> isLoading=false.obs;
  Future<void> getHomeDetail()async{
    try{
      isLoading.value=true;
      await Future.wait([
        _apiInstance.post(url: APIConstant().apiFeeds,isFormData: true,requestBody: {
          'user_id':PreferenceService().getInt(key: AppConstants().prefKeyUserId),
          'no_of_post':30,
        }),
      ]).then((responses){
        isLoading.value=false;
        if(responses[0].isNotEmpty){
          if(responses[0]['httpStatusCode']==200){
            posts.value=PostModel.fromJsonList(responses[0]['data']);
            posts.refresh();
          }
        }
      });

    }catch(e){
      LoggerService().log(message: e.toString());
    }
  }
  Future<void> like({required int postId})async{

    try{
      await _apiInstance.post(url: APIConstant().apiPostLike,isFormData: true,requestBody: {
        'post_id':postId,
        'user_id':PreferenceService().getInt(key: AppConstants().prefKeyUserId),
      }).then((resp){
        LoggerService().log(message: json.encode(resp));
        if(resp.isNotEmpty){
          if(resp['httpStatusCode']==200){
                int temp=posts.indexWhere((e)=>e.postId==postId);
                if(temp>=0){
                  posts[temp].isLiked=posts[temp].isLiked==1 ? 0:1;

                 if(posts[temp].isLiked==1){
                   posts[temp].likeCount=posts[temp].likeCount+1;
                 }else{
                   posts[temp].likeCount=posts[temp].likeCount-1;
                 }

                  posts.refresh();
                }
          }
        }
      });
    }catch(e){
      LoggerService().log(message: e.toString());
    }
  }
  Future<void> view({required int postId})async{

    try{
      await _apiInstance.post(url: APIConstant().apiPostView,isFormData: true,requestBody: {
        'post_id':postId,
        'user_id':PreferenceService().getInt(key: AppConstants().prefKeyUserId),
      }).then((resp){
        LoggerService().log(message: json.encode(resp));
        if(resp.isNotEmpty){
          if(resp['httpStatusCode']==200){
            int temp=posts.indexWhere((e)=>e.postId==postId);
            if(temp>=0){
                posts[temp].viewCount=posts[temp].viewCount+1;
                 posts.refresh();
            }
          }
        }
      });
    }catch(e){
      LoggerService().log(message: e.toString());
    }
  }
  Future<void> share({required int postId})async{

    try{
      await _apiInstance.post(url: APIConstant().apiPostShare,isFormData: true,requestBody: {
        'post_id':postId,
        'user_id':PreferenceService().getInt(key: AppConstants().prefKeyUserId),
      }).then((resp){
        if(resp.isNotEmpty){
          if(resp['httpStatusCode']==200){
            int temp=posts.indexWhere((e)=>e.postId==postId);
            if(temp>=0){
                posts[temp].shareCount=posts[temp].shareCount+1;
                posts.refresh();
            }
          }
        }
      });
    }catch(e){
      LoggerService().log(message: e.toString());
    }
  }
  Future<bool> comment({required int postId,required String comment})async{
    bool success=false;
    try{
      await _apiInstance.post(url: APIConstant().apiPostComment,isFormData: true,requestBody: {
        'post_id':postId,
        'user_id':PreferenceService().getInt(key: AppConstants().prefKeyUserId),
        'comment':comment,
      }).then((resp){
        if(resp.isNotEmpty){
          if(resp['httpStatusCode']==200){
            int temp=posts.indexWhere((e)=>e.postId==postId);
            if(temp>=0) {
              posts[temp].commentCount = posts[temp].commentCount + 1;
              posts.refresh();




            }
            success=true;
          }
        }
      });
    }catch(e){
      LoggerService().log(message: e.toString());
    }
    return success;
  }
  Future<void> getCommentByPostId({required int postId})async{
    try{
      await _apiInstance.get(url: "${APIConstant().apiGetCommentByPost}/$postId").then((resp){
        if(resp.isNotEmpty){
          if(resp['httpStatusCode']==200){
            currentPostDetail.value=resp['data'];
            currentPostDetail.refresh();
          }
        }
      });
    }catch(e){
      LoggerService().log(message: e.toString());
    }
  }
}