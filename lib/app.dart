import 'package:flutter/material.dart';

import 'src/screens/home_screen.dart';
import 'src/screens/login_screen.dart';
import 'src/theme/app_theme.dart';

class SkillCircleApp extends StatelessWidget {
  const SkillCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill Circle',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: LoginScreen.routeName,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case LoginScreen.routeName:
            return MaterialPageRoute<void>(
              builder: (_) => const LoginScreen(),
            );
          case HomeScreen.routeName:
            final email = settings.arguments as String? ?? 'Guest';
            return MaterialPageRoute<void>(
              builder: (_) => HomeScreen(email: email),
            );
        }

        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
        );
      },
    );
  }
}
