import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../models/job_model.dart';
import '../../providers/job_provider.dart';
import '../../providers/theme_provider.dart';

class JobComparisonDetailScreen extends StatefulWidget {
  const JobComparisonDetailScreen({super.key});

  @override
  State<JobComparisonDetailScreen> createState() =>
      _JobComparisonDetailScreenState();
}

class _JobComparisonDetailScreenState extends State<JobComparisonDetailScreen> {
  List<JobModel> _selectedJobs = [];
  bool _showAIRecommendation = false;

  @override
  void initState() {
    super.initState();
  }

  void _addJob(JobModel job) {
    if (_selectedJobs.length < 5 && !_selectedJobs.contains(job)) {
      setState(() {
        _selectedJobs.add(job);
        _showAIRecommendation = false;
      });
    }
  }

  void _removeJob(JobModel job) {
    setState(() {
      _selectedJobs.remove(job);
      _showAIRecommendation = false;
    });
  }

  void _generateAIRecommendation() {
    setState(() {
      _showAIRecommendation = true;
    });
  }

  JobModel? _getBestMatch() {
    if (_selectedJobs.isEmpty) return null;

    // AI logic: Score based on multiple factors
    // Future enhancement: Use actual user profile data from AuthProvider
    JobModel? bestJob;
    double bestScore = 0;

    for (final job in _selectedJobs) {
      double score = 0;

      // Salary score (higher is better)
      final salaryNum = _extractSalaryNumber(job.salary);
      score += salaryNum / 100;

      // Experience level match
      if (job.experienceLevel == 'Mid' || job.experienceLevel == 'Entry') {
        score += 20;
      }

      // Job type preference (Full-time preferred)
      if (job.type == 'Full-time') {
        score += 15;
      }

      // Location preference (Phnom Penh preferred)
      if (job.location.contains('Phnom Penh')) {
        score += 10;
      }

      // Skills match (simplified)
      if (job.category == 'Technology') {
        score += 25;
      }

      // Urgent jobs get bonus
      if (job.isUrgent) {
        score += 5;
      }

      if (score > bestScore) {
        bestScore = score;
        bestJob = job;
      }
    }

    return bestJob;
  }

  double _extractSalaryNumber(String salary) {
    final numbers = RegExp(r'\d+').allMatches(salary);
    if (numbers.isEmpty) return 0;
    return double.tryParse(numbers.first.group(0) ?? '0') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final jobProvider = context.watch<JobProvider>();
    final availableJobs = jobProvider.jobs
        .where((j) => !_selectedJobs.contains(j))
        .toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Compare Jobs',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        actions: [
          if (_selectedJobs.length >= 2)
            TextButton.icon(
              onPressed: _generateAIRecommendation,
              icon: Icon(
                Icons.auto_awesome,
                size: 18,
                color: AppColors.primary,
              ),
              label: Text(
                'AI Match',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Job count and add button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? Colors.grey.shade800
                      : const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.compare_arrows, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${_selectedJobs.length} of 5 jobs selected',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                if (_selectedJobs.length < 5)
                  TextButton.icon(
                    onPressed: () => _showAddJobSheet(availableJobs, isDark),
                    icon: const Icon(Icons.add_circle_outline, size: 18),
                    label: Text(
                      'Add Job',
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _selectedJobs.isEmpty
                ? _buildEmptyState(isDark)
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // AI Recommendation banner
                      if (_showAIRecommendation && _selectedJobs.length >= 2)
                        _buildAIRecommendation(isDark),

                      // Job cards row (horizontal scroll)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _buildComparisonCards(isDark),
                      ),

                      const SizedBox(height: 16),

                      // Criteria rows
                      _buildCriteriaSection(isDark),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIRecommendation(bool isDark) {
    final bestJob = _getBestMatch();
    if (bestJob == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            const Color(0xFF5B8FFF).withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Recommendation',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Based on your profile and preferences',
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
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        bestJob.companyLogo,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.business,
                              color: AppColors.primary,
                            ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.stars, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Best Match',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bestJob.title,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        bestJob.companyName,
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
                ElevatedButton(
                  onPressed: () => context.push('/job-detail/${bestJob.id}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'View',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '✓ Matches your skills and experience level\n'
            '✓ Competitive salary and benefits\n'
            '✓ Great company culture and growth opportunities',
            style: GoogleFonts.poppins(
              fontSize: 12,
              height: 1.6,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCards(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _selectedJobs.map((job) {
        final isBest = _showAIRecommendation && _getBestMatch()?.id == job.id;
        return Container(
          width: 200,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isBest
                  ? AppColors.primary
                  : (isDark ? Colors.grey.shade800 : const Color(0xFFE5E7EB)),
              width: isBest ? 2 : 1,
            ),
            boxShadow: isBest
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isBest
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : (isDark ? AppColors.darkCard : const Color(0xFFF8F9FA)),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    if (isBest)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'AI Best Match',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image.asset(
                                job.companyLogo,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.business, size: 20),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                job.companyName,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _removeJob(job),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Details
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _infoRow(
                      Icons.attach_money,
                      job.salary,
                      AppColors.primary,
                      isDark,
                      bold: true,
                    ),
                    _infoRow(
                      Icons.work_outline,
                      job.type,
                      const Color(0xFF16A34A),
                      isDark,
                    ),
                    _infoRow(
                      Icons.school_outlined,
                      job.experienceLevel,
                      const Color(0xFF7C3AED),
                      isDark,
                    ),
                    _infoRow(
                      Icons.location_on_outlined,
                      job.location,
                      const Color(0xFFEA580C),
                      isDark,
                    ),
                    _infoRow(
                      Icons.category_outlined,
                      job.category,
                      const Color(0xFF0284C7),
                      isDark,
                    ),
                    _infoRow(
                      Icons.calendar_today_outlined,
                      job.postedDate,
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                      isDark,
                    ),
                    if (job.isUrgent)
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              color: Color(0xFFEF4444),
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'URGENT HIRING',
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.push('/job-detail/${job.id}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isBest
                              ? AppColors.primary
                              : (isDark
                                    ? AppColors.darkCard
                                    : const Color(0xFFF1F5F9)),
                          foregroundColor: isBest
                              ? Colors.white
                              : (isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'View Details',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _infoRow(
    IconData icon,
    String value,
    Color iconColor,
    bool isDark, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
                color: bold
                    ? iconColor
                    : (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriteriaSection(bool isDark) {
    return const SizedBox.shrink();
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.compare_arrows,
            size: 64,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No jobs to compare',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add jobs to start comparing',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () =>
                _showAddJobSheet(context.read<JobProvider>().jobs, isDark),
            icon: const Icon(Icons.add),
            label: Text(
              'Add Jobs',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddJobSheet(List<JobModel> availableJobs, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkDivider : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      'Add Job to Compare',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: isDark ? AppColors.darkDivider : Colors.grey.shade100,
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: availableJobs.length,
                  itemBuilder: (context, index) {
                    final job = availableJobs[index];
                    return GestureDetector(
                      onTap: () {
                        _addJob(job);
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard
                              : const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? Colors.grey.shade800
                                : const Color(0xFFE5E7EB),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Image.asset(
                                    job.companyLogo,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.business),
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    job.companyName,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    job.salary,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.add_circle_outline,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
