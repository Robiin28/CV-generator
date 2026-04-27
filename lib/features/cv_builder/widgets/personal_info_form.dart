import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resume_model.dart';
import '../../../core/services/resume_service.dart';

class PersonalInfoForm extends StatelessWidget {
  const PersonalInfoForm({super.key});

  Widget _buildInputField(String label, String initialValue, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF64748B),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF0A2540), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final resumeService = context.read<ResumeService>();
    final personalInfo = resumeService.currentResume?.personalInfo;

    if (personalInfo == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Photo Uploader Section
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
            ),
            child: const Icon(Icons.person_outline, size: 40, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0A2540),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Upload Photo', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 32),

          // Form Fields
          _buildInputField('Full Name', personalInfo.fullName, (val) {
            final current = context.read<ResumeService>().currentResume!.personalInfo;
            context.read<ResumeService>().updatePersonalInfo(current.copyWith(fullName: val));
          }),
          const SizedBox(height: 24),
          
          _buildInputField('Job Title', personalInfo.jobTitle ?? '', (val) {
            final current = context.read<ResumeService>().currentResume!.personalInfo;
            context.read<ResumeService>().updatePersonalInfo(current.copyWith(jobTitle: val));
          }),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _buildInputField('Email Address', personalInfo.email, (val) {
                  final current = context.read<ResumeService>().currentResume!.personalInfo;
                  context.read<ResumeService>().updatePersonalInfo(current.copyWith(email: val));
                }),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInputField('Phone Number', personalInfo.phone, (val) {
                  final current = context.read<ResumeService>().currentResume!.personalInfo;
                  context.read<ResumeService>().updatePersonalInfo(current.copyWith(phone: val));
                }),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _buildInputField('Location', personalInfo.location, (val) {
                  final current = context.read<ResumeService>().currentResume!.personalInfo;
                  context.read<ResumeService>().updatePersonalInfo(current.copyWith(location: val));
                }),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInputField('LinkedIn', personalInfo.linkedin ?? '', (val) {
                  final current = context.read<ResumeService>().currentResume!.personalInfo;
                  context.read<ResumeService>().updatePersonalInfo(current.copyWith(linkedin: val));
                }),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CUSTOM FIELDS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A2540),
                  letterSpacing: 1.0,
                ),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Field'),
                onPressed: () {
                  final current = context.read<ResumeService>().currentResume!.personalInfo;
                  final updatedFields = [...(current.customFields ?? []), CustomField(label: 'New Field', value: '')];
                  context.read<ResumeService>().updatePersonalInfo(current.copyWith(customFields: updatedFields));
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0A2540),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (personalInfo.customFields != null)
            ...personalInfo.customFields!.asMap().entries.map((entry) {
              final idx = entry.key;
              final field = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildInputField('Label', field.label, (val) {
                        final current = context.read<ResumeService>().currentResume!.personalInfo;
                        final updatedFields = List<CustomField>.from(current.customFields!);
                        updatedFields[idx] = CustomField(label: val, value: field.value);
                        context.read<ResumeService>().updatePersonalInfo(current.copyWith(customFields: updatedFields));
                      }),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: _buildInputField('Value', field.value, (val) {
                        final current = context.read<ResumeService>().currentResume!.personalInfo;
                        final updatedFields = List<CustomField>.from(current.customFields!);
                        updatedFields[idx] = CustomField(label: field.label, value: val);
                        context.read<ResumeService>().updatePersonalInfo(current.copyWith(customFields: updatedFields));
                      }),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
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
