import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resume_model.dart';
import '../../../core/services/resume_service.dart';
import 'ai_input_field.dart';

class CertificationsForm extends StatelessWidget {
  const CertificationsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final certifications = context.watch<ResumeService>().currentResume?.certifications ?? [];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Certification'),
              onPressed: () {
                final newCertification = Certification(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: '',
                  issuer: '',
                  date: '',
                );
                context.read<ResumeService>().updateCertifications([...certifications, newCertification]);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : const Color(0xFF0A2540),
                side: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...certifications.asMap().entries.map((entry) {
            final index = entry.key;
            final cert = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AIInputField(
                            label: 'Certification Name', 
                            initialValue: cert.name, 
                            onChanged: (val) {
                              final current = context.read<ResumeService>().currentResume?.certifications ?? [];
                              final newList = List<Certification>.from(current);
                              newList[index] = newList[index].copyWith(name: val);
                              context.read<ResumeService>().updateCertifications(newList);
                            }, 
                            aiContext: 'professional certification name',
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                            final current = context.read<ResumeService>().currentResume?.certifications ?? [];
                            final newList = List<Certification>.from(current)..removeAt(index);
                            context.read<ResumeService>().updateCertifications(newList);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: AIInputField(
                            label: 'Issuer', 
                            initialValue: cert.issuer, 
                            onChanged: (val) {
                              final current = context.read<ResumeService>().currentResume?.certifications ?? [];
                              final newList = List<Certification>.from(current);
                              newList[index] = newList[index].copyWith(issuer: val);
                              context.read<ResumeService>().updateCertifications(newList);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AIInputField(
                            label: 'Date', 
                            initialValue: cert.date, 
                            onChanged: (val) {
                              final current = context.read<ResumeService>().currentResume?.certifications ?? [];
                              final newList = List<Certification>.from(current);
                              newList[index] = newList[index].copyWith(date: val);
                              context.read<ResumeService>().updateCertifications(newList);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
