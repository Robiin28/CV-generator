import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/resume_model.dart';

class ResumeService extends ChangeNotifier {
  Resume? _currentResume;
  static const String _storageKey = 'saved_resume_data';
  
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Resume? get currentResume => _currentResume;

  ResumeService() {
    _currentResume = _createDummyResume();
    _init();
  }

  Future<void> _init() async {
    try {
      await _initNotifications();
    } catch (e) {
      debugPrint('Notification init failed: $e');
    }
    await _loadFromStorage();
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('launcher_icon');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _notifications.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'resume_forge_id',
      'ResumeForge Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notifications.show(0, title, body, platformChannelSpecifics);
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // TEMPORARY: Clear preferences to reset user state after a corrupted build
      // await prefs.clear(); 

      final savedData = prefs.getString(_storageKey);
      
      if (savedData != null) {
        final Map<String, dynamic> json = jsonDecode(savedData);
        final loadedResume = Resume.fromJson(json);
        
        // Validation check to prevent loading a completely empty resume
        if (loadedResume.personalInfo.fullName.isEmpty && loadedResume.experience.isEmpty) {
          _currentResume = _createDummyResume();
        } else {
          _currentResume = loadedResume;
        }
      } else {
        _currentResume = _createDummyResume();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading resume: $e');
      _currentResume = _createDummyResume();
      notifyListeners();
    }
  }

  Future<void> _saveToStorage() async {
    if (_currentResume == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(_currentResume!.toJson());
      await prefs.setString(_storageKey, jsonStr);
    } catch (e) {
      debugPrint('Error saving resume: $e');
    }
  }

  void updateResume(Resume newResume) {
    _currentResume = newResume;
    _saveToStorage();
    notifyListeners();
  }

