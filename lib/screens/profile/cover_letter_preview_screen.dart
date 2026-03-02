import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/auth_provider.dart';
import 'package:job_finder/providers/cover_letter_provider.dart';
import 'package:job_finder/providers/theme_provider.dart';

class CoverLetterPreviewScreen extends StatelessWidget {
  const CoverLetterPreviewScreen({super.key});

  String _formatDate() {
    final now = DateTime.now();
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cover letter copied!',
            style: GoogleFonts.poppins(fontSize: 13)),
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
    final bg = isDark ? AppColors.darkBg : const Color(0xFFEEF0F3);
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              size: 20,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Cover Letter',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            )),
        centerTitle: true,
        actions: [
          if (cl.generated)
            IconButton(
              icon: const Icon(Icons.copy_outlined, color: AppColors.primary),
              tooltip: 'Copy letter',
              onPressed: () =>
                  _copyToClipboard(context, cl.fullLetter(auth.userName)),
            ),
        ],
      ),
      body: cl.generated
          ? _buildGeneratedView(context, cl, auth, isDark)
          : _buildEmptyView(context, isDark),
    );
  }

  Widget _buildGeneratedView(BuildContext context, CoverLetterProvider cl,
      AuthProvider auth, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ── Letter document ──────────────────────────────
          Container(
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
                // Header strip
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
                              auth.userName.toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              auth.userEmail.isNotEmpty
                                  ? auth.userEmail
                                  : 'user@email.com',
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: const Color(0xFF7EAADC)),
                            ),
                            if (auth.userPhone.isNotEmpty)
                              Text(
                                auth.userPhone,
                                style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: const Color(0xFF7EAADC)),
                              ),
                          ],
                        ),
                      ),
                      const Icon(Icons.article_outlined,
                          color: Colors.white30, size: 30),
                    ],
                  ),
                ),

                // Body
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(),
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: const Color(0xFF888888)),
                      ),
                      const SizedBox(height: 16),
                      // Tone badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${cl.tone} tone  •  ${cl.company.isNotEmpty ? cl.company : "Company"}',
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        cl.opening,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1B2A4A),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        cl.body,
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          color: const Color(0xFF444444),
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        cl.closing,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF444444),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        auth.userName,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1B2A4A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                          height: 2, width: 60, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Tip card ────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Want to edit this letter? Tap "Edit in Builder" below.',
                    style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        color: AppColors.primary,
                        height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Action buttons ───────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/cover-letter'),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: Text('Edit in Builder',
                      style: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _copyToClipboard(
                      context, cl.fullLetter(auth.userName)),
                  icon: const Icon(Icons.copy_outlined, size: 16),
                  label: Text('Copy Letter',
                      style: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle),
              child: const Icon(Icons.description_outlined,
                  size: 44, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            Text('No Cover Letter Generated',
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary)),
            const SizedBox(height: 10),
            Text(
              'Build your cover letter first by going to the Cover Letter Builder.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                  height: 1.6),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => context.push('/cover-letter'),
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: Text('Create Cover Letter',
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
