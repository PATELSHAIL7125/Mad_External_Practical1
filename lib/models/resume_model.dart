import 'package:hive/hive.dart';

part 'resume_model.g.dart';

@HiveType(typeId: 0)
class ResumeModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String fullName;
  
  @HiveField(2)
  final String email;
  
  @HiveField(3)
  final String education;
  
  @HiveField(4)
  final String skills;
  
  @HiveField(5)
  final String? experience;

  ResumeModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.education,
    required this.skills,
    this.experience,
  });
}
