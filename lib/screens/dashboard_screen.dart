import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/student_provider.dart';
import '../providers/message_provider.dart';
import '../widgets/student_card.dart';
import 'login_screen.dart';
import 'academic_results_screen.dart';
import 'announcements_screen.dart';
import 'messages_screen.dart';
import 'attendance_screen.dart';
import 'homework_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.user != null) {
        context.read<StudentProvider>().loadChildren(auth.user!.id);
        _setupRealtime(auth.user!.id);
      }
    });
  }

  void _setupRealtime(String userId) {
    final mp = context.read<MessageProvider>();
    mp.subscribeToRealtime(userId);
    mp.onNewMessage = (message) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New message from ${message.senderName}: ${message.subject}'),
          action: SnackBarAction(
            label: 'View',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MessagesScreen()),
              );
            },
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MBKIS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final mp = context.read<MessageProvider>();
              await auth.logout();
              mp.unsubscribeFromRealtime();
              if (!context.mounted) return;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (auth.user != null) {
            await context.read<StudentProvider>().loadChildren(auth.user!.id);
          }
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    auth.user?.name ?? 'Parent',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Consumer<StudentProvider>(
                    builder: (context, sp, _) {
                      final count = sp.children.length;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          count == 1
                              ? '1 child linked'
                              : '$count children linked',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildFeatureCards(theme, colorScheme),
            const SizedBox(height: 24),
            Consumer<StudentProvider>(
              builder: (context, sp, _) {
                if (sp.loadingChildren) {
                  return Column(
                    children: List.generate(
                      3,
                      (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _shimmerCard(theme),
                      ),
                    ),
                  );
                }

                if (sp.error != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.error_outline,
                              size: 48, color: colorScheme.error),
                          const SizedBox(height: 8),
                          Text(sp.error!),
                        ],
                      ),
                    ),
                  );
                }

                if (sp.children.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.child_care_outlined,
                              size: 64,
                              color: colorScheme.onSurfaceVariant),
                          const SizedBox(height: 16),
                          Text(
                            'No children linked to your account',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'My Children',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${sp.children.length} total',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ...sp.children.map(
                      (student) => StudentCard(
                        student: student,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  AcademicResultsScreen(student: student),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCards(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Access', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _featureCard(Icons.campaign_rounded, 'Announcements', colorScheme.primary, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnnouncementsScreen())))),
            const SizedBox(width: 10),
            Expanded(child: _featureCard(Icons.email_rounded, 'Messages', colorScheme.tertiary, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MessagesScreen())))),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _featureCard(Icons.calendar_today_rounded, 'Attendance', Colors.green, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AttendanceScreen())))),
            const SizedBox(width: 10),
            Expanded(child: _featureCard(Icons.assignment_rounded, 'Homework', Colors.orange, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HomeworkScreen())))),
          ],
        ),
      ],
    );
  }

  Widget _featureCard(IconData icon, String label, Color color, VoidCallback onTap) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(label, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerCard(ThemeData theme) {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
