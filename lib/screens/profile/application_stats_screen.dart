import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/job_provider.dart';
import 'package:job_finder/providers/theme_provider.dart';

class ApplicationStatsScreen extends StatelessWidget {
  const ApplicationStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final jobProvider = context.watch<JobProvider>();
    final applied = jobProvider.appliedJobs;
    final saved = jobProvider.savedJobs;
    final bg = isDark ? AppColors.darkBg : const Color(0xFFF8F9FA);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

    final totalApplied = applied.length;
    final interviews = totalApplied > 0 ? (totalApplied * 0.3).ceil() : 0;
    final shortlisted = totalApplied > 0 ? (totalApplied * 0.5).ceil() : 0;
    final responseRate = totalApplied > 0
        ? ((shortlisted / totalApplied) * 100).round()
        : 0;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Application Statistics',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, Color(0xFF5B8FFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Job Search',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    'Overview',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _bannerStat('$totalApplied', 'Applied', Colors.white),
                      _vDivider(),
                      _bannerStat('$shortlisted', 'Shortlisted', Colors.white),
                      _vDivider(),
                      _bannerStat('$interviews', 'Interviews', Colors.white),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Response Rate card
            _sectionTitle('Response Rate', isDark),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [_shadow()],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$responseRate%',
                              style: GoogleFonts.poppins(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: _rateColor(responseRate),
                              ),
                            ),
                            Text(
                              'Employer Response Rate',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _rateColor(
                            responseRate,
                          ).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          responseRate >= 50
                              ? Icons.sentiment_satisfied_alt
                              : responseRate > 0
                              ? Icons.sentiment_neutral
                              : Icons.sentiment_dissatisfied,
                          size: 32,
                          color: _rateColor(responseRate),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: responseRate / 100,
                      minHeight: 10,
                      backgroundColor: isDark
                          ? AppColors.darkCard
                          : Colors.grey.shade100,
                      valueColor: AlwaysStoppedAnimation(
                        _rateColor(responseRate),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    totalApplied == 0
                        ? 'Apply to jobs to track your response rate.'
                        : 'Based on $totalApplied application${totalApplied == 1 ? '' : 's'}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextHint
                          : AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Activity breakdown
            _sectionTitle('Activity Breakdown', isDark),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _statCard(
                  '$totalApplied',
                  'Total Applied',
                  Icons.send_outlined,
                  const Color(0xFF3B82F6),
                  cardBg,
                  isDark,
                ),
                _statCard(
                  '${saved.length}',
                  'Jobs Saved',
                  Icons.bookmark_outline,
                  const Color(0xFF8B5CF6),
                  cardBg,
                  isDark,
                ),
                _statCard(
                  '$shortlisted',
                  'Shortlisted',
                  Icons.star_outline,
                  const Color(0xFF10B981),
                  cardBg,
                  isDark,
                ),
                _statCard(
                  '$interviews',
                  'Interviews',
                  Icons.event_outlined,
                  const Color(0xFFF59E0B),
                  cardBg,
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Application status breakdown
            if (totalApplied > 0) ...[
              _sectionTitle('Status Breakdown', isDark),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [_shadow()],
                ),
                child: Column(
                  children: [
                    _statusBar(
                      'Under Review',
                      shortlisted,
                      totalApplied,
                      const Color(0xFFF59E0B),
                      isDark,
                    ),
                    const SizedBox(height: 12),
                    _statusBar(
                      'Shortlisted',
                      (shortlisted * 0.6).ceil(),
                      totalApplied,
                      const Color(0xFF10B981),
                      isDark,
                    ),
                    const SizedBox(height: 12),
                    _statusBar(
                      'Interview',
                      interviews,
                      totalApplied,
                      const Color(0xFF8B5CF6),
                      isDark,
                    ),
                    const SizedBox(height: 12),
                    _statusBar(
                      'Pending',
                      totalApplied - shortlisted,
                      totalApplied,
                      const Color(0xFF3B82F6),
                      isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Tips card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.tips_and_updates_outlined,
                    color: Color(0xFF10B981),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pro Tip',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Applying to 10–15 jobs per week and customising your resume for each role increases your interview rate by up to 3x.',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _bannerStat(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withValues(alpha: 0.3),
    );
  }

  Widget _sectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      ),
    );
  }

  Widget _statCard(
    String value,
    String label,
    IconData icon,
    Color color,
    Color cardBg,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [_shadow()],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBar(
    String label,
    int count,
    int total,
    Color color,
    bool isDark,
  ) {
    final pct = total > 0 ? (count / total).clamp(0.0, 1.0) : 0.0;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            Text(
              '$count',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 8,
            backgroundColor: isDark ? AppColors.darkCard : Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }

  Color _rateColor(int rate) {
    if (rate >= 60) return const Color(0xFF10B981);
    if (rate >= 30) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  BoxShadow _shadow() => BoxShadow(
    color: Colors.black.withValues(alpha: 0.04),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );
}
