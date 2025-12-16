import 'dart:convert';

import 'package:bapa_sitaram/services/loger_service.dart';
import 'package:flutter/services.dart';

class APIConstant {
  factory APIConstant() => _instance;
  APIConstant._internal();
  static const bool isLocalEnv = false;
  static final APIConstant _instance = APIConstant._internal();

  Future<void> setUrl({required bool isDev})async{
    try{
      final d=await MethodChannel(
        'flutter.myapp.app/myChannel',
      ).invokeMethod('getAllUrl');
      Map<String,dynamic> apis=json.decode(d);
      apiMainMenu = apis['main-menu']??'';
      apiLogin = apis['login']??'';
      apiContactUs = apis['contact-us']??'';
      apiUpdateProfile = apis['update-profile']??'';
      apiLoading = apis['app-loading']??'';
      apiHomePage = apis['home-page']??'';
      apiPunamList = apis['poonam-list']??'';
      apiPresMedia = apis['press-media']??'';
      apiMyDonation = apis['my-donation']??'';
      apiDownloadInvoice = apis['download-invoice']??'';
      apiMenu = apis['menu-detail']??'';
      apiGallery = apis['gallery']??'';
      apiSocialActivity = apis['event']??'';
      apiAboutUs = apis['about-us']??'';
      apiDownloadPost = apis['download-post']??'';
      apiPostComment = apis['post-comment']??'';
      apiPostView = apis['post-view']??'';
      apiPostShare = apis['post-share']??'';
      apiPostLike = apis['post-like-unlike']??'';
      apiFeeds = apis['app-post']??'';
      apiGetCommentByPost = apis['comment-by-post']??'';
      apiCreateOrder = apis['create-order']??'';
      apiPaymentSuccess = apis['payment-success']??'';



      LoggerService().log(message: apiMainMenu);
    }catch(e){
        LoggerService().log(message: 'error occurred while getting api url');
    }
  }
  late final String apiMainMenu;
  late final String apiLogin;
  late final String apiContactUs;
  late final String apiUpdateProfile ;
  late final String apiLoading ;
  late final String apiHomePage ;
  late final String apiPunamList ;
  late final String apiPresMedia ;
  late final String apiMyDonation ;
  late final String apiDownloadInvoice ;
  late final String apiMenu ;
  late final String apiGallery ;
  late final String apiSocialActivity ;
  late final String apiAboutUs ;
  late final String apiDownloadPost ;
  late final String apiPostComment ;
  late final String apiPostView ;
  late final String apiPostShare ;
  late final String apiPostLike ;
  late final String apiFeeds ;
  late final String apiGetCommentByPost ;
  late final String apiCreateOrder ;
  late final String apiPaymentSuccess ;
}
