import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/auth_provider.dart';
import 'package:job_finder/providers/job_provider.dart';
import 'package:job_finder/providers/resume_provider.dart';
import 'package:job_finder/providers/theme_provider.dart';

class ApplySuccessScreen extends StatelessWidget {
  final String? jobTitle;
  const ApplySuccessScreen({super.key, this.jobTitle});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    context.watch<JobProvider>();
    final auth = context.read<AuthProvider>();
    final resume = context.read<ResumeProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // ── Green check icon ──
              Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const Icon(
                  Icons.check_circle,
                  size: 110,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 28),

              // ── Successful text ──
              Text(
                'Successful',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // ── Description ──
              Text(
                "You have successfully applied for the job.",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 3),

              // ── View My CV button (primary) ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => context.push(
                    '/cv-preview',
                    extra: {
                      'userName': auth.userName,
                      'userEmail': auth.userEmail,
                      'userPhone': auth.userPhone,
                      'jobTitle': jobTitle,
                      'experiences': resume.experiences
                          .map(
                            (e) => {
                              'title': e.title,
                              'company': e.company,
                              'period': e.period,
                              'description': e.description,
                            },
                          )
                          .toList(),
                      'educations': resume.educations
                          .map(
                            (e) => {
                              'degree': e.degree,
                              'school': e.school,
                              'period': e.period,
                              'field': e.field,
                            },
                          )
                          .toList(),
                      'skills': List<String>.from(resume.skills),
                    },
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.description_outlined, size: 20),
                  label: Text(
                    'View My CV',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ── View Cover Letter button ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/cover-letter-preview'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.article_outlined, size: 20),
                  label: Text(
                    'View Cover Letter',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ── Back Home button (outlined) ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => context.go('/main'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: BorderSide(
                      color: isDark
                          ? AppColors.darkDivider
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    'Back Home',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
