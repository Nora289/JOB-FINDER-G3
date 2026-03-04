import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/auth_provider.dart';
import 'package:job_finder/providers/job_provider.dart';
import 'package:job_finder/providers/theme_provider.dart';
import 'package:job_finder/widgets/user_avatar.dart';
import 'package:job_finder/l10n/app_localizations.dart';

class JobApplyScreen extends StatefulWidget {
  final String jobId;

  const JobApplyScreen({super.key, required this.jobId});

  @override
  State<JobApplyScreen> createState() => _JobApplyScreenState();
}

class _JobApplyScreenState extends State<JobApplyScreen> {
  final _messageController = TextEditingController();
  int _selectedProfileIndex = 0;
  int _selectedResumeIndex = 0;
  bool _isSubmitting = false;

  // CV Source: 0 = Use App CV (Case 1), 1 = Upload from Phone (Case 2)
  int _cvSourceIndex = 0;
  String? _uploadedCVFileName;
  String? _uploadedCoverLetterFileName;

  final List<Map<String, String>> _profiles = [
    {'name': 'Chem Bunjok', 'subtitle': 'job finder'},
    {'name': 'Slv Chanbormey', 'subtitle': 'job finder'},
  ];

  final List<String> _resumes = ['Chem Bunjok'];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.userName.isNotEmpty && _profiles.isNotEmpty) {
      _profiles[0]['name'] = auth.userName;
      _resumes[0] = auth.userName;
    }

    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
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
          context.tr('apply_now'),
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // ── Select a profile ──
            Text(
              context.tr('personal_info'),
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(_profiles.length, (index) {
                final profile = _profiles[index];
                final isSelected = _selectedProfileIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedProfileIndex = index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            UserAvatar(
                              name: profile['name']!,
                              radius: 30,
                              fontSize: 16,
                            ),
                            if (isSelected)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          profile['name']!,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          profile['subtitle']!,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.darkTextHint
                                : AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),

            // ── CV Source Toggle ──
            Text(
              context.tr('upload_resume'),
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // Toggle row: Use App CV / Upload from Phone
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  _cvToggleTab(
                    index: 0,
                    icon: Icons.description_outlined,
                    label: context.tr('my_resume'),
                    isDark: isDark,
                  ),
                  _cvToggleTab(
                    index: 1,
                    icon: Icons.upload_file_outlined,
                    label: context.tr('upload_resume'),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Case 1: App-generated CV (existing resume selector)
            if (_cvSourceIndex == 0) ..._buildAppCVSection(isDark),

            // Case 2: Upload from phone
            if (_cvSourceIndex == 1) ..._buildUploadSection(isDark),

            const SizedBox(height: 28),

            // ── Leave Your Message (Optional) ──
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Leave Your Message  ',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: '(Optional)',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? AppColors.darkTextHint
                          : AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _messageController,
              maxLines: 5,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Dear Hiring Manager,.....',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                ),
                filled: true,
                fillColor: isDark ? AppColors.darkCard : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkDivider
                        : Colors.grey.shade300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.darkDivider
                        : Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 32),

            // ── Apply Now button ──
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isSubmitting
                    ? null
                    : () {
                        setState(() => _isSubmitting = true);
                        final jobProvider = context.read<JobProvider>();
                        jobProvider.applyJob(widget.jobId);
                        final job = jobProvider.jobs.firstWhere(
                          (j) => j.id == widget.jobId,
                          orElse: () => jobProvider.jobs.first,
                        );
                        final router = GoRouter.of(context);
                        Future.delayed(const Duration(seconds: 1), () {
                          if (!mounted) return;
                          router.go(
                            '/apply-success',
                            extra: {'jobTitle': job.title},
                          );
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        context.tr('apply_now'),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
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

  // ── Toggle tab widget ──
  Widget _cvToggleTab({
    required int index,
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    final isSelected = _cvSourceIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _cvSourceIndex = index;
          _uploadedCVFileName = null;
          _uploadedCoverLetterFileName = null;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Case 1: App-generated CV section ──
  List<Widget> _buildAppCVSection(bool isDark) {
    return [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : const Color(0xFFF0F9FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkDivider : const Color(0xFFBAE6FD),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.description_outlined,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _resumes[_selectedResumeIndex],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Auto-generated CV from your profile',
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Ready',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  // ── Case 2: Upload from phone section ──
  List<Widget> _buildUploadSection(bool isDark) {
    return [
      // Upload CV
      _uploadFileButton(
        label: 'Upload CV / Resume',
        subtitle: 'PDF, DOC, DOCX (max 10MB)',
        icon: Icons.picture_as_pdf_outlined,
        iconColor: const Color(0xFFDC2626),
        fileName: _uploadedCVFileName,
        isDark: isDark,
        onTap: () async {
          final result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'doc', 'docx'],
          );
          if (result != null && result.files.isNotEmpty) {
            setState(() {
              _uploadedCVFileName = result.files.first.name;
            });
          }
        },
      ),
      const SizedBox(height: 12),
      // Upload Cover Letter
      _uploadFileButton(
        label: 'Upload Cover Letter',
        subtitle: 'PDF, DOC, DOCX (Optional)',
        icon: Icons.article_outlined,
        iconColor: const Color(0xFF7C3AED),
        fileName: _uploadedCoverLetterFileName,
        isDark: isDark,
        onTap: () async {
          final result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'doc', 'docx'],
          );
          if (result != null && result.files.isNotEmpty) {
            setState(() {
              _uploadedCoverLetterFileName = result.files.first.name;
            });
          }
        },
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          const Icon(Icons.info_outline, size: 13, color: Color(0xFF64748B)),
          const SizedBox(width: 6),
          Text(
            'Files from Google Drive, phone storage, or any app',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    ];
  }

  Widget _uploadFileButton({
    required String label,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required String? fileName,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final isUploaded = fileName != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUploaded
              ? AppColors.success.withValues(alpha: 0.06)
              : isDark
              ? AppColors.darkCard
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUploaded
                ? AppColors.success
                : isDark
                ? AppColors.darkDivider
                : Colors.grey.shade300,
            width: isUploaded ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isUploaded
                    ? AppColors.success.withValues(alpha: 0.1)
                    : iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isUploaded ? Icons.check_circle_outline : icon,
                color: isUploaded ? AppColors.success : iconColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isUploaded ? fileName : label,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isUploaded
                          ? AppColors.success
                          : isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    isUploaded ? 'Uploaded successfully ✓' : subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: isUploaded
                          ? AppColors.success
                          : isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isUploaded ? Icons.edit_outlined : Icons.upload_outlined,
              size: 18,
              color: isUploaded
                  ? AppColors.success
                  : isDark
                  ? AppColors.darkTextSecondary
                  : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
