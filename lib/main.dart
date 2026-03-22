import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lokse/core/network/getx_network_manager.dart';
import 'package:lokse/core/utils/dio_client.dart';

import 'app/lokse_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // Initialize DioClient
  DioClient.init();

  // Initialize Network Manager
  Get.put(GetXNetworkManager());

  runApp(const LokseApp());
}
