import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/job_provider.dart';
import 'package:job_finder/widgets/job_card.dart';

class SavedJobsScreen extends StatelessWidget {
  const SavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final savedJobs = jobProvider.savedJobs;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Saved Jobs',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
      ),
      body: savedJobs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 80,
                    color: AppColors.textHint.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No saved jobs yet',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Save jobs you are interested in\nto view them later',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textHint,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/main'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Browse Jobs',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    'You saved ${savedJobs.length} job${savedJobs.length > 1 ? 's' : ''}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: savedJobs.length,
                    itemBuilder: (context, index) {
                      final job = savedJobs[index];
                      return JobCard(
                        job: job,
                        onTap: () => context.push('/job-detail/${job.id}'),
                        onSave: () => jobProvider.toggleSaveJob(job.id),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
