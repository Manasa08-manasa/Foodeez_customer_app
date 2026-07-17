import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Breakpoints and layout helpers for phone + tablet.
class AppResponsive {
  AppResponsive._(this.size);

  final Size size;

  static AppResponsive of(BuildContext context) =>
      AppResponsive._(MediaQuery.sizeOf(context));

  double get width => size.width;
  double get height => size.height;
  double get shortest => size.shortestSide;

  bool get isPhone => shortest < 600;
  bool get isTablet => shortest >= 600;
  bool get isLargeTablet => shortest >= 900;

  /// Max width for readable content on tablets / landscape.
  double get contentMaxWidth {
    if (isLargeTablet) return 840;
    if (isTablet) return 720;
    return double.infinity;
  }

  /// Horizontal page padding that grows slightly on wider screens.
  double get pagePadding {
    if (width >= 900) return 32;
    if (width >= 600) return 28;
    return 20;
  }

  /// Scales a design-time size from a 390pt phone reference.
  double scale(double value, {double min = 0.9, double max = 1.2}) {
    final factor = (width / 390).clamp(min, max);
    return value * factor;
  }

  int gridColumns({int phone = 2, int tablet = 3, int large = 4}) {
    if (isLargeTablet) return large;
    if (isTablet) return tablet;
    return phone;
  }
}

/// Centers [child] and caps width on tablet so every screen stays phone-friendly.
class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({
    super.key,
    required this.child,
    this.fullBleed = false,
  });

  final Widget child;
  final bool fullBleed;

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    if (fullBleed || !r.isTablet) return child;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = math.min(constraints.maxWidth, r.contentMaxWidth);
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: width,
            height: constraints.maxHeight,
            child: child,
          ),
        );
      },
    );
  }
}
