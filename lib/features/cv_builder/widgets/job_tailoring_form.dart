import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/resume_service.dart';

class JobTailoringForm extends StatefulWidget {
  const JobTailoringForm({super.key});

  @override
  State<JobTailoringForm> createState() => _JobTailoringFormState();
}

class _JobTailoringFormState extends State<JobTailoringForm> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final resume = context.read<ResumeService>().currentResume;
    _titleController = TextEditingController(text: resume?.targetJobTitle ?? '');
    _descriptionController = TextEditingController(text: resume?.targetJobDescription ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTargetJob() {
    context.read<ResumeService>().updateTargetJob(
      _titleController.text,
      _descriptionController.text,
    );
  }

  void _startInteractiveTailoring() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter target job title and description first.')),
      );
      return;
    }

    _saveTargetJob();

    final resumeService = context.read<ResumeService>();
    resumeService.setInitialChatPrompt(
      "I have entered my target job title: '$title' and requirements. Let's do an interactive ATS-friendly enhancement of my CV. Ask me clarifying questions about my background relative to these requirements so we can build it together step-by-step!"
    );

    // Pop back to home screen (which will trigger index switch to AI tab)
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fill in your target job posting parameters. Once entered, you can start a step-by-step collaborative session with the AI Career Coach to optimize your CV sections interactively.',
          style: TextStyle(fontSize: 13, height: 1.4, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        
        Text(
          'TARGET JOB TITLE',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white54 : const Color(0xFF64748B),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          onChanged: (_) => _saveTargetJob(),
          decoration: InputDecoration(
            hintText: 'e.g. "Senior Fullstack Engineer"',
            fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(height: 20),

        Text(
          'JOB DESCRIPTION / REQUIREMENTS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white54 : const Color(0xFF64748B),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          maxLines: 10,
          onChanged: (_) => _saveTargetJob(),
          decoration: InputDecoration(
            hintText: 'Paste the job posting description and requirements here...',
            fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _startInteractiveTailoring,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.blueAccent : const Color(0xFF0A2540),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Tailor interactively with AI Coach', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
