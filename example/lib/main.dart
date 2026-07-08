import 'package:flutter/material.dart';
import 'package:device_guard_example/src/app.dart';

export 'src/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DeviceGuardApp());
}
