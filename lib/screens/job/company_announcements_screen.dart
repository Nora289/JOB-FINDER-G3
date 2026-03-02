import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/models/job_model.dart';
import 'package:job_finder/providers/job_provider.dart';
import 'package:job_finder/providers/theme_provider.dart';

class CompanyAnnouncementsScreen extends StatefulWidget {
  const CompanyAnnouncementsScreen({super.key});

  @override
  State<CompanyAnnouncementsScreen> createState() =>
      _CompanyAnnouncementsScreenState();
}

class _CompanyAnnouncementsScreenState
    extends State<CompanyAnnouncementsScreen> {
  // Which company cards are expanded
  final Set<String> _expanded = {};

  // Category filter chip selection (null = All)
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final jp = context.watch<JobProvider>();

    final bg = isDark ? AppColors.darkBg : const Color(0xFFF5F7FA);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    // Group all jobs by company
    final Map<String, List<JobModel>> byCompany = {};
    for (final job in jp.jobs) {
      byCompany.putIfAbsent(job.companyName, () => []).add(job);
    }

    // Build category options from all jobs
    final allCategories = [
      'All',
      ...jp.categories,
    ];

    // Filter per selected category
    final Map<String, List<JobModel>> filtered = {};
    byCompany.forEach((company, jobs) {
      final result = _selectedCategory == 'All'
          ? jobs
          : jobs.where((j) => j.category == _selectedCategory).toList();
      if (result.isNotEmpty) filtered[company] = result;
    });

    // Sort companies: urgent-first then alphabetical
    final sortedCompanies = filtered.keys.toList()
      ..sort((a, b) {
        final aUrgent = filtered[a]!.any((j) => j.isUrgent) ? 0 : 1;
        final bUrgent = filtered[b]!.any((j) => j.isUrgent) ? 0 : 1;
        if (aUrgent != bUrgent) return aUrgent.compareTo(bUrgent);
        return a.compareTo(b);
      });

    // Total open positions
    final totalPositions =
        filtered.values.fold(0, (sum, jobs) => sum + jobs.length);

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // ── Hero App Bar ──
          SliverAppBar(
            expandedHeight: 170,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
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
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.local_fire_department_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Company Announcements',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '$totalPositions open positions · ${sortedCompanies.length} companies',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color:
                                        Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Category filter chips ──
          SliverToBoxAdapter(
            child: Container(
              color: bg,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter by Category',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: allCategories.map((cat) {
                        final sel = _selectedCategory == cat;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategory = cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: sel
                                  ? const Color(0xFFFF6B35)
                                  : (isDark
                                      ? AppColors.darkCard
                                      : Colors.white),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: sel
                                    ? const Color(0xFFFF6B35)
                                    : (isDark
                                        ? AppColors.darkDivider
                                        : Colors.grey.shade200),
                              ),
                            ),
                            child: Text(
                              cat,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: sel
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: sel
                                    ? Colors.white
                                    : textPrimary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Summary stats row ──
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  _StatPill(
                    label: 'Total Jobs',
                    value: '$totalPositions',
                    color: AppColors.primary,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _StatPill(
                    label: 'Urgent',
                    value: '${jp.jobs.where((j) => j.isUrgent).length}',
                    color: const Color(0xFFFF6B35),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _StatPill(
                    label: 'Companies',
                    value: '${sortedCompanies.length}',
                    color: const Color(0xFF10B981),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),

          // ── Company announcement cards ──
          if (sortedCompanies.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.business_center_outlined,
                        size: 60,
                        color: isDark
                            ? AppColors.darkTextHint
                            : Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text(
                      'No positions in this category',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: textSecondary),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final company = sortedCompanies[i];
                    final jobs = filtered[company]!;
                    final isExpanded = _expanded.contains(company);
                    final hasUrgent = jobs.any((j) => j.isUrgent);
                    final logo = jobs.first.companyLogo;

                    // Group jobs by category for summary counts
                    final Map<String, int> catCounts = {};
                    for (final j in jobs) {
                      catCounts[j.title] =
                          (catCounts[j.title] ?? 0) + 1;
                    }

                    // Build grouped summary: "2 × iOS Developer"
                    final titleCounts = <String, int>{};
                    for (final j in jobs) {
                      titleCounts[j.title] =
                          (titleCounts[j.title] ?? 0) + 1;
                    }
                    final summaryParts = titleCounts.entries
                        .map((e) =>
                            '${e.value}× ${e.key}')
                        .toList();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // ── Company header ──
                          InkWell(
                            onTap: () => setState(() {
                              if (isExpanded) {
                                _expanded.remove(company);
                              } else {
                                _expanded.add(company);
                              }
                            }),
                            borderRadius: BorderRadius.circular(18),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Logo
                                  Container(
                                    width: 54,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.darkCard
                                          : const Color(0xFFF5F7FA),
                                      borderRadius:
                                          BorderRadius.circular(14),
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(14),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: Image.asset(
                                          logo,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.business,
                                                  color:
                                                      AppColors.primary),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  // Name + summary
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                company,
                                                style:
                                                    GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.w700,
                                                  color: textPrimary,
                                                ),
                                              ),
                                            ),
                                            if (hasUrgent)
                                              Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 8,
                                                    vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                          0xFFFF6B35)
                                                      .withValues(
                                                          alpha: 0.12),
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(20),
                                                  border: Border.all(
                                                    color: const Color(
                                                            0xFFFF6B35)
                                                        .withValues(
                                                            alpha: 0.4),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .local_fire_department_rounded,
                                                      color: Color(
                                                          0xFFFF6B35),
                                                      size: 12,
                                                    ),
                                                    const SizedBox(
                                                        width: 3),
                                                    Text(
                                                      'Urgent',
                                                      style: GoogleFonts
                                                          .poppins(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight
                                                                .w600,
                                                        color: const Color(
                                                            0xFFFF6B35),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        // Job count badge
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 3),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                              ),
                                              child: Text(
                                                '${jobs.length} open position${jobs.length > 1 ? 's' : ''}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        // Summary: "2× iOS Dev, 1× Flutter Dev"
                                        Text(
                                          summaryParts.join('  ·  '),
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: textSecondary,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Chevron
                                  AnimatedRotation(
                                    turns: isExpanded ? 0.5 : 0,
                                    duration:
                                        const Duration(milliseconds: 200),
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

                          // ── Expanded job list ──
                          AnimatedCrossFade(
                            firstChild:
                                const SizedBox(width: double.infinity),
                            secondChild: Column(
                              children: [
                                Divider(
                                  height: 1,
                                  color: isDark
                                      ? AppColors.darkDivider
                                      : Colors.grey.shade100,
                                ),
                                ...jobs.map((job) =>
                                    _JobRow(
                                      job: job,
                                      isDark: isDark,
                                      onTap: () => context
                                          .push('/job-detail/${job.id}'),
                                    )),
                              ],
                            ),
                            crossFadeState: isExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 220),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: sortedCompanies.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual job row inside expanded company card
// ─────────────────────────────────────────────────────────────────────────────
class _JobRow extends StatelessWidget {
  final JobModel job;
  final bool isDark;
  final VoidCallback onTap;

  const _JobRow({
    required this.job,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            // Left colored indicator
            Container(
              width: 4,
              height: 44,
              decoration: BoxDecoration(
                color: job.isUrgent
                    ? const Color(0xFFFF6B35)
                    : AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            // Job info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          job.title,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      if (job.isUrgent)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Urgent',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFFF6B35),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _MiniChip(
                        label: job.type,
                        color: AppColors.primary,
                        isDark: isDark,
                      ),
                      const SizedBox(width: 6),
                      _MiniChip(
                        label: job.experienceLevel,
                        color: const Color(0xFF8B5CF6),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 6),
                      _MiniChip(
                        label: job.category,
                        color: const Color(0xFF10B981),
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.attach_money,
                          size: 13,
                          color: isDark
                              ? AppColors.darkTextHint
                              : AppColors.textHint),
                      Text(
                        job.salary,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.primaryLight
                              : AppColors.primary,
                        ),
                      ),
                      if (job.deadline != null) ...[
                        const SizedBox(width: 10),
                        Icon(Icons.event_outlined,
                            size: 12,
                            color: isDark
                                ? AppColors.darkTextHint
                                : AppColors.textHint),
                        const SizedBox(width: 2),
                        Text(
                          'Apply by ${job.deadline}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: isDark ? AppColors.darkTextHint : AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDark;

  const _MiniChip({
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 18,
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
      ),
    );
  }
}
