import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      Color(0xFF4A90D9), // Blue
      Color(0xFF50C878), // Green
      Color(0xFFE74C3C), // Red
      Color(0xFF9B59B6), // Purple
      Color(0xFFF39C12), // Orange
      Color(0xFF1ABC9C), // Teal
      Color(0xFFE91E63), // Pink
      Color(0xFF3F51B5), // Indigo
      Color(0xFF009688), // Cyan
      Color(0xFFFF5722), // Deep Orange
      Color(0xFF795548), // Brown
      Color(0xFF607D8B), // Blue Grey
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
    final color = _generateColor(name);
    final initials = _getInitials(name);
    final darkerColor = HSLColor.fromColor(color).withLightness(0.35).toColor();

    return Container(
      width: radius * 2,
      height: radius * 2,
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
