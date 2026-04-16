/* src/app/core/models/europass.model.ts */

export interface CEFRLanguage {
  language: string;
  listening: 'A1' | 'A2' | 'B1' | 'B2' | 'C1' | 'C2';
  reading: 'A1' | 'A2' | 'B1' | 'B2' | 'C1' | 'C2';
  spokenInteraction: 'A1' | 'A2' | 'B1' | 'B2' | 'C1' | 'C2';
  spokenProduction: 'A1' | 'A2' | 'B1' | 'B2' | 'C1' | 'C2';
  writing: 'A1' | 'A2' | 'B1' | 'B2' | 'C1' | 'C2';
}

export interface DigitalSkills {
  informationProcessing: string;
  communication: string;
  contentCreation: string;
  safety: string;
  problemSolving: string;
}

export interface PersonalDetails {
  nationality: string;
  dateOfBirth: string;
  gender: 'Male' | 'Female' | 'Other' | 'Prefer not to say';
  address: string;
  personalStatement: string;
}

export interface EuropassData {
  motherTongues: string[];
  otherLanguages: CEFRLanguage[];
  digitalSkills: DigitalSkills;
  communicationSkills: string;
  organisationalSkills: string;
  jobRelatedSkills: string;
  additionalInfo: string;
}
