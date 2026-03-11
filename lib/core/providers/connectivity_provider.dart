import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider with ChangeNotifier {
  ConnectivityResult _connectivityResult = ConnectivityResult.wifi;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isFirstCheck = true;

  ConnectivityResult get result => _connectivityResult;
  bool get isConnected => _connectivityResult != ConnectivityResult.none;

  ConnectivityProvider() {
    _initConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  Future<void> _initConnectivity() async {
    try {
      final List<ConnectivityResult> results = await _connectivity
          .checkConnectivity();
      _updateStatus(results);
    } catch (_) {}
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final newResult = results.isNotEmpty
        ? results.first
        : ConnectivityResult.none;
    if (_connectivityResult != newResult || _isFirstCheck) {
      _connectivityResult = newResult;
      _isFirstCheck = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
