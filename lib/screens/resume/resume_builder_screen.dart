import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/resume_model.dart';
import '../../providers/resume_provider.dart';

class ResumeBuilderScreen extends StatefulWidget {
  final ResumeModel? resume;
  const ResumeBuilderScreen({super.key, this.resume});

  @override
  State<ResumeBuilderScreen> createState() => _ResumeBuilderScreenState();
}

class _ResumeBuilderScreenState extends State<ResumeBuilderScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _eduController;
  late TextEditingController _skillsController;
  late TextEditingController _expController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.resume?.fullName);
    _emailController = TextEditingController(text: widget.resume?.email);
    _eduController = TextEditingController(text: widget.resume?.education);
    _skillsController = TextEditingController(text: widget.resume?.skills);
    _expController = TextEditingController(text: widget.resume?.experience);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.resume == null ? 'Build Resume' : 'Edit Resume')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSectionHeader('Personal Details'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person)),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 30),
            
            _buildSectionHeader('Education'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _eduController,
              decoration: const InputDecoration(labelText: 'Degree & University', prefixIcon: Icon(Icons.school)),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 30),

            _buildSectionHeader('Skills'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _skillsController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Skills (comma separated)',
                alignLabelWithHint: true,
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 30),

            _buildSectionHeader('Experience (Optional)'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _expController,
              decoration: const InputDecoration(labelText: 'Summary', prefixIcon: Icon(Icons.work)),
            ),
            
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _saveResume,
              child: const Text('Save Resume'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveResume() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<ResumeProvider>(context, listen: false);
      final resume = ResumeModel(
        id: widget.resume?.id ?? const Uuid().v4(),
        fullName: _nameController.text,
        email: _emailController.text,
        education: _eduController.text,
        skills: _skillsController.text,
        experience: _expController.text,
      );

      if (widget.resume == null) {
        await provider.addResume(resume);
      } else {
        await provider.updateResume(resume);
      }
      if (mounted) Navigator.pop(context);
    }
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigoAccent),
    );
  }
}
