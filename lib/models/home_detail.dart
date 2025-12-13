import 'package:bapa_sitaram/services/helper_service.dart';
import 'package:bapa_sitaram/utils/helper.dart';

class HomeDetailModel {
  List<SliderItem> slider;
  String impMsg;
  AboutBapa aboutBapa;
  Arti arti;
  List<EventItem> events;
  DarshanTime darshanTime;
  String liveArti;

  HomeDetailModel({
    this.slider = const [],
    this.impMsg = '',
    AboutBapa? aboutBapa,
    Arti? arti,
    this.events = const [],
    DarshanTime? darshanTime,
    this.liveArti = '',
  })  : aboutBapa = aboutBapa ?? AboutBapa(),
        arti = arti ?? Arti(),
        darshanTime = darshanTime ?? DarshanTime();

  factory HomeDetailModel.fromJson(Map<String, dynamic> json) {
    return HomeDetailModel(
      slider: (json['slider'] as List? ?? [])
          .map((e) => SliderItem.fromJson(e ?? {}))
          .toList(),
      impMsg: json['imp_msg'] ?? '',
      aboutBapa: AboutBapa.fromJson(json['about_bapa'] ?? {}),
      arti: Arti.fromJson(json['arti'] ?? {}),
      events: (json['events'] as List? ?? [])
          .map((e) => EventItem.fromJson(e ?? {}))
          .toList(),
      darshanTime: DarshanTime.fromJson(json['darshan_time'] ?? {}),
      liveArti: json['live_arti'] ?? '',
    );
  }
}

// ---------------- SLIDER ----------------

class SliderItem {
  int sliderId;
  String sliderImage;
  String sliderType;
  dynamic value;

  SliderItem({
    this.sliderId = 0,
    this.sliderImage = '',
    this.sliderType = '',
    this.value = '',
  });

  factory SliderItem.fromJson(Map<String, dynamic> json) {
    return SliderItem(
      sliderId: json['slider_id'] ?? 0,
      sliderImage: json['slider_image'] ?? '',
      sliderType: json['slider_type'] ?? '',
      value: json['value'] ?? '',
    );
  }
}

// ---------------- ABOUT BAPA ----------------

class AboutBapa {
  String title;
  String subTitle;
  String description;
  String image;
  String tab1Title;
  String tab1Desc;
  String tab2Title;
  String tab2Desc;
  String btnText;

  AboutBapa({
    this.title = '',
    this.subTitle = '',
    this.description = '',
    this.image = '',
    this.tab1Title = '',
    this.tab1Desc = '',
    this.tab2Title = '',
    this.tab2Desc = '',
    this.btnText = '',
  });

  factory AboutBapa.fromJson(Map<String, dynamic> json) {
    return AboutBapa(
      title: json['title'] ?? '',
      subTitle: json['sub_title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      tab1Title: json['tab_1_title'] ?? '',
      tab1Desc: json['tab_1_desc'] ?? '',
      tab2Title: json['tab_2_title'] ?? '',
      tab2Desc: json['tab_2_desc'] ?? '',
      btnText: json['btn_text'] ?? '',
    );
  }
}

// ---------------- ARTI ----------------

class Arti {
  String title;
  String description;
  List<ArtiItem> data;

  Arti({
    this.title = '',
    this.description = '',
    this.data = const [],
  });

  factory Arti.fromJson(Map<String, dynamic> json) {
    return Arti(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => ArtiItem.fromJson(e ?? {}))
          .toList(),
    );
  }
}

class ArtiItem {
  String title;
  String descp;
  String image;

  ArtiItem({
    this.title = '',
    this.descp = '',
    this.image = '',
  });

  factory ArtiItem.fromJson(Map<String, dynamic> json) {
    return ArtiItem(
      title: json['title'] ?? '',
      descp: json['descp'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

// ---------------- EVENTS ----------------

class EventItem {
  final int eventId;
  final String eventTitle;
  final String eventDesc;
  final String eventImage;
  final DateTime eventDate;

  const EventItem({
    this.eventId = 0,
    this.eventTitle = '',
    this.eventDesc = '',
    this.eventImage = '',
    required this.eventDate,
  });

  factory EventItem.fromJson(Map<String, dynamic> json) {
    return EventItem(
      eventId: json['event_id'] ?? 0,
      eventTitle: json['event_title'] ?? '',
      eventDesc: json['event_desc'] ?? '',
      eventImage: json['event_image'] ?? '',
      eventDate: HelperService().parseDate(date:  json['event_date'] ?? '',inputFormat: 'dd MMMM, yyyy'),
    );
  }
}

// ---------------- DARSHAN TIME ----------------

class DarshanTime {
  String manglaArti;
  String rajbhogArti;
  String sandhyaArti;
  String darshanClose;
  String note;

  DarshanTime({
    this.manglaArti = '',
    this.rajbhogArti = '',
    this.sandhyaArti = '',
    this.darshanClose = '',
    this.note = '',
  });

  factory DarshanTime.fromJson(Map<String, dynamic> json) {
    return DarshanTime(
      manglaArti: json['mangla_arti'] ?? '',
      rajbhogArti: json['rajbhog_arti'] ?? '',
      sandhyaArti: json['sandhya_arti'] ?? '',
      darshanClose: json['darshan_close'] ?? '',
      note: json['note'] ?? '',
    );
  }
}
