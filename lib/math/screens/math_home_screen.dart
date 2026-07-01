import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/student_card.dart';
import 'math_hub_screen.dart';

class MathHomeScreen extends StatefulWidget {
  const MathHomeScreen({super.key});

  @override
  State<MathHomeScreen> createState() => _MathHomeScreenState();
}

class _MathHomeScreenState extends State<MathHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sp = context.read<StudentProvider>();
      if (sp.children.isEmpty) {
        final auth = context.read<AuthProvider>();
        if (auth.user != null) {
          sp.loadChildren(auth.user!.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text('Interactive Math'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<StudentProvider>(
        builder: (context, sp, _) {
          if (sp.loadingChildren) {
            return const Center(child: CircularProgressIndicator());
          }
          if (sp.children.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.child_care_outlined, size: 64, color: colorScheme.onSurfaceVariant),
                    const SizedBox(height: 16),
                    Text('No children linked to your account',
                        style: theme.textTheme.bodyLarge),
                  ],
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Math Practice',
                        style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                    const SizedBox(height: 6),
                    Text('Choose a child to get started',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Select a Student',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...sp.children.map((student) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: StudentCard(
                  student: student,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MathHubScreen(student: student),
                      ),
                    );
                  },
                ),
              )),
            ],
          );
        },
      ),
    );
  }
}
