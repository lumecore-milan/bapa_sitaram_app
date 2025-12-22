import 'dart:convert';
import 'dart:io';

import 'package:bapa_sitaram/services/loger_service.dart';
import 'package:flutter/services.dart';

class APIConstant {
  factory APIConstant() => _instance;
  APIConstant._internal();
  static const bool isLocalEnv = false;
  static final APIConstant _instance = APIConstant._internal();
  String api(String path) => "https://bapasitaramtemple.org/76238Bapa6631bhagat/$path";
  Future<void> setUrl({required bool isDev}) async {
    try {
      if (Platform.isAndroid) {
        final d = await MethodChannel('flutter.myapp.app/myChannel').invokeMethod('getAllUrl');
        Map<String, dynamic> apis = json.decode(d);
        
        apiMainMenu = apis['main-menu'] ?? '';
        apiLogin = apis['login'] ?? '';
        apiContactUs = apis['contact-us'] ?? '';
        apiUpdateProfile = apis['update-profile'] ?? '';
        apiLoading = apis['app-loading'] ?? '';
        apiHomePage = apis['home-page'] ?? '';
        apiPunamList = apis['poonam-list'] ?? '';
        apiPresMedia = apis['press-media'] ?? '';
        apiMyDonation = apis['my-donation'] ?? '';
        apiDownloadInvoice = apis['download-invoice'] ?? '';
        apiMenu = apis['menu-detail'] ?? '';
        apiGallery = apis['gallery'] ?? '';
        apiSocialActivity = apis['event'] ?? '';
        apiAboutUs = apis['about-us'] ?? '';
        apiDownloadPost = apis['download-post'] ?? '';
        apiPostComment = apis['post-comment'] ?? '';
        apiPostView = apis['post-view'] ?? '';
        apiPostShare = apis['post-share'] ?? '';
        apiPostLike = apis['post-like-unlike'] ?? '';
        apiFeeds = apis['app-post'] ?? '';
        apiGetCommentByPost = apis['comment-by-post'] ?? '';
        apiCreateOrder = apis['create-order'] ?? '';
        apiPaymentSuccess = apis['payment-success'] ?? '';
        apiEventById = apis['event-by-id'] ?? '';
      } else {
        apiMainMenu = api("main-menu");
        apiLogin = api("login");
        apiContactUs = api("contact-us");
        apiUpdateProfile = api("update-profile");
        apiLoading = api("app-loading");
        apiHomePage = api("home-page");
        apiPunamList = api("poonam-list");
        apiPresMedia = api("press-media");
        apiMyDonation = api("my-donation");
        apiDownloadInvoice = api("download-invoice");
        apiMenu = api("menu-detail");
        apiGallery = api("gallery");
        apiSocialActivity = api("event");
        apiAboutUs = api("about-us");
        apiDownloadPost = api("download-post");
        apiPostComment = api("post-comment");
        apiPostView = api("post-view");
        apiPostShare = api("post-share");
        apiPostLike = api("post-like-unlike");
        apiFeeds = api("app-post");
        apiGetCommentByPost = api("comment-by-post");
        apiCreateOrder = api("create-order");
        apiPaymentSuccess = api("payment-success");
        apiPostById = api("post-by-id");

        /*apiMainMenu = "https://bapasitaramtemple.org/76238Bapa6631bhagat/main-menu";
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
        apiPaymentSuccess = apis['payment-success']??'';*/
      }
    } catch (e) {
      LoggerService().log(message: 'error occurred while getting api url');
    }
  }

  String apiMainMenu = '';
  String apiLogin = '';
  String apiContactUs = '';
  String apiUpdateProfile = '';
  String apiLoading = '';
  String apiHomePage = '';
  String apiPunamList = '';
  String apiPresMedia = '';
  String apiMyDonation = '';
  String apiDownloadInvoice = '';
  String apiMenu = '';
  String apiGallery = '';
  String apiSocialActivity = '';
  String apiAboutUs = '';
  String apiDownloadPost = '';
  String apiPostComment = '';
  String apiPostView = '';
  String apiPostShare = '';
  String apiPostLike = '';
  String apiFeeds = '';
  String apiGetCommentByPost = '';
  String apiCreateOrder = '';
  String apiPaymentSuccess = '';
  String apiPostById = '';
  String apiEventById = '';
}
