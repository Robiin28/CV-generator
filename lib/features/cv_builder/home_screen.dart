import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cv_builder_screen.dart';
import '../../core/services/theme_service.dart';
import 'templates_body.dart';
import 'ai_assistant_body.dart';
import 'settings_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();
    final isDark = themeService.isDarkMode;

    return Scaffold(
      extendBody: true, // Important for the curved bottom bar
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0A2540),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('F', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Text(
              'ResumeForge',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0A2540),
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode_outlined, color: isDark ? Colors.white70 : Colors.black54),
            onPressed: () => themeService.toggleTheme(),
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF0A2540),
            child: Text('M', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _buildBody(_selectedIndex, isDark),
      bottomNavigationBar: _CurvedBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        isDark: isDark,
      ),
    );
  }

  Widget _buildBody(int index, bool isDark) {
    switch (index) {
      case 0: return _HomeBody(isDark: isDark);
      case 1: return TemplatesBody(isDark: isDark);
      case 2: return AIAssistantBody(isDark: isDark);
      case 3: return SettingsBody(isDark: isDark);
      default: return _HomeBody(isDark: isDark);
    }
  }
}

class _CurvedBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isDark;

  const _CurvedBottomNav({required this.currentIndex, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final activeColor = isDark ? Colors.blueAccent : const Color(0xFF0A2540);
    final inactiveColor = isDark ? Colors.white24 : Colors.grey.shade400;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        height: 70,
        decoration: BoxDecoration(
          color: isDark 
              ? const Color(0xFF1E293B).withValues(alpha: 0.8) 
              : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home', activeColor, inactiveColor)),
              Expanded(child: _buildNavItem(1, Icons.layers_outlined, Icons.layers, 'Templates', activeColor, inactiveColor)),
              
              // Center FAB
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CvBuilderScreen()));
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [activeColor, activeColor.withValues(alpha: 0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ),

              Expanded(child: _buildNavItem(2, Icons.auto_awesome_outlined, Icons.auto_awesome, 'AI', activeColor, inactiveColor)),
              Expanded(child: _buildNavItem(3, Icons.settings_outlined, Icons.settings, 'Settings', activeColor, inactiveColor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label, Color activeColor, Color inactiveColor) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: () => onTap(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? activeColor : inactiveColor,
            size: isSelected ? 24 : 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
              color: isSelected ? activeColor : inactiveColor,
              letterSpacing: 0.2,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: activeColor,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}



class _HomeBody extends StatelessWidget {
  final bool isDark;
  const _HomeBody({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100), // Space for bottom bar
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark 
                  ? [const Color(0xFF0F172A), const Color(0xFF020617)]
                  : [const Color(0xFF0A2540), const Color(0xFF1E3A8A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mekdim\'s Dashboard', style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 8),
                const Text(
                  'Stand out from\nthe crowd.',
                  style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, height: 1.1),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.5)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, color: Colors.blueAccent, size: 16),
                      SizedBox(width: 4),
                      Text('PRO PLAN ACTIVE', style: TextStyle(color: Colors.blueAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Recent Resumes
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Resumes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    TextButton(onPressed: () {}, child: const Text('View All')),
                  ],
                ),
                const SizedBox(height: 20),
                _ResumeCard(
                  title: 'Executive Resume',
                  subtitle: 'Software Engineer Role',
                  date: 'Today, 10:45 AM',
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CvBuilderScreen()));
                  },
                ),
                const SizedBox(height: 16),
                _ResumeCard(
                  title: 'Academic CV',
                  subtitle: 'PhD Application',
                  date: 'Yesterday, 4:20 PM',
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CvBuilderScreen()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResumeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final bool isDark;
  final VoidCallback onTap;

  const _ResumeCard({required this.title, required this.subtitle, required this.date, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF0A2540).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.description, color: Color(0xFF0A2540)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  date,
                  style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : Colors.grey.shade400),
                ),
                const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
