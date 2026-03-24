import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokse/core/constants/logger.dart';

/// 🔌 Network Manager using GetX
/// 0 = No Internet
/// 1 = WiFi
/// 2 = Mobile Data
class GetXNetworkManager extends GetxController {
  /// Singleton access
  static GetXNetworkManager get instance => Get.find<GetXNetworkManager>();

  /// Connection type
  final RxInt connectionType = 0.obs;

  final Connectivity _connectivity = Connectivity();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _listenToConnectivityChanges();
  }

  /// Initial connectivity check
  Future<void> _initConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionType(results);
    } catch (e) {
      if (kDebugMode) {
        appLog.e("❌ Initial connectivity check failed", error: e);
      }
    }
  }

  /// Listen for connectivity changes (NEW API)
  void _listenToConnectivityChanges() {
    _subscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        _updateConnectionType(results);
      },
    );
  }

  /// Update connection state from list
  void _updateConnectionType(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      connectionType.value = 0;
    } else {
      final result = results.last;

      switch (result) {
        case ConnectivityResult.wifi:
          connectionType.value = 1;
          break;
        case ConnectivityResult.mobile:
          connectionType.value = 2;
          break;
        case ConnectivityResult.none:
        default:
          connectionType.value = 0;
          break;
      }
    }

    appLog.d(
      "🌐 Network: ${_connectionTypeToString(connectionType.value)}",
    );

    if (connectionType.value == 0) {
      _showNoInternetSnackbar();
    }
  }

  /// Snackbar when offline
  void _showNoInternetSnackbar() {
    if (Get.isSnackbarOpen) return;

    Get.snackbar(
      "No Internet",
      "Please check your connection",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.wifi_off, color: Colors.white),
    );
  }

  /// Helper for logging
  String _connectionTypeToString(int type) {
    switch (type) {
      case 1:
        return "WiFi";
      case 2:
        return "Mobile Data";
      default:
        return "No Internet";
    }
  }

  /// Clean usage in controllers
  bool get isConnected => connectionType.value != 0;

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
