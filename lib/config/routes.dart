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
import 'package:job_finder/screens/company/company_profile_screen.dart';
import 'package:job_finder/screens/messaging/chat_list_screen.dart';
import 'package:job_finder/screens/messaging/chat_screen.dart';
import 'package:job_finder/screens/profile/profile_screen.dart';
import 'package:job_finder/screens/profile/resume_screen.dart';
import 'package:job_finder/screens/notifications/notifications_screen.dart';
import 'package:job_finder/screens/search/search_screen.dart';

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
      builder: (context, state) => const ApplySuccessScreen(),
    ),
    GoRoute(
      path: '/saved-jobs',
      builder: (context, state) => const SavedJobsScreen(),
    ),
    GoRoute(
      path: '/company/:id',
      builder: (context, state) {
        final companyId = state.pathParameters['id']!;
        return CompanyProfileScreen(companyId: companyId);
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
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
  ],
);
