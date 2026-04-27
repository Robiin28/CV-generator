import 'package:flutter/foundation.dart';
import '../models/resume_model.dart';

class ResumeService extends ChangeNotifier {
  Resume? _currentResume;

  Resume? get currentResume => _currentResume;

  ResumeService() {
    _currentResume = _createDummyResume();
  }

  void updateResume(Resume newResume) {
    _currentResume = newResume;
    notifyListeners();
  }

  void updatePersonalInfo(PersonalInfo newInfo) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(personalInfo: newInfo, lastUpdated: DateTime.now());
      notifyListeners();
    }
  }

  void updateSummary(String newSummary) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(summary: newSummary, lastUpdated: DateTime.now());
      notifyListeners();
    }
  }

  void updateExperience(List<Experience> newExperience) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(experience: newExperience, lastUpdated: DateTime.now());
      notifyListeners();
    }
  }

  void updateEducation(List<Education> newEducation) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(education: newEducation, lastUpdated: DateTime.now());
      notifyListeners();
    }
  }

  void updateSkills(List<SkillCategory> newSkills) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(skills: newSkills, lastUpdated: DateTime.now());
      notifyListeners();
    }
  }

  void updateProjects(List<Project> newProjects) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(projects: newProjects, lastUpdated: DateTime.now());
      notifyListeners();
    }
  }

  void updateLanguages(List<Language> newLanguages) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(languages: newLanguages, lastUpdated: DateTime.now());
      notifyListeners();
    }
  }

  void updateCertifications(List<Certification> newCertifications) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(certifications: newCertifications, lastUpdated: DateTime.now());
      notifyListeners();
    }
  }

  void updateVolunteering(List<Volunteering> newVolunteering) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(volunteering: newVolunteering, lastUpdated: DateTime.now());
      notifyListeners();
    }
  }

  void updateCustomSections(List<CustomSection> newSections) {
    if (_currentResume != null) {
      _currentResume = _currentResume!.copyWith(customSections: newSections, lastUpdated: DateTime.now());
      notifyListeners();
    }
  }

  Resume _createDummyResume() {
    return Resume(
      id: 'resume-mekdim-02',
      title: 'Mekdim Hailu Legesse CV',
      lastUpdated: DateTime.now(),
      personalInfo: PersonalInfo(
        fullName: 'MEKDIM HAILU LEGESSE',
        email: 'mekdimhailu@gmail.com',
        phone: '+44 xxxxxxxxx',
        location: 'London, UK',
        jobTitle: 'COMMUNICATIONS & CAMPAIGNS SPECIALIST',
        photo: '',
        linkedin: 'linkedin.com/in/mekdimhailu',
        website: 'Selected writing works available here.',
        github: '',
        customFields: [],
      ),
      summary: 'Versatile communications professional and Chevening Scholar with over 8 years’ experience in strategic communications, content creation, campaign management, and stakeholder engagement across international NGOs, development projects, and media sectors.',
      experience: [
        Experience(
          id: 'exp-psi',
          jobTitle: 'COMMUNICATIONS MANAGER',
          company: 'PSI Ethiopia – USAID Transform WASH Activity',
          location: 'Addis Ababa, Ethiopia',
          startDate: 'Feb 2023',
          endDate: 'Mar 2024',
          current: false,
          description: 'Developed and implemented 8+ communications strategies across digital, print, and event platforms.',
          bullets: [],
        ),
      ],
      education: [
        Education(
          id: 'edu-lse',
          school: 'London School of Economics',
          degree: 'MSc',
          fieldOfStudy: 'Media, Communication & Development',
          startDate: '2024',
          endDate: 'Present',
          description: 'Focused on strategic communication and the role of media in influencing public discourse and development outcomes.',
        ),
      ],
      skills: [
        SkillCategory(
          category: 'Expertise',
          skills: [
            'Strategic Communications',
            'Content Creation',
            'Stakeholder Engagement',
          ],
        )
      ],
      projects: [
        Project(
          id: 'proj-1',
          name: 'Personal Finance Dashboard',
          description: 'A cross-platform app built to track expenses and set savings goals.',
          technologies: 'Flutter, Firebase, Provider',
          bullets: [],
        ),
      ],
      languages: [
        Language(id: 'lang-1', name: 'Amharic', level: 'Native'),
        Language(id: 'lang-2', name: 'English', level: 'IELTS Overall Score: 8'),
      ],
      certifications: [
        Certification(id: 'cert-1', name: 'Professional Scrum Master I', issuer: 'Scrum.org', date: '2022'),
      ],
      volunteering: [
        Volunteering(
          id: 'vol-1',
          role: 'Volunteer Staff',
          organization: 'Red Cross Society',
          location: 'Addis Ababa',
          startDate: '2015',
          endDate: '2016',
          current: false,
          description: 'Assisted in community outreach and first aid training programs.',
        ),
      ],
      customSections: [
        CustomSection(
          id: 'sec-interests',
          title: 'Interests',
          items: [
            CustomField(label: 'Sports', value: 'Basketball, Swimming'),
            CustomField(label: 'Reading', value: 'Psychology, History'),
          ],
        ),
      ],
    );
  }
}
