import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

/// GradientBackground ऐप की सभी स्क्रीन को आधुनिक पृष्ठभूमि प्रदान करता है।
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  /// अंदर प्रदर्शित होने वाला वास्तविक कंटेंट।
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color(0xFF0F172A),
            Color(0xFF1E293B),
            AppColors.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -120,
            right: -80,
            child: _BlurCircle(color: Colors.white.withOpacity(0.12), size: 280),
          ),
          Positioned(
            bottom: -100,
            left: -60,
            child: _BlurCircle(color: AppColors.secondary.withOpacity(0.18), size: 240),
          ),
          child,
        ],
      ),
    );
  }
}

/// _BlurCircle हल्के ब्लर इफेक्ट वाला सजावटी वृत्त बनाता है।
class _BlurCircle extends StatelessWidget {
  const _BlurCircle({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 120,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }
}
