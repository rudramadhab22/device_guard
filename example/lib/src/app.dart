import 'package:flutter/material.dart';
import 'package:device_guard_example/src/pages/splash_page.dart';

class DeviceGuardApp extends StatelessWidget {
  const DeviceGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Guard Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
