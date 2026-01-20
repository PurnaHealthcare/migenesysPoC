import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/features/org_dashboard/view_model/dashboard_view_model.dart';

class OrgDashboardScreen extends ConsumerWidget {
  const OrgDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpisAsync = ref.watch(dashboardKpisProvider);
    final scoresAsync = ref.watch(dashboardScoresProvider);
    final alertAsync = ref.watch(dashboardCriticalAlertProvider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Smart Alert Banner
          alertAsync.when(
            data: (alert) => alert.isActive
                ? Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            alert.message,
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () { _showAIAssistDialog(context); },
                          child: const Text('Resolve', style: TextStyle(color: Colors.red)),
                        )
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (e, s) => const SizedBox.shrink(),
          ),
          const Text(
            'Practice Overview',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Multi-Factor Scores
          scoresAsync.when(
            data: (scores) => IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: scores.map((score) => Expanded(
                  child: Card(
                    color: score.color.withValues(alpha: 0.1),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(score.value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: score.color)),
                          const SizedBox(height: 4),
                          Text(score.title, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ),
            loading: () => const Center(child: LinearProgressIndicator()),
            error: (e, s) => Text('Error: $e'),
          ),
          const SizedBox(height: 16),
          // KPI Grid
          kpisAsync.when(
            data: (kpis) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: kpis.length,
              itemBuilder: (context, index) {
                final kpi = kpis[index];
                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(kpi.icon, size: 32, color: Theme.of(context).primaryColor),
                        const SizedBox(height: 8),
                        Text(
                          kpi.value,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          kpi.title,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          kpi.change,
                          style: TextStyle(
                            color: kpi.isPositiveChange ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Text('Error loading KPIs: $e'),
          ),
            const SizedBox(height: 24),
            // Visits by Specialty Chart Placeholder
            const Text(
              'Visits by Specialty',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              child: Container(
                height: 200,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pie_chart, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text(
                        'Chart Visualization Placeholder\n(Cardiology: 40%, GP: 30%, Neuro: 30%)',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }

  void _showAIAssistDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => const _AIAssistSheet(),
    );
  }
}

class _AIAssistSheet extends StatefulWidget {
  const _AIAssistSheet();

  @override
  State<_AIAssistSheet> createState() => _AIAssistSheetState();
}

class _AIAssistSheetState extends State<_AIAssistSheet> {
  final List<String> _messages = [
    'Hello! I am MiGenesys Assist. How can I help you improve your practice today?',
  ];

  final List<String> _suggestions = [
    'What needs immediate attention?',
    'Propose process improvements',
    'Identify Revenue at Risk',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: const Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text('MiGenesys Assist', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final isUser = index % 2 != 0;
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(_messages[index]),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _suggestions.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return Center(
                  child: ActionChip(
                    label: Text(_suggestions[index]),
                    onPressed: () {
                      setState(() {
                        _messages.add(_suggestions[index]);
                        // Mock AI Response
                        Future.delayed(const Duration(seconds: 1), () {
                          if (mounted) {
                            setState(() {
                              _messages.add(_getAIResponse(_suggestions[index]));
                            });
                          }
                        });
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _getAIResponse(String query) {
    if (query.contains('attention')) {
      return '⚠️ Immediate Attention:\nWait times in Cardiology have exceeded 45 mins this morning. Consider re-allocating staff from General Practice.';
    } else if (query.contains('Revenue')) {
      return '💰 Revenue Risk:\nWe noticed a 15% cancellation rate for Dr. Smith. Implementing automated SMS reminders could recover ~\$2k/month.';
    } else {
      return 'I can analyze workflow metrics to suggest improvements. Try asking about "Wait Times" or "Staff Burnout".';
    }
  }
}
