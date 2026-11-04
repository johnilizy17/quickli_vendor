import 'package:flutter/material.dart';

/// Shown when the app cannot start — misconfigured build or unexpected
/// startup exception. Keeps the cause readable instead of leaving the
/// OS launch splash on screen with nothing behind it.
class StartupFailureScreen extends StatelessWidget {
  final String title;
  final String message;
  final String? details;

  const StartupFailureScreen({
    super.key,
    required this.title,
    required this.message,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                const Icon(Icons.error_outline_rounded, size: 48, color: Color(0xFFD8143A)),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1B2B),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF808080),
                    height: 1.5,
                  ),
                ),
                if (details != null) ...[
                  const SizedBox(height: 24),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF1F1F1)),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          details!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                            color: Color(0xFF4B4C5E),
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
