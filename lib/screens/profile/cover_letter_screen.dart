import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/auth_provider.dart';
import 'package:job_finder/providers/cover_letter_provider.dart';
import 'package:job_finder/providers/theme_provider.dart';

class CoverLetterScreen extends StatefulWidget {
  const CoverLetterScreen({super.key});

  @override
  State<CoverLetterScreen> createState() => _CoverLetterScreenState();
}

class _CoverLetterScreenState extends State<CoverLetterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late TextEditingController _recipientNameCtrl;
  late TextEditingController _companyCtrl;
  late TextEditingController _positionCtrl;
  late TextEditingController _openingCtrl;
  late TextEditingController _bodyCtrl;
  late TextEditingController _closingCtrl;

  static const List<String> _tones = [
    'Professional',
    'Enthusiastic',
    'Formal',
    'Friendly',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final cl = context.read<CoverLetterProvider>();
    _recipientNameCtrl = TextEditingController(
      text: cl.recipientName.isEmpty ? 'Hiring Manager' : cl.recipientName,
    );
    _companyCtrl = TextEditingController(text: cl.company);
    _positionCtrl = TextEditingController(text: cl.position);
    _openingCtrl = TextEditingController(text: cl.opening);
    _bodyCtrl = TextEditingController(text: cl.body);
    _closingCtrl = TextEditingController(text: cl.closing);

    if (cl.generated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tabController.animateTo(1);
      });
    }

    _openingCtrl.addListener(
      () =>
          context.read<CoverLetterProvider>().updateOpening(_openingCtrl.text),
    );
    _bodyCtrl.addListener(
      () => context.read<CoverLetterProvider>().updateBody(_bodyCtrl.text),
    );
    _closingCtrl.addListener(
      () =>
          context.read<CoverLetterProvider>().updateClosing(_closingCtrl.text),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _recipientNameCtrl.dispose();
    _companyCtrl.dispose();
    _positionCtrl.dispose();
    _openingCtrl.dispose();
    _bodyCtrl.dispose();
    _closingCtrl.dispose();
    super.dispose();
  }

  void _generate() {
    final cl = context.read<CoverLetterProvider>();
    cl.setFields(
      recipientName: _recipientNameCtrl.text,
      company: _companyCtrl.text,
      position: _positionCtrl.text,
      tone: cl.tone,
    );
    cl.generate();
    _openingCtrl.text = cl.opening;
    _bodyCtrl.text = cl.body;
    _closingCtrl.text = cl.closing;
    _tabController.animateTo(1);
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Cover letter copied!',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final cl = context.watch<CoverLetterProvider>();
    final auth = context.watch<AuthProvider>();
    final bg = isDark ? AppColors.darkBg : const Color(0xFFF5F7FA);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

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
          'Cover Letter',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          if (cl.generated)
            IconButton(
              icon: const Icon(Icons.copy_outlined, color: AppColors.primary),
              tooltip: 'Copy letter',
              onPressed: () => _copyToClipboard(cl.fullLetter(auth.userName)),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark
              ? AppColors.darkTextHint
              : AppColors.textHint,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'Builder'),
            Tab(text: 'Preview'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BuilderTab(
            isDark: isDark,
            cardBg: cardBg,
            recipientNameCtrl: _recipientNameCtrl,
            companyCtrl: _companyCtrl,
            positionCtrl: _positionCtrl,
            selectedTone: cl.tone,
            tones: _tones,
            onToneChanged: (v) => context.read<CoverLetterProvider>().setFields(
              recipientName: _recipientNameCtrl.text,
              company: _companyCtrl.text,
              position: _positionCtrl.text,
              tone: v!,
            ),
            onGenerate: _generate,
          ),
          _PreviewTab(
            isDark: isDark,
            cardBg: cardBg,
            generated: cl.generated,
            userName: auth.userName,
            userEmail: auth.userEmail,
            userPhone: auth.userPhone,
            openingCtrl: _openingCtrl,
            bodyCtrl: _bodyCtrl,
            closingCtrl: _closingCtrl,
            onCopy: () => _copyToClipboard(cl.fullLetter(auth.userName)),
            onGoBuilder: () => _tabController.animateTo(0),
          ),
        ],
      ),
    );
  }
}

//
// Builder Tab
//
class _BuilderTab extends StatelessWidget {
  final bool isDark;
  final Color cardBg;
  final TextEditingController recipientNameCtrl;
  final TextEditingController companyCtrl;
  final TextEditingController positionCtrl;
  final String selectedTone;
  final List<String> tones;
  final ValueChanged<String?> onToneChanged;
  final VoidCallback onGenerate;

