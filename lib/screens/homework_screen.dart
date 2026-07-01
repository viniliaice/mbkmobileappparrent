import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/homework_provider.dart';
import '../providers/student_provider.dart';

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sp = context.read<StudentProvider>();
      final ids = sp.children.map((c) => c.id).toList();
      if (ids.isNotEmpty) {
        context.read<HomeworkProvider>().loadHomework(ids);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final df = DateFormat('MMM dd');

    return Scaffold(
      appBar: AppBar(title: const Text('Homework')),
      body: Consumer<HomeworkProvider>(
        builder: (context, hp, _) {
          if (hp.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (hp.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                    const SizedBox(height: 16),
                    Text(hp.error!),
                  ],
                ),
              ),
            );
          }

          if (hp.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.assignment_outlined, size: 64, color: colorScheme.onSurfaceVariant),
                    const SizedBox(height: 16),
                    Text('No homework assigned', style: theme.textTheme.bodyLarge),
                  ],
                ),
              ),
            );
          }

          final grouped = hp.groupedByStudent;
          final sections = <dynamic>[];
          for (final entry in grouped.entries) {
            sections.add(entry.key);
            sections.addAll(entry.value);
          }

          return RefreshIndicator(
            onRefresh: () async {
              final sp = context.read<StudentProvider>();
              final ids = sp.children.map((c) => c.id).toList();
              if (ids.isNotEmpty) {
                await hp.loadHomework(ids);
              }
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sections.length + (hp.overdueCount > 0 ? 1 : 0),
              itemBuilder: (context, index) {
                int offset = 0;
                if (hp.overdueCount > 0) {
                  if (index == 0) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.red),
                          const SizedBox(width: 8),
                          Text('${hp.overdueCount} overdue assignment${hp.overdueCount == 1 ? '' : 's'}',
                              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    );
                  }
                  offset = 1;
                }
                final item = sections[index - offset];
                if (item is String) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(item[0].toUpperCase(),
                                style: TextStyle(color: colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(item, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }
                final hw = item as dynamic;
                final overdue = hw.isOverdue;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: overdue ? BorderSide(color: Colors.red.withValues(alpha: 0.4)) : BorderSide.none,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: overdue ? Colors.red.withValues(alpha: 0.1) : colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              hw.isCompleted ? Icons.check_circle : (overdue ? Icons.schedule : Icons.assignment),
                              color: hw.isCompleted ? Colors.green : (overdue ? Colors.red : colorScheme.primary),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(hw.title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Text('${hw.subject} · Due ${df.format(hw.dueDate)}', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                if (overdue)
                                  Text('OVERDUE', style: theme.textTheme.labelSmall?.copyWith(color: Colors.red, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: hw.isCompleted
                                  ? Colors.green.withValues(alpha: 0.15)
                                  : colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              hw.status,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: hw.isCompleted ? Colors.green : colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
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
    );
  }
}
