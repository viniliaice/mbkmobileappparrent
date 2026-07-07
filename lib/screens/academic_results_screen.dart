import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_strings.dart';
import '../models/student.dart';
import '../models/subject_summary.dart';
import '../providers/student_provider.dart';
import '../theme/aurora_background.dart';
import '../widgets/aurora_card.dart';
import '../widgets/responsive_content.dart';

class AcademicResultsScreen extends StatefulWidget {
  final Student student;

  const AcademicResultsScreen({super.key, required this.student});

  @override
  State<AcademicResultsScreen> createState() => _AcademicResultsScreenState();
}

class _AcademicResultsScreenState extends State<AcademicResultsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedMonth;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sp = context.read<StudentProvider>();
      sp.loadStudentData(widget.student.id);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          bottom: false,
          child: ResponsiveContent(
            child: Column(
              children: [
              _buildHeader(theme, colorScheme),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: theme.brightness == Brightness.dark
                        ? const Color(0xFF141D3A).withValues(alpha: 0.6)
                        : Colors.white.withValues(alpha: 0.6),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: colorScheme.primary.withValues(alpha: 0.15),
                    ),
                    indicatorWeight: 0,
                    dividerColor: Colors.transparent,
                    labelColor: colorScheme.primary,
                    unselectedLabelColor: colorScheme.onSurfaceVariant,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    tabs: const [
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_month_outlined, size: 18),
                            SizedBox(width: 6),
                            Text(AppStrings.monthly),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.book_outlined, size: 18),
                            SizedBox(width: 6),
                            Text(AppStrings.midterm),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.workspace_premium_outlined, size: 18),
                            SizedBox(width: 6),
                            Text(AppStrings.finalTerm),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Consumer<StudentProvider>(
                  builder: (context, sp, _) {
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _MonthlyTab(
                          student: widget.student,
                          selectedMonth: _selectedMonth,
                          onMonthChanged: (m) {
                            setState(() => _selectedMonth = m);
                          },
                        ),
                        _MidtermTab(student: widget.student),
                        _FinalTab(student: widget.student),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withValues(alpha: 0.12),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                widget.student.name.isNotEmpty
                    ? widget.student.name[0].toUpperCase()
                    : AppStrings.unknown,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.student.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  widget.student.className,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _MonthlyTab extends StatelessWidget {
  final Student student;
  final String? selectedMonth;
  final ValueChanged<String> onMonthChanged;

  const _MonthlyTab({
    required this.student,
    required this.selectedMonth,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<StudentProvider>(
      builder: (context, sp, _) {
        if (sp.loadingExams) return _loadingState(theme);

        if (sp.error != null) return _errorState(theme, colorScheme, sp.error!);

        final months = sp.availableMonths;
        if (months.isEmpty) {
          return _emptyState(theme, colorScheme, AppStrings.noMonthlyData);
        }

        final effectiveMonth = selectedMonth ?? months.first;

        final capNotice = sp.allExams.length >= 400
            ? AppStrings.showing400Records
            : null;

        return RefreshIndicator(
          onRefresh: () => sp.loadStudentData(student.id),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: months.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final m = months[index];
                    final isSelected = m == effectiveMonth;
                    return FilterChip(
                      label: Text(_monthLabel(m)),
                      selected: isSelected,
                      onSelected: (_) => onMonthChanged(m),
                      showCheckmark: false,
                      selectedColor: colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  },
                ),
              ),
              if (capNotice != null) ...[
                const SizedBox(height: 8),
                _infoChip(theme, colorScheme, capNotice),
              ],
              const SizedBox(height: 16),
              _buildAverageBanner(theme, colorScheme, sp, effectiveMonth),
              const SizedBox(height: 16),
              ..._buildSubjectList(sp, effectiveMonth, theme, colorScheme),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAverageBanner(ThemeData theme, ColorScheme colorScheme,
      StudentProvider sp, String month) {
    final summaries = sp.getMonthlySummary(month);
    if (summaries.isEmpty) return const SizedBox.shrink();
    final avg = summaries.fold<double>(0, (sum, s) => sum + s.combinedPercent) /
        summaries.length;
    return _scoreBanner(theme, colorScheme, AppStrings.monthlyAverage, avg,
        Icons.trending_up_rounded, _scoreColor(avg, colorScheme));
  }

  List<Widget> _buildSubjectList(StudentProvider sp, String month,
      ThemeData theme, ColorScheme colorScheme) {
    final summaries = sp.getMonthlySummary(month);
    if (summaries.isEmpty) {
      return [
        _emptyState(theme, colorScheme, AppStrings.noResultsThisMonth)
      ];
    }
    return summaries.map((s) {
      final comment = sp.teacherComments[s.subject];
      return _SubjectResultCard(
        summary: s,
        teacherComment: comment,
        colorScheme: colorScheme,
        theme: theme,
      );
    }).toList();
  }

  String _monthLabel(String month) => AppStrings.monthLabel(month);
}

class _MidtermTab extends StatelessWidget {
  final Student student;

  const _MidtermTab({required this.student});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<StudentProvider>(
      builder: (context, sp, _) {
        if (sp.loadingExams) return _loadingState(theme);
        if (sp.error != null) return _errorState(theme, colorScheme, sp.error!);

        final summaries = sp.getMidtermSummary();
        if (summaries.isEmpty) {
          return _emptyState(theme, colorScheme, AppStrings.noMidtermData);
        }

        final avg = summaries.fold<double>(0, (sum, s) => sum + s.combinedPercent) /
            summaries.length;

        return RefreshIndicator(
          onRefresh: () => sp.loadStudentData(student.id),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              _scoreBanner(theme, colorScheme, AppStrings.midtermAverage, avg,
                  Icons.assignment_turned_in, colorScheme.tertiary),
              const SizedBox(height: 12),
              _buildLegend(theme, colorScheme, colorScheme.tertiary),
              const SizedBox(height: 8),
              ...summaries.map((s) => _SubjectResultCard(
                    summary: s,
                    colorScheme: colorScheme,
                    theme: theme,
                    showPosition: true,
                  )),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegend(
      ThemeData theme, ColorScheme colorScheme, Color examColor) {
    return Row(
      children: [
        _legendItem(AppStrings.ca50, colorScheme.primary, theme),
        const SizedBox(width: 16),
        _legendItem(AppStrings.exam50, examColor, theme),
      ],
    );
  }

  Widget _legendItem(String label, Color color, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.labelSmall),
      ],
    );
  }
}

class _FinalTab extends StatelessWidget {
  final Student student;

  const _FinalTab({required this.student});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<StudentProvider>(
      builder: (context, sp, _) {
        if (sp.loadingExams) return _loadingState(theme);
        if (sp.error != null) return _errorState(theme, colorScheme, sp.error!);

        final summaries = sp.getFinalSummary();
        if (summaries.isEmpty) {
          return _emptyState(theme, colorScheme, AppStrings.noFinalData);
        }

        final avg = summaries.fold<double>(0, (sum, s) => sum + s.combinedPercent) /
            summaries.length;
        final overallAvg = summaries.fold<double>(0, (sum, s) => sum + s.overallAverage) /
            summaries.length;

        return RefreshIndicator(
          onRefresh: () => sp.loadStudentData(student.id),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              _FinalBanner(
                  theme: theme,
                  colorScheme: colorScheme,
                  avg: avg,
                  overallAvg: overallAvg),
              const SizedBox(height: 12),
              _buildLegend(theme, colorScheme),
              const SizedBox(height: 8),
              ...summaries.map((s) => _SubjectResultCard(
                    summary: s,
                    colorScheme: colorScheme,
                    theme: theme,
                    showPosition: true,
                    isFinal: true,
                  )),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegend(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        _legendItem(AppStrings.ca50, colorScheme.primary, theme),
        const SizedBox(width: 16),
        _legendItem(AppStrings.exam50, Colors.amber.shade700, theme),
      ],
    );
  }

  Widget _legendItem(String label, Color color, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.labelSmall),
      ],
    );
  }
}

class _FinalBanner extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;
  final double avg;
  final double overallAvg;

  const _FinalBanner({
    required this.theme,
    required this.colorScheme,
    required this.avg,
    required this.overallAvg,
  });

  @override
  Widget build(BuildContext context) {
    return AuroraCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.emoji_events_rounded,
              color: Colors.amber.shade700, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.finalAverage,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant)),
                Text('${avg.toStringAsFixed(1)}%',
                    style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _scoreColor(avg, colorScheme))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(AppStrings.overall,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant)),
              Text('${overallAvg.toStringAsFixed(1)}%',
                  style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface)),
            ],
          ),
          const SizedBox(width: 12),
          _GradeBadge(grade: _gradeFromPercent(avg), colorScheme: colorScheme),
        ],
      ),
    );
  }
}

