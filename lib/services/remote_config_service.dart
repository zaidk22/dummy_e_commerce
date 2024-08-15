import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService(this._remoteConfig);

  Future<bool> shouldShowDiscountedPrice() async {
    try {
      await _remoteConfig.fetchAndActivate();
      
      return _remoteConfig.getBool('show_discounted_price');
    } catch (e) {
      throw Exception('Failed to fetch remote config: $e');
    }
  }
}
