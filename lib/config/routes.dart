import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_finder/screens/onboarding/splash_screen.dart';
import 'package:job_finder/screens/onboarding/onboarding_screen.dart';
import 'package:job_finder/screens/auth/sign_in_screen.dart';
import 'package:job_finder/screens/auth/register_screen.dart';
import 'package:job_finder/screens/onboarding/job_preferences_screen.dart';
import 'package:job_finder/screens/home/main_screen.dart';
import 'package:job_finder/screens/job/job_detail_screen.dart';
import 'package:job_finder/screens/job/job_apply_screen.dart';
import 'package:job_finder/screens/job/apply_success_screen.dart';
import 'package:job_finder/screens/job/saved_jobs_screen.dart';
import 'package:job_finder/screens/job/my_applications_screen.dart';
import 'package:job_finder/screens/company/company_profile_screen.dart';
import 'package:job_finder/screens/company/company_location_screen.dart';
import 'package:job_finder/screens/messaging/chat_list_screen.dart';
import 'package:job_finder/screens/messaging/chat_screen.dart';
import 'package:job_finder/screens/profile/profile_screen.dart';
import 'package:job_finder/screens/profile/resume_screen.dart';
import 'package:job_finder/screens/profile/cv_preview_screen.dart';
import 'package:job_finder/screens/profile/about_screen.dart';
import 'package:job_finder/screens/profile/edit_profile_screen.dart';
import 'package:job_finder/screens/profile/help_center_screen.dart';
import 'package:job_finder/screens/profile/language_screen.dart';
import 'package:job_finder/screens/profile/following_companies_screen.dart';
import 'package:job_finder/screens/profile/cover_letter_screen.dart';
import 'package:job_finder/screens/profile/cover_letter_preview_screen.dart';
import 'package:job_finder/screens/profile/proposals_screen.dart';
import 'package:job_finder/screens/profile/portfolio_screen.dart';
import 'package:job_finder/screens/notifications/notifications_screen.dart';
import 'package:job_finder/screens/search/search_screen.dart';
import 'package:job_finder/screens/job/application_status_screen.dart';
import 'package:job_finder/screens/job/company_announcements_screen.dart';
import 'package:job_finder/screens/job/job_alerts_screen.dart';
import 'package:job_finder/screens/job/career_resources_screen.dart';
import 'package:job_finder/screens/profile/application_stats_screen.dart';
import 'package:job_finder/screens/job/filtered_jobs_screen.dart';
import 'package:job_finder/screens/job/job_comparison_detail_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/job-preferences',
      builder: (context, state) => const JobPreferencesScreen(),
    ),
    GoRoute(path: '/main', builder: (context, state) => const MainScreen()),
    GoRoute(
      path: '/job-detail/:id',
      builder: (context, state) {
        final jobId = state.pathParameters['id']!;
        return JobDetailScreen(jobId: jobId);
      },
    ),
    GoRoute(
      path: '/job-apply/:id',
      builder: (context, state) {
        final jobId = state.pathParameters['id']!;
        return JobApplyScreen(jobId: jobId);
      },
    ),
    GoRoute(
      path: '/apply-success',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final jobTitle = extra?['jobTitle'] as String?;
        return ApplySuccessScreen(jobTitle: jobTitle);
      },
    ),
    GoRoute(
      path: '/saved-jobs',
      builder: (context, state) => const SavedJobsScreen(),
    ),
    GoRoute(
      path: '/my-applications',
      builder: (context, state) => const MyApplicationsScreen(),
    ),
    GoRoute(
      path: '/company/:id',
      builder: (context, state) {
        final companyId = state.pathParameters['id']!;
        return CompanyProfileScreen(companyId: companyId);
      },
    ),
    GoRoute(
      path: '/company-location/:id',
      builder: (context, state) {
        final companyId = state.pathParameters['id']!;
        return CompanyLocationScreen(companyId: companyId);
      },
    ),
    GoRoute(
      path: '/chat-list',
      builder: (context, state) => const ChatListScreen(),
    ),
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) {
        final chatId = state.pathParameters['id']!;
        return ChatScreen(chatId: chatId);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(path: '/resume', builder: (context, state) => const ResumeScreen()),
    GoRoute(
      path: '/proposals',
      builder: (context, state) => const ProposalsScreen(),
    ),
    GoRoute(
      path: '/portfolio',
      builder: (context, state) => const PortfolioScreen(),
    ),
    GoRoute(
      path: '/cover-letter',
      builder: (context, state) => const CoverLetterScreen(),
    ),
    GoRoute(
      path: '/cover-letter-preview',
      builder: (context, state) => const CoverLetterPreviewScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
    GoRoute(
      path: '/help-center',
      builder: (context, state) => const HelpCenterScreen(),
    ),
    GoRoute(
      path: '/language',
      builder: (context, state) => const LanguageScreen(),
    ),
    GoRoute(
      path: '/following-companies',
      builder: (context, state) => const FollowingCompaniesScreen(),
    ),
    GoRoute(
      path: '/cv-preview',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return CvPreviewScreen(data: extra);
      },
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
    GoRoute(
      path: '/interview-tips',
      builder: (context, state) => const InterviewTipsScreen(),
    ),
    GoRoute(
      path: '/company-announcements',
      builder: (context, state) => const CompanyAnnouncementsScreen(),
    ),
    GoRoute(
      path: '/job-alerts',
      builder: (context, state) => const JobAlertsScreen(),
    ),
    GoRoute(
      path: '/compare-jobs',
      builder: (context, state) => const JobComparisonDetailScreen(),
    ),
    GoRoute(
      path: '/career-resources',
      builder: (context, state) => const CareerResourcesScreen(),
    ),
    GoRoute(
      path: '/application-stats',
      builder: (context, state) => const ApplicationStatsScreen(),
    ),
    GoRoute(
      path: '/filtered-jobs',
      builder: (context, state) => const FilteredJobsScreen(),
    ),
  ],
);