class _SubjectResultCard extends StatelessWidget {
  final SubjectSummary summary;
  final String? teacherComment;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final bool showPosition;
  final bool isFinal;

  const _SubjectResultCard({
    required this.summary,
    this.teacherComment,
    required this.colorScheme,
    required this.theme,
    this.showPosition = false,
    this.isFinal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AuroraCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(summary.subject,
                      style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  )),
                ),
                _GradeBadge(grade: summary.grade, colorScheme: colorScheme),
              ],
            ),
            const SizedBox(height: 14),
            _buildScoreRow(AppStrings.ca, summary.caPercent,
                summary.caTotal > 0
                    ? '${summary.caScore.toStringAsFixed(0)} / ${summary.caTotal.toStringAsFixed(0)}'
                    : '-',
                colorScheme.primary),
            const SizedBox(height: 10),
            _buildScoreRow(
                isFinal ? AppStrings.finalExam : showPosition ? AppStrings.midtermExam : AppStrings.monthlyExam,
                summary.examPercent,
                summary.examTotal > 0
                    ? '${summary.examScore.toStringAsFixed(0)} / ${summary.examTotal.toStringAsFixed(0)}'
                    : '-',
                isFinal ? Colors.amber.shade700 : colorScheme.tertiary),
            const SizedBox(height: 10),
            _buildTotalRow(summary),
            if (summary.position != null && showPosition) ...[
              const SizedBox(height: 8),
              _positionBadge(summary.position!),
            ],
            if (teacherComment != null && teacherComment!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 14, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(teacherComment!,
                          style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(
      String label, double percent, String detail, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            )),
            Text(detail,
                style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            )),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 8,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(_scoreColor(percent, colorScheme)),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow(SubjectSummary s) {
    final totalPercent = s.combinedPercent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.total,
                style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            )),
            Text('${totalPercent.toStringAsFixed(1)}%',
                style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: _scoreColor(totalPercent, colorScheme),
            )),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: totalPercent / 100,
            minHeight: 10,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(_scoreColor(totalPercent, colorScheme)),
          ),
        ),
      ],
    );
  }

  Widget _positionBadge(int position) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: position <= 3
            ? Colors.amber.withValues(alpha: 0.15)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            position <= 3 ? Icons.emoji_events : Icons.sort,
            size: 14,
            color: position <= 3
                ? Colors.amber.shade700
                : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(AppStrings.positionLabel(position, _ordinal(position)),
              style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
          )),
        ],
      ),
    );
  }

  String _ordinal(int n) {
    if (n >= 11 && n <= 13) return AppStrings.ordinalDefault;
    switch (n % 10) {
      case 1: return AppStrings.ordinalFirst;
      case 2: return AppStrings.ordinalSecond;
      case 3: return AppStrings.ordinalThird;
      default: return AppStrings.ordinalDefault;
    }
  }
}

