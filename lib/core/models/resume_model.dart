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
  final String? targetJobTitle;
  final String? targetJobDescription;

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
    this.targetJobTitle,
    this.targetJobDescription,
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
    String? targetJobTitle,
    String? targetJobDescription,
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
      targetJobTitle: targetJobTitle ?? this.targetJobTitle,
      targetJobDescription: targetJobDescription ?? this.targetJobDescription,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'personalInfo': personalInfo.toJson(),
    'summary': summary,
    'experience': experience.map((e) => e.toJson()).toList(),
    'education': education.map((e) => e.toJson()).toList(),
    'skills': skills.map((e) => e.toJson()).toList(),
    'projects': projects?.map((e) => e.toJson()).toList(),
    'languages': languages?.map((e) => e.toJson()).toList(),
    'certifications': certifications?.map((e) => e.toJson()).toList(),
    'volunteering': volunteering?.map((e) => e.toJson()).toList(),
    'customSections': customSections?.map((e) => e.toJson()).toList(),
    'atsScore': atsScore,
    'lastUpdated': lastUpdated.toIso8601String(),
    'nationality': nationality,
    'dateOfBirth': dateOfBirth,
    'motherTongues': motherTongues,
    'cefrLanguages': cefrLanguages?.map((e) => e.toJson()).toList(),
    'communicationSkills': communicationSkills,
    'organisationalSkills': organisationalSkills,
    'jobRelatedSkills': jobRelatedSkills,
    'additionalInfo': additionalInfo,
    'targetJobTitle': targetJobTitle,
    'targetJobDescription': targetJobDescription,
  };

  factory Resume.fromJson(Map<String, dynamic> json) => Resume(
    id: json['id'],
    title: json['title'],
    personalInfo: PersonalInfo.fromJson(json['personalInfo']),
    summary: json['summary'],
    experience: (json['experience'] as List).map((e) => Experience.fromJson(e)).toList(),
    education: (json['education'] as List).map((e) => Education.fromJson(e)).toList(),
    skills: (json['skills'] as List).map((e) => SkillCategory.fromJson(e)).toList(),
    projects: json['projects'] != null ? (json['projects'] as List).map((e) => Project.fromJson(e)).toList() : null,
    languages: json['languages'] != null ? (json['languages'] as List).map((e) => Language.fromJson(e)).toList() : null,
    certifications: json['certifications'] != null ? (json['certifications'] as List).map((e) => Certification.fromJson(e)).toList() : null,
    volunteering: json['volunteering'] != null ? (json['volunteering'] as List).map((e) => Volunteering.fromJson(e)).toList() : null,
    customSections: json['customSections'] != null ? (json['customSections'] as List).map((e) => CustomSection.fromJson(e)).toList() : null,
    atsScore: json['atsScore'],
    lastUpdated: DateTime.parse(json['lastUpdated']),
    nationality: json['nationality'],
    dateOfBirth: json['dateOfBirth'],
    motherTongues: json['motherTongues'] != null ? List<String>.from(json['motherTongues']) : null,
    cefrLanguages: json['cefrLanguages'] != null ? (json['cefrLanguages'] as List).map((e) => CEFRLanguage.fromJson(e)).toList() : null,
    communicationSkills: json['communicationSkills'],
    organisationalSkills: json['organisationalSkills'],
    jobRelatedSkills: json['jobRelatedSkills'],
    additionalInfo: json['additionalInfo'],
    targetJobTitle: json['targetJobTitle'],
    targetJobDescription: json['targetJobDescription'],
  );
}

class CustomSection {
  final String id;
  final String title;
  final List<CustomField> items;

  CustomSection({required this.id, required this.title, required this.items});

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'items': items.map((e) => e.toJson()).toList()};
  factory CustomSection.fromJson(Map<String, dynamic> json) => CustomSection(
    id: json['id'],
    title: json['title'],
    items: (json['items'] as List).map((e) => CustomField.fromJson(e)).toList(),
  );
}

class CustomField {
  final String label;
  final String value;

  CustomField({required this.label, required this.value});

