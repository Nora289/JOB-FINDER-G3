import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/job_provider.dart';

class JobApplyScreen extends StatefulWidget {
  final String jobId;

  const JobApplyScreen({super.key, required this.jobId});

  @override
  State<JobApplyScreen> createState() => _JobApplyScreenState();
}

class _JobApplyScreenState extends State<JobApplyScreen> {
  final _coverLetterController = TextEditingController();
  String? _selectedFileName;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _coverLetterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final job = jobProvider.getJobById(widget.jobId);

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
          'Apply for Job',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job info card
            if (job != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Image.asset(
                            job.companyLogo,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.business,
                                  color: AppColors.primary,
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            job.companyName,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            // Cover Letter
            Text(
              'Cover Letter',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _coverLetterController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Write your cover letter here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Resume/CV upload
            Text(
              'Resume / CV',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFileName = 'my_resume.pdf';
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.divider,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      _selectedFileName != null
                          ? Icons.description
                          : Icons.cloud_upload_outlined,
                      size: 48,
                      color: _selectedFileName != null
                          ? AppColors.primary
                          : AppColors.textHint,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedFileName ?? 'Upload your CV/Resume',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: _selectedFileName != null
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight: _selectedFileName != null
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                    if (_selectedFileName == null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'PDF, DOC up to 5MB',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Submit button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isSubmitting
                    ? null
                    : () {
                        setState(() => _isSubmitting = true);
                        Future.delayed(const Duration(seconds: 1), () {
                          if (!mounted) return;
                          // ignore: use_build_context_synchronously
                          context.go('/apply-success');
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
                        'Submit Application',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
