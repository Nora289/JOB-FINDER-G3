import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/config/routes.dart';
import 'package:job_finder/providers/auth_provider.dart';
import 'package:job_finder/providers/job_provider.dart';

void main() {
  runApp(const JobFinderApp());
}

class JobFinderApp extends StatelessWidget {
  const JobFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
      ],
      child: MaterialApp.router(
        title: 'Job Finder',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: appRouter,
      ),
    );
  }
}
