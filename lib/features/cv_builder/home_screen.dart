import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'cv_builder_screen.dart';
import '../../core/services/theme_service.dart';
import '../../core/services/resume_service.dart';
import 'templates_body.dart';
import 'ai_assistant_body.dart';
import 'settings_body.dart';

// Custom emerald color used throughout the UI
const Color _kEmerald = Color(0xFF50C878);


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
    final resumeService = context.watch<ResumeService>();
    final isDark = themeService.isDarkMode;

    if (resumeService.initialChatPrompt != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedIndex = 2;
        });
      });
    }

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
      case 0: return _HomeBody(
        isDark: isDark,
        onStartJobTailorChat: () => setState(() => _selectedIndex = 2),
      );
      case 1: return TemplatesBody(isDark: isDark);
      case 2: return AIAssistantBody(isDark: isDark);
      case 3: return SettingsBody(isDark: isDark);
      default: return _HomeBody(
        isDark: isDark,
        onStartJobTailorChat: () => setState(() => _selectedIndex = 2),
      );
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



class _HomeBody extends StatefulWidget {
  final bool isDark;
  final VoidCallback onStartJobTailorChat;
  const _HomeBody({super.key, required this.isDark, required this.onStartJobTailorChat});

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inDays < 1 && now.day == dt.day) {
      return 'Today, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays < 2 && now.subtract(const Duration(days: 1)).day == dt.day) {
      return 'Yesterday, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    }
  }

  void _showRenameDialog(BuildContext context, ResumeService service, String resumeId, String currentTitle) {
    final controller = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename CV'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'CV Title / Target Role',
              hintText: 'e.g. Senior Software Engineer',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  service.renameResume(resumeId, controller.text.trim());
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('CV renamed to "${controller.text}"')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDuplicateDialog(BuildContext context, ResumeService service, String resumeId, String currentTitle) {
    final controller = TextEditingController(text: 'Copy of $currentTitle');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Duplicate CV'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'New CV Title',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  service.duplicateResume(resumeId, controller.text.trim());
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('CV duplicated as "${controller.text}"')),
                  );
                }
              },
              child: const Text('Duplicate'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateDialog(BuildContext context, ResumeService service) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New CV'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'CV Title / Target Role',
              hintText: 'e.g. Web Developer CV',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  service.createNewResume(controller.text.trim());
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CvBuilderScreen()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Created new CV: "${controller.text}"')),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, ResumeService service, String resumeId, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete CV'),
          content: Text('Are you sure you want to delete "$title"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                service.deleteResume(resumeId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deleted CV: "$title"')),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final resumeService = context.watch<ResumeService>();
    final resumesList = resumeService.resumes;
    final currentResume = resumeService.currentResume;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120), // Space for bottom bar
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Glassmorphic Hero Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: GlassContainer(
              blur: 25,
              opacity: widget.isDark ? 0.08 : 0.55,
              borderRadius: 24,
              borderColor: widget.isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.7),
              color: widget.isDark ? const Color(0xFF1E293B).withValues(alpha: 0.3) : Colors.blue.shade50.withValues(alpha: 0.3),
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mekdim\'s Dashboard', 
                          style: TextStyle(
                            color: widget.isDark ? Colors.white70 : const Color(0xFF475569), 
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Stand out with AI',
                          style: TextStyle(
                            color: widget.isDark ? Colors.white : const Color(0xFF0F172A), 
                            fontSize: 26, 
                            fontWeight: FontWeight.w900, 
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.5)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.bolt, color: Colors.blueAccent, size: 14),
                              SizedBox(width: 4),
                              Text('PRO PLAN ACTIVE', style: TextStyle(color: Colors.blueAccent, fontSize: 9, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  AnimatedCharacterWidget(isDark: widget.isDark),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Role Selector Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Text(
              'Select Target Role',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: widget.isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(height: 4),
          RoleCarousel(
            isDark: widget.isDark,
            onRoleSelected: (roleTitle) {
              resumeService.updateTargetJob(roleTitle, '');
              resumeService.setInitialChatPrompt(
                "I want to tailor my CV for a $roleTitle role. Help me customize my summary, professional experience, and skills to highlight target keywords for this career path."
              );
              widget.onStartJobTailorChat();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Starting AI Coach session for $roleTitle...')),
              );
            },
          ),

          const SizedBox(height: 20),

          // Timeline view
          CVTimelineWidget(isDark: widget.isDark),

          const SizedBox(height: 20),

          // Saved Resumes list
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CV History & Versions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showCreateDialog(context, resumeService),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('New CV'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: resumesList.length,
                  itemBuilder: (context, index) {
                    final resume = resumesList[index];
                    final isActive = resume.id == currentResume?.id;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _ResumeCard(
                        title: resume.title,
                        subtitle: (resume.targetJobTitle != null && resume.targetJobTitle!.isNotEmpty)
                            ? resume.targetJobTitle!
                            : 'General Resume',
                        date: _formatDate(resume.lastUpdated),
                        isDark: widget.isDark,
                        isActive: isActive,
                        onTap: () async {
                          await resumeService.loadResume(resume.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Switched to "${resume.title}"'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CvBuilderScreen()),
                          );
                        },
                        trailing: PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert, 
                            color: widget.isDark ? Colors.white70 : Colors.black54,
                            size: 20,
                          ),
                          onSelected: (value) {
                            if (value == 'duplicate') {
                              _showDuplicateDialog(context, resumeService, resume.id, resume.title);
                            } else if (value == 'rename') {
                              _showRenameDialog(context, resumeService, resume.id, resume.title);
                            } else if (value == 'delete') {
                              _showDeleteDialog(context, resumeService, resume.id, resume.title);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'duplicate',
                              child: Row(
                                children: [
                                  Icon(Icons.copy, size: 16),
                                  SizedBox(width: 8),
                                  Text('Duplicate'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'rename',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 16),
                                  SizedBox(width: 8),
                                  Text('Rename / Edit Role'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              enabled: resumesList.length > 1,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline, 
                                    color: resumesList.length > 1 ? Colors.red : Colors.grey, 
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: resumesList.length > 1 ? Colors.red : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
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

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final Color? borderColor;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Border? customBorder;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 15,
    this.opacity = 0.1,
    this.borderRadius = 20,
    this.borderColor,
    this.color,
    this.padding,
    this.margin,
    this.customBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color ?? Colors.white.withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: customBorder ?? Border.all(
                color: borderColor ?? Colors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AnimatedCharacterWidget extends StatefulWidget {
  final bool isDark;
  const AnimatedCharacterWidget({super.key, required this.isDark});

  @override
  State<AnimatedCharacterWidget> createState() => _AnimatedCharacterWidgetState();
}

class _AnimatedCharacterWidgetState extends State<AnimatedCharacterWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    
    _floatAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: child,
        );
      },
      child: Container(
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: widget.isDark 
                ? [Colors.blueAccent, Colors.indigoAccent]
                : [const Color(0xFF0A2540), Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withValues(alpha: 0.4),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipOval(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.15,
                  child: CustomPaint(
                    painter: GridPainter(),
                  ),
                ),
              ),
              SvgPicture.string(
                '''
                <svg viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <circle cx="50" cy="40" r="22" fill="#FFFFFF" fill-opacity="0.1"/>
                  <rect x="36" y="28" width="28" height="20" rx="6" fill="#FFFFFF" fill-opacity="0.9"/>
                  <rect x="39" y="31" width="22" height="14" rx="3" fill="#0A2540"/>
                  <circle cx="45" cy="38" r="2" fill="#00FFCC"/>
                  <circle cx="55" cy="38" r="2" fill="#00FFCC"/>
                  <path d="M47 42 C 48 43, 52 43, 53 42" stroke="#00FFCC" stroke-width="1.5" stroke-linecap="round"/>
                  <rect x="49" y="22" width="2" height="6" fill="#FFFFFF"/>
                  <circle cx="50" cy="20" r="3" fill="#FF3366"/>
                  <path d="M25 50 C 35 45, 65 45, 75 50" stroke="#00FFCC" stroke-width="1" stroke-dasharray="2 2"/>
                  <path d="M25 75 C 25 62, 75 62, 75 75 Z" fill="#FFFFFF" fill-opacity="0.85"/>
                  <rect x="42" y="58" width="16" height="10" fill="#FFFFFF" fill-opacity="0.9"/>
                  <circle cx="50" cy="68" r="4" fill="#FF3366"/>
                </svg>
                ''',
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0;
    const step = 10.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RoleCarousel extends StatelessWidget {
  final bool isDark;
  final Function(String) onRoleSelected;

  const RoleCarousel({
    super.key,
    required this.isDark,
    required this.onRoleSelected,
  });

  static const List<Map<String, String>> roles = [
    {
      'title': 'Software Engineer',
      'icon': 'tech',
      'desc': 'Tailor for frontend, backend, or fullstack coding positions.',
    },
    {
      'title': 'Product Manager',
      'icon': 'product',
      'desc': 'Highlight leadership, roadmapping, and business metrics.',
    },
    {
      'title': 'UI/UX Designer',
      'icon': 'design',
      'desc': 'Focus on portfolio links, design systems, and user research.',
    },
    {
      'title': 'Data Scientist',
      'icon': 'data',
      'desc': 'Emphasize machine learning, statistics, and python expertise.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 155,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: roles.length,
        itemBuilder: (context, index) {
          final role = roles[index];
          return Container(
            width: 175,
            margin: const EdgeInsets.only(right: 16),
            child: GlassContainer(
              blur: 20,
              opacity: isDark ? 0.08 : 0.45,
              borderRadius: 18,
              padding: const EdgeInsets.all(16),
              borderColor: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.6),
              color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.4) : Colors.blue.shade50.withValues(alpha: 0.4),
              child: InkWell(
                onTap: () => onRoleSelected(role['title']!),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: _getRoleIcon(role['icon']!),
                    ),
                    const Spacer(),
                    Text(
                      role['title']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role['desc']!,
                      style: TextStyle(
                        fontSize: 10,
                        height: 1.3,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getRoleIcon(String iconType) {
    String svgString;
    switch (iconType) {
      case 'tech':
        svgString = '''
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M16 18L22 12L16 6M8 6L2 12L8 18M13 3L11 21" stroke="#3B82F6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        ''';
        break;
      case 'product':
        svgString = '''
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M9 19V5M15 19V5M3 9H21M3 15H21" stroke="#3B82F6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        ''';
        break;
      case 'design':
        svgString = '''
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22Z" stroke="#3B82F6" stroke-width="2"/>
            <path d="M12 6A1.5 1.5 0 1 0 12 9A1.5 1.5 0 1 0 12 6Z" fill="#3B82F6"/>
            <path d="M7.5 10.5A1.5 1.5 0 1 0 7.5 13.5A1.5 1.5 0 1 0 7.5 10.5Z" fill="#3B82F6"/>
            <path d="M16.5 10.5A1.5 1.5 0 1 0 16.5 13.5A1.5 1.5 0 1 0 16.5 10.5Z" fill="#3B82F6"/>
            <path d="M12 15A1.5 1.5 0 1 0 12 18A1.5 1.5 0 1 0 12 15Z" fill="#3B82F6"/>
          </svg>
        ''';
        break;
      case 'data':
      default:
        svgString = '''
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M18 20V10M12 20V4M6 20V14" stroke="#3B82F6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        ''';
    }
    return SvgPicture.string(svgString, width: 18, height: 18);
  }
}

class CVTimelineWidget extends StatelessWidget {
  final bool isDark;
  const CVTimelineWidget({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      blur: 20,
      opacity: isDark ? 0.06 : 0.45,
      borderRadius: 20,
      borderColor: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.6),
      color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.6),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.string(
                '''
                <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M12 8V12L15 15M21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12C3 7.02944 7.02944 3 12 3C16.9706 3 21 7.02944 21 12Z" stroke="#3B82F6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                ''',
                width: 18,
                height: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Job Application Timeline',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTimelineNode(
            title: 'Draft Created',
            time: 'Today, 2:30 PM',
            desc: 'AI tailored resume for Senior Fullstack Developer.',
            status: 'Draft',
            isFirst: true,
            isCompleted: true,
          ),
          _buildTimelineNode(
            title: 'Applied on LinkedIn',
            time: 'June 4, 2026',
            desc: 'Submitted to Vercel for Remote Software Engineer.',
            status: 'Applied',
            isCompleted: true,
          ),
          _buildTimelineNode(
            title: 'Interview Scheduled',
            time: 'June 10, 2:00 PM',
            desc: 'Technical Screening with engineering team.',
            status: 'Interview',
            isLast: true,
            isPending: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineNode({
    required String title,
    required String time,
    required String desc,
    required String status,
    bool isFirst = false,
    bool isLast = false,
    bool isCompleted = false,
    bool isPending = false,
  }) {
    Color nodeColor = Colors.blueAccent;
    Widget nodeIcon;

    if (isCompleted) {
      nodeColor = _kEmerald;
      nodeIcon = const Icon(Icons.check, size: 12, color: Colors.white);
    } else if (isPending) {
      nodeColor = Colors.amber;
      nodeIcon = const SizedBox(
        width: 10,
        height: 10,
        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
      );
    } else {
      nodeIcon = const CircleAvatar(radius: 4, backgroundColor: Colors.white);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: nodeColor.withValues(alpha: 0.2),
                border: Border.all(color: nodeColor, width: 2),
              ),
              child: Center(child: nodeIcon),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 55,
                color: isCompleted ? _kEmerald.withValues(alpha: 0.3) : (isDark ? Colors.white10 : Colors.grey.shade200),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: nodeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: nodeColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.white38 : Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.3,
                  color: isDark ? Colors.white60 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResumeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final bool isDark;
  final bool isActive;
  final Widget? trailing;
  final VoidCallback onTap;

  const _ResumeCard({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.isDark,
    required this.isActive,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark ? Colors.blueAccent : const Color(0xFF0A2540);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive 
                ? activeColor 
                : (isDark ? Colors.white10 : Colors.grey.shade200),
            width: isActive ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? activeColor.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isActive 
                    ? activeColor.withValues(alpha: 0.15) 
                    : const Color(0xFF0A2540).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.description, 
                color: isActive ? activeColor : const Color(0xFF0A2540),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isActive) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: activeColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: activeColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : Colors.grey.shade400),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
