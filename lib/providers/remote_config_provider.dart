import 'package:flutter/material.dart';
import '../services/remote_config_service.dart';

class RemoteConfigProvider with ChangeNotifier {
  bool _showDiscountedPrice = false;
  final RemoteConfigService _remoteConfigService;

  RemoteConfigProvider(this._remoteConfigService);

  bool get showDiscountedPrice => _showDiscountedPrice;

  Future<void> loadRemoteConfig() async {
    _showDiscountedPrice = await _remoteConfigService.shouldShowDiscountedPrice();
    notifyListeners();
  }
}
