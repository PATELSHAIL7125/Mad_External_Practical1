import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../models/job_application_model.dart';
import '../../providers/application_provider.dart';
import '../../providers/resume_provider.dart';

class ApplicationEntryScreen extends StatefulWidget {
  const ApplicationEntryScreen({super.key});

  @override
  State<ApplicationEntryScreen> createState() => _ApplicationEntryScreenState();
}

class _ApplicationEntryScreenState extends State<ApplicationEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _roleController = TextEditingController();
  String _selectedStatus = 'Applied';
  String? _selectedResumeId;
  DateTime _selectedDate = DateTime.now();

  final List<String> _statusOptions = ['Applied', 'Shortlisted', 'Interview Scheduled', 'Rejected', 'Selected'];

  @override
  Widget build(BuildContext context) {
    final resumes = Provider.of<ResumeProvider>(context).resumes;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Job Application')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Company Name', prefixIcon: Icon(Icons.business)),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Job Role', prefixIcon: Icon(Icons.work_outline)),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Application Status', prefixIcon: Icon(Icons.sync)),
                items: _statusOptions.map((status) => DropdownMenuItem(value: status, child: Text(status))).toList(),
                onChanged: (val) => setState(() => _selectedStatus = val!),
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedResumeId,
                decoration: const InputDecoration(labelText: 'Select Resume', prefixIcon: Icon(Icons.description)),
                items: resumes.map((resume) => DropdownMenuItem(value: resume.id, child: Text(resume.fullName))).toList(),
                onChanged: (val) => setState(() => _selectedResumeId = val),
                validator: (v) => v == null ? 'Please select a resume' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Date Applied',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                controller: TextEditingController(text: DateFormat('yyyy-MM-dd').format(_selectedDate)),
                readOnly: true,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveApplication,
                child: const Text('Save Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveApplication() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<ApplicationProvider>(context, listen: false);
      final application = JobApplicationModel(
        id: const Uuid().v4(),
        companyName: _companyController.text,
        jobRole: _roleController.text,
        status: _selectedStatus,
        dateApplied: DateFormat('yyyy-MM-dd').format(_selectedDate),
        resumeId: _selectedResumeId!,
      );

      await provider.addApplication(application);
      if (mounted) Navigator.pop(context);
    }
  }
}