  const _BuilderTab({
    required this.isDark,
    required this.cardBg,
    required this.recipientNameCtrl,
    required this.companyCtrl,
    required this.positionCtrl,
    required this.selectedTone,
    required this.tones,
    required this.onToneChanged,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.description_outlined,
                  color: Colors.white,
                  size: 36,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cover Letter Builder',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Fill in the details below and generate a professional cover letter instantly.',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _card(
            isDark: isDark,
            cardBg: cardBg,
            title: 'Job Details',
            icon: Icons.work_outline,
            child: Column(
              children: [
                _field(
                  ctrl: companyCtrl,
                  label: 'Company Name',
                  hint: 'e.g. ABA Bank',
                  icon: Icons.business_outlined,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _field(
                  ctrl: positionCtrl,
                  label: 'Position Applying For',
                  hint: 'e.g. Flutter Developer',
                  icon: Icons.badge_outlined,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _field(
                  ctrl: recipientNameCtrl,
                  label: 'Recipient Name',
                  hint: 'e.g. Hiring Manager',
                  icon: Icons.person_outline,
                  isDark: isDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _card(
            isDark: isDark,
            cardBg: cardBg,
            title: 'Writing Tone',
            icon: Icons.tune_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose the tone that best fits the company culture',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tones.map((tone) {
                    final selected = tone == selectedTone;
                    return GestureDetector(
                      onTap: () => onToneChanged(tone),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary
                              : isDark
                              ? AppColors.darkCard
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : isDark
                                ? AppColors.darkDivider
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (selected)
                              const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            Text(
                              tone,
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
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: onGenerate,
              icon: const Icon(Icons.auto_awesome, size: 20),
              label: Text(
                'Generate Cover Letter',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
// Preview Tab
//
class _PreviewTab extends StatelessWidget {
  final bool isDark;
  final Color cardBg;
  final bool generated;
  final String userName;
  final String userEmail;
  final String userPhone;
  final TextEditingController openingCtrl;
  final TextEditingController bodyCtrl;
  final TextEditingController closingCtrl;
  final VoidCallback onCopy;
  final VoidCallback onGoBuilder;

  const _PreviewTab({
    required this.isDark,
    required this.cardBg,
    required this.generated,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.openingCtrl,
    required this.bodyCtrl,
    required this.closingCtrl,
    required this.onCopy,
    required this.onGoBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (!generated) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.description_outlined,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'No Cover Letter Yet',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Go to the Builder tab, fill in your details and tap "Generate Cover Letter".',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onGoBuilder,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text(
                  'Go to Builder',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Theme(
            data: ThemeData.light().copyWith(
              inputDecorationTheme: const InputDecorationTheme(
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            child: _letterCard(
              userName,
              userEmail,
              userPhone,
              openingCtrl,
              bodyCtrl,
              closingCtrl,
            ),
          ),
          const SizedBox(height: 16),
          _tipCard(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onGoBuilder,
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: Text(
                    'Edit Details',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy_outlined, size: 16),
                  label: Text(
                    'Copy Letter',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//
// Shared letter card widget (reused in preview screen too)
//
Widget _letterCard(
  String userName,
  String userEmail,
  String userPhone,
  TextEditingController openingCtrl,
  TextEditingController bodyCtrl,
  TextEditingController closingCtrl,
) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          color: const Color(0xFF1B2A4A),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      userEmail.isNotEmpty ? userEmail : 'user@email.com',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: const Color(0xFF7EAADC),
                      ),
                    ),
                    if (userPhone.isNotEmpty)
                      Text(
                        userPhone,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: const Color(0xFF7EAADC),
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(
                Icons.description_outlined,
                color: Colors.white30,
                size: 30,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatDate(),
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: const Color(0xFF888888),
                ),
              ),
              const SizedBox(height: 16),
              _editableSection(
                ctrl: openingCtrl,
                minLines: 1,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1B2A4A),
                ),
              ),
              const SizedBox(height: 14),
              _editableSection(
                ctrl: bodyCtrl,
                minLines: 8,
                style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  color: const Color(0xFF444444),
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 14),
              _editableSection(
                ctrl: closingCtrl,
                minLines: 1,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF444444),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                userName,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1B2A4A),
                ),
              ),
              const SizedBox(height: 4),
              Container(height: 2, width: 60, color: AppColors.primary),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _tipCard() {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
    ),
    child: Row(
      children: [
        const Icon(Icons.lightbulb_outline, color: AppColors.primary, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Tip: Tap any text in the letter above to edit it directly before copying.',
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              color: AppColors.primary,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _editableSection({
  required TextEditingController ctrl,
  required int minLines,
  required TextStyle style,
}) {
  return TextField(
    controller: ctrl,
    minLines: minLines,
    maxLines: null,
    style: style,
    decoration: const InputDecoration(
      border: InputBorder.none,
      isDense: true,
      contentPadding: EdgeInsets.zero,
      filled: true,
      fillColor: Colors.white,
    ),
  );
}

String _formatDate() {
  final now = DateTime.now();
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[now.month - 1]} ${now.day}, ${now.year}';
}

Widget _card({
  required bool isDark,
  required Color cardBg,
  required String title,
  required IconData icon,
  required Widget child,
}) {
  return Container(
    decoration: BoxDecoration(
      color: cardBg,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: isDark ? AppColors.darkDivider : Colors.grey.shade100,
        ),
        Padding(padding: const EdgeInsets.all(16), child: child),
      ],
    ),
  );
}

Widget _field({
  required TextEditingController ctrl,
  required String label,
  required String hint,
  required IconData icon,
  required bool isDark,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
      ),
      const SizedBox(height: 5),
      TextField(
        controller: ctrl,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            fontSize: 13,
            color: isDark ? AppColors.darkTextHint : AppColors.textHint,
          ),
          prefixIcon: Icon(
            icon,
            size: 18,
            color: isDark ? AppColors.darkTextHint : AppColors.textHint,
          ),
          filled: true,
          fillColor: isDark ? AppColors.darkCard : Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkDivider : AppColors.divider,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkDivider : AppColors.divider,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
        ),
      ),
    ],
  );
}
