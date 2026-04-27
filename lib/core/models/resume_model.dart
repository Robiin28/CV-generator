class Resume {
  final String id;
  final String title;
  final PersonalInfo personalInfo;
  final String summary;
  final List<Experience> experience;
  final List<Education> education;
  final List<SkillCategory> skills;
  
  final List<Project>? projects;
  final List<Language>? languages;
  final List<Certification>? certifications;
  final List<Volunteering>? volunteering;
  final List<CustomSection>? customSections;
  
  final double? atsScore;
  final DateTime lastUpdated;
  // Europass Extended Fields
  final String? nationality;
  final String? dateOfBirth;
  final List<String>? motherTongues;
  final List<CEFRLanguage>? cefrLanguages;
  final String? communicationSkills;
  final String? organisationalSkills;
  final String? jobRelatedSkills;
  final String? additionalInfo;

 Resume({
    required this.id,
    required this.title,
    required this.personalInfo,
    required this.summary,
    required this.experience,
    required this.education,
    required this.skills,
    required this.lastUpdated,
    this.projects,
    this.languages,
    this.certifications,
    this.volunteering,
    this.customSections,
    this.atsScore,
    this.nationality,
    this.dateOfBirth,
    this.motherTongues,
    this.cefrLanguages,
    this.communicationSkills,
    this.organisationalSkills,
    this.jobRelatedSkills,
    this.additionalInfo,
  });

  Resume copyWith({
    String? id,
    String? title,
    PersonalInfo? personalInfo,
    String? summary,
    List<Experience>? experience,
    List<Education>? education,
    List<SkillCategory>? skills,
    List<Project>? projects,
    List<Language>? languages,
    List<Certification>? certifications,
    List<Volunteering>? volunteering,
    List<CustomSection>? customSections,
    double? atsScore,
    DateTime? lastUpdated,
    String? nationality,
    String? dateOfBirth,
    List<String>? motherTongues,
    List<CEFRLanguage>? cefrLanguages,
    String? communicationSkills,
    String? organisationalSkills,
    String? jobRelatedSkills,
    String? additionalInfo,
  }) {
    return Resume(
      id: id ?? this.id,
      title: title ?? this.title,
      personalInfo: personalInfo ?? this.personalInfo,
      summary: summary ?? this.summary,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      projects: projects ?? this.projects,
      languages: languages ?? this.languages,
      certifications: certifications ?? this.certifications,
      volunteering: volunteering ?? this.volunteering,
      customSections: customSections ?? this.customSections,
      atsScore: atsScore ?? this.atsScore,
      nationality: nationality ?? this.nationality,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      motherTongues: motherTongues ?? this.motherTongues,
      cefrLanguages: cefrLanguages ?? this.cefrLanguages,
      communicationSkills: communicationSkills ?? this.communicationSkills,
      organisationalSkills: organisationalSkills ?? this.organisationalSkills,
      jobRelatedSkills: jobRelatedSkills ?? this.jobRelatedSkills,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }
}

class CustomSection {
  final String id;
  final String title;
  final List<CustomField> items;

  CustomSection({required this.id, required this.title, required this.items});
}

class CustomField {
  final String label;
  final String value;

 CustomField({required this.label, required this.value});
}

class PersonalInfo {
  final String fullName;
  final String email;
  final String phone;
  final String location;
  final String? jobTitle;
  final String? photo;
  final String? website;
  final String? linkedin;
  final String? github;
  final List<CustomField>? customFields;

  PersonalInfo({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.location,
    this.jobTitle,
    this.photo,
    this.website,
    this.linkedin,
    this.github,
    this.customFields,
  });

  PersonalInfo copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? location,
    String? jobTitle,
    String? photo,
    String? website,
    String? linkedin,
    String? github,
    List<CustomField>? customFields,
  }) {
    return PersonalInfo(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      jobTitle: jobTitle ?? this.jobTitle,
      photo: photo ?? this.photo,
      website: website ?? this.website,
      linkedin: linkedin ?? this.linkedin,
      github: github ?? this.github,
      customFields: customFields ?? this.customFields,
    );
  }
}

