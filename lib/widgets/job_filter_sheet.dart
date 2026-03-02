import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/job_provider.dart';
import 'package:job_finder/providers/theme_provider.dart';

/// Call this from any screen to show the filter bottom sheet.
Future<void> showJobFilterSheet(BuildContext context) {
  // Pass the outer context so the sheet can access Provider
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetCtx) => ChangeNotifierProvider.value(
      value: Provider.of<JobProvider>(context, listen: false),
      child: ChangeNotifierProvider.value(
        value: Provider.of<ThemeProvider>(context, listen: false),
        child: const _JobFilterSheet(),
      ),
    ),
  );
}

class _JobFilterSheet extends StatefulWidget {
  const _JobFilterSheet();

  @override
  State<_JobFilterSheet> createState() => _JobFilterSheetState();
}

class _JobFilterSheetState extends State<_JobFilterSheet> {
  late String _category;
  late String _type;
  late String _experience;
  late String _location;
  late String _sort;
  late double _salaryMin;
  late double _salaryMax;

  @override
  void initState() {
    super.initState();
    final jp = context.read<JobProvider>();
    _category = jp.filterCategory;
    _type = jp.filterType;
    _experience = jp.filterExperience;
    _location = jp.filterLocation;
    _sort = jp.sortBy;
    _salaryMin = jp.filterSalaryMin;
    _salaryMax = jp.filterSalaryMax;
  }

  void _apply() {
    context.read<JobProvider>().setFilters(
      category: _category,
      type: _type,
      experience: _experience,
      location: _location,
      sort: _sort,
      salaryMin: _salaryMin,
      salaryMax: _salaryMax,
    );
    Navigator.pop(context);
    context.push('/filtered-jobs');
  }

