import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/student_provider.dart';
import '../providers/announcement_provider.dart';
import '../providers/message_provider.dart';
import '../models/message.dart';
import '../models/announcement.dart';
import '../models/student.dart';
import 'login_screen.dart';
import 'announcements_screen.dart';
import 'messages_screen.dart';
import '../learning/screens/hub_screen.dart';
import '../theme/aurora_background.dart';
import '../widgets/aurora_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  StreamSubscription<AppMessage>? _newMessageSub;
  late AnimationController _fadeController;
  late AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeController.forward();
    _staggerController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final sp = context.read<StudentProvider>();
      final ap = context.read<AnnouncementProvider>();
      if (auth.user != null) {
        sp.loadChildren(auth.user!.id).then((_) {
          final classes = sp.children.map((c) => c.className).toSet().toList();
          if (classes.isNotEmpty) ap.loadAnnouncements(classes);
        });
        _setupRealtime(auth.user!.id);
      }
    });
  }

  void _setupRealtime(String userId) {
    final mp = context.read<MessageProvider>();
    mp.subscribeToRealtime(userId);
    _newMessageSub = mp.newMessages.listen((message) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New message from ${message.senderName}: ${message.subject}'),
          action: SnackBarAction(label: 'View', onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MessagesScreen()));
          }),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.all(16),
        ),
      );
    });
  }

  @override
  void dispose() {
    _newMessageSub?.cancel();
    _fadeController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: AuroraBackground(
        child: RefreshIndicator(
          onRefresh: () async {
            if (auth.user != null) {
              final sp = context.read<StudentProvider>();
              final ap = context.read<AnnouncementProvider>();
              await sp.loadChildren(auth.user!.id);
              final classes = sp.children.map((c) => c.className).toSet().toList();
              if (classes.isNotEmpty) ap.loadAnnouncements(classes);
            }
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeController,
                  child: _buildWelcomeSection(theme, auth),
                ),
              ),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: CurvedAnimation(parent: _staggerController, curve: const Interval(0.0, 0.5)),
                  child: _buildStudentCards(theme),
                ),
              ),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: CurvedAnimation(parent: _staggerController, curve: const Interval(0.2, 0.7)),
                  child: _buildQuickActions(theme),
                ),
              ),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: CurvedAnimation(parent: _staggerController, curve: const Interval(0.4, 1.0)),
                  child: _buildAnnouncements(theme),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(ThemeData theme, dynamic auth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _timeBasedGreeting(),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            auth.user?.name ?? 'Parent',
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCards(ThemeData theme) {
    final students = context.watch<StudentProvider>().children;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (students.isEmpty)
            AuroraCard(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Icon(Icons.child_care_outlined, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                  const SizedBox(width: 12),
                  Text('No children linked yet', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            )
          else
            ...students.map((student) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _StudentCard(student: student),
            )),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text('Quick Actions', style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700, letterSpacing: -0.3,
            )),
          ),
          Row(
            children: [
              Expanded(child: _QuickActionCard(
                icon: Icons.auto_stories_rounded,
                label: 'Learning Hub',
                gradient: const [Color(0xFF448AFF), Color(0xFF00BCD4)],
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LearningHubScreen())),
              )),
              const SizedBox(width: 12),
              Expanded(child: _QuickActionCard(
                icon: Icons.mail_outline_rounded,
                label: 'Messages',
                gradient: const [Color(0xFF9B59B6), Color(0xFFB39DDB)],
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MessagesScreen())),
              )),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _QuickActionCard(
                icon: Icons.campaign_rounded,
                label: 'Announcements',
                gradient: const [Color(0xFF00BCD4), Color(0xFF2ECC71)],
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnnouncementsScreen())),
              )),
              const SizedBox(width: 12),
              Expanded(child: _QuickActionCard(
                icon: Icons.logout_rounded,
                label: 'Sign Out',
                gradient: const [Color(0xFFE74C3C), Color(0xFF9B59B6)],
                onTap: () async {
                  final mp = context.read<MessageProvider>();
                  final auth = context.read<AuthProvider>();
                  final navigator = Navigator.of(context);
                  await auth.logout();
                  mp.unsubscribeFromRealtime();
                  if (!context.mounted) return;
                  navigator.pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncements(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Announcements', style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700, letterSpacing: -0.3,
              )),
              TextButton.icon(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnnouncementsScreen())),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Consumer<AnnouncementProvider>(
            builder: (context, ap, _) {
              if (ap.loading && ap.announcements.isEmpty) {
                return _buildShimmer();
              }
              if (ap.announcements.isEmpty) {
                return AuroraCard(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(Icons.campaign_outlined, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                      const SizedBox(width: 12),
                      Text('No announcements yet', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  for (int i = 0; i < ap.announcements.length && i < 3; i++)
                    _AnnouncementTile(announcement: ap.announcements[i]),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Column(
      children: List.generate(2, (_) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: AuroraCard(
          height: 80,
          padding: EdgeInsets.zero,
          child: ShimmerLoading(),
        ),
      )),
    );
  }

  String _timeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}

class _StudentCard extends StatelessWidget {
  final Student student;
  const _StudentCard({required this.student});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = student.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join();
    return AuroraCard(
      hasGlow: true,
      accentColor: const Color(0xFF448AFF),
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF448AFF), Color(0xFF00BCD4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(initials, style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18,
              )),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(student.className, style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                )),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [
            BoxShadow(color: gradient.first.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _AnnouncementTile extends StatelessWidget {
  final Announcement announcement;
  const _AnnouncementTile({required this.announcement});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AuroraCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.campaign_rounded, size: 20, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    announcement.className.isNotEmpty ? 'Class ${announcement.className}' : 'Announcement',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13,
                      color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 4),
                  Text(announcement.message, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({super.key});
  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF141D3A), const Color(0xFF1A2A5C), const Color(0xFF141D3A)]
                  : [const Color(0xFFE8ECF4), const Color(0xFFF0F4FF), const Color(0xFFE8ECF4)],
              stops: [_controller.value - 0.3, _controller.value, _controller.value + 0.3]
                  .map((v) => v.clamp(0.0, 1.0)).toList(),
              begin: Alignment(-1.0, 0.0), end: Alignment(1.0, 0.0),
            ),
          ),
        );
      },
    );
  }
}
