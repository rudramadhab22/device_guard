import 'package:flutter/material.dart';
import 'package:device_guard/device_guard.dart';
import '../pages/home_page.dart';
import '../utils/app_utils.dart';

class CheckController {
  final DeviceGuard _plugin = DeviceGuard();

  DeviceGuardResult? result;
  bool isLoading = true;

  final VoidCallback onStateChanged;

  CheckController({required this.onStateChanged});

  Future<void> init() async {
    await handleChecks();
  }

  Future<void> handleChecks() async {
    isLoading = true;
    onStateChanged();

    result = await AppUtils.performChecks(_plugin);
    isLoading = false;
    onStateChanged();
  }

  void checkNavigation(BuildContext context) {
    if (result?.isValid ?? false) {
      _navigateToHome(context);
    }
  }

  Future<void> _navigateToHome(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    if (!context.mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}
