import 'package:flutter/material.dart';
import 'responsive_utils.dart';
import 'responsive_wrapper.dart';

/// A responsive screen template that can be used to create responsive screens quickly.
/// This serves as a wrapper for common responsive patterns.
class ResponsiveScreenTemplate extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool useGradientBackground;
  final Color? backgroundColor;
  final Widget? drawer;
  final PreferredSizeWidget? customAppBar;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool useSafeArea;
  final EdgeInsetsGeometry? padding;

  const ResponsiveScreenTemplate({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.useGradientBackground = false,
    this.backgroundColor,
    this.drawer,
    this.customAppBar,
    this.showBackButton = true,
    this.onBackPressed,
    this.useSafeArea = true,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar ?? _buildAppBar(context),
      body: ResponsiveBuilder(
        builder: (context, deviceType, isLandscape) {
          return Container(
            decoration: useGradientBackground
                ? const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1A3A6B), Color(0xFF5A8ED0)],
                    ),
                  )
                : BoxDecoration(
                    color: backgroundColor,
                  ),
            child: useSafeArea
                ? SafeArea(
                    child: _buildBodyWithPadding(context, deviceType, isLandscape),
                  )
                : _buildBodyWithPadding(context, deviceType, isLandscape),
          );
        },
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20),
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color(0xFF1A3A6B),
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      actions: actions,
    );
  }

  Widget _buildBodyWithPadding(BuildContext context, DeviceType deviceType, bool isLandscape) {
    final responsivePadding = padding ?? ResponsiveUtils.getResponsivePadding(context);
    
    return Padding(
      padding: responsivePadding,
      child: body,
    );
  }
}

/// Extension method to quickly convert a screen to use the responsive template
extension ResponsiveScreenExtension on Widget {
  ResponsiveScreenTemplate wrapWithResponsiveScreen({
    required String title,
    List<Widget>? actions,
    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
    bool useGradientBackground = false,
    Color? backgroundColor,
    Widget? drawer,
    PreferredSizeWidget? customAppBar,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
    bool useSafeArea = true,
    EdgeInsetsGeometry? padding,
  }) {
    return ResponsiveScreenTemplate(
      title: title,
      body: this,
      actions: actions,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      useGradientBackground: useGradientBackground,
      backgroundColor: backgroundColor,
      drawer: drawer,
      customAppBar: customAppBar,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      useSafeArea: useSafeArea,
      padding: padding,
    );
  }
} 
 