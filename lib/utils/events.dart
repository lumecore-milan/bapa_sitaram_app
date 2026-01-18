import 'dart:async';

class NotificationCLickDetail {
  NotificationCLickDetail({this.id = '', this.type = ''});
  final String id, type;
}

NotificationCLickDetail pendingDetail = NotificationCLickDetail();

class PageJumpDetail {
  PageJumpDetail({this.page = '', this.additionalData = ''});
  final String page, additionalData;
}

final StreamController<PageJumpDetail> jumpPage = StreamController.broadcast();
final StreamController<NotificationCLickDetail> notificationClicked = StreamController.broadcast();
final StreamController<String> soundCompleted = StreamController.broadcast();
