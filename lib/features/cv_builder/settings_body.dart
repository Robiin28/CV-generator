import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/theme_service.dart';
import '../../core/services/resume_service.dart';
import '../../core/models/resume_model.dart';

class SettingsBody extends StatefulWidget {
  final bool isDark;
  const SettingsBody({super.key, required this.isDark});

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resume = context.watch<ResumeService>().currentResume;
    final info = resume?.personalInfo;
    final isDark = widget.isDark;

    return Column(
      children: [
        // Hero Header
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                  : [const Color(0xFF0A2540), const Color(0xFF1E3A8A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Avatar
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Color(0xFF6366F1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        info?.fullName.isNotEmpty == true
                            ? info!.fullName[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _showEditProfileSheet(context, info, isDark),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                info?.fullName.isNotEmpty == true ? info!.fullName : 'Your Name',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                info?.jobTitle?.isNotEmpty == true ? info!.jobTitle! : 'Your Job Title',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Pro Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                    Text('PRO PLAN', style: TextStyle(color: Colors.blueAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stats Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatBadge(label: 'Experience', value: '${resume?.experience.length ?? 0}', isDark: isDark),
                    _StatDivider(),
                    _StatBadge(label: 'Education', value: '${resume?.education.length ?? 0}', isDark: isDark),
                    _StatDivider(),
                    _StatBadge(label: 'Skills', value: '${resume?.skills.fold(0, (sum, s) => sum + s.skills.length) ?? 0}', isDark: isDark),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tabs
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white38,
                indicatorColor: Colors.blueAccent,
                indicatorWeight: 3,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [
                  Tab(text: 'Profile'),
                  Tab(text: 'Settings'),
                ],
              ),
            ],
          ),
        ),

        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _ProfileTab(info: info, resume: resume, isDark: isDark),
              _SettingsTab(isDark: isDark),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditProfileSheet(BuildContext context, PersonalInfo? info, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditProfileSheet(info: info, isDark: isDark),
    );
  }
}

// ─────────────────────────── PROFILE TAB ───────────────────────────
class _ProfileTab extends StatelessWidget {
  final PersonalInfo? info;
  final Resume? resume;
  final bool isDark;

  const _ProfileTab({required this.info, required this.resume, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Contact Info Card
          _SectionCard(
            title: 'Contact Information',
            icon: Icons.contact_mail,
            isDark: isDark,
            children: [
              _InfoRow(icon: Icons.email_outlined, label: 'Email', value: info?.email ?? '-', isDark: isDark),
              _InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: info?.phone ?? '-', isDark: isDark),
              _InfoRow(icon: Icons.location_on_outlined, label: 'Location', value: info?.location ?? '-', isDark: isDark),
              if (info?.linkedin?.isNotEmpty == true)
                _InfoRow(icon: Icons.link, label: 'LinkedIn', value: info!.linkedin!, isDark: isDark),
              if (info?.website?.isNotEmpty == true)
                _InfoRow(icon: Icons.language, label: 'Website', value: info!.website!, isDark: isDark),
            ],
          ),
          const SizedBox(height: 20),

          // Summary Card
          if (resume?.summary.isNotEmpty == true)
            _SectionCard(
              title: 'Professional Summary',
              icon: Icons.text_snippet_outlined,
              isDark: isDark,
              children: [
                Text(
                  resume!.summary,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),

          // Experience Card
          if (resume?.experience.isNotEmpty == true)
            _SectionCard(
              title: 'Experience (${resume!.experience.length})',
              icon: Icons.work_outline,
              isDark: isDark,
              children: resume!.experience.take(3).map((e) => _ExperienceRow(exp: e, isDark: isDark)).toList(),
            ),
          const SizedBox(height: 20),

          // Education Card
          if (resume?.education.isNotEmpty == true)
            _SectionCard(
              title: 'Education',
              icon: Icons.school_outlined,
              isDark: isDark,
              children: resume!.education.map((e) => _EducationRow(edu: e, isDark: isDark)).toList(),
            ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// ─────────────────────────── SETTINGS TAB ───────────────────────────
class _SettingsTab extends StatelessWidget {
  final bool isDark;
  const _SettingsTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _SectionCard(
            title: 'Appearance',
            icon: Icons.palette_outlined,
            isDark: isDark,
            children: [
              _SwitchRow(
                icon: isDark ? Icons.dark_mode : Icons.light_mode,
                label: 'Dark Mode',
                value: isDark,
                isDark: isDark,
                onChanged: (_) => context.read<ThemeService>().toggleTheme(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionCard(
            title: 'Notifications',
            icon: Icons.notifications_outlined,
            isDark: isDark,
            children: [
              _SwitchRow(
                icon: Icons.campaign_outlined,
                label: 'Push Notifications',
                value: true,
                isDark: isDark,
                onChanged: (_) {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionCard(
            title: 'Data & Privacy',
            icon: Icons.security_outlined,
            isDark: isDark,
            children: [
              _TapRow(
                icon: Icons.download_outlined,
                label: 'Export My Data',
                isDark: isDark,
                onTap: () {},
              ),
              _TapRow(
                icon: Icons.delete_forever_outlined,
                label: 'Clear All Data',
                isDark: isDark,
                isDestructive: true,
                onTap: () => _showClearDialog(context, isDark),
              ),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear All Data', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('This will permanently reset your CV and all saved information. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── EDIT PROFILE SHEET ───────────────────────────
class _EditProfileSheet extends StatefulWidget {
  final PersonalInfo? info;
  final bool isDark;

  const _EditProfileSheet({required this.info, required this.isDark});

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _linkedinController;

  @override
  void initState() {
    super.initState();
    final info = widget.info;
    _nameController = TextEditingController(text: info?.fullName ?? '');
    _titleController = TextEditingController(text: info?.jobTitle ?? '');
    _emailController = TextEditingController(text: info?.email ?? '');
    _phoneController = TextEditingController(text: info?.phone ?? '');
    _locationController = TextEditingController(text: info?.location ?? '');
    _linkedinController = TextEditingController(text: info?.linkedin ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _linkedinController.dispose();
    super.dispose();
  }

  void _save(BuildContext context) {
    final current = context.read<ResumeService>().currentResume?.personalInfo;
    if (current == null) return;
    context.read<ResumeService>().updatePersonalInfo(current.copyWith(
      fullName: _nameController.text,
      jobTitle: _titleController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      location: _locationController.text,
      linkedin: _linkedinController.text,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Edit Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A))),
                ElevatedButton(
                  onPressed: () => _save(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A2540),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _SheetField(controller: _nameController, label: 'Full Name', icon: Icons.person_outline, isDark: isDark),
                  _SheetField(controller: _titleController, label: 'Job Title', icon: Icons.work_outline, isDark: isDark),
                  _SheetField(controller: _emailController, label: 'Email', icon: Icons.email_outlined, isDark: isDark),
                  _SheetField(controller: _phoneController, label: 'Phone', icon: Icons.phone_outlined, isDark: isDark),
                  _SheetField(controller: _locationController, label: 'Location', icon: Icons.location_on_outlined, isDark: isDark),
                  _SheetField(controller: _linkedinController, label: 'LinkedIn', icon: Icons.link, isDark: isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── SHARED HELPERS ───────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isDark;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.icon, required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.blueAccent),
              const SizedBox(width: 10),
              Text(
                title.toUpperCase(),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.blueAccent),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const _InfoRow({required this.icon, required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isDark ? Colors.white38 : Colors.grey.shade500),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey.shade500)),
              Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF0F172A))),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExperienceRow extends StatelessWidget {
  final Experience exp;
  final bool isDark;

  const _ExperienceRow({required this.exp, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8, height: 8,
            margin: const EdgeInsets.only(top: 5, right: 12),
            decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exp.jobTitle, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A))),
                Text(
                  '${exp.company} · ${exp.startDate} – ${exp.endDate}',
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EducationRow extends StatelessWidget {
  final Education edu;
  final bool isDark;

  const _EducationRow({required this.edu, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8, height: 8,
            margin: const EdgeInsets.only(top: 5, right: 12),
            decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(edu.school, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A))),
                Text(
                  '${edu.degree} in ${edu.fieldOfStudy} · ${edu.startDate} – ${edu.endDate}',
                  style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final bool isDark;
  final Function(bool) onChanged;

  const _SwitchRow({required this.icon, required this.label, required this.value, required this.isDark, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: isDark ? Colors.white70 : const Color(0xFF0A2540)),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF0F172A)))),
        Switch(value: value, onChanged: onChanged, activeColor: Colors.blueAccent),
      ],
    );
  }
}

class _TapRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final bool isDestructive;
  final VoidCallback onTap;

  const _TapRow({required this.icon, required this.label, required this.isDark, this.isDestructive = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.redAccent : (isDark ? Colors.white70 : const Color(0xFF0A2540));
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: color))),
            Icon(Icons.chevron_right, size: 20, color: color),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _StatBadge({required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: Colors.white24);
  }
}

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isDark;

  const _SheetField({required this.controller, required this.label, required this.icon, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600),
          prefixIcon: Icon(icon, color: Colors.blueAccent, size: 20),
          filled: true,
          fillColor: isDark ? const Color(0xFF1E293B) : Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.blueAccent, width: 2)),
        ),
      ),
    );
  }
}
