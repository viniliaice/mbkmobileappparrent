import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/announcement_provider.dart';
import '../providers/student_provider.dart';
import '../theme/aurora_background.dart';
import '../widgets/aurora_card.dart';
import '../widgets/responsive_content.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sp = context.read<StudentProvider>();
      final classes = sp.children.map((c) => c.className).toSet().toList();
      if (classes.isNotEmpty) {
        context.read<AnnouncementProvider>().loadAnnouncements(classes);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final df = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Announcements')),
      body: AuroraBackground(
        child: ResponsiveContent(
          child: Consumer<AnnouncementProvider>(
            builder: (context, ap, _) {
              if (ap.loading && ap.announcements.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (ap.error != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                        const SizedBox(height: 16),
                        Text(ap.error!),
                      ],
                    ),
                  ),
                );
              }
              if (ap.announcements.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.campaign_outlined, size: 64, color: colorScheme.onSurfaceVariant),
                        const SizedBox(height: 16),
                        Text('No announcements yet', style: theme.textTheme.bodyLarge),
                      ],
                    ),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  final sp = context.read<StudentProvider>();
                  final classes = sp.children.map((c) => c.className).toSet().toList();
                  if (classes.isNotEmpty) {
                    await ap.loadAnnouncements(classes);
                  }
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: ap.announcements.length + (ap.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == ap.announcements.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: ap.loading
                              ? const CircularProgressIndicator()
                              : TextButton(
                                  onPressed: () => ap.loadMore(),
                                  child: const Text('Load more'),
                                ),
                        ),
                      );
                    }
                    final a = ap.announcements[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AuroraCard(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.campaign, size: 20, color: colorScheme.primary),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(a.className, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
                                  ),
                                  const Spacer(),
                                  Text(df.format(a.createdAt), style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(a.message, style: theme.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