  void updatePersonalInfo(PersonalInfo newInfo) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(personalInfo: newInfo, lastUpdated: DateTime.now());
      _saveToStorage();
      notifyListeners();
    }
  }

  void updateSummary(String newSummary) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(summary: newSummary, lastUpdated: DateTime.now());
      _saveToStorage();
      notifyListeners();
    }
  }

  void updateExperience(List<Experience> newExperience) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(experience: newExperience, lastUpdated: DateTime.now());
      _saveToStorage();
      notifyListeners();
    }
  }

  void updateEducation(List<Education> newEducation) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(education: newEducation, lastUpdated: DateTime.now());
      _saveToStorage();
      notifyListeners();
    }
  }

  void updateSkills(List<SkillCategory> newSkills) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(skills: newSkills, lastUpdated: DateTime.now());
      _saveToStorage();
      notifyListeners();
    }
  }

  void updateProjects(List<Project> newProjects) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(projects: newProjects, lastUpdated: DateTime.now());
      _saveToStorage();
      notifyListeners();
    }
  }

  void updateLanguages(List<Language> newLanguages) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(languages: newLanguages, lastUpdated: DateTime.now());
      _saveToStorage();
      notifyListeners();
    }
  }

  void updateCertifications(List<Certification> newCertifications) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(certifications: newCertifications, lastUpdated: DateTime.now());
      _saveToStorage();
      notifyListeners();
    }
  }

  void updateVolunteering(List<Volunteering> newVolunteering) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(volunteering: newVolunteering, lastUpdated: DateTime.now());
      _saveToStorage();
      notifyListeners();
    }
  }

  void updateCustomSections(List<CustomSection> newSections) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(customSections: newSections, lastUpdated: DateTime.now());
      _saveToStorage();
      notifyListeners();
    }
  }

  Resume _createDummyResume() {
    return Resume(
      id: 'resume-robel-01',
      title: 'Robel Hailu Woldesenebet CV',
      personalInfo: PersonalInfo(
        fullName: 'ROBEL HAILU WOLDESENEBET',
        email: 'robiiihailuu@gmail.com',
        phone: '+251986991447',
        location: 'Ethiopia, Adiss Ababa',
        jobTitle: 'FULL STACK ENGINEER & DATA ANALYST | PLATFORM DEVELOPMENT & ERP IMPLEMENTATION SPECIALIST',
        linkedin: 'linkedin.com/in/mr-robel-hailu-854143239/',
        website: '',
        github: '',
        customFields: [],
      ),
      summary: 'Versatile Full Stack Engineer with strong experience spanning full stack development and data analysis, along with ERP implementation, platform administration, and data management in fintech environments. Skilled in building and maintaining end-to-end applications across frontend and backend systems while leveraging data to improve system performance, ensure data integrity, and support informed decision-making. Experienced in managing and processing financial and operational data within fintech systems, integrating ERP solutions, and supporting reliable platform operations. Focused on delivering scalable, secure, and efficient technology solutions that align engineering, data, and business processes.',
      experience: [
        Experience(
          id: 'exp-1',
          jobTitle: 'SENIOR PLATFORM ADMINISTRATOR',
          company: 'Kifiya Financial Technology',
          location: 'Addis Ababa, Ethiopia',
          startDate: 'Jan 2026',
          endDate: 'Present',
          current: true,
          description: 'Hired as a Senior Platform Administrator with active involvement in platform development and system management within a large-scale fintech environment handling high-volume loan operations and participant data\nWork directly with NGOs, financial institutions, and bank partners as clients, managing large-scale participant and loan taker datasets as part of end-to-end system operations\nAct as a developer and system interpreter, bridging technical implementation with client and stakeholder requirements to ensure accurate and reliable platform delivery\nTake direct responsibility for data-related operations, ensuring integrity, consistency, and proper handling of large-scale loan and financial datasets across the platform\nCollaborate with multiple banks and financial partners to support loan processing workflows, contributing to systems that have enabled over 6B+ in loan disbursement through platform and data infrastructure support\nContribute to platform development and improvement by aligning business requirements with technical solutions and ensuring scalable system performance in production environments\nMonitor and support platform operations to ensure continuous availability, reliability, and smooth execution of financial workflows.',
          bullets: [],
        ),
        Experience(
          id: 'exp-2',
          jobTitle: 'DATA ANALYST & JUNIOR ERP CONSULTANT',
          company: 'ESIG Ethiopia sugar company',
          location: 'Addis Ababa, Ethiopia',
          startDate: 'Jul 2025',
          endDate: 'Jan 2026',
          current: false,
          description: 'Worked as a Data Analyst and ERP Consultant, acting as a key bridge between development teams, stakeholders, and consultancy representatives to ensure accurate requirement gathering and successful ERP system delivery\nConducted requirement elicitation sessions with stakeholders and requirement teams, translating business processes into structured technical specifications for developers\nVisited operational sites and real-world factory environments to observe actual workflows, understand business processes, and accurately map them into ERP system requirements\nAnalyzed, cleaned, and structured operational and business data to ensure readiness for ERP integration, reporting, and system configuration\nCollaborated closely with stakeholders, consultants, and developers to validate requirements, clarify business logic, and ensure alignment between real operations and system design\nPrepared datasets and business rules for ERP implementation, ensuring accuracy, consistency, and compliance with operational workflows before system deployment\nContributed to improving process efficiency by identifying gaps between field operations and system design, helping optimize ERP workflows and usability.',
          bullets: [],
        ),
        Experience(
          id: 'exp-3',
          jobTitle: 'SOFTWARE DEVELOPER INTERN',
          company: 'BM Technology',
          location: 'Addis Ababa, Ethiopia',
          startDate: 'Mar 2024',
          endDate: 'Sep 2024',
          current: false,
          description: 'Joined as a Software Developer Intern and worked closely with senior developers, gaining hands-on experience in full stack development while contributing to real-world system development and improvements\nWorked on the BEFA Finance project, a system designed based on standard accounting principles, supporting structured financial data processing and reporting workflows\nContributed to both frontend and backend development of web applications, strengthening practical skills in building scalable and maintainable systems\nGained exposure to financial system workflows including accounting structures, data processing, and secure handling of financial information\nParticipated in Agile development processes including sprint planning, daily standups, and code reviews, improving collaboration and delivery practices\nContributed to bug fixing, feature implementation, and system testing while learning clean code practices, version control, and system security fundamentals.',
          bullets: [],
        ),
        Experience(
          id: 'exp-4',
          jobTitle: 'SENIOR FULLSTACK DEVELOPER (REMOTE)',
          company: 'elisoft Technology',
          location: 'Addis Ababa, Ethiopia',
          startDate: 'Feb 2023',
          endDate: 'Present',
          current: true,
          description: 'joined as a Junior Full Stack Engineer and progressed to senior-level responsibilities through continuous development and project delivery while working remotely alongside university studies\nDeveloped and maintained full stack applications, working across frontend and backend systems to build scalable and reliable software solutions\nWorked extensively on ERP-related systems as part of larger platform development, contributing to modules such as Inventory Management, Human Resources (HR), and core business workflows\nIntegrated ERP systems with external platforms such as POS (Point of Sale), ensuring smooth data flow and system interoperability\nContributed to database design, API development, and system optimization across production environments\nSupported platform reliability and feature delivery through debugging, enhancements, and continuous improvements',
          bullets: [],
        ),
      ],
      education: [
        Education(
          id: 'edu-1',
          school: 'Addis Ababa University',
          degree: 'MSc',
          fieldOfStudy: 'Data Analysis',
          startDate: 'Jan 2026',
          endDate: '2029 (on going)',
          description: 'In progress',
        ),
        Education(
          id: 'edu-2',
          school: 'Arbaminch University Ethiopia',
          degree: 'BSc',
          fieldOfStudy: 'Global Software Engineering Studies & International Relations',
          startDate: '2021',
          endDate: '2025',
          description: '',
        ),
      ],
      skills: [
        SkillCategory(
          category: 'TECHNICAL SKILLS',
          skills: ['Full Stack Development (Frontend & Backend)', 'API Development & Integration (REST APIs)', 'ERP System Development & Implementation'],
        ),
        SkillCategory(
          category: 'DATA & PLATFORM SKILLS',
          skills: ['Data Analysis & Data Processing', 'Data Cleaning & Validation', 'Data Management (Large-scale financial datasets)', 'Reporting & Dashboarding (Excel/Metabase / Power BI)', 'Operational Data Monitoring', 'Data Integrity Management'],
        ),
        SkillCategory(
          category: 'PLATFORM & INFRASTRUCTURE SKILLS',
          skills: ['Platform Administration', 'System Monitoring & Incident Handling', 'Basic CI/CD Understanding', 'Production System Support'],
        ),
        SkillCategory(
          category: 'SOFT / PROFESSIONAL SKILLS',
          skills: ['Stakeholder Management', 'Requirement Elicitation', 'Client Communication (NGOs, Banks, Partners)', 'Team Coordination', 'Decision Support through Data', 'Analytical Thinking', 'Fintech Experience', 'High-volume Data Operations'],
        ),
      ],
      projects: [
        Project(
          id: 'proj-1',
          name: 'FINTECH LOAN MANAGEMENT PLATFORM',
          description: 'Contributed to a large-scale loan management platform handling high-volume loan processing and participant data across multiple financial institutions. Worked on backend services, API development, and system features to support loan lifecycle workflows and platform scalability. Acted as a middleware data interpreter between NGOs, banks, and Kifiya systems translating business requirements into technical implementation for development teams. Supported system integration across external banking systems and internal platform services to ensure accurate and consistent data flow. Managed and validated loan-related data across systems ensuring data integrity, consistency, and alignment with business rules. Participated in platform enhancement and debugging activities improving system reliability and performance in production environments.',
          technologies: 'Node.js, Next.js, Go (Golang), Microservices Architecture, PostgreSQL, Redis, Kafka, AWS, CI/CD, REST APIs',
          link: 'https://linkedin.com/in/mr-robel-hailu-854143239/',
          bullets: [],
        ),
        Project(
          id: 'proj-2',
          name: 'ERP SYSTEM DEVELOPMENT (HR, FINANCE, INVENTORY MODULES)',
          description: 'Designed and contributed to core ERP modules supporting business operations including HR, finance, and inventory management. Developed backend logic, database structures, and API integrations to ensure smooth workflow automation across enterprise processes. Improved system usability and performance through continuous feature enhancements and bug fixing.',
          technologies: 'Laravel, Filament, CodeIgniter, Node.js, MySQL, PostgreSQL, REST APIs, ERP Systems, Database Design',
          link: 'https://linkedin.com/in/mr-robel-hailu-854143239/',
          bullets: [],
        ),
        Project(
          id: 'proj-3',
          name: 'PERSONAL PROJECTS',
          description: 'AI-powered CV tool, RAG-based experiments, e-learning platform, frontend client projects, Telegram bot automation, and final year project (personalized recommendation system and university news feed for AMU), along with other smaller experimental and learning-based projects in full stack development and APIs. Most of my development work has been through company-based systems, while these personal projects were built alongside to strengthen full stack engineering, data handling, and system design.',
          technologies: 'Most Programming Languages',
          link: 'https://linkedin.com/in/mr-robel-hailu-854143239/',
          bullets: [],
        ),
      ],
      languages: [
        Language(id: 'l-1', name: 'Amharic', level: 'Native'),
        Language(id: 'l-2', name: 'English', level: 'credible'),
      ],
      volunteering: [
        Volunteering(
          id: 'vol-1',
          role: 'CHARITY LEADERSHIP & FIRST AID VOLUNTEER',
          organization: 'Amu Charity',
          location: 'Ethiopia',
          startDate: '2022',
          endDate: '2025',
          current: false,
          description: 'Received a certificate for active participation in charity leadership initiatives and organized outreach programs focused on education and social impact\nAssisted in delivering first aid training sessions in local schools, supporting basic health awareness and emergency preparedness\nContributed to the planning and coordination of charity activities, ensuring effective execution of events and participant engagement\nSupported team efforts in charity programs aimed at improving local awareness, education, and social well-being',
        ),
      ],
      certifications: [],
      customSections: [],
      lastUpdated: DateTime.now(),
    );
  }
}
