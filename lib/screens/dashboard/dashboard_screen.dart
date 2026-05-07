import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/application_provider.dart';
import '../../widgets/custom_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Syncing with cloud...'), behavior: SnackBarBehavior.floating),
              );
              // Simulate sync delay
              Future.delayed(const Duration(seconds: 2), () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sync Complete (Offline-first)'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
                );
              });
            },
          ),
        ],
      ),
      body: Consumer<ApplicationProvider>(
        builder: (context, provider, child) {
          final apps = provider.applications;
          final stats = provider.getStatusDistribution();
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildStatGrid(apps.length, stats),
                const SizedBox(height: 32),
                const Text(
                  'Application Distribution',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                const SizedBox(height: 16),
                _buildStatusChart(stats),
                const SizedBox(height: 32),
                const Text(
                  'Recent Activities',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                const SizedBox(height: 16),
                _buildRecentApplications(apps),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back,',
          style: TextStyle(fontSize: 16, color: Colors.grey[400]),
        ),
        const Text(
          'Career Progress',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatGrid(int total, Map<String, int> stats) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard('Total', total.toString(), const Color(0xFF6366F1)),
        _buildStatCard('Applied', (stats['Applied'] ?? 0).toString(), const Color(0xFFF59E0B)),
        _buildStatCard('Interviews', (stats['Interview Scheduled'] ?? 0).toString(), const Color(0xFF8B5CF6)),
        _buildStatCard('Selected', (stats['Selected'] ?? 0).toString(), const Color(0xFF10B981)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return GlassCard(
      gradient: [color.withOpacity(0.2), color.withOpacity(0.05)],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: Colors.grey[300], fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChart(Map<String, int> stats) {
    return GlassCard(
      child: Container(
        height: 220,
        padding: const EdgeInsets.all(24),
        child: PieChart(
          PieChartData(
            sectionsSpace: 4,
            centerSpaceRadius: 40,
            sections: [
              PieChartSectionData(value: (stats['Applied'] ?? 0).toDouble(), color: const Color(0xFFF59E0B), title: 'App', radius: 50, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              PieChartSectionData(value: (stats['Interview Scheduled'] ?? 0).toDouble(), color: const Color(0xFF8B5CF6), title: 'Int', radius: 50, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              PieChartSectionData(value: (stats['Selected'] ?? 0).toDouble(), color: const Color(0xFF10B981), title: 'Sel', radius: 50, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              PieChartSectionData(value: (stats['Rejected'] ?? 0).toDouble(), color: Colors.redAccent, title: 'Rej', radius: 50, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentApplications(List apps) {
    final recent = apps.reversed.take(5).toList();
    if (recent.isEmpty) {
      return const GlassCard(
        child: Center(child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Text('Start applying to track progress!'),
        )),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recent.length,
      itemBuilder: (context, index) {
        final app = recent[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.business_rounded, color: Colors.blueAccent),
              ),
              title: Text(app.companyName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(app.jobRole),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(app.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getStatusColor(app.status).withOpacity(0.3)),
                ),
                child: Text(
                  app.status,
                  style: TextStyle(color: _getStatusColor(app.status), fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Applied': return Colors.orange;
      case 'Shortlisted': return Colors.blue;
      case 'Interview Scheduled': return Colors.purple;
      case 'Selected': return Colors.green;
      case 'Rejected': return Colors.red;
      default: return Colors.grey;
    }
  }
}
