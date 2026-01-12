import 'dart:convert';
import 'dart:io';


import 'package:bapa_sitaram/services/loger_service.dart';
import 'package:flutter/services.dart';

class APIConstant {
  factory APIConstant() => _instance;
  APIConstant._internal();
  static const bool isLocalEnv = false;
  static final APIConstant _instance = APIConstant._internal();
  Future<void> setUrl({required bool isDev}) async {


    try {
      if(Platform.isAndroid)
      {
        final d = await const MethodChannel('flutter.myapp.app/myChannel').invokeMethod('getAllUrl');
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
        apiPostById = apis['post-by-id']??'';
        apiDeleteAccount = 'https://bapasitaramtemple.org/76238Bapa6631bhagat/delete-account';
      }else{
        const String baseUrl='https://bapasitaramtemple.org/76238Bapa6631bhagat';

        apiMainMenu        = '$baseUrl/main-menu';
        apiLogin           = '$baseUrl/login';
        apiContactUs       = '$baseUrl/contact-us';
        apiUpdateProfile   = '$baseUrl/update-profile';
        apiLoading         = '$baseUrl/app-loading';
        apiHomePage        = '$baseUrl/home-page';
        apiPunamList       = '$baseUrl/poonam-list';
        apiPresMedia       = '$baseUrl/press-media';
        apiMyDonation      = '$baseUrl/my-donation';
        apiDownloadInvoice = '$baseUrl/download-invoice';
        apiMenu            = '$baseUrl/menu-detail';
        apiGallery         = '$baseUrl/gallery';
        apiSocialActivity  = '$baseUrl/event';
        apiAboutUs         = '$baseUrl/about-us';
        apiDownloadPost    = '$baseUrl/download-post';
        apiPostComment     = '$baseUrl/post-comment';
        apiPostView        = '$baseUrl/post-view';
        apiPostShare       = '$baseUrl/post-share';
        apiPostLike        = '$baseUrl/post-like-unlike';
        apiFeeds           = '$baseUrl/app-post';
        apiGetCommentByPost= '$baseUrl/comment-by-post';
        apiCreateOrder     = '$baseUrl/create-order';
        apiPaymentSuccess  = '$baseUrl/payment-success';
        apiEventById       = '$baseUrl/event-by-id';
        apiPostById        = '$baseUrl/post-by-id';
        apiDeleteAccount = 'https://bapasitaramtemple.org/76238Bapa6631bhagat/delete-account';
      }
    } catch (e) {
      LoggerService().log(message: 'error occurred while getting api url $e');
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
  String apiDeleteAccount= '';
}