  void _reset() {
    setState(() {
      _category = 'All';
      _type = 'All';
      _experience = 'All';
      _location = 'All';
      _sort = 'Newest';
      _salaryMin = 0;
      _salaryMax = 5000;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final jp = context.watch<JobProvider>();
    final bg = isDark ? AppColors.darkSurface : Colors.white;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final categories = ['All', ...jp.categories];
    final types = ['All', ...JobProvider.jobTypes];
    final levels = ['All', ...JobProvider.experienceLevels];
    final locations = ['All', ...jp.locations];
    final sorts = JobProvider.sortOptions;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkDivider : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Text(
                      'Filter & Sort',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _reset,
                      child: Text(
                        'Reset',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: isDark ? AppColors.darkDivider : Colors.grey.shade100,
              ),
              // Body
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Sort By
                    _sectionTitle('Sort By', textPrimary),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: sorts.map((s) {
                        final sel = _sort == s;
                        return _FilterChip(
                          label: s,
                          selected: sel,
                          isDark: isDark,
                          onTap: () => setState(() => _sort = s),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 22),

                    // Job Type
                    _sectionTitle('Job Type', textPrimary),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: types.map((t) {
                        final sel = _type == t;
                        return _FilterChip(
                          label: t,
                          selected: sel,
                          isDark: isDark,
                          onTap: () => setState(() => _type = t),
                          icon: _typeIcon(t),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 22),

                    // Experience Level
                    _sectionTitle('Experience Level', textPrimary),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: levels.map((l) {
                        final sel = _experience == l;
                        return _FilterChip(
                          label: l,
                          selected: sel,
                          isDark: isDark,
                          onTap: () => setState(() => _experience = l),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 22),

                    // Category
                    _sectionTitle('Category', textPrimary),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.map((c) {
                        final sel = _category == c;
                        return _FilterChip(
                          label: c,
                          selected: sel,
                          isDark: isDark,
                          onTap: () => setState(() => _category = c),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 22),

                    // Location
                    _sectionTitle('Location', textPrimary),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: locations.map((loc) {
                        final sel = _location == loc;
                        return _FilterChip(
                          label: loc,
                          selected: sel,
                          isDark: isDark,
                          onTap: () => setState(() => _location = loc),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 22),

                    // Salary Range
                    _sectionTitle('Salary Range (\$)', textPrimary),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${_salaryMin.toInt()}',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          _salaryMax >= 5000
                              ? '\$5000+'
                              : '\$${_salaryMax.toInt()}',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: RangeValues(_salaryMin, _salaryMax),
                      min: 0,
                      max: 5000,
                      divisions: 50,
                      activeColor: AppColors.primary,
                      inactiveColor: isDark
                          ? AppColors.darkDivider
                          : Colors.grey.shade200,
                      onChanged: (vals) => setState(() {
                        _salaryMin = vals.start;
                        _salaryMax = vals.end;
                      }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Entry level',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.darkTextHint
                                : AppColors.textHint,
                          ),
                        ),
                        Text(
                          'Senior level',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.darkTextHint
                                : AppColors.textHint,
                          ),
                        ),
                      ],
                    ),

                    // Live result count
                    const SizedBox(height: 16),
                    _LiveCount(
                      category: _category,
                      type: _type,
                      experience: _experience,
                      location: _location,
                      isDark: isDark,
                    ),

                    // Active filter summary
                    if (_category != 'All' ||
                        _type != 'All' ||
                        _experience != 'All' ||
                        _location != 'All') ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.filter_list,
                              color: AppColors.primary,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _filterSummary(),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              // Apply button
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                decoration: BoxDecoration(
                  color: bg,
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? AppColors.darkDivider
                          : Colors.grey.shade100,
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: _ApplyButton(
                    onPressed: _apply,
                    category: _category,
                    type: _type,
                    experience: _experience,
                    location: _location,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String text, Color color) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  IconData? _typeIcon(String type) {
    switch (type) {
      case 'Full-time':
        return Icons.work_outline;
      case 'Part-time':
        return Icons.access_time;
      case 'Remote':
        return Icons.home_work_outlined;
      case 'Internship':
        return Icons.school_outlined;
      default:
        return null;
    }
  }

  String _filterSummary() {
    final parts = <String>[];
    if (_category != 'All') parts.add(_category);
    if (_type != 'All') parts.add(_type);
    if (_experience != 'All') parts.add('$_experience level');
    if (_location != 'All') parts.add(_location);
    return 'Filtering by: ${parts.join(' · ')}';
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;
  final IconData? icon;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.isDark,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: icon != null ? 12 : 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : (isDark ? AppColors.darkCard : const Color(0xFFF5F7FA)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : (isDark ? AppColors.darkDivider : Colors.grey.shade200),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: selected
                    ? Colors.white
                    : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected
                    ? Colors.white
                    : (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Live matched-job count widget ─────────────────────────────────────────
class _LiveCount extends StatelessWidget {
  final String category;
  final String type;
  final String experience;
  final String location;
  final bool isDark;

  const _LiveCount({
    required this.category,
    required this.type,
    required this.experience,
    required this.location,
    required this.isDark,
  });

  int _count(List jobs) {
    var result = List.from(jobs);
    if (category != 'All') {
      result = result.where((j) => j.category == category).toList();
    }
    if (type != 'All') {
      result = result.where((j) => j.type == type).toList();
    }
    if (experience != 'All') {
      result = result.where((j) => j.experienceLevel == experience).toList();
    }
    if (location != 'All') {
      result = result.where((j) => j.location.contains(location)).toList();
    }
    return result.length;
  }

  @override
  Widget build(BuildContext context) {
    final jp = context.watch<JobProvider>();
    final count = _count(jp.jobs);
    final hasFilter =
        category != 'All' ||
        type != 'All' ||
        experience != 'All' ||
        location != 'All';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: hasFilter
            ? AppColors.primary.withValues(alpha: 0.08)
            : (isDark ? AppColors.darkCard : const Color(0xFFF5F7FA)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasFilter
              ? AppColors.primary.withValues(alpha: 0.25)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.work_outline,
            size: 16,
            color: hasFilter
                ? AppColors.primary
                : (isDark ? AppColors.darkTextHint : AppColors.textHint),
          ),
          const SizedBox(width: 8),
          Text(
            hasFilter
                ? '$count job${count == 1 ? '' : 's'} match your filters'
                : '${jp.jobs.length} total jobs available',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: hasFilter
                  ? AppColors.primary
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary),
            ),
          ),
          const Spacer(),
          if (hasFilter)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Apply button with live count ──────────────────────────────────────────
class _ApplyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String category;
  final String type;
  final String experience;
  final String location;

  const _ApplyButton({
    required this.onPressed,
    required this.category,
    required this.type,
    required this.experience,
    required this.location,
  });

  int _count(List jobs) {
    var result = List.from(jobs);
    if (category != 'All') {
      result = result.where((j) => j.category == category).toList();
    }
    if (type != 'All') {
      result = result.where((j) => j.type == type).toList();
    }
    if (experience != 'All') {
      result = result.where((j) => j.experienceLevel == experience).toList();
    }
    if (location != 'All') {
      result = result.where((j) => j.location.contains(location)).toList();
    }
    return result.length;
  }

  @override
  Widget build(BuildContext context) {
    final jp = context.watch<JobProvider>();
    final count = _count(jp.jobs);
    final hasFilter =
        category != 'All' ||
        type != 'All' ||
        experience != 'All' ||
        location != 'All';

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          hasFilter
              ? 'Show $count Job${count == 1 ? '' : 's'}'
              : 'Apply Filters',
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
