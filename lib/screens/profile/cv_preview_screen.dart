import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/auth_provider.dart';
import 'package:job_finder/providers/theme_provider.dart';

class CvPreviewScreen extends StatelessWidget {
  final Map<String, dynamic>? data;
  const CvPreviewScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final auth = context.watch<AuthProvider>();

    final name = (data?['userName'] as String?)?.isNotEmpty == true
        ? data!['userName'] as String
        : (auth.userName.isNotEmpty ? auth.userName : 'User');
    final email = (data?['userEmail'] as String?)?.isNotEmpty == true
        ? data!['userEmail'] as String
        : auth.userEmail;
    final phone = (data?['userPhone'] as String?)?.isNotEmpty == true
        ? data!['userPhone'] as String
        : auth.userPhone;

    final rawExp = data?['experiences'] as List? ?? [];
    final experiences = rawExp.map((e) => e as Map<String, dynamic>).toList();

    final rawEdu = data?['educations'] as List? ?? [];
    final educations = rawEdu.map((e) => e as Map<String, dynamic>).toList();

    final skills =
        (data?['skills'] as List?)?.map((s) => s as String).toList() ??
        ['Flutter', 'Dart', 'Firebase', 'REST API', 'Git', 'UI/UX', 'Figma'];

    // Use job title from data (applied job) if available, otherwise use experience
    final jobTitle = (data?['jobTitle'] as String?)?.isNotEmpty == true
        ? data!['jobTitle'] as String
        : (experiences.isNotEmpty
              ? (experiences.first['title'] as String? ?? 'Developer')
              : 'Developer');

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFEEF0F3),
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
          'CV Preview',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.download_outlined, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'CV downloaded!',
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _CvHeader(name: name, jobTitle: jobTitle),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 130,
                      child: _CvSidebar(
                        email: email,
                        phone: phone,
                        skills: skills,
                      ),
                    ),
                    Expanded(
                      child: _CvMainContent(
                        experiences: experiences,
                        educations: educations,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────

/// Maps normalised name keywords → asset path for team members.
String? _memberPhoto(String name) {
  final n = name.toLowerCase().replaceAll(RegExp(r'\s+'), '');
  if (n.contains('soknora') || n.contains('nora')) {
    return 'assets/images/Sok nora.JPG';
  }
  if (n.contains('sruochsrean') || n.contains('srean')) {
    return 'assets/images/Sruoch Srean.jpg';
  }
  if (n.contains('unpheasa') || n.contains('pheasa')) {
    return 'assets/images/Un pheasa.jpg';
  }
  if (n.contains('yornsomnang') || n.contains('somnang')) {
    return 'assets/images/Yorn Somnang.jpg';
  }
  if (n.contains('pansothea') || n.contains('sothea')) {
    return 'assets/images/Pan Sothea.jpg';
  }
  return null;
}

class _CvHeader extends StatelessWidget {
  final String name;
  final String jobTitle;
  const _CvHeader({required this.name, required this.jobTitle});

  @override
  Widget build(BuildContext context) {
    final displayName = name.trim().toUpperCase(); // keeps spaces: "SOK NORA"
    final photoAsset = _memberPhoto(name);

    return Container(
      color: const Color(0xFF1B2A4A),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Row(
        children: [
          // Avatar — real photo or fallback
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2E4070),
              border: Border.all(color: Colors.white30, width: 2),
            ),
            clipBehavior: Clip.antiAlias,
            child: photoAsset != null
                ? Image.asset(
                    photoAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _InitialAvatar(name: name),
                  )
                : _InitialAvatar(name: name),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  jobTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: const Color(0xFF7EAADC),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4,
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

/// Fallback avatar: shows first initial letter in a circle.
class _InitialAvatar extends StatelessWidget {
  final String name;
  const _InitialAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    return Container(
      color: const Color(0xFF2E4070),
      child: Center(
        child: Text(
          initial,
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Left Sidebar
// ─────────────────────────────────────────────────────────────
class _CvSidebar extends StatelessWidget {
  final String email;
  final String phone;
  final List<String> skills;

  const _CvSidebar({
    required this.email,
    required this.phone,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1B2A4A),
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CONTACTS
          _SidebarSection(title: 'CONTACTS'),
          const SizedBox(height: 8),
          _SidebarContactRow(
            icon: Icons.phone_outlined,
            text: phone.isNotEmpty ? phone : '+855 12 345 678',
          ),
          const SizedBox(height: 6),
          _SidebarContactRow(
            icon: Icons.email_outlined,
            text: email.isNotEmpty ? email : 'user@gmail.com',
          ),
          const SizedBox(height: 6),
          _SidebarContactRow(
            icon: Icons.location_on_outlined,
            text: 'Phnom Penh, Cambodia',
          ),
          const SizedBox(height: 6),
          _SidebarContactRow(
            icon: Icons.language_outlined,
            text: 'github.com/username',
          ),
          const SizedBox(height: 20),

          // SKILLS
          _SidebarSection(title: 'SKILLS'),
          const SizedBox(height: 8),
          ...skills.map((s) => _SidebarSkillRow(skill: s)),
          const SizedBox(height: 20),

          // LANGUAGE
          _SidebarSection(title: 'LANGUAGE'),
          const SizedBox(height: 8),
          _SidebarLangRow(lang: 'Khmer', level: 1.0),
          const SizedBox(height: 6),
          _SidebarLangRow(lang: 'English', level: 0.8),
          const SizedBox(height: 20),

          // PORTFOLIO
          _SidebarSection(title: 'PORTFOLIO'),
          const SizedBox(height: 8),
          _SidebarContactRow(icon: Icons.code_outlined, text: 'GitHub'),
          const SizedBox(height: 6),
          _SidebarContactRow(icon: Icons.work_outline, text: 'LinkedIn'),
        ],
      ),
    );
  }
}

class _SidebarSection extends StatelessWidget {
  final String title;
  const _SidebarSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF7EAADC),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Container(height: 1.5, width: 30, color: const Color(0xFF7EAADC)),
      ],
    );
  }
}

class _SidebarContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _SidebarContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 10, color: const Color(0xFF7EAADC)),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 8.5,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _SidebarSkillRow extends StatelessWidget {
  final String skill;
  const _SidebarSkillRow({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFF7EAADC),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            skill,
            style: GoogleFonts.poppins(fontSize: 9, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _SidebarLangRow extends StatelessWidget {
  final String lang;
  final double level;
  const _SidebarLangRow({required this.lang, required this.level});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang,
          style: GoogleFonts.poppins(fontSize: 9, color: Colors.white70),
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: level,
            minHeight: 4,
            backgroundColor: Colors.white12,
            valueColor: const AlwaysStoppedAnimation(Color(0xFF7EAADC)),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Right Main Content
// ─────────────────────────────────────────────────────────────
class _CvMainContent extends StatelessWidget {
  final List<Map<String, dynamic>> experiences;
  final List<Map<String, dynamic>> educations;

  const _CvMainContent({required this.experiences, required this.educations});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ABOUT ME
          _MainSection(title: 'ABOUT ME'),
          const SizedBox(height: 8),
          Text(
            'Passionate Flutter developer with 3+ years of experience building '
            'cross-platform mobile applications. Skilled in Dart, Firebase, and '
            'REST API integration. Committed to writing clean, maintainable code '
            'and delivering great user experiences.',
            style: GoogleFonts.poppins(
              fontSize: 9,
              color: const Color(0xFF555555),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),

          // EDUCATION
          if (educations.isNotEmpty) ...[
            _MainSection(title: 'EDUCATION'),
            const SizedBox(height: 10),
            ...educations.asMap().entries.map((entry) {
              final i = entry.key;
              final edu = entry.value;
              return Column(
                children: [
                  _MainTimelineItem(
                    dotColor: i == 0
                        ? const Color(0xFF1B2A4A)
                        : const Color(0xFF7EAADC),
                    title: edu['degree'] as String? ?? '',
                    subtitle: edu['school'] as String? ?? '',
                    period: edu['period'] as String? ?? '',
                    description: edu['field'] as String? ?? '',
                  ),
                  if (i < educations.length - 1) const SizedBox(height: 10),
                ],
              );
            }),
            const SizedBox(height: 18),
          ],

          // EXPERIENCE
          if (experiences.isNotEmpty) ...[
            _MainSection(title: 'EXPERIENCE'),
            const SizedBox(height: 10),
            ...experiences.asMap().entries.map((entry) {
              final i = entry.key;
              final exp = entry.value;
              return Column(
                children: [
                  _MainTimelineItem(
                    dotColor: i == 0
                        ? const Color(0xFF1B2A4A)
                        : const Color(0xFF7EAADC),
                    title: exp['title'] as String? ?? '',
                    subtitle: exp['company'] as String? ?? '',
                    period: exp['period'] as String? ?? '',
                    description: exp['description'] as String? ?? '',
                  ),
                  if (i < experiences.length - 1) const SizedBox(height: 10),
                ],
              );
            }),
            const SizedBox(height: 18),
          ],
        ],
      ),
    );
  }
}

class _MainSection extends StatelessWidget {
  final String title;
  const _MainSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B2A4A),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Container(height: 1.5, color: const Color(0xFF1B2A4A))),
      ],
    );
  }
}

class _MainTimelineItem extends StatelessWidget {
  final Color dotColor;
  final String title;
  final String subtitle;
  final String period;
  final String description;

  const _MainTimelineItem({
    required this.dotColor,
    required this.title,
    required this.subtitle,
    required this.period,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline dot + line
        Column(
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 1.5,
              height: 50,
              color: dotColor.withValues(alpha: 0.25),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1B2A4A),
                      ),
                    ),
                  ),
                  Text(
                    period,
                    style: GoogleFonts.poppins(
                      fontSize: 8,
                      color: const Color(0xFF7EAADC),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 8.5,
                  color: const Color(0xFF666666),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
