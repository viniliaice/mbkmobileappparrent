import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/message_provider.dart';
import '../providers/auth_provider.dart';
import '../services/supabase_service.dart';
import '../theme/aurora_background.dart';
import '../widgets/aurora_card.dart';
import '../widgets/aurora_button.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.user != null) {
        context.read<MessageProvider>().loadInbox(auth.user!.id);
        context.read<MessageProvider>().loadSent(auth.user!.id);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _composeMessage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _ComposeSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    Text('Messages',
                        style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.edit_outlined,
                            color: colorScheme.primary),
                        onPressed: () => _composeMessage(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
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
                    tabs: [
                      Consumer<MessageProvider>(
                        builder: (_, mp, _) => Tab(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Inbox'),
                              if (mp.unreadCount > 0) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: colorScheme.error,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text('${mp.unreadCount}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const Tab(text: 'Sent'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _MessageList(inbox: true),
                    _MessageList(inbox: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  final bool inbox;
  const _MessageList({required this.inbox});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<MessageProvider>(
      builder: (context, mp, _) {
        final loading = inbox ? mp.loadingInbox : mp.loadingSent;
        final messages = inbox ? mp.inbox : mp.sent;
        final hasMore = inbox ? mp.hasMoreInbox : false;

        if (loading && messages.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (messages.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.email_outlined,
                      size: 64, color: colorScheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(inbox ? 'No messages' : 'No sent messages',
                      style: theme.textTheme.bodyLarge),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            final auth = context.read<AuthProvider>();
            if (auth.user != null) {
              if (inbox) {
                await mp.loadInbox(auth.user!.id);
              } else {
                await mp.loadSent(auth.user!.id);
              }
            }
          },
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: messages.length + (inbox && hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (inbox && hasMore && index == messages.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: mp.loadingInbox
                        ? const CircularProgressIndicator()
                        : TextButton(
                            onPressed: () {
                              final auth = context.read<AuthProvider>();
                              if (auth.user != null) {
                                mp.loadMoreInbox(auth.user!.id);
                              }
                            },
                            child: const Text('Load more'),
                          ),
                  ),
                );
              }
              final m = messages[index];
              final df = DateFormat('MMM dd');
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AuroraCard(
                  padding: const EdgeInsets.all(14),
                  onTap: () {
                    if (inbox && !m.isRead) {
                      mp.markRead(m.id);
                    }
                    showDialog(
                      context: context,
                      builder: (_) => _MessageDetailDialog(message: m),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: inbox
                              ? (m.isRead
                                  ? colorScheme.surfaceContainerHighest
                                  : colorScheme.primary.withValues(alpha: 0.15))
                              : colorScheme.secondaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            (inbox ? m.senderName : m.recipientName)[0]
                                .toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: inbox
                                  ? (m.isRead
                                      ? colorScheme.onSurfaceVariant
                                      : colorScheme.primary)
                                  : colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              inbox ? m.senderName : m.recipientName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: m.isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              m.subject,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: m.isRead
                                    ? FontWeight.normal
                                    : FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(df.format(m.createdAt),
                          style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _MessageDetailDialog extends StatelessWidget {
  final dynamic message;
  const _MessageDetailDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final df = DateFormat('MMM dd, yyyy HH:mm');

    return Dialog(
      backgroundColor: Colors.transparent,
      child: AuroraCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(message.subject,
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('From: ${message.senderName}',
                style: theme.textTheme.bodySmall),
            Text('To: ${message.recipientName}',
                style: theme.textTheme.bodySmall),
            Text(df.format(message.createdAt),
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 16),
            Container(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
            const SizedBox(height: 8),
            Text(message.body, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ComposeSheet extends StatefulWidget {
  const _ComposeSheet();

  @override
  State<_ComposeSheet> createState() => _ComposeSheetState();
}

class _ComposeSheetState extends State<_ComposeSheet> {
  final _formKey = GlobalKey<FormState>();
  final _subjectCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  String? _selectedRecipientId;
  List<Map<String, dynamic>> _teachers = [];

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  Future<void> _loadTeachers() async {
    final data = await SupabaseService().getUsersByRole('teacher');
    final supervisors = await SupabaseService().getUsersByRole('supervisor');
    setState(() {
      _teachers = [...data, ...supervisors];
    });
  }

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New Message',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Recipient',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                prefixIcon: const Icon(Icons.person_outline),
              ),
              items: _teachers
                  .map((t) => DropdownMenuItem(
                        value: t['id'] as String,
                        child: Text(t['name'] as String? ?? ''),
                      ))
                  .toList(),
              onChanged: (v) => _selectedRecipientId = v,
              validator: (v) => v == null ? 'Select a recipient' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _subjectCtrl,
              decoration: InputDecoration(
                labelText: 'Subject',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter subject' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bodyCtrl,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Message',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                alignLabelWithHint: true,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter message' : null,
            ),
            const SizedBox(height: 16),
            Consumer<MessageProvider>(
              builder: (context, mp, _) {
                return AuroraButton(
                  label: mp.sending ? 'Sending...' : 'Send',
                  loading: mp.sending,
                  onPressed: mp.sending
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          final auth = context.read<AuthProvider>();
                          if (auth.user == null ||
                              _selectedRecipientId == null) { return; }
                          final ok = await mp.sendMessage(
                            auth.user!.id,
                            _selectedRecipientId!,
                            _subjectCtrl.text.trim(),
                            _bodyCtrl.text.trim(),
                          );
                          if (ok && context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
