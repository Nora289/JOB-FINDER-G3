import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/auth_provider.dart';
import 'package:job_finder/providers/theme_provider.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final auth = context.watch<AuthProvider>();
    final themeProvider = context.read<ThemeProvider>();
    final userName = auth.userName.isNotEmpty ? auth.userName : 'User';

    return Drawer(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userName,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Divider(
                    height: 20,
                    color: isDark ? AppColors.darkDivider : AppColors.divider,
                  ),
                ],
              ),
            ),

            // ── Menu items ──
            _drawerItem(
              context,
              icon: Icons.person_outline,
              label: 'Personal Info',
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
                context.push('/profile');
              },
            ),
            _drawerItem(
              context,
              icon: Icons.assignment_outlined,
              label: 'Applications',
              isDark: isDark,
              onTap: () => Navigator.pop(context),
            ),
            _drawerItem(
              context,
              icon: Icons.people_outline,
              label: 'Proposals',
              isDark: isDark,
              onTap: () => Navigator.pop(context),
            ),
            _drawerItem(
              context,
              icon: Icons.description_outlined,
              label: 'Resumes',
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
                context.push('/resume');
              },
            ),
            _drawerItem(
              context,
              icon: Icons.work_outline,
              label: 'Portfolio',
              isDark: isDark,
              onTap: () => Navigator.pop(context),
            ),
            _drawerItem(
              context,
              icon: Icons.mail_outline,
              label: 'Cover Letters',
              isDark: isDark,
              onTap: () => Navigator.pop(context),
            ),

            const Spacer(),

            // ── Dark mode toggle ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.dark_mode_outlined,
                    size: 20,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Dark Mode',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: isDark,
                    onChanged: (_) => themeProvider.toggleTheme(),
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),

            // ── Logout ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  context.read<AuthProvider>().signOut();
                  context.go('/sign-in');
                },
                child: Text(
                  'Logout',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Membership button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    minimumSize: Size.zero,
                  ),
                  icon: const Icon(Icons.star, size: 16),
                  label: Text(
                    'Membership',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color:
                    isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
