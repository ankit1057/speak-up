import 'package:flutter/material.dart';

class AppConstants {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 992;

  // Colors
  static const Color primaryColor = Color(0xFFFF5252);
  static const Color secondaryColor = Color(0xFF2196F3);
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black87;

  // Padding
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;

  // Border Radius
  static const double defaultBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;

  // Animation Duration
  static const Duration defaultDuration = Duration(milliseconds: 300);

  // Categories
  static const List<Map<String, dynamic>> categories = [
    {'name': 'Banking', 'icon': Icons.account_balance},
    {'name': 'Government', 'icon': Icons.account_balance_wallet},
    {'name': 'Telecom', 'icon': Icons.phone_android},
    {'name': 'Insurance', 'icon': Icons.security},
    {'name': 'Healthcare', 'icon': Icons.local_hospital},
    {'name': 'Education', 'icon': Icons.school},
  ];
}