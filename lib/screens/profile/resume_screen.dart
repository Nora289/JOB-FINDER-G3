import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/theme_provider.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen>
    with SingleTickerProviderStateMixin {
  bool _isUploading = false;
  bool _isUploaded = false;
  double _uploadProgress = 0.0;
  String? _uploadedFileName;
  String? _uploadedFileSize;

  void _startUpload() {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 80));
      if (!mounted) return false;
      setState(() => _uploadProgress += 0.02);
      if (_uploadProgress >= 1.0) {
        setState(() {
          _isUploading = false;
          _isUploaded = true;
          _uploadedFileName = 'Rifat_cv_UX Designer';
          _uploadedFileSize = '357 KB';
        });
        return false;
      }
      return true;
    });
  }

  void _removeFile() {
    setState(() {
      _isUploaded = false;
      _isUploading = false;
      _uploadProgress = 0.0;
      _uploadedFileName = null;
      _uploadedFileSize = null;
    });
  }

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
            size: 20,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Resume & Portfolio',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!_isUploaded)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Skip',
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Resume or CV',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: (!_isUploading && !_isUploaded) ? _startUpload : null,
              child: CustomPaint(
                painter: _DashedBorderPainter(
                  color: const Color(0xFF2E8B8B),
                  strokeWidth: 1.5,
                  gap: 6,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  child: _buildUploadContent(isDark),
                ),
              ),
            ),
            const SizedBox(height: 28),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Uploading  ',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: '(Optional)',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (!_isUploaded) ...[
              Row(
                children: [
                  _actionButton('Portfolio Link', isDark),
                  const SizedBox(width: 12),
                  _actionButton('Add PDF', isDark),
                ],
              ),
              const SizedBox(height: 12),
              _actionButton('Add Photos', isDark),
            ] else ...[
              Row(
                children: [
                  _actionButton('Add PDF', isDark),
                  const SizedBox(width: 12),
                  _actionButton('Add Photos', isDark),
                ],
              ),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isUploaded ? AppColors.primary : Colors.grey.shade300,
                  foregroundColor: _isUploaded ? Colors.white : AppColors.textSecondary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Save',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadContent(bool isDark) {
    if (_isUploaded && _uploadedFileName != null) {
      return Column(
        children: [
          Text(
            'Upload your CV or Resume and\nuse it when apply for jobs.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'PDF',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _uploadedFileName!,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _uploadedFileSize!,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextHint : AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _removeFile,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (_isUploading) {
      return Column(
        children: [
          Text(
            'Upload your CV or Resume and\nuse it when apply for jobs.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: _uploadProgress,
                  strokeWidth: 4,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
                Text(
                  '${(_uploadProgress * 100).toInt()}%',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Uploading',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Text(
          'Upload your CV or Resume and\nuse it when apply for jobs.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text(
          'Tap to upload',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: isDark ? AppColors.darkTextHint : AppColors.textHint,
          ),
        ),
      ],
    );
  }

  Widget _actionButton(String label, bool isDark) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        side: BorderSide(color: isDark ? AppColors.darkDivider : Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.gap = 5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    final rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(14),
    );

    final metrics = Path()..addRRect(rRect);
    for (final metric in metrics.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + gap * 1.5;
        path.addPath(
          metric.extractPath(distance, min(next, metric.length)),
          Offset.zero,
        );
        distance = next + gap;
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
