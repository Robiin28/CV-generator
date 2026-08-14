import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resume_model.dart';
import '../../../core/services/resume_service.dart';
import 'ai_input_field.dart';

class PersonalInfoForm extends StatelessWidget {
  const PersonalInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    final personalInfo = context.watch<ResumeService>().currentResume?.personalInfo;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (personalInfo == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Photo Uploader Section
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isDark ? Colors.blueAccent.withValues(alpha: 0.3) : Colors.grey.shade200, width: 4),
                  color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
                ),
                child: Icon(Icons.person_outline, size: 45, color: isDark ? Colors.white24 : Colors.grey),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Color(0xFF0A2540), shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Profile Photo',
            style: TextStyle(color: isDark ? Colors.white70 : const Color(0xFF475569), fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Divider(color: isDark ? Colors.white10 : Colors.grey.shade200),
          const SizedBox(height: 32),

          AIInputField(
            label: 'Full Name', 
            initialValue: personalInfo.fullName, 
            onChanged: (val) {
              final current = context.read<ResumeService>().currentResume!.personalInfo;
              context.read<ResumeService>().updatePersonalInfo(current.copyWith(fullName: val));
            },
          ),
          const SizedBox(height: 24),
          
          AIInputField(
            label: 'Job Title', 
            initialValue: personalInfo.jobTitle ?? '', 
            onChanged: (val) {
              final current = context.read<ResumeService>().currentResume!.personalInfo;
              context.read<ResumeService>().updatePersonalInfo(current.copyWith(jobTitle: val));
            },
          ),
          const SizedBox(height: 24),

          Wrap(
            spacing: 16,
            runSpacing: 24,
            children: [
              SizedBox(
                width: 300,
                child: AIInputField(
                  label: 'Email Address', 
                  initialValue: personalInfo.email, 
                  onChanged: (val) {
                    final current = context.read<ResumeService>().currentResume!.personalInfo;
                    context.read<ResumeService>().updatePersonalInfo(current.copyWith(email: val));
                  },
                ),
              ),
              SizedBox(
                width: 300,
                child: AIInputField(
                  label: 'Phone Number', 
                  initialValue: personalInfo.phone, 
                  onChanged: (val) {
                    final current = context.read<ResumeService>().currentResume!.personalInfo;
                    context.read<ResumeService>().updatePersonalInfo(current.copyWith(phone: val));
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Wrap(
            spacing: 16,
            runSpacing: 24,
            children: [
              SizedBox(
                width: 300,
                child: AIInputField(
                  label: 'Location', 
                  initialValue: personalInfo.location, 
                  onChanged: (val) {
                    final current = context.read<ResumeService>().currentResume!.personalInfo;
                    context.read<ResumeService>().updatePersonalInfo(current.copyWith(location: val));
                  },
                ),
              ),
              SizedBox(
                width: 300,
                child: AIInputField(
                  label: 'LinkedIn', 
                  initialValue: personalInfo.linkedin ?? '', 
                  onChanged: (val) {
                    final current = context.read<ResumeService>().currentResume!.personalInfo;
                    context.read<ResumeService>().updatePersonalInfo(current.copyWith(linkedin: val));
                  },
                ),
              ),
              SizedBox(
                width: 300,
                child: AIInputField(
                  label: 'Portfolio / Website', 
                  initialValue: personalInfo.website ?? '', 
                  onChanged: (val) {
                    final current = context.read<ResumeService>().currentResume!.personalInfo;
                    context.read<ResumeService>().updatePersonalInfo(current.copyWith(website: val));
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Divider(color: isDark ? Colors.white10 : Colors.grey.shade200),
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CUSTOM FIELDS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : const Color(0xFF0A2540),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Add hobbies, links, or other info.',
                      style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Field'),
                onPressed: () {
                  final current = context.read<ResumeService>().currentResume!.personalInfo;
                  final updatedFields = <CustomField>[...(current.customFields ?? []), CustomField(label: 'New Field', value: '')];
                  context.read<ResumeService>().updatePersonalInfo(current.copyWith(customFields: updatedFields));
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : const Color(0xFF0A2540),
                  side: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (personalInfo.customFields != null)
            ...personalInfo.customFields!.asMap().entries.map((entry) {
              final idx = entry.key;
              final field = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    SizedBox(
                      width: 160,
                      child: AIInputField(
                        label: 'Label', 
                        initialValue: field.label, 
                        onChanged: (val) {
                          final current = context.read<ResumeService>().currentResume!.personalInfo;
                          final updatedFields = List<CustomField>.from(current.customFields!);
                          updatedFields[idx] = CustomField(label: val, value: field.value);
                          context.read<ResumeService>().updatePersonalInfo(current.copyWith(customFields: updatedFields));
                        },
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: AIInputField(
                        label: 'Value', 
                        initialValue: field.value, 
                        onChanged: (val) {
                          final current = context.read<ResumeService>().currentResume!.personalInfo;
                          final updatedFields = List<CustomField>.from(current.customFields!);
                          updatedFields[idx] = CustomField(label: field.label, value: val);
                          context.read<ResumeService>().updatePersonalInfo(current.copyWith(customFields: updatedFields));
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                      onPressed: () {
                        final current = context.read<ResumeService>().currentResume!.personalInfo;
                        final updatedFields = List<CustomField>.from(current.customFields!)..removeAt(idx);
                        context.read<ResumeService>().updatePersonalInfo(current.copyWith(customFields: updatedFields));
                      },
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
