import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/resume_service.dart';
import '../../core/services/theme_service.dart';
import 'widgets/cv_form_sidebar.dart';
import 'widgets/cv_preview_document.dart';
import '../../core/services/pdf_service.dart';

class CvBuilderScreen extends StatefulWidget {
  const CvBuilderScreen({super.key});

  @override
  State<CvBuilderScreen> createState() => _CvBuilderScreenState();
}

class _CvBuilderScreenState extends State<CvBuilderScreen> {
  bool _isEditing = true;

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();
    final isDark = themeService.isDarkMode;
    final size = MediaQuery.of(context).size;
    final isNarrow = size.width < 1100;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF020617) : const Color(0xFFF1F5F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : const Color(0xFF0A2540)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing ? 'Editor' : 'Preview',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0A2540),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode_outlined, color: isDark ? Colors.white70 : Colors.black54),
            onPressed: () => themeService.toggleTheme(),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          _buildPreviewToolbar(context, isDark),
          if (isNarrow) _buildModeSwitcher(isDark),
          Expanded(
            child: isNarrow 
              ? _buildNarrowLayout(context, isDark)
              : _buildWideLayout(context, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSwitcher(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: isDark ? const Color(0xFF0F172A) : Colors.white,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isEditing = true),
                child: Container(
                  decoration: BoxDecoration(
                    color: _isEditing ? const Color(0xFF0A2540) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'EDIT',
                    style: TextStyle(
                      color: _isEditing ? Colors.white : (isDark ? Colors.white38 : Colors.grey),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isEditing = false),
                child: Container(
                  decoration: BoxDecoration(
                    color: !_isEditing ? const Color(0xFF0A2540) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'PREVIEW',
                    style: TextStyle(
                      color: !_isEditing ? Colors.white : (isDark ? Colors.white38 : Colors.grey),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context, bool isDark) {
    return Row(
      children: [
        const Expanded(
          flex: 4,
          child: CvFormSidebar(),
        ),
        Expanded(
          flex: 6,
          child: Container(
            color: isDark ? const Color(0xFF020617) : const Color(0xFFE2E8F0),
            child: const SingleChildScrollView(
              padding: EdgeInsets.all(40.0),
              child: Center(
                child: CvPreviewDocument(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context, bool isDark) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _isEditing 
        ? const CvFormSidebar()
        : Container(
            key: const ValueKey('preview'),
            width: double.infinity,
            color: isDark ? const Color(0xFF020617) : const Color(0xFFE2E8F0),
            child: const SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: CvPreviewDocument(),
            ),
          ),
    );
  }

  Widget _buildPreviewToolbar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 18, color: Colors.blueAccent),
              const SizedBox(width: 8),
              Text(
                'AI ENHANCED',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: isDark ? Colors.white70 : const Color(0xFF475569),
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final resumeService = context.read<ResumeService>();
              final resume = resumeService.currentResume;
              if (resume != null) {
                await PdfService.generateAndDownload(resume);
                await resumeService.showNotification(
                  'Resume Exported!',
                  'Your professional CV is ready and has been downloaded.',
                );
              }
            },
            icon: const Icon(Icons.download_rounded, size: 18),
            label: const Text('Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A2540),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
