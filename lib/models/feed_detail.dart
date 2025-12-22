import 'package:get/get.dart';

class PostModel {
  int postId;
  String postDesc;
  String postImage;
  String postType;
  int likeCount;
  int commentCount;
  int shareCount;
  int viewCount;
  int isLiked;
  String addedDate;
  UserData userData;
  bool hide = false;
  Rx<bool> thumbGenerated = false.obs;

  PostModel({
    this.postId = 0,
    this.postDesc = '',
    this.postImage = '',
    this.postType = '',
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.viewCount = 0,
    this.isLiked = 0,
    this.addedDate = '',
    this.hide = false,
    this.userData = const UserData(),
  });

  factory PostModel.fromJson(Map<String, dynamic> json, {bool hidedetail = false}) {
    return PostModel(
      postId: json['post_id'] ?? 0,
      hide: hidedetail,
      postDesc: json['post_desc'] ?? '',
      postImage: json['post_image'] ?? '',
      postType: json['post_type'] ?? '',
      likeCount: json['like_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      shareCount: json['share_count'] ?? 0,
      viewCount: json['view_count'] ?? 0,
      isLiked: json['is_liked'] ?? 0,
      addedDate: json['added_date'] ?? '',
      userData: json['user_data'] != null ? UserData.fromJson(json['user_data']) : UserData(),
    );
  }

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'post_desc': postDesc,
      'post_image': postImage,
      'post_type': postType,
      'like_count': likeCount,
      'comment_count': commentCount,
      'share_count': shareCount,
      'view_count': viewCount,
      'is_liked': isLiked,
      'added_date': addedDate,
      'user_data': userData.toJson(),
    };
  }

  /// FROM JSON LIST
  static List<PostModel> fromJsonList(dynamic jsonList) {
    if (jsonList == null) return [];
    return List<PostModel>.from((jsonList as List).map((item) => PostModel.fromJson(item ?? {})));
  }
}

class UserData {
  final int userId;
  final String userName;
  final String userProfile;
  const UserData({this.userId = 0, this.userName = '', this.userProfile = ''});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(userId: json['user_id'] ?? 0, userName: json['user_name'] ?? '', userProfile: json['user_profile'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'user_name': userName, 'user_profile': userProfile};
  }
}
