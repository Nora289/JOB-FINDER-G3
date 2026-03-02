import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Maps a normalised name to a team member's asset photo path.
String? _memberPhotoForAvatar(String name) {
  final n = name.toLowerCase().replaceAll(RegExp(r'\s+'), '');
  if (n.contains('soknora') || n == 'nora') {
    return 'assets/images/Sok nora.JPG';
  }
  if (n.contains('sruochsrean') || n.contains('srean')) {
    return 'assets/images/Sruoch Srean.jpg';
  }
  if (n.contains('unpheasa') || n.contains('pheasa')) {
    return 'assets/images/Un pheasa.jpg';
  }
  if (n.contains('yornsomnang') || n.contains('somnang')) {
    return 'assets/images/Yorn Somnang.jpg';
  }
  if (n.contains('pansothea') || n.contains('sothea')) {
    return 'assets/images/Pan Sothea.jpg';
  }
  return null;
}

class UserAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final double fontSize;

  const UserAvatar({
    super.key,
    required this.name,
    this.radius = 50,
    this.fontSize = 28,
  });

  /// Generate a deterministic color from the user's name
  Color _generateColor(String name) {
    const colors = [
      Color(0xFF4A90D9),
      Color(0xFF50C878),
      Color(0xFFE74C3C),
      Color(0xFF9B59B6),
      Color(0xFFF39C12),
      Color(0xFF1ABC9C),
      Color(0xFFE91E63),
      Color(0xFF3F51B5),
      Color(0xFF009688),
      Color(0xFFFF5722),
      Color(0xFF795548),
      Color(0xFF607D8B),
    ];
    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return colors[hash.abs() % colors.length];
  }

  /// Get initials from name (up to 2 characters)
  String _getInitials(String name) {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final photoAsset = _memberPhotoForAvatar(name);
    final diameter = radius * 2;

    if (photoAsset != null) {
      return Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            photoAsset,
            width: diameter,
            height: diameter,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _initialCircle(diameter),
          ),
        ),
      );
    }

    return _initialCircle(diameter);
  }

  Widget _initialCircle(double diameter) {
    final color = _generateColor(name);
    final initials = _getInitials(name);
    final darkerColor = HSLColor.fromColor(color).withLightness(0.35).toColor();

    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, darkerColor],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
