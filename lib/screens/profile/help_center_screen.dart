import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/theme_provider.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  int? _expandedIndex;

  static const List<Map<String, String>> _faqs = [
    {
      'q': 'How do I apply for a job?',
      'a':
          'Browse jobs on the Home screen, tap a job card to view details, then press "Apply Now". Fill in the application form and submit. You can track your applications under Profile → My Applications.',
    },
    {
      'q': 'How do I save a job?',
      'a':
          'Tap the bookmark icon on any job card or on the job detail page to save it. Saved jobs are accessible from Profile → Saved Jobs or the Saved tab at the bottom.',
    },
    {
      'q': 'How do I update my profile?',
      'a':
          'Go to the Profile tab and tap "Edit Profile". You can update your name, email, phone number, and profile picture from there.',
    },
    {
      'q': 'How do I upload my CV / Resume?',
      'a':
          'Go to Profile → My Resume. Tap the upload area to select your PDF file (max 5MB). Once uploaded, you can view it using the eye icon.',
    },
    {
      'q': 'How do I message a company?',
      'a':
          'Tap the Messages icon at the bottom navigation bar to open your chat list. You can view and reply to messages from recruiters and companies.',
    },
    {
      'q': 'Can I switch between dark mode and light mode?',
      'a':
          'Yes! Go to Profile and toggle the "Dark Mode" switch. The change applies immediately across the entire app.',
    },
    {
      'q': 'How do I search for specific jobs?',
      'a':
          'Use the search bar on the Home screen or tap the Search icon. You can filter by job title, company name, or location.',
    },
    {
      'q': 'How do I view a company profile?',
      'a':
          'On any job detail page, scroll down to the company section and tap "View company profile" to see all open positions and company info.',
    },
    {
      'q': 'How do I see the company\'s location?',
      'a':
          'On the job detail page, tap the Location card (it has a blue border and "View on map →" text). This opens the company\'s location page with address and map details.',
    },
    {
      'q': 'What should I do if I find a bug?',
      'a':
          'Please contact our support team at support@jobfinder.com.kh or reach out through the in-app chat. We appreciate your feedback!',
    },
  ];

  List<Map<String, String>> get _filtered {
    if (_query.isEmpty) return _faqs;
    return _faqs
        .where((f) =>
            f['q']!.toLowerCase().contains(_query.toLowerCase()) ||
            f['a']!.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color:
                  isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help Center',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Header banner ────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.support_agent,
                      color: AppColors.primary, size: 32),
                ),
                const SizedBox(height: 10),
                Text(
                  'How can we help you?',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkCard
                        : const Color(0xFFF0F4F8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() {
                      _query = v;
                      _expandedIndex = null;
                    }),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search questions...',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkTextHint
                            : AppColors.textHint,
                      ),
                      prefixIcon: Icon(Icons.search,
                          color: isDark
                              ? AppColors.darkTextHint
                              : AppColors.textHint),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear,
                                  size: 18,
                                  color: isDark
                                      ? AppColors.darkTextHint
                                      : AppColors.textHint),
                              onPressed: () => setState(() {
                                _query = '';
                                _searchController.clear();
                              }),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── FAQ List ─────────────────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'No results found',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkTextHint
                            : AppColors.textHint,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length + 1,
                    itemBuilder: (context, i) {
                      if (i == filtered.length) {
                        return _contactCard(isDark);
                      }
                      final faq = filtered[i];
                      final isExpanded = _expandedIndex == i;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _FaqTile(
                          question: faq['q']!,
                          answer: faq['a']!,
                          isExpanded: isExpanded,
                          isDark: isDark,
                          onTap: () => setState(() =>
                              _expandedIndex = isExpanded ? null : i),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _contactCard(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(Icons.mail_outline,
              color: AppColors.primary, size: 28),
          const SizedBox(height: 8),
          Text(
            'Still need help?',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Contact us at support@jobfinder.com.kh',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final bool isDark;
  final VoidCallback onTap;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.help_outline,
                        color: AppColors.primary, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      question,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color:
                        isDark ? AppColors.darkTextHint : AppColors.textHint,
                  ),
                ],
              ),
            ),
            if (isExpanded)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? AppColors.darkDivider
                          : AppColors.divider,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    answer,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
