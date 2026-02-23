import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_finder/config/theme.dart';

class ResumeScreen extends StatelessWidget {
  const ResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Resume & Portfolio',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Edit',
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/profile.JPG'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Sokha Chan',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Flutter Developer',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Phnom Penh, Cambodia',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // About
            _sectionTitle('About Me'),
            const SizedBox(height: 8),
            Text(
              'Passionate Flutter developer with 3+ years of experience building cross-platform mobile applications. Strong background in Dart, state management, and UI/UX implementation.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            // Skills
            _sectionTitle('Skills'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _skillChip('Flutter'),
                _skillChip('Dart'),
                _skillChip('Firebase'),
                _skillChip('REST API'),
                _skillChip('Git'),
                _skillChip('UI/UX'),
                _skillChip('Provider'),
                _skillChip('Bloc'),
                _skillChip('Agile'),
              ],
            ),
            const SizedBox(height: 24),
            // Experience
            _sectionTitle('Experience'),
            const SizedBox(height: 12),
            _experienceCard(
              title: 'Flutter Developer',
              company: 'Tech Company',
              period: 'Jan 2023 - Present',
              description:
                  'Developing and maintaining mobile applications using Flutter framework.',
            ),
            const SizedBox(height: 12),
            _experienceCard(
              title: 'Junior Developer',
              company: 'Startup Inc.',
              period: 'Jun 2021 - Dec 2022',
              description:
                  'Built mobile apps and contributed to backend API development.',
            ),
            const SizedBox(height: 24),
            // Education
            _sectionTitle('Education'),
            const SizedBox(height: 12),
            _experienceCard(
              title: 'Bachelor of Computer Science',
              company: 'Royal University of Phnom Penh',
              period: '2018 - 2022',
              description: 'Major in Software Engineering',
            ),
            const SizedBox(height: 24),
            // Resume file
            _sectionTitle('Resume File'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sokha_Chan_Resume.pdf',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '245 KB • Updated 2 days ago',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.download_outlined,
                      color: AppColors.primary,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _skillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        skill,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _experienceCard({
    required String title,
    required String company,
    required String period,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.business,
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
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  company,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  period,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
