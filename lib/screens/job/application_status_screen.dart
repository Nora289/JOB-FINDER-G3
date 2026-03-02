import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/models/job_model.dart';
import 'package:job_finder/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ApplicationStatusScreen extends StatelessWidget {
  final JobModel job;
  final String status;

  const ApplicationStatusScreen({
    super.key,
    required this.job,
    required this.status,
  });

  static const _steps = [
    _Step(
      label: 'Application Submitted',
      sub: 'Your application has been received.',
      icon: Icons.send_outlined,
    ),
    _Step(
      label: 'Under Review',
      sub: 'The recruiter is reviewing your profile.',
      icon: Icons.manage_search_outlined,
    ),
    _Step(
      label: 'Shortlisted',
      sub: 'Congratulations! You have been shortlisted.',
      icon: Icons.star_outline,
    ),
    _Step(
      label: 'Interview Scheduled',
      sub: 'An interview has been arranged for you.',
      icon: Icons.event_outlined,
    ),
    _Step(
      label: 'Final Decision',
      sub: 'Awaiting the employer\'s final decision.',
      icon: Icons.verified_outlined,
    ),
  ];

  int get _currentStep {
    switch (status) {
      case 'Submitted':
        return 0;
      case 'Under Review':
        return 1;
      case 'Shortlisted':
        return 2;
      case 'Interview Scheduled':
        return 3;
      case 'Offer':
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final bg = isDark ? AppColors.darkBg : const Color(0xFFF5F7FA);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final current = _currentStep;

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
          'Application Status',
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
          children: [
            // Job card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(
                          job.companyLogo,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.business, color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${job.companyName} · ${job.location}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(status).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _statusColor(status),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Timeline
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Application Progress',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(_steps.length, (i) {
                    final step = _steps[i];
                    final isDone = i <= current;
                    final isActive = i == current;
                    final isLast = i == _steps.length - 1;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon + line column
                        Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: isDone
                                    ? (isActive
                                        ? AppColors.primary
                                        : AppColors.primary.withValues(
                                            alpha: 0.15))
                                    : (isDark
                                        ? AppColors.darkCard
                                        : Colors.grey.shade100),
                                shape: BoxShape.circle,
                                border: isActive
                                    ? Border.all(
                                        color: AppColors.primary, width: 2)
                                    : null,
                              ),
                              child: Icon(
                                step.icon,
                                size: 18,
                                color: isDone
                                    ? (isActive
                                        ? Colors.white
                                        : AppColors.primary)
                                    : (isDark
                                        ? AppColors.darkTextHint
                                        : Colors.grey.shade400),
                              ),
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 36,
                                color: isDone
                                    ? AppColors.primary.withValues(alpha: 0.4)
                                    : (isDark
                                        ? AppColors.darkDivider
                                        : Colors.grey.shade200),
                              ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        // Text column
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: isLast ? 0 : 20,
                              top: 7,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step.label,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: isActive
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isDone
                                        ? (isActive
                                            ? AppColors.primary
                                            : (isDark
                                                ? AppColors.darkTextPrimary
                                                : AppColors.textPrimary))
                                        : (isDark
                                            ? AppColors.darkTextHint
                                            : AppColors.textHint),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  step.sub,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: isDone
                                        ? (isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textSecondary)
                                        : (isDark
                                            ? AppColors.darkTextHint
                                            : Colors.grey.shade400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tips banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF5B8FFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lightbulb_outline,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prepare for your Interview',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Check our expert interview tips to boost your chances.',
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const InterviewTipsScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'View Tips',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
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

  Color _statusColor(String s) {
    switch (s) {
      case 'Shortlisted':
        return const Color(0xFF10B981);
      case 'Interview Scheduled':
        return const Color(0xFF8B5CF6);
      case 'Under Review':
        return const Color(0xFFF59E0B);
      case 'Offer':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF3B82F6);
    }
  }
}

class _Step {
  final String label;
  final String sub;
  final IconData icon;
  const _Step({required this.label, required this.sub, required this.icon});
}

// ─────────────────────────────────────────────────────────────────────────────
// Interview Tips Screen
// ─────────────────────────────────────────────────────────────────────────────

class InterviewTipsScreen extends StatelessWidget {
  const InterviewTipsScreen({super.key});

  static const _categories = [
    _TipCategory(
      title: 'Before the Interview',
      color: Color(0xFF3B82F6),
      icon: Icons.event_available_outlined,
      tips: [
        'Research the company thoroughly — mission, products, recent news.',
        'Re-read the job description and match your skills to requirements.',
        'Prepare 3–5 specific examples using the STAR method (Situation, Task, Action, Result).',
        'Plan your route and aim to arrive 10–15 minutes early.',
        'Prepare thoughtful questions to ask the interviewer.',
        'Choose professional attire the night before.',
      ],
    ),
    _TipCategory(
      title: 'During the Interview',
      color: Color(0xFF8B5CF6),
      icon: Icons.record_voice_over_outlined,
      tips: [
        'Greet with a firm handshake and maintain good eye contact.',
        'Listen carefully before answering — take a moment to think.',
        'Be specific with examples rather than giving vague answers.',
        'Show enthusiasm and genuine interest in the role.',
        'Speak clearly at a moderate pace and avoid filler words.',
        'Be honest — if you don\'t know something, say so professionally.',
      ],
    ),
    _TipCategory(
      title: 'Common Questions',
      color: Color(0xFFF59E0B),
      icon: Icons.help_outline,
      tips: [
        '"Tell me about yourself" — Keep it professional and relevant (2 mins).',
        '"Why do you want this job?" — Connect your goals with the company.',
        '"What is your greatest strength?" — Give a strength backed by a story.',
        '"What is your weakness?" — Show self-awareness + improvement steps.',
        '"Where do you see yourself in 5 years?" — Align with the company\'s growth.',
        '"Why should we hire you?" — Summarise your unique value confidently.',
      ],
    ),
    _TipCategory(
      title: 'Salary Negotiation',
      color: Color(0xFF10B981),
      icon: Icons.attach_money_outlined,
      tips: [
        'Research market salary ranges for your role and location beforehand.',
        'Let the employer mention a number first if possible.',
        'Give a range rather than a fixed number.',
        'Never accept or reject on the spot — ask for time to consider.',
        'Negotiate based on value, not personal financial needs.',
        'Consider the full package: benefits, flexibility, and growth potential.',
      ],
    ),
    _TipCategory(
      title: 'After the Interview',
      color: Color(0xFFEF4444),
      icon: Icons.mark_email_read_outlined,
      tips: [
        'Send a thank-you email within 24 hours.',
        'Personalise the email by referencing specific topics discussed.',
        'Reiterate your enthusiasm for the role briefly.',
        'Follow up politely if you haven\'t heard back by the agreed time.',
        'Reflect on what went well and what you can improve.',
        'Keep applying — don\'t wait on one opportunity.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final bg = isDark ? AppColors.darkBg : const Color(0xFFF5F7FA);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, Color(0xFF5B8FFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 48, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Interview Tips',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Expert advice to land your dream job',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  if (i >= _categories.length) return null;
                  final cat = _categories[i];
                  return _TipCategoryCard(
                    category: cat,
                    isDark: isDark,
                    cardBg: cardBg,
                  );
                },
                childCount: _categories.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _TipCategoryCard extends StatefulWidget {
  final _TipCategory category;
  final bool isDark;
  final Color cardBg;

  const _TipCategoryCard({
    required this.category,
    required this.isDark,
    required this.cardBg,
  });

  @override
  State<_TipCategoryCard> createState() => _TipCategoryCardState();
}

class _TipCategoryCardState extends State<_TipCategoryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    final isDark = widget.isDark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: widget.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header (always visible)
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: cat.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(cat.icon, color: cat.color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat.title,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${cat.tips.length} tips',
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
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: isDark
                          ? AppColors.darkTextHint
                          : AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expanded tips
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              children: [
                Divider(
                  height: 1,
                  color: isDark ? AppColors.darkDivider : Colors.grey.shade100,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    children: List.generate(cat.tips.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 3),
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: cat.color.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${i + 1}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: cat.color,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                cat.tips[i],
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class _TipCategory {
  final String title;
  final Color color;
  final IconData icon;
  final List<String> tips;

  const _TipCategory({
    required this.title,
    required this.color,
    required this.icon,
    required this.tips,
  });
}
