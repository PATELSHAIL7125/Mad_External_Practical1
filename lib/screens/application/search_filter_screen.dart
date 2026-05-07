import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/application_provider.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final _searchController = TextEditingController();
// Search_filter screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search & Filter')),
      body: Consumer<ApplicationProvider>(
        builder: (context, provider, child) {
          final apps = provider.applications;
          
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by Company or Role...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear), 
                      onPressed: () {
                        _searchController.clear();
                        provider.setSearchQuery('');
                      },
                    ),
                  ),
                  onChanged: (val) => provider.setSearchQuery(val),
                ),
              ),
              
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: ['All', 'Applied', 'Shortlisted', 'Interview Scheduled', 'Rejected', 'Selected'].map((status) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(status == 'Interview Scheduled' ? 'Interview' : status),
                        selected: provider.filterStatus == status,
                        onSelected: (selected) {
                          provider.setFilterStatus(status);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const Divider(height: 32),
              
              Expanded(
                child: apps.isEmpty 
                  ? const Center(child: Text('No matching applications found.'))
                  : ListView.builder(
                      itemCount: apps.length,
                      itemBuilder: (context, index) {
                        final app = apps[index];
                        return ListTile(
                          title: Text(app.companyName),
                          subtitle: Text('${app.jobRole} • ${app.status}'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Show status update dialog or detail
                            _showStatusDialog(context, provider, app.id, app.status);
                          },
                        );
                      },
                    ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showStatusDialog(BuildContext context, ApplicationProvider provider, String id, String currentStatus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Applied', 'Shortlisted', 'Interview Scheduled', 'Rejected', 'Selected'].map((status) {
            return ListTile(
              title: Text(status),
              leading: Radio<String>(
                value: status,
                groupValue: currentStatus,
                onChanged: (val) {
                  provider.updateStatus(id, val!);
                  Navigator.pop(context);
                },
              ),
              onTap: () {
                provider.updateStatus(id, status);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
