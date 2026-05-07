import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/job_application_model.dart';

class ApplicationProvider with ChangeNotifier {
  Box<JobApplicationModel>? _appBox;
  List<JobApplicationModel> _applications = [];
  String _searchQuery = '';
  String _filterStatus = 'All';

  List<JobApplicationModel> get applications {
    return _applications.where((app) {
      final matchesSearch = app.companyName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            app.jobRole.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _filterStatus == 'All' || app.status == _filterStatus;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  String get filterStatus => _filterStatus;

  ApplicationProvider() {
    _init();
  }

  Future<void> _init() async {
    _appBox = await Hive.openBox<JobApplicationModel>('applications');
    _applications = _appBox!.values.toList();
    notifyListeners();
  }

  Future<void> addApplication(JobApplicationModel application) async {
    await _appBox!.put(application.id, application);
    _applications = _appBox!.values.toList();
    notifyListeners();
  }

  Future<void> updateStatus(String id, String newStatus) async {
    final app = _appBox!.get(id);
    if (app != null) {
      final updatedApp = JobApplicationModel(
        id: app.id,
        companyName: app.companyName,
        jobRole: app.jobRole,
        status: newStatus,
        dateApplied: app.dateApplied,
        resumeId: app.resumeId,
      );
      await _appBox!.put(id, updatedApp);
      _applications = _appBox!.values.toList();
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  Map<String, int> getStatusDistribution() {
    Map<String, int> distribution = {
      'Applied': 0,
      'Shortlisted': 0,
      'Interview Scheduled': 0,
      'Rejected': 0,
      'Selected': 0,
    };
    for (var app in _applications) {
      if (distribution.containsKey(app.status)) {
        distribution[app.status] = distribution[app.status]! + 1;
      }
    }
    return distribution;
  }
}
