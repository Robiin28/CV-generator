import 'package:flutter/material.dart';

class TemplatesBody extends StatelessWidget {
  final bool isDark;
  
  const TemplatesBody({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100, top: 24, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Your Style',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select from our collection of professional templates designed to get you hired.',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 32),
          
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 24,
            childAspectRatio: 0.7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _TemplateCard(
                title: 'Executive',
                isPro: false,
                isSelected: true,
                isDark: isDark,
                colors: const [Color(0xFF0A2540), Color(0xFF1E3A8A)],
              ),
              _TemplateCard(
                title: 'Minimalist',
                isPro: false,
                isSelected: false,
                isDark: isDark,
                colors: const [Color(0xFFE2E8F0), Color(0xFF94A3B8)],
              ),
              _TemplateCard(
                title: 'Creative',
                isPro: true,
                isSelected: false,
                isDark: isDark,
                colors: const [Color(0xFFEC4899), Color(0xFF8B5CF6)],
              ),
              _TemplateCard(
                title: 'Academic',
                isPro: true,
                isSelected: false,
                isDark: isDark,
                colors: const [Color(0xFF0F766E), Color(0xFF047857)],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final String title;
  final bool isPro;
  final bool isSelected;
  final bool isDark;
  final List<Color> colors;

  const _TemplateCard({
    required this.title,
    required this.isPro,
    required this.isSelected,
    required this.isDark,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: colors[0].withValues(alpha: 0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                )
              ] : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
              border: isSelected 
                ? Border.all(color: Colors.white, width: 3)
                : Border.all(color: Colors.transparent, width: 3),
            ),
            child: Stack(
              children: [
                if (isPro)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 10),
                          SizedBox(width: 4),
                          Text('PRO', style: TextStyle(color: Colors.amber, fontSize: 8, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                if (isSelected)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Color(0xFF0A2540), size: 16),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
