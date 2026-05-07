import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/resume_model.dart';
import 'package:uuid/uuid.dart';

class ResumeProvider with ChangeNotifier {
  Box<ResumeModel>? _resumeBox;
  List<ResumeModel> _resumes = [];

  List<ResumeModel> get resumes => _resumes;

  ResumeProvider() {
    _init();
  }

  Future<void> _init() async {
    _resumeBox = await Hive.openBox<ResumeModel>('resumes');
    _resumes = _resumeBox!.values.toList();
    notifyListeners();
  }

  Future<void> addResume(ResumeModel resume) async {
    await _resumeBox!.put(resume.id, resume);
    _resumes = _resumeBox!.values.toList();
    notifyListeners();
  }

  Future<void> updateResume(ResumeModel resume) async {
    await resume.save();
    _resumes = _resumeBox!.values.toList();
    notifyListeners();
  }

  Future<void> deleteResume(String id) async {
    await _resumeBox!.delete(id);
    _resumes = _resumeBox!.values.toList();
    notifyListeners();
  }

  ResumeModel? getResumeById(String id) {
    return _resumeBox?.get(id);
  }
}
