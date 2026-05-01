import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resume_model.dart';
import '../../../core/services/resume_service.dart';

class PersonalInfoForm extends StatelessWidget {
  const PersonalInfoForm({super.key});

  Widget _buildInputField(BuildContext context, String label, String initialValue, Function(String) onChanged, {String? hint}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white54 : const Color(0xFF64748B),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 6),
            if (hint != null)
              Tooltip(
                message: hint,
                triggerMode: TooltipTriggerMode.tap,
                child: Icon(Icons.info_outline, size: 14, color: isDark ? Colors.blueAccent : const Color(0xFF0A2540)),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (!isDark) BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            initialValue: initialValue,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              filled: true,
              hintText: label,
              hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.grey.shade400, fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: isDark ? Colors.blueAccent : const Color(0xFF0A2540), width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

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

          _buildInputField(context, 'Full Name', personalInfo.fullName, (val) {
            final current = context.read<ResumeService>().currentResume!.personalInfo;
            context.read<ResumeService>().updatePersonalInfo(current.copyWith(fullName: val));
          }, hint: 'Enter your legal name as it should appear on your CV.'),
          const SizedBox(height: 24),
          
          _buildInputField(context, 'Job Title', personalInfo.jobTitle ?? '', (val) {
            final current = context.read<ResumeService>().currentResume!.personalInfo;
            context.read<ResumeService>().updatePersonalInfo(current.copyWith(jobTitle: val));
          }, hint: 'The specific position you are applying for (e.g., Senior Developer).'),
          const SizedBox(height: 24),

          Wrap(
            spacing: 16,
            runSpacing: 24,
            children: [
              SizedBox(
                width: 300,
                child: _buildInputField(context, 'Email Address', personalInfo.email, (val) {
                  final current = context.read<ResumeService>().currentResume!.personalInfo;
                  context.read<ResumeService>().updatePersonalInfo(current.copyWith(email: val));
                }, hint: 'Use a professional email address.'),
              ),
              SizedBox(
                width: 300,
                child: _buildInputField(context, 'Phone Number', personalInfo.phone, (val) {
                  final current = context.read<ResumeService>().currentResume!.personalInfo;
                  context.read<ResumeService>().updatePersonalInfo(current.copyWith(phone: val));
                }, hint: 'Include your country code for international reach.'),
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
                child: _buildInputField(context, 'Location', personalInfo.location, (val) {
                  final current = context.read<ResumeService>().currentResume!.personalInfo;
                  context.read<ResumeService>().updatePersonalInfo(current.copyWith(location: val));
                }, hint: 'City, Country (e.g., London, UK).'),
              ),
              SizedBox(
                width: 300,
                child: _buildInputField(context, 'LinkedIn', personalInfo.linkedin ?? '', (val) {
                  final current = context.read<ResumeService>().currentResume!.personalInfo;
                  context.read<ResumeService>().updatePersonalInfo(current.copyWith(linkedin: val));
                }, hint: 'Paste your full LinkedIn profile URL.'),
              ),
              SizedBox(
                width: 300,
                child: _buildInputField(context, 'Portfolio / Website', personalInfo.website ?? '', (val) {
                  final current = context.read<ResumeService>().currentResume!.personalInfo;
                  context.read<ResumeService>().updatePersonalInfo(current.copyWith(website: val));
                }, hint: 'Optional: your portfolio or personal website URL.'),
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
                      child: _buildInputField(context, 'Label', field.label, (val) {
                        final current = context.read<ResumeService>().currentResume!.personalInfo;
                        final updatedFields = List<CustomField>.from(current.customFields!);
                        updatedFields[idx] = CustomField(label: val, value: field.value);
                        context.read<ResumeService>().updatePersonalInfo(current.copyWith(customFields: updatedFields));
                      }),
                    ),
                    SizedBox(
                      width: 200,
                      child: _buildInputField(context, 'Value', field.value, (val) {
                        final current = context.read<ResumeService>().currentResume!.personalInfo;
                        final updatedFields = List<CustomField>.from(current.customFields!);
                        updatedFields[idx] = CustomField(label: field.label, value: val);
                        context.read<ResumeService>().updatePersonalInfo(current.copyWith(customFields: updatedFields));
                      }),
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
