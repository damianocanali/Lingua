import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/progress_provider.dart';
import 'screens/home_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait for kids - easier to use
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final prefs = await SharedPreferences.getInstance();
  final isNewUser = (prefs.getString('profile_name') ?? '').isEmpty;

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: LinguaApp(isNewUser: isNewUser),
    ),
  );
}

class LinguaApp extends StatelessWidget {
  final bool isNewUser;
  const LinguaApp({super.key, required this.isNewUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lingua',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: isNewUser ? const ProfileSetupScreen() : const HomeScreen(),
    );
  }
}