class _GradeBadge extends StatelessWidget {
  final String grade;
  final ColorScheme colorScheme;

  const _GradeBadge({required this.grade, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    Color color;
  switch (grade) {
    case AppStrings.gradeAPlus:
    case AppStrings.gradeA:
      color = Colors.green;
    case AppStrings.gradeBPlus:
    case AppStrings.gradeB:
      color = Colors.blue;
    case AppStrings.gradeCPlus:
    case AppStrings.gradeC:
      color = Colors.orange;
    case AppStrings.gradeD:
      color = Colors.deepOrange;
    default:
      color = Colors.red;
  }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(grade,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          )),
    );
  }
}

Widget _scoreBanner(ThemeData theme, ColorScheme colorScheme, String label,
    double avg, IconData icon, Color color) {
  return AuroraCard(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 2),
            Text('${avg.toStringAsFixed(1)}%',
                style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: _scoreColor(avg, colorScheme),
            )),
          ],
        ),
        const Spacer(),
        _GradeBadge(grade: _gradeFromPercent(avg), colorScheme: colorScheme),
      ],
    ),
  );
}

Widget _infoChip(ThemeData theme, ColorScheme colorScheme, String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.info_outline, size: 14, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(text,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: colorScheme.onSurfaceVariant)),
      ],
    ),
  );
}

Color _scoreColor(double percent, ColorScheme colorScheme) {
  if (percent >= 70) return Colors.green;
  if (percent >= 50) return Colors.orange;
  return Colors.red;
}

String _gradeFromPercent(double percent) {
  if (percent >= 90) return AppStrings.gradeAPlus;
  if (percent >= 80) return AppStrings.gradeA;
  if (percent >= 70) return AppStrings.gradeBPlus;
  if (percent >= 60) return AppStrings.gradeB;
  if (percent >= 50) return AppStrings.gradeC;
  if (percent >= 40) return AppStrings.gradeD;
  return AppStrings.gradeF;
}

Widget _loadingState(ThemeData theme) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(AppStrings.loadingResults,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ],
    ),
  );
}

Widget _errorState(ThemeData theme, ColorScheme colorScheme, String error) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: colorScheme.error),
          const SizedBox(height: 16),
          Text(error, style: theme.textTheme.bodyLarge),
        ],
      ),
    ),
  );
}

Widget _emptyState(ThemeData theme, ColorScheme colorScheme, String message) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.assignment_outlined,
              size: 64, color: colorScheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(message, style: theme.textTheme.bodyLarge),
        ],
      ),
    ),
  );
}
