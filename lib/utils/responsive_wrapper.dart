import 'package:flutter/material.dart';
import 'responsive_utils.dart';

/// A widget that automatically adjusts its child based on screen size and orientation
class ResponsiveWrapper extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? landscapeMobile;
  final Widget? landscapeTablet;

  const ResponsiveWrapper({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.landscapeMobile,
    this.landscapeTablet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = ResponsiveUtils.isLandscape(context);
        final deviceType = ResponsiveUtils.getDeviceType(context);

        // For landscape orientation, use specific landscape layouts if provided
        if (isLandscape) {
          switch (deviceType) {
            case DeviceType.mobile:
              return landscapeMobile ?? mobile;
            case DeviceType.tablet:
              return landscapeTablet ?? tablet ?? mobile;
            case DeviceType.desktop:
              return desktop ?? tablet ?? mobile;
          }
        }

        // For portrait orientation
        switch (deviceType) {
          case DeviceType.mobile:
            return mobile;
          case DeviceType.tablet:
            return tablet ?? mobile;
          case DeviceType.desktop:
            return desktop ?? tablet ?? mobile;
        }
      },
    );
  }
}

/// A simpler responsive wrapper that uses the same builder for all devices but provides device info
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType, bool isLandscape) builder;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = ResponsiveUtils.isLandscape(context);
        final deviceType = ResponsiveUtils.getDeviceType(context);
        
        return builder(context, deviceType, isLandscape);
      },
    );
  }
} 