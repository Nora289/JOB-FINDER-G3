import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/models/job_model.dart';
import 'package:job_finder/providers/theme_provider.dart';
import 'package:job_finder/providers/job_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';
  final List<String> _recentSearches = [];

  static const _popularRoles = [
    'designer',
    'Administrate',
    'NGO',
    'Manager',
    'Managememt',
    'IT',
    'Marketing',
    'Developer',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() => _query = value);
  }

  void _submitSearch(String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    _searchController.text = q;
    setState(() {
      _recentSearches.remove(q);
      _recentSearches.insert(0, q);
      _query = q;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final jobProvider = context.watch<JobProvider>();

    final List<JobModel> results = _query.trim().isNotEmpty
        ? jobProvider.jobs
              .where(
                (j) =>
                    j.title.toLowerCase().contains(_query.toLowerCase()) ||
                    j.companyName.toLowerCase().contains(
                      _query.toLowerCase(),
                    ) ||
                    j.location.toLowerCase().contains(_query.toLowerCase()) ||
                    j.type.toLowerCase().contains(_query.toLowerCase()),
              )
              .toList()
        : [];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      size: 24,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Search field ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkDivider
                              : AppColors.divider,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: _onChanged,
                        onSubmitted: _submitSearch,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search or position',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.darkTextHint
                                : AppColors.textHint,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: isDark
                                ? AppColors.darkTextHint
                                : AppColors.textHint,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkDivider
                            : AppColors.divider,
                      ),
                    ),
                    child: Icon(Icons.tune, color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Body ──
            Expanded(
              child: _query.trim().isNotEmpty
                  ? _buildResults(results, isDark)
                  : _buildSuggestions(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(bool isDark) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Recent searches
        Text(
          'Recent Searches',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        if (_recentSearches.isEmpty)
          Text(
            'You don\'t have any search history',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isDark ? AppColors.darkTextHint : AppColors.textHint,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches
                .map((s) => _chip(s, isDark, isRecent: true))
                .toList(),
          ),
        const SizedBox(height: 20),

        // Popular roles
        Text(
          'Popular Roles',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _popularRoles
              .map((r) => _chip(r, isDark, isRecent: false))
              .toList(),
        ),
      ],
    );
  }

  Widget _chip(String label, bool isDark, {required bool isRecent}) {
    return GestureDetector(
      onTap: () {
        _searchController.text = label;
        _submitSearch(label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.darkDivider : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildResults(List<JobModel> results, bool isDark) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 60,
              color: isDark ? AppColors.darkTextHint : AppColors.textHint,
            ),
            const SizedBox(height: 12),
            Text(
              'No jobs found for "$_query"',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            '${results.length} result${results.length == 1 ? '' : 's'} found',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: results.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: isDark ? AppColors.darkDivider : AppColors.divider,
            ),
            itemBuilder: (context, index) {
              final JobModel job = results[index];
              return InkWell(
                onTap: () {
                  _submitSearch(job.title);
                  context.push('/job-detail/${job.id}');
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      // Company logo
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Image.asset(
                              job.companyLogo,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.business,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Job info
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
                            const SizedBox(height: 4),
                            // Type chip
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                job.type,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Salary
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
              );
            },
          ),
        ),
      ],
    );
  }
}
