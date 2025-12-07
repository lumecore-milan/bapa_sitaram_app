import 'dart:async';

class NotificationCLickDetail{
  final String id,type;
  NotificationCLickDetail({this.id='',this.type=''});
}

class PageJumpDetail{
  final String page,additionalData;
  PageJumpDetail({this.page='',this.additionalData=''});
}

final StreamController<PageJumpDetail> jumpPage = StreamController.broadcast();
final StreamController<NotificationCLickDetail> notificationClicked = StreamController.broadcast();