class Experience {
  final String id;
  final String jobTitle;
  final String company;
  final String location;
  final String startDate;
  final String endDate;
  final bool current;
  final String description;
  final List<String> bullets;
  Experience({
    required this.id,
    required this.jobTitle,
    required this.company,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.current,
    required this.description,
    required this.bullets,
  });

  Experience copyWith({
    String? id,
    String? jobTitle,
    String? company,
    String? location,
    String? startDate,
    String? endDate,
    bool? current,
    String? description,
    List<String>? bullets,
  }) {
    return Experience(
      id: id ?? this.id,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      current: current ?? this.current,
      description: description ?? this.description,
      bullets: bullets ?? this.bullets,
    );
  }
}

class Education {
  final String id;
  final String school;
  final String degree;
  final String fieldOfStudy;
  final String startDate;
  final String endDate;
  final String? gpa;
  final String? description;
  Education({
    required this.id,
    required this.school,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    required this.endDate,
    this.gpa,
    this.description,
  });

  Education copyWith({
    String? id,
    String? school,
    String? degree,
    String? fieldOfStudy,
    String? startDate,
    String? endDate,
    String? gpa,
    String? description,
  }) {
    return Education(
      id: id ?? this.id,
      school: school ?? this.school,
      degree: degree ?? this.degree,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      gpa: gpa ?? this.gpa,
      description: description ?? this.description,
    );
  }
}

class SkillCategory {
  final String category;
  final List<String> skills;
  SkillCategory({required this.category, required this.skills});

  SkillCategory copyWith({
    String? category,
    List<String>? skills,
  }) {
    return SkillCategory(
      category: category ?? this.category,
      skills: skills ?? this.skills,
    );
  }
}

class Project {
  final String id;
  final String name;
  final String description;
  final String technologies;
  final String? link;
  final String? github;
  final List<String> bullets;
  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.technologies,
    required this.bullets,
    this.link,
    this.github,
  });

  Project copyWith({
    String? id,
    String? name,
    String? description,
    String? technologies,
    List<String>? bullets,
    String? link,
    String? github,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      technologies: technologies ?? this.technologies,
      bullets: bullets ?? this.bullets,
      link: link ?? this.link,
      github: github ?? this.github,
    );
  }
}

class Certification {
  final String id;
  final String name;
  final String issuer;
  final String date;
  final String? url;
  Certification({
    required this.id,
    required this.name,
    required this.issuer,
    required this.date,
    this.url,
  });

  Certification copyWith({
    String? id,
    String? name,
    String? issuer,
    String? date,
    String? url,
  }) {
    return Certification(
      id: id ?? this.id,
      name: name ?? this.name,
      issuer: issuer ?? this.issuer,
      date: date ?? this.date,
      url: url ?? this.url,
    );
  }
}

class Language {
  final String id;
  final String name;
  final String level;
  Language({required this.id, required this.name, required this.level});

  Language copyWith({
    String? id,
    String? name,
    String? level,
  }) {
    return Language(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
    );
  }
}

class CEFRLanguage {
  final String language;
  final String listening;
  final String reading;
  final String spokenInteraction;
  final String spokenProduction;
  final String writing;
  CEFRLanguage({
    required this.language,
    required this.listening,
    required this.reading,
    required this.spokenInteraction,
    required this.spokenProduction,
    required this.writing,
  });
}

class Volunteering {
  final String id;
  final String role;
  final String organization;
  final String location;
  final String startDate;
  final String endDate;
  final bool current;
  final String description;
  Volunteering({
    required this.id,
    required this.role,
    required this.organization,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.current,
    required this.description,
  });

  Volunteering copyWith({
    String? id,
    String? role,
    String? organization,
    String? location,
    String? startDate,
    String? endDate,
    bool? current,
    String? description,
  }) {
    return Volunteering(
      id: id ?? this.id,
      role: role ?? this.role,
      organization: organization ?? this.organization,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      current: current ?? this.current,
      description: description ?? this.description,
    );
  }
}