  Map<String, dynamic> toJson() => {'label': label, 'value': value};
  factory CustomField.fromJson(Map<String, dynamic> json) => CustomField(label: json['label'], value: json['value']);
}

class PersonalInfo {
  final String fullName;
  final String email;
  final String phone;
  final String location;
  final String? address;
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
    this.address,
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
    String? address,
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
      address: address ?? this.address,
      jobTitle: jobTitle ?? this.jobTitle,
      photo: photo ?? this.photo,
      website: website ?? this.website,
      linkedin: linkedin ?? this.linkedin,
      github: github ?? this.github,
      customFields: customFields ?? this.customFields,
    );
  }

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'location': location,
    'address': address,
    'jobTitle': jobTitle,
    'photo': photo,
    'website': website,
    'linkedin': linkedin,
    'github': github,
    'customFields': customFields?.map((e) => e.toJson()).toList(),
  };

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
    fullName: json['fullName'],
    email: json['email'],
    phone: json['phone'],
    location: json['location'],
    address: json['address'],
    jobTitle: json['jobTitle'],
    photo: json['photo'],
    website: json['website'],
    linkedin: json['linkedin'],
    github: json['github'],
    customFields: json['customFields'] != null ? (json['customFields'] as List).map((e) => CustomField.fromJson(e)).toList() : null,
  );
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'jobTitle': jobTitle,
    'company': company,
    'location': location,
    'startDate': startDate,
    'endDate': endDate,
    'current': current,
    'description': description,
    'bullets': bullets,
  };

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    id: json['id'],
    jobTitle: json['jobTitle'],
    company: json['company'],
    location: json['location'],
    startDate: json['startDate'],
    endDate: json['endDate'],
    current: json['current'],
    description: json['description'],
    bullets: List<String>.from(json['bullets']),
  );
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'school': school,
    'degree': degree,
    'fieldOfStudy': fieldOfStudy,
    'startDate': startDate,
    'endDate': endDate,
    'gpa': gpa,
    'description': description,
  };

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    id: json['id'],
    school: json['school'],
    degree: json['degree'],
    fieldOfStudy: json['fieldOfStudy'],
    startDate: json['startDate'],
    endDate: json['endDate'],
    gpa: json['gpa'],
    description: json['description'],
  );
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

  Map<String, dynamic> toJson() => {'category': category, 'skills': skills};
  factory SkillCategory.fromJson(Map<String, dynamic> json) => SkillCategory(
    category: json['category'],
    skills: List<String>.from(json['skills']),
  );
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'technologies': technologies,
    'link': link,
    'github': github,
    'bullets': bullets,
  };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    technologies: json['technologies'],
    link: json['link'],
    github: json['github'],
    bullets: List<String>.from(json['bullets']),
  );
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

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'issuer': issuer, 'date': date, 'url': url};
  factory Certification.fromJson(Map<String, dynamic> json) => Certification(
    id: json['id'],
    name: json['name'],
    issuer: json['issuer'],
    date: json['date'],
    url: json['url'],
  );
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

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'level': level};
  factory Language.fromJson(Map<String, dynamic> json) => Language(id: json['id'], name: json['name'], level: json['level']);
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

  Map<String, dynamic> toJson() => {
    'language': language,
    'listening': listening,
    'reading': reading,
    'spokenInteraction': spokenInteraction,
    'spokenProduction': spokenProduction,
    'writing': writing,
  };

  factory CEFRLanguage.fromJson(Map<String, dynamic> json) => CEFRLanguage(
    language: json['language'],
    listening: json['listening'],
    reading: json['reading'],
    spokenInteraction: json['spokenInteraction'],
    spokenProduction: json['spokenProduction'],
    writing: json['writing'],
  );
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role,
    'organization': organization,
    'location': location,
    'startDate': startDate,
    'endDate': endDate,
    'current': current,
    'description': description,
  };

  factory Volunteering.fromJson(Map<String, dynamic> json) => Volunteering(
    id: json['id'],
    role: json['role'],
    organization: json['organization'],
    location: json['location'],
    startDate: json['startDate'],
    endDate: json['endDate'],
    current: json['current'],
    description: json['description'],
  );
}