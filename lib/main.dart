import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/resume_service.dart';
import 'core/services/theme_service.dart';
import 'features/cv_builder/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ResumeService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'ResumeForge',
            debugShowCheckedModeBanner: false,
            // Combined theme configuration with custom transitions
            theme: themeService.lightTheme.copyWith(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
                },
              ),
            ),
            darkTheme: themeService.darkTheme,
            themeMode: themeService.themeMode,
            home: const ThemeTransitionWrapper(),
          );
        },
      ),
    );
  }
}

class ThemeTransitionWrapper extends StatelessWidget {
  const ThemeTransitionWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeService>().themeMode;
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey(themeMode),
        child: const SplashScreen(),
      ),
    );
  }
}
