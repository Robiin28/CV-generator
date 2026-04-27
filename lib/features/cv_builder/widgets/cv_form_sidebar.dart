import 'package:flutter/material.dart';
import 'personal_info_form.dart';
import 'experience_form.dart';
import 'education_form.dart';
import 'skills_form.dart';
import 'projects_form.dart';
import 'summary_form.dart';
import 'certifications_form.dart';
import 'volunteering_form.dart';

class CvFormSidebar extends StatefulWidget {
  const CvFormSidebar({super.key});

  @override
  State<CvFormSidebar> createState() => _CvFormSidebarState();
}

class _CvFormSidebarState extends State<CvFormSidebar> {
  int _currentStep = 0;
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _steps = [
    {'title': 'Personal', 'icon': Icons.person_outline, 'form': const PersonalInfoForm()},
    {'title': 'Summary', 'icon': Icons.description_outlined, 'form': const SummaryForm()},
    {'title': 'Experience', 'icon': Icons.work_outline, 'form': const ExperienceForm()},
    {'title': 'Education', 'icon': Icons.school_outlined, 'form': const EducationForm()},
    {'title': 'Skills', 'icon': Icons.psychology_outlined, 'form': const SkillsForm()},
    {'title': 'Projects', 'icon': Icons.code_outlined, 'form': const ProjectsForm()},
    {'title': 'Certifications', 'icon': Icons.verified_outlined, 'form': const CertificationsForm()},
    {'title': 'Volunteering', 'icon': Icons.volunteer_activism_outlined, 'form': const VolunteeringForm()},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return Container(
      color: surfaceColor,
      child: Column(
        children: [
          // Category Navigation Bar with Scroll Indicators
          Stack(
            children: [
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200)),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _steps.length,
                  itemBuilder: (context, index) {
                    final isSelected = _currentStep == index;
                    return GestureDetector(
                      onTap: () => setState(() => _currentStep = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 12),
                        width: 90,
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? (isDark ? Colors.blueAccent.withOpacity(0.1) : const Color(0xFF0A2540).withOpacity(0.05))
                            : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? (isDark ? Colors.blueAccent : const Color(0xFF0A2540)) : (isDark ? Colors.white10 : Colors.grey.shade200),
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _steps[index]['icon'],
                              color: isSelected ? (isDark ? Colors.blueAccent : const Color(0xFF0A2540)) : (isDark ? Colors.white54 : const Color(0xFF475569)),
                              size: 24,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _steps[index]['title'],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? (isDark ? Colors.blueAccent : const Color(0xFF0A2540)) : (isDark ? Colors.white54 : const Color(0xFF475569)),
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
              // Right side fade indicator
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: Container(
                    width: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [surfaceColor.withOpacity(0), surfaceColor],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),

          // Progress Guider Line
          LinearProgressIndicator(
            value: (_currentStep + 1) / _steps.length,
            backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(isDark ? Colors.blueAccent : const Color(0xFF0A2540)),
            minHeight: 3,
          ),

          // Form Header & Navigation Buttons
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _steps[_currentStep]['title'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline, size: 14, color: isDark ? Colors.blueAccent : const Color(0xFF64748B)),
                          const SizedBox(width: 6),
                          Text(
                            'Step ${_currentStep + 1} of ${_steps.length}',
                            style: TextStyle(color: isDark ? Colors.white54 : const Color(0xFF64748B), fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _currentStep > 0 ? () => setState(() => _currentStep--) : null,
                      icon: const Icon(Icons.arrow_back_ios, size: 18),
                      tooltip: 'Previous Step',
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _currentStep < _steps.length - 1 ? () => setState(() => _currentStep++) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.blueAccent : const Color(0xFF0A2540),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Next Step', style: TextStyle(fontWeight: FontWeight.bold)),
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
