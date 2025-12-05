class AppSettingModel {
  VersionModel version;
  UserInfoModel userInfo;
  AboutUsModel aboutUs;
  NoticeModel notice;

  AppSettingModel({
    this.version = const VersionModel(),
    this.userInfo = const UserInfoModel(),
    this.aboutUs = const AboutUsModel(),
    this.notice = const NoticeModel(),
  });

  factory AppSettingModel.fromJson(Map<String, dynamic> json) {
    return AppSettingModel(
      version: VersionModel.fromJson(json['version'] ?? {}),
      userInfo: UserInfoModel.fromJson(json['user_info'] ?? {}),
      aboutUs: AboutUsModel.fromJson(json['aboutUs'] ?? {}),
      notice: NoticeModel.fromJson(json['notice'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "version": version.toJson(),
      "user_info": userInfo.toJson(),
      "aboutUs": aboutUs.toJson(),
      "notice": notice.toJson(),
    };
  }
}

class VersionModel {
  final String versionNo;
  final String versionForceUpdate;
  final String versionTitle;
  final String versionMessage;
  final String versionNeedClearData;

  const VersionModel({
    this.versionNo = '',
    this.versionForceUpdate = '',
    this.versionTitle = '',
    this.versionMessage = '',
    this.versionNeedClearData = '',
  });

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    return VersionModel(
      versionNo: json['version_no'] ?? '',
      versionForceUpdate: json['version_force_update'] ?? '',
      versionTitle: json['version_title'] ?? '',
      versionMessage: json['version_message'] ?? '',
      versionNeedClearData: json['version_need_clear_data'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "version_no": versionNo,
      "version_force_update": versionForceUpdate,
      "version_title": versionTitle,
      "version_message": versionMessage,
      "version_need_clear_data": versionNeedClearData,
    };
  }
}

class UserInfoModel {
  final String userStatus;

  const UserInfoModel({
    this.userStatus = '',
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      userStatus: json['user_status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_status": userStatus,
    };
  }
}

class AboutUsModel {
  final String aboutTitle;
  final String aboutImage;
  final String aboutEmail;
  final String aboutPhone;
  final String aboutWebsite;
  final String facebook;
  final String instagram;
  final String youtube;
  final String twitter;
  final String developBy;
  final String address;
  final String privacyPolicy;
  final String refundPolicy;
  final String termCondition;
  final String razorpayKey;
  final String razorpaySecret;
  final String otpAppId;
  final String otplessOn;
  final String treePlantationShow;

  const AboutUsModel({
    this.aboutTitle = '',
    this.aboutImage = '',
    this.aboutEmail = '',
    this.aboutPhone = '',
    this.aboutWebsite = '',
    this.facebook = '',
    this.instagram = '',
    this.youtube = '',
    this.twitter = '',
    this.developBy = '',
    this.address = '',
    this.privacyPolicy = '',
    this.refundPolicy = '',
    this.termCondition = '',
    this.razorpayKey = '',
    this.razorpaySecret = '',
    this.otpAppId = '',
    this.otplessOn = '',
    this.treePlantationShow = '',
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) {
    return AboutUsModel(
      aboutTitle: json['about_title'] ?? '',
      aboutImage: json['about_image'] ?? '',
      aboutEmail: json['about_email'] ?? '',
      aboutPhone: json['about_phone'] ?? '',
      aboutWebsite: json['about_website'] ?? '',
      facebook: json['facebook'] ?? '',
      instagram: json['instagram'] ?? '',
      youtube: json['youtube'] ?? '',
      twitter: json['twitter'] ?? '',
      developBy: json['develop_by'] ?? '',
      address: json['address'] ?? '',
      privacyPolicy: json['privacypolicy'] ?? '',
      refundPolicy: json['refundpolicy'] ?? '',
      termCondition: json['term_condition'] ?? '',
      razorpayKey: json['razorpay_key'] ?? '',
      razorpaySecret: json['razorpay_secret'] ?? '',
      otpAppId: json['otp_app_id'] ?? '',
      otplessOn: json['otpless_on'] ?? '',
      treePlantationShow: json['tree_plantation_show'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "about_title": aboutTitle,
      "about_image": aboutImage,
      "about_email": aboutEmail,
      "about_phone": aboutPhone,
      "about_website": aboutWebsite,
      "facebook": facebook,
      "instagram": instagram,
      "youtube": youtube,
      "twitter": twitter,
      "develop_by": developBy,
      "address": address,
      "privacypolicy": privacyPolicy,
      "refundpolicy": refundPolicy,
      "term_condition": termCondition,
      "razorpay_key": razorpayKey,
      "razorpay_secret": razorpaySecret,
      "otp_app_id": otpAppId,
      "otpless_on": otplessOn,
      "tree_plantation_show": treePlantationShow,
    };
  }
}

class NoticeModel {
  final String noticeTitle;
  final String noticeImage;
  final String noticeShow;

  const NoticeModel({
    this.noticeTitle = '',
    this.noticeImage = '',
    this.noticeShow = '',
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      noticeTitle: json['notice_title'] ?? '',
      noticeImage: json['notice_image'] ?? '',
      noticeShow: json['notice_show'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "notice_title": noticeTitle,
      "notice_image": noticeImage,
      "notice_show": noticeShow,
    };
  }
}
