import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:job_finder/config/theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      image: 'assets/images/1.png',
      title: 'Search your job',
      subtitle:
          'Figure out your top five priorities whether\nit is company culture, salary.',
    ),
    _OnboardingData(
      image: 'assets/images/2.png',
      title: 'Browse jobs list',
      subtitle:
          'Our job include several industries, so\nyou can find the base job for you.',
    ),
    _OnboardingData(
      image: 'assets/images/3.png',
      title: 'Apply to base jobs',
      subtitle:
          'You can apply to your desirable jobs very\nquickly and easily with ease.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: () => context.go('/job-preferences'),
                  child: Text(
                    'Skip',
                    style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: const WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: AppColors.primary,
                  dotColor: AppColors.divider,
                ),
              ),
            ),
            // Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      context.go('/job-preferences');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 250,
            height: 250,
            child: Image.asset(data.image, fit: BoxFit.contain),
          ),
          const SizedBox(height: 48),
          Text(
            data.title,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.subtitle,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final String image;
  final String title;
  final String subtitle;

  _OnboardingData({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}
