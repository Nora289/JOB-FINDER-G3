import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/theme_provider.dart';

class JobPreferencesScreen extends StatefulWidget {
  const JobPreferencesScreen({super.key});

  @override
  State<JobPreferencesScreen> createState() => _JobPreferencesScreenState();
}

class _JobPreferencesScreenState extends State<JobPreferencesScreen> {
  // Job Roles
  final List<String> _jobRoles = [
    'Product Designer',
    'Motion Designer',
    'UX Designer',
    'Graphics Designer',
    'Full-Stack Developer',
    'Developer',
  ];
  final Set<String> _selectedRoles = {'Motion Designer', 'UX Designer'};

  // Locations
  final List<String> _locations = [
    'All Phnom Penh',
    'Toul Kork',
    'Sen Sok',
    'BKK',
    'Chamkarmon',
    'Russey Keo',
  ];
  final Set<String> _selectedLocations = {'Toul Kork'};

  // Job Type
  final List<String> _jobTypes = ['Any', 'Full-Time', 'Part-Time'];
  String _selectedJobType = 'Any';

  // Office
  final List<String> _officeTypes = ['Any', 'On-Site', 'Remote'];
  String _selectedOfficeType = 'Any';

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Job Preferences',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // ── Select Job Roles ──
            _sectionHeader('Select job Roles', isDark),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _jobRoles.map((role) {
                final selected = _selectedRoles.contains(role);
                return _chip(
                  label: role,
                  selected: selected,
                  isDark: isDark,
                  onTap: () {
                    setState(() {
                      if (selected) {
                        _selectedRoles.remove(role);
                      } else {
                        _selectedRoles.add(role);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // ── Select Location ──
            _sectionHeader('Select Location', isDark),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _locations.map((loc) {
                final selected = _selectedLocations.contains(loc);
                return _chip(
                  label: loc,
                  selected: selected,
                  isDark: isDark,
                  onTap: () {
                    setState(() {
                      if (selected) {
                        _selectedLocations.remove(loc);
                      } else {
                        _selectedLocations.add(loc);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // ── Select Location (Job Type) ──
            _sectionHeader('Job Type', isDark),
            const SizedBox(height: 14),
            Row(
              children: _jobTypes.map((type) {
                final selected = _selectedJobType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _chip(
                    label: type,
                    selected: selected,
                    isDark: isDark,
                    onTap: () => setState(() => _selectedJobType = type),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // ── Office ──
            _sectionHeader('Office', isDark),
            const SizedBox(height: 14),
            Row(
              children: _officeTypes.map((type) {
                final selected = _selectedOfficeType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _chip(
                    label: type,
                    selected: selected,
                    isDark: isDark,
                    onTap: () => setState(() => _selectedOfficeType = type),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),

            // ── Save Button ──
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => context.go('/main'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: AppColors.primary.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Save',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            'See all',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : isDark
              ? AppColors.darkCard
              : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : isDark
                ? AppColors.darkDivider
                : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected
                ? Colors.white
                : isDark
                ? AppColors.darkTextPrimary
                : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
