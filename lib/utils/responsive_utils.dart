import 'package:flutter/material.dart';

/// Device type enum
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// Utility class for responsive design
class ResponsiveUtils {
  /// Screen width breakpoints
  static const double mobileBreakpoint = 480;
  static const double tabletBreakpoint = 768;
  static const double desktopBreakpoint = 1024;

  /// Get the device type based on width
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (width < tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Get responsive value based on screen width percentage
  static double getWidthPercentage(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }

  /// Get responsive value based on screen height percentage
  static double getHeightPercentage(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return const EdgeInsets.all(12.0);
      case DeviceType.tablet:
        return const EdgeInsets.all(16.0);
      case DeviceType.desktop:
        return const EdgeInsets.all(24.0);
    }
  }

  /// Get responsive font size
  static double getResponsiveFontSize(BuildContext context, double size) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return size;
      case DeviceType.tablet:
        return size * 1.2;
      case DeviceType.desktop:
        return size * 1.3;
    }
  }

  /// Get responsive width for cards and containers
  static double getResponsiveWidth(BuildContext context) {
    final deviceType = getDeviceType(context);
    final width = MediaQuery.of(context).size.width;
    
    switch (deviceType) {
      case DeviceType.mobile:
        return width * 0.9;
      case DeviceType.tablet:
        return width * 0.7;
      case DeviceType.desktop:
        return width * 0.5;
    }
  }
  
  /// Get grid column count based on screen width
  static int getGridColumnCount(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return isLandscape(context) ? 3 : 2;
      case DeviceType.tablet:
        return isLandscape(context) ? 4 : 3;
      case DeviceType.desktop:
        return 5;
    }
  }
} 