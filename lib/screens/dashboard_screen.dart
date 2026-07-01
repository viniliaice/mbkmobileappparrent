import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/student_provider.dart';
import '../providers/announcement_provider.dart';
import '../providers/message_provider.dart';
import '../models/message.dart';
import '../models/announcement.dart';
import 'login_screen.dart';
import 'announcements_screen.dart';
import 'messages_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  StreamSubscription<AppMessage>? _newMessageSub;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeController.forward();
    _slideController.forward();
    _staggerController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final sp = context.read<StudentProvider>();
      final ap = context.read<AnnouncementProvider>();
      if (auth.user != null) {
        sp.loadChildren(auth.user!.id).then((_) {
          final classes = sp.children.map((c) => c.className).toSet().toList();
          if (classes.isNotEmpty) {
            ap.loadAnnouncements(classes);
          }
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
    _slideController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final auth = context.watch<AuthProvider>();
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF000000) : const Color(0xFFF2F2F7),
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(theme, colorScheme, auth),
      body: RefreshIndicator(
        onRefresh: () async {
          if (auth.user != null) {
            final sp = context.read<StudentProvider>();
            final ap = context.read<AnnouncementProvider>();
            await sp.loadChildren(auth.user!.id);
            final classes = sp.children.map((c) => c.className).toSet().toList();
            if (classes.isNotEmpty) {
              ap.loadAnnouncements(classes);
            }
          }
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: kToolbarHeight + 8)),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeController,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.15),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic)),
                  child: _buildWelcomeSection(theme, colorScheme, auth, isDark),
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 8)),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: CurvedAnimation(parent: _staggerController, curve: const Interval(0.4, 1.0)),
                child: _buildAnnouncements(theme),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, ColorScheme colorScheme, dynamic auth) {
    return AppBar(
      title: const Text(
        'MBKIS Parent Portal',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17, letterSpacing: -0.3),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, size: 24),
          tooltip: 'Announcements',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AnnouncementsScreen()),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.logout_rounded, size: 24),
          tooltip: 'Logout',
          onPressed: () async {
            final mp = context.read<MessageProvider>();
            final navigator = Navigator.of(context);
            await auth.logout();
            mp.unsubscribeFromRealtime();
            if (!context.mounted) return;
            navigator.pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildWelcomeSection(ThemeData theme, ColorScheme colorScheme, dynamic auth, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1C1C1E), const Color(0xFF141416)]
                : [Colors.white, const Color(0xFFFAFAFA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.04),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.04),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _timeBasedGreeting(),
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              auth.user?.name ?? 'Parent',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                fontSize: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildAnnouncements(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionHeader('Announcements', theme),
              TextButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AnnouncementsScreen()),
                ),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Consumer<AnnouncementProvider>(
            builder: (context, ap, _) {
              if (ap.loading && ap.announcements.isEmpty) {
                return _buildShimmerAnnouncements(theme);
              }
              if (ap.announcements.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.campaign_outlined,
                          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                      const SizedBox(width: 12),
                      Text('No announcements yet',
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
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

  Widget _buildShimmerAnnouncements(ThemeData theme) {
    return Column(
      children: List.generate(2, (_) => Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const ShimmerLoading(),
      )),
    );
  }

  Widget _sectionHeader(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        fontSize: 22,
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
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.03),
        ),
      ),
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
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  announcement.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
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
  void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true); }
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
                  ? [const Color(0xFF1C1C1E), const Color(0xFF2A2A2E), const Color(0xFF1C1C1E)]
                  : [const Color(0xFFFAFAFA), const Color(0xFFE8E8ED), const Color(0xFFFAFAFA)],
              stops: [_controller.value - 0.3, _controller.value, _controller.value + 0.3].map((v) => v.clamp(0.0, 1.0)).toList(),
              begin: Alignment(-1.0, 0.0), end: Alignment(1.0, 0.0),
            ),
          ),
        );
      },
    );
  }
}