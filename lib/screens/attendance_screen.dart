import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/attendance_record.dart';
import '../providers/attendance_provider.dart';
import '../providers/student_provider.dart';
import '../theme/aurora_background.dart';
import '../widgets/aurora_card.dart';
import '../widgets/responsive_content.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sp = context.read<StudentProvider>();
      final ids = sp.children.map((c) => c.id).toList();
      if (ids.isNotEmpty) {
        context.read<AttendanceProvider>().loadAttendance(ids);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final df = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: AuroraBackground(
        child: Consumer<AttendanceProvider>(
          builder: (context, ap, _) {
            if (ap.loading) {
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

            final todayRec = ap.todayRecord;
            final total = ap.summary.values.fold(0, (a, b) => a + b);
            final recordCount = ap.records.length;
            final headerCount = 3;
            final totalItems = headerCount + recordCount;

            return ResponsiveContent(
              child: RefreshIndicator(
                onRefresh: () async {
                  final sp = context.read<StudentProvider>();
                  final ids = sp.children.map((c) => c.id).toList();
                  if (ids.isNotEmpty) {
                    await ap.loadAttendance(ids);
                  }
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: totalItems,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildTodayCard(theme, colorScheme, todayRec);
                    }
                    if (index == 1) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: _buildStatsCard(theme, colorScheme, ap, total),
                      );
                    }
                    if (index == 2) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('History', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      );
                    }
                    final r = ap.records[index - headerCount];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AuroraCard(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              _statusIcon(r.status, colorScheme),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(df.format(r.date), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                    Text(r.className, style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                  ],
                                ),
                              ),
                              _statusBadge(r.status, colorScheme),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTodayCard(ThemeData theme, ColorScheme colorScheme, AttendanceRecord? todayRec) {
    return AuroraCard(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              todayRec == null ? colorScheme.surfaceContainerHighest : _statusColor(todayRec.status, colorScheme).withValues(alpha: 0.15),
              todayRec == null ? colorScheme.surface : _statusColor(todayRec.status, colorScheme).withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            Icon(
              todayRec == null ? Icons.help_outline : _statusIconData(todayRec.status),
              size: 48,
              color: todayRec == null ? colorScheme.onSurfaceVariant : _statusColor(todayRec.status, colorScheme),
            ),
            const SizedBox(height: 8),
            Text('Today', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text(
              todayRec == null ? 'No record yet' : todayRec.status.toUpperCase(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: todayRec == null ? colorScheme.onSurfaceVariant : _statusColor(todayRec.status, colorScheme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(ThemeData theme, ColorScheme colorScheme, AttendanceProvider ap, int total) {
    return AuroraCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem(Icons.check_circle, 'Present', ap.summary['present'] ?? 0, Colors.green, theme),
                _statItem(Icons.cancel, 'Absent', ap.summary['absent'] ?? 0, Colors.red, theme),
                _statItem(Icons.access_time, 'Late', ap.summary['late'] ?? 0, Colors.orange, theme),
              ],
            ),
            if (total > 0) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: ap.monthlyPercentage / 100,
                  minHeight: 10,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(
                    ap.monthlyPercentage >= 80 ? Colors.green : ap.monthlyPercentage >= 60 ? Colors.orange : Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('${ap.monthlyPercentage.toStringAsFixed(1)}% monthly attendance', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statItem(IconData icon, String label, int count, Color color, ThemeData theme) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text('$count', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _statusIcon(String status, ColorScheme colorScheme) {
    return Icon(_statusIconData(status), color: _statusColor(status, colorScheme), size: 20);
  }

  Widget _statusBadge(String status, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: _statusColor(status, colorScheme).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status, style: TextStyle(color: _statusColor(status, colorScheme), fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }

  Color _statusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'present': return Colors.green;
      case 'absent': return Colors.red;
      case 'late': return Colors.orange;
      default: return colorScheme.onSurfaceVariant;
    }
  }

  IconData _statusIconData(String status) {
    switch (status.toLowerCase()) {
      case 'present': return Icons.check_circle;
      case 'absent': return Icons.cancel;
      case 'late': return Icons.access_time;
      default: return Icons.help_outline;
    }
  }
}
