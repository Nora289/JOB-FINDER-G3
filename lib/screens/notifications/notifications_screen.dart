import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/theme_provider.dart';

class _NotifItem {
  final String? logoAsset;
  final String initials;
  final String title;
  final String body;
  final String time;
  final bool hasOnline;
  final Color avatarColor;

  const _NotifItem({
    this.logoAsset,
    required this.initials,
    required this.title,
    required this.body,
    required this.time,
    this.hasOnline = false,
    required this.avatarColor,
  });
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const _newActivity = [
    _NotifItem(
      logoAsset: 'assets/images/ABA Bank.png',
      initials: 'ABA',
      title: 'ABA Bank',
      body:
          'want to take a final interview of you where head of HR will see you!',
      time: '12 min ago',
      hasOnline: true,
      avatarColor: Color(0xFF1565C0),
    ),
    _NotifItem(
      logoAsset: 'assets/images/Smart .png',
      initials: 'S',
      title: 'Smart Axiata',
      body: 'want to contact with you in 24 hours with proper preparation',
      time: '47 min ago',
      hasOnline: true,
      avatarColor: Color(0xFF2E7D32),
    ),
    _NotifItem(
      logoAsset: 'assets/images/Grab.png',
      initials: 'G',
      title: 'Grab Cambodia',
      body: 'viewed your profile and is interested in your background.',
      time: '1 hrs ago',
      hasOnline: true,
      avatarColor: Color(0xFF00838F),
    ),
  ];

  static const _applications = [
    _NotifItem(
      logoAsset: 'assets/images/Wing.png',
      initials: 'W',
      title: 'Wing Bank',
      body:
          'Your application is submitted successfully to Wing Bank. You can check the status here.',
      time: '1 hrs ago',
      avatarColor: Color(0xFF6A1B9A),
    ),
    _NotifItem(
      logoAsset: 'assets/images/Cellcard.png',
      initials: 'C',
      title: 'Cellcard',
      body:
          'reviewing your application, cover letter and portfolio. All the best!',
      time: '2 hrs ago',
      avatarColor: Color(0xFFE65100),
    ),
    _NotifItem(
      logoAsset: 'assets/images/Goolge.png',
      initials: 'G',
      title: 'Google',
      body:
          'Your application for Software Engineer has been received. We will review it shortly.',
      time: '3 hrs ago',
      avatarColor: Color(0xFF1565C0),
    ),
    _NotifItem(
      logoAsset: 'assets/images/Passapp.png',
      initials: 'P',
      title: 'PassApp',
      body:
          'Thank you for applying! Our team will get back to you within 3 business days.',
      time: '5 hrs ago',
      avatarColor: Color(0xFF00838F),
    ),
  ];

  static const _interviews = [
    _NotifItem(
      logoAsset: 'assets/images/Aceleda bank.png',
      initials: 'AC',
      title: 'ACLEDA Bank',
      body: 'liked your resume and want to take an interview of you.',
      time: '1 hrs ago',
      avatarColor: Color(0xFF00838F),
    ),
    _NotifItem(
      logoAsset: 'assets/images/Grab.png',
      initials: 'G',
      title: 'Grab Cambodia',
      body: 'You passed the first round. Be prepared for the next!',
      time: '2 hrs ago',
      avatarColor: Color(0xFF2E7D32),
    ),
    _NotifItem(
      logoAsset: 'assets/images/ABA Bank.png',
      initials: 'ABA',
      title: 'ABA Bank',
      body:
          'Your technical interview is scheduled for tomorrow at 10:00 AM. Please be on time.',
      time: 'Yesterday',
      avatarColor: Color(0xFF1565C0),
    ),
    _NotifItem(
      logoAsset: 'assets/images/Smart .png',
      initials: 'S',
      title: 'Smart Axiata',
      body:
          'Congratulations! You have been shortlisted for the final interview round.',
      time: 'Yesterday',
      avatarColor: Color(0xFF2E7D32),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              'Mark all read',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          _sectionHeader('New activity', isDark),
          ..._newActivity.map((n) => _notifTile(n, isDark)),
          const SizedBox(height: 4),
          _sectionHeaderWithSeeAll('Application', isDark),
          ..._applications.map((n) => _notifTile(n, isDark)),
          const SizedBox(height: 4),
          _sectionHeaderWithSeeAll('Interview', isDark),
          ..._interviews.map((n) => _notifTile(n, isDark)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _sectionHeaderWithSeeAll(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          Text(
            'See all',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _notifTile(_NotifItem item, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar with logo image
          Stack(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: item.avatarColor,
                  shape: BoxShape.circle,
                ),
                child: item.logoAsset != null
                    ? Center(
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image.asset(
                                item.logoAsset!,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Center(
                                  child: Text(
                                    item.initials,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: item.avatarColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          item.initials,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
              if (item.hasOnline)
                Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.darkBg : Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${item.title} ',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: item.body,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      height: 1.4,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Time
          Text(
            item.time,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: isDark ? AppColors.darkTextHint : AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
