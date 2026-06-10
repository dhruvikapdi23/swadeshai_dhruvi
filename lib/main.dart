import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swadesai_dhruvi/app.dart';
import 'package:swadesai_dhruvi/core/constants/api_constants.dart';
import 'package:swadesai_dhruvi/core/di/injection.dart';
import 'package:swadesai_dhruvi/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Injection.fcmService.init();
  log('QuickSlot API → ${ApiConstants.baseUrl}');
  runApp(const QuickSlotApp());
}
