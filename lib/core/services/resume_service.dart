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
      personalInfo: PersonalInfo(
        fullName: 'MEKDIM HAILU LEGESSE',
        email: 'mekdimhailu@gmail.com',
        phone: '+44 xxxxxxxxx',
        location: 'London, UK',
        jobTitle: 'COMMUNICATIONS & CAMPAIGNS SPECIALIST | DEVELOPMENT & MEDIA EXPERT',
        linkedin: 'linkedin.com/in/mekdimhailu',
        website: 'Selected writing works available here.',
        github: '',
        customFields: [],
      ),
      summary: 'Versatile communications professional and Chevening Scholar with over 8 years’ experience in strategic communications, content creation, campaign management, and stakeholder engagement across international NGOs, development projects, and media sectors. Skilled in content creation, stakeholder engagement, and campaign management, with a passion for using storytelling to drive social change and amplify marginalized voices.',
      experience: [
        Experience(
          id: 'exp-psi',
          jobTitle: 'COMMUNICATIONS MANAGER',
          company: 'PSI Ethiopia – USAID Transform WASH Activity',
          location: 'Addis Ababa, Ethiopia',
          startDate: 'Feb 2023',
          endDate: 'Mar 2024',
          current: false,
          description: 'Developed and implemented 8+ communications strategies across digital, print, and event platforms.\nAuthored 10+ case stories and articles, drawing on direct field visits and stakeholder interviews.\nCollaborated with government ministries and technical working groups to align communications with national strategies.\nServed as Chairperson for the National SBC Alliance, representing PSI Ethiopia in national coordination efforts alongside BBC Media Action and the Ministry of Health.',
          bullets: [],
        ),
        Experience(
          id: 'exp-ge',
          jobTitle: 'COVAX MEDIA MANAGER',
          company: 'Girl Effect (Seconded to Ethiopian Ministry of Health)',
          location: 'Addis Ababa, Ethiopia',
          startDate: 'Nov 2022',
          endDate: 'Jan 2023',
          current: false,
          description: 'Designed 5+ media strategies and KPIs to enhance COVID-19 vaccination uptake.\nFacilitated public listening sessions, collecting 200+ community feedback responses to inform messaging.\nCreated advocacy videos, success stories, and infographics to support immunization campaigns.\nWorked directly with the Ministry of Health’s Expanded Programme on Immunization and PR teams.',
          bullets: [],
        ),
        Experience(
          id: 'exp-wa',
          jobTitle: 'COMMUNICATIONS & CAMPAIGNS SPECIALIST',
          company: 'WaterAid Ethiopia',
          location: 'Addis Ababa, Ethiopia',
          startDate: 'Jul 2021',
          endDate: 'Nov 2022',
          current: false,
          description: 'Developed press releases, social media content, and articles, enhancing WaterAid’s visibility to thousands.\nDocumented lessons from 20+ projects, disseminating insights through publications, webinars, and workshops.\nManaged WaterAid Ethiopia’s presence at Dereja Annual Career Expo, connecting with 1,300+ youth, collecting 450+ CVs, and growing WaterAid’s newsletter subscriber base by 50+.\nSpearheaded the production of a climate change documentary aligned with WaterAid’s COP27 advocacy campaign.\nProject lead for the development and relaunch of WaterAid Ethiopia’s website.\nServed as Chief Editor, reviving and publishing WaterAid Ethiopia’s newsletter, contributing articles to regional editions.',
          bullets: [],
        ),
        Experience(
          id: 'exp-wkw',
          jobTitle: 'CONTENT DEVELOPMENT LEAD',
          company: 'Whiz Kids Workshop',
          location: 'Addis Ababa, Ethiopia',
          startDate: 'Oct 2019',
          endDate: 'Jun 2021',
          current: false,
          description: 'Managed creative development for 10+ donor-funded projects (USAID, World Bank, Deutsche Welle).\nWrote and reviewed 30+ educational scripts, ensuring cultural relevance and audience alignment.\nProject Lead for Easy Read UN Convention (Amharic), managing designers, animators, and disability experts to produce accessible materials.',
          bullets: [],
        ),
        Experience(
          id: 'exp-kana',
          jobTitle: 'SCRIPTWRITER & TRANSLATOR',
          company: 'BeMedia / Kana TV',
          location: 'Addis Ababa, Ethiopia',
          startDate: 'Jul 2016',
          endDate: 'Oct 2019',
          current: false,
          description: 'Wrote and edited 10+ scripts for the Yegna TV drama series, produced by Girl Effect and aimed at empowering Ethiopian girls.\nTranslated and edited 100+ final scripts, ensuring cultural and editorial accuracy.\nCollaborated with directors and producers in 20+ creative planning sessions to enhance storytelling.',
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
        Education(
          id: 'edu-ngu',
          school: 'New Generation University',
          degree: 'MA',
          fieldOfStudy: 'Global Studies & International Relations',
          startDate: '2022',
          endDate: '2024',
          description: 'Specialized in global diplomacy, international relations, and cross-cultural communication.',
        ),
        Education(
          id: 'edu-haw',
          school: 'Hawassa University',
          degree: 'BA',
          fieldOfStudy: 'Psychology',
          startDate: '2012',
          endDate: '2015',
          description: 'Built strong analytical and research skills with a focus on human behavior and social psychology.',
        ),
      ],
      skills: [
        SkillCategory(
          category: 'Expertise',
          skills: [
            'Strategic Communications & Campaigns',
            'Content Creation & Copywriting',
            'Stakeholder Engagement & Partnerships',
            'Media Relations & Public Relations',
            'Social Media & Digital Marketing',
            'Documentation & Reporting',
          ],
        )
      ],
      projects: [
        Project(
          id: 'pub-irc',
          name: 'IRC WASH Contributor Profile',
          description: 'Published 5 stories focused on water, sanitation, and hygiene, highlighting community impact and sector innovations.',
          technologies: 'WASH Sector',
          bullets: [],
        ),
        Project(
          id: 'pub-avessa',
          name: 'Avessa Magazine Contributor Profile',
          description: 'Published 5 articles covering social issues, personal reflections, and global development themes.',
          technologies: 'Editorial',
          bullets: [],
        ),
        Project(
          id: 'pub-linkedin',
          name: 'Yours Sincerely: Bi-weekly Opinion Series',
          description: 'Personal LinkedIn series exploring topics including gender, relationships, peace, and development.',
          technologies: 'LinkedIn Content',
          bullets: [],
        ),
        Project(
          id: 'pub-lse',
          name: 'LSE Africa Summit Blog Contributor',
          description: 'Published “Reclaiming the Pen: Owning Our Stories as African Women,” exploring representation through a feminist African lens.',
          technologies: 'Academic Writing',
          bullets: [],
        ),
      ],
      languages: [
        Language(id: 'lang-1', name: 'Amharic', level: 'Native'),
        Language(id: 'lang-2', name: 'English', level: 'IELTS Overall Score: 8'),
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
          description: 'Assisted in community outreach and first aid training programs for local schools.',
        ),
      ],
      customSections: [],
      lastUpdated: DateTime.now(),
    );
  }
}
