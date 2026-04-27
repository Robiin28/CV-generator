import 'package:flutter/material.dart';

import 'personal_info_form.dart';
import 'summary_form.dart';
import 'experience_form.dart';
import 'education_form.dart';
import 'skills_form.dart';
import 'projects_form.dart';
import 'languages_form.dart';
import 'certifications_form.dart';
import 'volunteering_form.dart';
import 'custom_sections_form.dart';

class CvFormSidebar extends StatefulWidget {
  const CvFormSidebar({super.key});

  @override
  State<CvFormSidebar> createState() => _CvFormSidebarState();
}

class _CvFormSidebarState extends State<CvFormSidebar> {
  int _currentStep = 0;

  final List<Map<String, dynamic>> _steps = [
    {'title': 'Personal Info', 'icon': Icons.person_outline, 'form': const PersonalInfoForm()},
    {'title': 'Summary', 'icon': Icons.description_outlined, 'form': const SummaryForm()},
    {'title': 'Experience', 'icon': Icons.work_outline, 'form': const ExperienceForm()},
    {'title': 'Education', 'icon': Icons.school_outlined, 'form': const EducationForm()},
    {'title': 'Skills', 'icon': Icons.bolt_outlined, 'form': const SkillsForm()},
    {'title': 'Projects', 'icon': Icons.code_outlined, 'form': const ProjectsForm()},
    {'title': 'Languages', 'icon': Icons.language_outlined, 'form': const LanguagesForm()},
    {'title': 'Certifications', 'icon': Icons.verified_outlined, 'form': const CertificationsForm()},
    {'title': 'Volunteering', 'icon': Icons.favorite_outline, 'form': const VolunteeringForm()},
    {'title': 'Add Sections', 'icon': Icons.add_circle_outline, 'form': const CustomSectionsForm()},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Category Navigation Bar
          Container(
            height: 90,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _steps.length,
              itemBuilder: (context, index) {
                final isSelected = _currentStep == index;
                return GestureDetector(
                  onTap: () => setState(() => _currentStep = index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 85,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: isSelected ? const Color(0xFF0A2540) : Colors.grey.shade200,
                        width: isSelected ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _steps[index]['icon'],
                          color: isSelected ? const Color(0xFF0A2540) : const Color(0xFF475569),
                          size: 22,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _steps[index]['title'],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? const Color(0xFF0A2540) : const Color(0xFF64748B),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Form Header & Navigation Buttons
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _steps[_currentStep]['title'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Complete the details below.',
                        style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: _currentStep > 0 ? () => setState(() => _currentStep--) : null,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text('Prev', style: TextStyle(color: Color(0xFF334155), fontSize: 13)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _currentStep < _steps.length - 1 ? () => setState(() => _currentStep++) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A2540),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: const Text('Next', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Active Form Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _steps[_currentStep]['form'],
            ),
          ),
        ],
      ),
    );
  }
}
