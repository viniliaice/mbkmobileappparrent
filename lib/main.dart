import 'package:flutter/material.dart';
import 'package:mbk_parent_portal/services/tts_service.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/student_provider.dart';
import 'providers/announcement_provider.dart';
import 'providers/message_provider.dart';
import 'providers/attendance_provider.dart';
import 'providers/homework_provider.dart';
import 'learning/provider.dart';
import 'math/providers/math_provider.dart';
import 'screens/login_screen.dart';
import 'widgets/app_shell.dart';
import 'services/supabase_service.dart';
import 'theme/aurora_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TtsService().speak('').catchError((_) {}); // triggers init silently
  await SupabaseService().initialize();

  runApp(const MBKParentPortalApp());
}

class MBKParentPortalApp extends StatelessWidget {
  const MBKParentPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => HomeworkProvider()),
        ChangeNotifierProvider(create: (_) => LearningProvider()),
        ChangeNotifierProvider(create: (_) => MathProvider()),
      ],
      child: MaterialApp(
        title: 'MBK Parent Portal',
        debugShowCheckedModeBanner: false,
        theme: auroraLightTheme(),
        darkTheme: auroraDarkTheme(),
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final auth = context.read<AuthProvider>();
    await auth.tryAutoLogin();

    if (!mounted) return;

    if (auth.status == AuthStatus.authenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AppShell()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 96,
              height: 96,
              errorBuilder: (_, _, _) => Icon(
                Icons.school_rounded,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
