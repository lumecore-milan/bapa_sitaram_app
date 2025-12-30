import 'dart:async';
import 'package:bapa_sitaram/services/network/api_mobile.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:bapa_sitaram/services/app_events.dart';
import 'package:bapa_sitaram/services/enums.dart';

class ConnectivityService {
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();
  static final ConnectivityService _instance = ConnectivityService._internal();
  bool hasInternet = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final _apiInstance = NetworkServiceMobile();
  String _defaultUrlToCheckInternet = 'https://example.com/';
  void startListening() {
    testInternet().then((result) {
      hasInternet = result;
      AppEventsStream().addEvent(AppEvent(type: result == true ? AppEventType.internetConnected : AppEventType.internetDisConnected, data: result));
    });
    _subscription = _connectivity.onConnectivityChanged.listen((results) async {
      final hasConnection = await _hasConnection(results);

      if (hasConnection) {
        hasInternet = hasConnection;
        AppEventsStream().addEvent(AppEvent(type: hasConnection == true ? AppEventType.internetConnected : AppEventType.internetDisConnected, data: hasConnection));
      } else {
        hasInternet = false;
        AppEventsStream().addEvent(AppEvent(type: AppEventType.internetDisConnected, data: false));
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }

  Future<bool> _hasConnection(List<ConnectivityResult> results) async {
    bool d = results.contains(ConnectivityResult.mobile) || results.contains(ConnectivityResult.wifi) || results.contains(ConnectivityResult.ethernet);

    if (!d) {
      return d;
    }
    bool d1 = await testInternet();
    return d1;
  }

  void setPingUrl({required String pingUrl}) {
    _defaultUrlToCheckInternet = pingUrl;
  }

  Future<bool> testInternet() async {
    bool status = false;
    try {
      await _apiInstance.get(url: _defaultUrlToCheckInternet).then((resp) {
        if (resp['httpStatusCode'] != -1 && resp['httpStatusCode'] != -2 && resp['httpStatusCode'] != 408) {
          status = true;
        }
      });
    } catch (e) {
      //
    }
    return status;
  }
}
