import 'package:flutter/material.dart';

class OrgDashboardScreen extends StatelessWidget {
  const OrgDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data for Analytics
    final List<Map<String, dynamic>> scores = [
      {'title': 'Efficiency Score', 'value': '85/100', 'color': Colors.blue},
      {'title': 'Patient Sat.', 'value': '4.8/5.0', 'color': Colors.green},
      {'title': 'Provider Sat.', 'value': '92/100', 'color': Colors.orange},
    ];

    final List<Map<String, dynamic>> kpis = [
      {'title': 'Unique Visits', 'value': '142', 'change': '+12%', 'icon': Icons.people},
      {'title': 'Avg Wait Time', 'value': '18m', 'change': '-2m', 'icon': Icons.timer},
      {'title': 'New Patients', 'value': '24', 'change': '+5%', 'icon': Icons.person_add},
    ];
    
    // Mock Critical Alert Logic (High Bar)
    const bool hasCriticalAlert = true; // Simulating 'Wait Time > 45m'
    const String alertMessage = 'CRITICAL: Cardiology Wait Times > 45m. Immediate action required.';

    return Scaffold(
      appBar: AppBar(
        title: const Text('MiGenesys Care'),
        actions: [
          Stack(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
              if (hasCriticalAlert)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
                    constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                  ),
                ),
            ],
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Smart Alert Banner
            if (hasCriticalAlert)
              Container(
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
                        alertMessage,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                      onPressed: () { _showAIAssistDialog(context); }, // Link to AI for resolution
                      child: const Text('Resolve', style: TextStyle(color: Colors.red)),
                    )
                  ],
                ),
              ),
            const Text(
              'Practice Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Multi-Factor Scores
            Row(
              children: scores.map((score) => Expanded(
                child: Card(
                  color: (score['color'] as Color).withOpacity(0.1),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(score['value'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: score['color'])),
                        const SizedBox(height: 4),
                        Text(score['title'], style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 16),
            // KPI Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns for mobile/tablet
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
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
                        Icon(kpi['icon'], size: 32, color: Theme.of(context).primaryColor),
                        const SizedBox(height: 8),
                        Text(
                          kpi['value'],
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          kpi['title'],
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          kpi['change'],
                          style: TextStyle(
                            color: kpi['change'].toString().startsWith('+') ? Colors.green : Colors.red,
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAIAssistDialog(context);
        },
        icon: const Icon(Icons.auto_awesome),
        label: const Text('MiGenesys Assist'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
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
              separatorBuilder: (_, __) => const SizedBox(width: 8),
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
