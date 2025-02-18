import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:speak_up/core/services/complaint_service.dart';
import 'complaint_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
final _complaintService = ComplaintService();
  Map<String, int> _statistics = {
    'total': 0,
    'inProgress': 0,
    'resolved': 0,
    'rejected': 0
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      final stats = await _complaintService.getStatistics();
      if (mounted) {
        setState(() {
          _statistics = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadStatistics,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Total Complaints',
                    _statistics['total'].toString(),
                    CupertinoIcons.exclamationmark_circle,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'In Progress',
                    _statistics['inProgress'].toString(),
                    CupertinoIcons.clock,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Resolved',
                    _statistics['resolved'].toString(),
                    Icons.check_circle_outline,
                    Colors.green,
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Pending',
                  '6',
                  Icons.hourglass_empty,
                  Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Category-wise Breakdown
          const Text(
            'Category-wise Breakdown',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildCategoryProgress('Infrastructure', 0.4, Colors.purple),
          const SizedBox(height: 8),
          _buildCategoryProgress('Education', 0.3, Colors.blue),
          const SizedBox(height: 8),
          _buildCategoryProgress('Healthcare', 0.2, Colors.green),
          const SizedBox(height: 8),
          _buildCategoryProgress('Transportation', 0.1, Colors.orange),
          const SizedBox(height: 24),
          // Recent Complaints
          const Text(
            'Recent Complaints',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.report_outlined, color: Colors.white),
                  ),
                  title: Text('Complaint #${index + 1}'),
                  subtitle: const Text('Status: Under Review'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComplaintDetailsScreen(complaintId: index + 1),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    ));
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryProgress(String category, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category),
            Text('${(progress * 100).toInt()}%'),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }
}