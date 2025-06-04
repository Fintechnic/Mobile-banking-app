import 'package:flutter/material.dart';

/// Utility class for handling icon mapping across the application
class IconUtils {
  /// Maps notification type strings to corresponding IconData
  static IconData getNotificationIcon(String type) {
    switch (type) {
      case 'transaction':
        return Icons.account_balance_wallet;
      case 'promotion':
        return Icons.local_offer;
      case 'security':
        return Icons.security;
      case 'reminder':
        return Icons.notification_important;
      case 'account':
        return Icons.person;
      default:
        return Icons.notifications;
    }
  }

  /// Maps notification colors based on type
  static Color getNotificationColor(String type) {
    switch (type) {
      case 'transaction':
        return Colors.blue;
      case 'promotion':
        return Colors.purple;
      case 'security':
        return Colors.red;
      case 'reminder':
        return Colors.orange;
      case 'account':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Maps string icon names to IconData
  static IconData getIconFromString(String iconName) {
    switch (iconName) {
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'notifications_active':
        return Icons.notifications_active;
      case 'warning_amber_rounded':
        return Icons.warning_amber_rounded;
      case 'support_agent':
        return Icons.support_agent;
      case 'local_offer':
        return Icons.local_offer;
      case 'card_giftcard':
        return Icons.card_giftcard;
      case 'videogame_asset':
        return Icons.videogame_asset;
      case 'campaign':
        return Icons.campaign;
      case 'people':
        return Icons.people;
      case 'storefront':
        return Icons.storefront;
      case 'groups':
        return Icons.groups;
      case 'rate_review':
        return Icons.rate_review;
      case 'bolt':
        return Icons.bolt;
      case 'water_drop_outlined':
        return Icons.water_drop_outlined;
      case 'tv':
        return Icons.tv;
      case 'smartphone':
        return Icons.smartphone;
      case 'school':
        return Icons.school;
      case 'wifi':
        return Icons.wifi;
      default:
        return Icons.notifications;
    }
  }

  /// Maps IconData to string names
  static String getStringFromIcon(IconData icon) {
    if (icon == Icons.account_balance_wallet) return 'account_balance_wallet';
    if (icon == Icons.notifications_active) return 'notifications_active';
    if (icon == Icons.warning_amber_rounded) return 'warning_amber_rounded';
    if (icon == Icons.support_agent) return 'support_agent';
    if (icon == Icons.local_offer) return 'local_offer';
    if (icon == Icons.card_giftcard) return 'card_giftcard';
    if (icon == Icons.videogame_asset) return 'videogame_asset';
    if (icon == Icons.campaign) return 'campaign';
    if (icon == Icons.people) return 'people';
    if (icon == Icons.storefront) return 'storefront';
    if (icon == Icons.groups) return 'groups';
    if (icon == Icons.rate_review) return 'rate_review';
    if (icon == Icons.bolt) return 'bolt';
    if (icon == Icons.water_drop_outlined) return 'water_drop_outlined';
    if (icon == Icons.tv) return 'tv';
    if (icon == Icons.smartphone) return 'smartphone';
    if (icon == Icons.school) return 'school';
    if (icon == Icons.wifi) return 'wifi';
    return 'notifications';
  }
} 