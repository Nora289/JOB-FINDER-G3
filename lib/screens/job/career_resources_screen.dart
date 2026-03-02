import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/theme_provider.dart';

class CareerResourcesScreen extends StatelessWidget {
  const CareerResourcesScreen({super.key});

  static const _sections = [
    _ResourceSection(
      title: 'Resume Tips',
      icon: Icons.description_outlined,
      color: Color(0xFF3B82F6),
      articles: [
        _Article('How to Write a Winning Resume', '5 min read', Icons.star_outline),
        _Article('Top 10 Resume Mistakes to Avoid', '4 min read', Icons.warning_amber_outlined),
        _Article('Tailoring Your Resume for Each Job', '6 min read', Icons.tune_outlined),
        _Article('Resume Format: Chronological vs Functional', '5 min read', Icons.compare_outlined),
        _Article('Action Verbs That Impress Recruiters', '3 min read', Icons.flash_on_outlined),
      ],
    ),
    _ResourceSection(
      title: 'Cover Letter Guide',
      icon: Icons.mail_outline,
      color: Color(0xFF8B5CF6),
      articles: [
        _Article('Writing a Cover Letter That Gets Read', '6 min read', Icons.edit_outlined),
        _Article('Cover Letter Opening Lines That Stand Out', '4 min read', Icons.format_quote_outlined),
        _Article('How to Address Gaps in Employment', '5 min read', Icons.timeline_outlined),
        _Article('Cover Letter vs Resume: Key Differences', '4 min read', Icons.compare_arrows_outlined),
      ],
    ),
    _ResourceSection(
      title: 'Salary & Negotiation',
      icon: Icons.attach_money_outlined,
      color: Color(0xFF10B981),
      articles: [
        _Article('How to Research Your Market Salary', '5 min read', Icons.search_outlined),
        _Article('Negotiation Scripts That Actually Work', '7 min read', Icons.record_voice_over_outlined),
        _Article('When & How to Ask for a Raise', '6 min read', Icons.trending_up_outlined),
        _Article('Benefits Beyond Salary: What to Negotiate', '5 min read', Icons.card_giftcard_outlined),
        _Article('Common Salary Negotiation Mistakes', '4 min read', Icons.warning_outlined),
      ],
    ),
    _ResourceSection(
      title: 'Career Growth',
      icon: Icons.rocket_launch_outlined,
      color: Color(0xFFF59E0B),
      articles: [
        _Article('Building a Personal Brand on LinkedIn', '6 min read', Icons.person_outlined),
        _Article('Networking Strategies for Introverts', '5 min read', Icons.people_outline),
        _Article('Skills to Learn for the Future of Work', '7 min read', Icons.lightbulb_outline),
        _Article('How to Switch Careers Successfully', '8 min read', Icons.swap_horiz_outlined),
        _Article('Finding a Mentor in Your Industry', '5 min read', Icons.school_outlined),
      ],
    ),
    _ResourceSection(
      title: 'Remote Work',
      icon: Icons.home_work_outlined,
      color: Color(0xFFEF4444),
      articles: [
        _Article('How to Find & Land Remote Jobs', '5 min read', Icons.search_outlined),
        _Article('Productivity Tips for Working From Home', '6 min read', Icons.check_circle_outline),
        _Article('Setting Up Your Home Office', '4 min read', Icons.desktop_windows_outlined),
        _Article('Remote Work Tools Every Professional Needs', '5 min read', Icons.build_outlined),
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
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
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
                          'Career Resources',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Guides, tips & tools to grow your career',
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
                  if (i >= _sections.length) return null;
                  return _SectionCard(
                    section: _sections[i],
                    isDark: isDark,
                    cardBg: cardBg,
                  );
                },
                childCount: _sections.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _SectionCard extends StatefulWidget {
  final _ResourceSection section;
  final bool isDark;
  final Color cardBg;

  const _SectionCard({
    required this.section,
    required this.isDark,
    required this.cardBg,
  });

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.section;
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
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: s.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(s.icon, color: s.color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.title,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${s.articles.length} articles',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextHint : AppColors.textHint,
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
                      color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              children: [
                Divider(
                  height: 1,
                  color: isDark ? AppColors.darkDivider : Colors.grey.shade100,
                ),
                ...s.articles.map(
                  (a) => InkWell(
                    onTap: () => _showArticleDialog(context, a, s.color, isDark),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: s.color.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(a.icon, size: 18, color: s.color),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  a.title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  a.duration,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  void _showArticleDialog(BuildContext context, _Article article, Color color, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(article.icon, size: 18, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                article.title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'This article is coming soon! We\'re preparing quality career content to help you land your dream job. Check back soon.',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Got it',
              style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceSection {
  final String title;
  final IconData icon;
  final Color color;
  final List<_Article> articles;
  const _ResourceSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.articles,
  });
}

class _Article {
  final String title;
  final String duration;
  final IconData icon;
  const _Article(this.title, this.duration, this.icon);
}
