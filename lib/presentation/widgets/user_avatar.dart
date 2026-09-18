import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Avatar circulaire avec les initiales du pseudo (ou une icône par défaut).
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.pseudo,
    this.radius = 28,
    this.onTap,
  });

  final String? pseudo;
  final double radius;
  final VoidCallback? onTap;

  String get _initials {
    final name = pseudo?.trim() ?? '';
    if (name.isEmpty) return '?';
    final parts = name.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.characters.first.toUpperCase();
    }
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary,
      child: Text(
        _initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.7,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    if (onTap == null) return avatar;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: avatar,
    );
  }
}