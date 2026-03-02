import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/l10n/app_localizations.dart';
import 'package:job_finder/providers/theme_provider.dart';
import 'package:job_finder/screens/home/home_screen.dart';
import 'package:job_finder/screens/job/saved_jobs_screen.dart';
import 'package:job_finder/screens/messaging/chat_list_screen.dart';
import 'package:job_finder/screens/notifications/notifications_screen.dart';
import 'package:job_finder/screens/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SavedJobsScreen(),
    NotificationsScreen(),
    ChatListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: _ClassicNavBar(
        currentIndex: _currentIndex,
        isDark: isDark,
        l10n: l10n,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// ── Classic flat bottom navbar matching screenshot style ──────────────────
class _ClassicNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isDark;
  final AppLocalizations l10n;
  final ValueChanged<int> onTap;

  const _ClassicNavBar({
    required this.currentIndex,
    required this.isDark,
    required this.l10n,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkSurface : Colors.white;
    final active = AppColors.primary;
    final inactive = isDark ? AppColors.darkTextHint : Colors.grey.shade500;

    final items = [
      _Item(Icons.home_outlined, Icons.home_rounded, l10n['home'] ?? 'Home'),
      _Item(
        Icons.bookmark_border_rounded,
        Icons.bookmark_rounded,
        l10n['saved'] ?? 'Saved',
      ),
      _Item(
        Icons.notifications_outlined,
        Icons.notifications_rounded,
        l10n['notifications'] ?? 'Alerts',
      ),
      _Item(
        Icons.chat_bubble_outline_rounded,
        Icons.chat_bubble_rounded,
        l10n['messages'] ?? 'Messages',
      ),
      _Item(
        Icons.person_outline_rounded,
        Icons.person_rounded,
        l10n['profile'] ?? 'Profile',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: bg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(items.length, (i) {
              final sel = i == currentIndex;
              final item = items[i];
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: sel
                              ? active.withValues(alpha: 0.12)
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Icon(
                            sel ? item.activeIcon : item.icon,
                            size: 22,
                            color: sel ? active : inactive,
                          ),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                          color: sel ? active : inactive,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _Item {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _Item(this.icon, this.activeIcon, this.label);
}
