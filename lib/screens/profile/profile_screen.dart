import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    backgroundImage: const AssetImage(
                      'assets/images/profile.JPG',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    auth.userName.isNotEmpty ? auth.userName : 'User',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    auth.userEmail,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (auth.userPhone.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      auth.userPhone,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(
                      'Edit Profile',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Stats
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statItem('3', 'Applied'),
                  Container(width: 1, height: 40, color: AppColors.divider),
                  _statItem('2', 'Saved'),
                  Container(width: 1, height: 40, color: AppColors.divider),
                  _statItem('1', 'Interview'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Menu items
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _menuItem(
                    icon: Icons.description_outlined,
                    title: 'My Resume',
                    onTap: () => context.push('/resume'),
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.work_outline,
                    title: 'My Applications',
                    badge: '3',
                    onTap: () {},
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.bookmark_border,
                    title: 'Saved Jobs',
                    onTap: () => context.push('/saved-jobs'),
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.business_outlined,
                    title: 'Following Companies',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Settings
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _menuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    trailing: Switch(
                      value: false,
                      onChanged: (val) {},
                      activeColor: AppColors.primary,
                    ),
                    onTap: () {},
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: 'English',
                    onTap: () {},
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    onTap: () {},
                  ),
                  _divider(),
                  _menuItem(
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Logout
            Container(
              color: Colors.white,
              child: _menuItem(
                icon: Icons.logout,
                title: 'Log Out',
                iconColor: AppColors.error,
                titleColor: AppColors.error,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(
                        'Log Out',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      content: Text(
                        'Are you sure you want to log out?',
                        style: GoogleFonts.poppins(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text('Cancel', style: GoogleFonts.poppins()),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            auth.signOut();
                            context.go('/sign-in');
                          },
                          child: Text(
                            'Log Out',
                            style: GoogleFonts.poppins(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    String? badge,
    Widget? trailing,
    Color? iconColor,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: iconColor ?? AppColors.textSecondary),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: titleColor ?? AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textHint,
              ),
            )
          : null,
      trailing:
          trailing ??
          (badge != null
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                )
              : const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textHint,
                )),
      onTap: onTap,
    );
  }

  Widget _divider() {
    return const Divider(height: 1, indent: 60);
  }
}
