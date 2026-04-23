export interface Resume {
  id: string;
  title: string;
  personalInfo: PersonalInfo;
  summary: string;
  experience: Experience[];
  education: Education[];
  skills: SkillCategory[];
  projects?: Project[];
  languages?: Language[];
  certifications?: Certification[];
  volunteering?: Volunteering[];
  atsScore?: number;
  lastUpdated: Date;
  // Europass Extended Fields
  nationality?: string;
  dateOfBirth?: string;
  motherTongues?: string[];
  cefrLanguages?: CEFRLanguage[];
  communicationSkills?: string;
  organisationalSkills?: string;
  jobRelatedSkills?: string;
  additionalInfo?: string;
}

export interface PersonalInfo {
  fullName: string;
  email: string;
  phone: string;
  location: string;
  jobTitle?: string;
  photo?: string;
  website?: string;
  linkedin?: string;
  github?: string;
}

export interface Experience {
  id: string;
  jobTitle: string;
  company: string;
  location: string;
  startDate: string;
  endDate: string;
  current: boolean;
  description: string;
  bullets: string[];
}

export interface Education {
  id: string;
  school: string;
  degree: string;
  fieldOfStudy: string;
  startDate: string;
  endDate: string;
  gpa?: string;
  description?: string;
}

export interface SkillCategory {
  category: string; // e.g. "Languages", "Frameworks", "Databases", "Tools"
  skills: string[];
}

export interface Project {
  id: string;
  name: string;
  description: string;
  technologies: string;
  link?: string;
  github?: string;
  bullets: string[];
}

export interface Certification {
  id: string;
  name: string;
  issuer: string;
  date: string;
  url?: string;
}

export interface Language {
  id: string;
  name: string;
  level: string; // Native, C2, C1, B2, B1, A2, A1
}

export interface CEFRLanguage {
  language: string;
  listening: 'A1' | 'A2' | 'B1' | 'B2' | 'C1' | 'C2';
  reading: 'A1' | 'A2' | 'B1' | 'B2' | 'C1' | 'C2';
  spokenInteraction: 'A1' | 'A2' | 'B1' | 'B2' | 'C1' | 'C2';
  spokenProduction: 'A1' | 'A2' | 'B1' | 'B2' | 'C1' | 'C2';
  writing: 'A1' | 'A2' | 'B1' | 'B2' | 'C1' | 'C2';
}

// Legacy – keep for backward compat
export interface Skill {
  name: string;
  level: number;
}

export interface Volunteering {
  id: string;
  role: string;
  organization: string;
  location: string;
  startDate: string;
  endDate: string;
  current: boolean;
  description: string;
}
