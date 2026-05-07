import 'package:hive/hive.dart';

part 'job_application_model.g.dart';

@HiveType(typeId: 1)
class JobApplicationModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String companyName;
  
  @HiveField(2)
  final String jobRole;
  
  @HiveField(3)
  final String status; // Applied, Shortlisted, Interview Scheduled, Rejected, Selected
  
  @HiveField(4)
  final String dateApplied;
  
  @HiveField(5)
  final String resumeId; // Link to ResumeModel

  JobApplicationModel({
    required this.id,
    required this.companyName,
    required this.jobRole,
    required this.status,
    required this.dateApplied,
    required this.resumeId,
  });
}
