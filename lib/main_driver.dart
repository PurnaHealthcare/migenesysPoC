import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main.dart';

void main() {
  print('DEBUG: Enabling Flutter Driver Extension');
  enableFlutterDriverExtension();
  print('DEBUG: Flutter Driver Extension Enabled');
  runApp(
    // const ProviderScope(child: VisualFeedbackOverlay(child: MiGenesysApp())),
    const ProviderScope(child: MiGenesysApp()),
  );
}

class VisualFeedbackOverlay extends StatefulWidget {
  final Widget child;
  const VisualFeedbackOverlay({super.key, required this.child});

  @override
  State<VisualFeedbackOverlay> createState() => _VisualFeedbackOverlayState();
}

class _VisualFeedbackOverlayState extends State<VisualFeedbackOverlay> {
  final List<Offset> _taps = [];

  void _addTap(Offset position) {
    setState(() => _taps.add(position));
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _taps.remove(position));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          Listener(
            onPointerDown: (event) => _addTap(event.position),
            child: widget.child,
          ),
          ..._taps.map(
            (pos) => Positioned(
              left: pos.dx - 25,
              top: pos.dy - 25,
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 400),
                builder: (context, val, _) => Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.redAccent.withOpacity(1 - val),
                      width: 2,
                    ),
                    color: Colors.redAccent.withOpacity(0.2 * (1 - val)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
