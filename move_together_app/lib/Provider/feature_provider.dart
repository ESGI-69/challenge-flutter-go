import 'package:flutter/material.dart';
import 'package:move_together_app/core/services/feature_service.dart';
import 'package:move_together_app/core/models/feature.dart';

class FeatureProvider with ChangeNotifier, WidgetsBindingObserver {
  final FeatureService _featureService = FeatureService();
  List<Feature> _features = [];

  List<Feature> get features => _features;

  FeatureProvider() {
    WidgetsBinding.instance.addObserver(this);
    loadFeatures();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print("reload features when app came back to foreground");
      loadFeatures();
    }
  }

  Future<void> loadFeatures() async {
    _features = await _featureService.getAll();
    notifyListeners();
  }

  bool isFeatureEnabled(FeatureNames featureName) {
    return _features
        .any((feature) => feature.name == featureName && feature.isEnabled);
  }
}
