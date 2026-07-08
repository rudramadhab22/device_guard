import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_guard_example/src/controllers/check_controller.dart';
import 'package:device_guard_example/src/utils/app_utils.dart';
import 'package:device_guard/device_guard.dart';

class CheckPage extends StatefulWidget {
  const CheckPage({super.key});

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  late final CheckController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CheckController(
      onStateChanged: () {
        if (mounted) {
          setState(() {});
          _controller.checkNavigation(context);
        }
      },
    );
    _controller.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security Check')),
      body: SafeArea(
        child: _controller.isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _CheckDetailsView(
              result: _controller.result!,
              onRetry: _controller.handleChecks,
              onClose: () => SystemNavigator.pop(),
            ),
      ),
    );
  }
}

class _CheckDetailsView extends StatelessWidget {
  final DeviceGuardResult result;
  final VoidCallback onRetry;
  final VoidCallback onClose;

  const _CheckDetailsView({
    required this.result,
    required this.onRetry,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Verifying Device Requirements...',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          _CheckItem(
            label: 'Android Version (Min ${AppUtils.getAndroidVersion(result.minSdk)})',
            current: '${result.platformVersion}',
            isOk: result.isAndroidVersionSupported,
          ),
          _CheckItem(
            label: 'RAM (Min ${result.minRamGb} GB)',
            current: AppUtils.formatRam(result.actualRamGb),
            isOk: result.isRamSufficient,
          ),
          _CheckItem(
            label: 'Developer Options (OFF)',
            current: result.isDeveloperOptionsOff ? 'OFF' : 'ON',
            isOk: result.isDeveloperOptionsOff,
          ),
          const Spacer(),
          if (!result.isValid)
            _FailureActions(onClose: onClose, onRetry: onRetry)
          else
            const _SuccessView(),
        ],
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String label;
  final String current;
  final bool isOk;

  const _CheckItem({
    required this.label,
    required this.current,
    required this.isOk,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(
            isOk ? Icons.check_circle : Icons.cancel,
            color: isOk ? Colors.green : Colors.red,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text('Current: $current', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FailureActions extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onRetry;

  const _FailureActions({required this.onClose, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: onClose,
            child: const Text('CLOSE APP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: onRetry,
            child: const Text('Retry Checks'),
          ),
        ),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 60),
          SizedBox(height: 10),
          Text(
            'All checks passed! Redirecting...',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
