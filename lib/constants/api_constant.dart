class APIConstant {
  factory APIConstant() => _instance;
  APIConstant._internal();
  static const bool isLocalEnv = false;
  static final APIConstant _instance = APIConstant._internal();

  static final String _baseUrl = 'https://brandbaba.in/temple/1234/';

  String get baseUrl => _baseUrl;
  String get apiMainMenu => '${_baseUrl}main-menu';
  String get apiLogin => '${_baseUrl}login';
  String get apiContactUs => '${_baseUrl}contact-us';
  String get apiUpdateProfile => '${_baseUrl}update-profile';
  String get apiLoading => '${_baseUrl}app-loading';
  String get apiHomePage => '${_baseUrl}home-page';
  String get apiPunamList => '${_baseUrl}poonam-list';
  String get apiPresMedia => '${_baseUrl}press-media';
  String get apiMyDonation => '${_baseUrl}my-donation';
  String get apiDownloadInvoice => '${_baseUrl}download-invoice';
  String get apiMenu => '${_baseUrl}menu-detail';
  String get apiGallery => '${_baseUrl}gallery';
  String get apiSocialActivity => '${_baseUrl}event';
  String get apiAboutUs => '${_baseUrl}about-us';
  String get apiDownloadPost => '${_baseUrl}app-post';
  String get apiPostComment => '${_baseUrl}post-comment';
  String get apiPostView => '${_baseUrl}post-view';
  String get apiPostShare => '${_baseUrl}post-share';
  String get apiPostLike => '${_baseUrl}post-like-unlike';
  String get apiFeeds => '${_baseUrl}app-post';
  String get apiGetCommentByPost => '${_baseUrl}comment-by-post';
  String get apiCreateOrder => '${_baseUrl}create-order';
  String get apiPaymentSuccess => '${_baseUrl}payment-success';
}
