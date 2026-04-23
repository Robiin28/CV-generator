import { signalStore, withState, withMethods, patchState, withHooks } from '@ngrx/signals';
import { Resume, PersonalInfo, Experience, SkillCategory, Project, Certification, Language, Volunteering } from '../../../core/models/resume.model';
import { inject } from '@angular/core';
import { StorageService } from '../../../core/services/storage.service';

export interface ResumeState {
  resume: Resume;
  selectedTemplateId: string;
  isLoading: boolean;
  currentStep: number;
}

const initialResume: Resume = {
  id: 'resume-mekdim-02',
  title: 'Mekdim Hailu Legesse CV',
  personalInfo: {
    fullName: 'MEKDIM HAILU LEGESSE',
    email: 'mekdimhailu@gmail.com',
    phone: '+44 xxxxxxxxx',
    location: 'London, UK',
    jobTitle: 'COMMUNICATIONS & CAMPAIGNS SPECIALIST | DEVELOPMENT & MEDIA EXPERT',
    photo: '',
    linkedin: 'linkedin.com/in/mekdimhailu',
    website: 'Selected writing works available here.',
    github: ''
  },
  summary: 'Versatile communications professional and Chevening Scholar with over 8 years’ experience in strategic communications, content creation, campaign management, and stakeholder engagement across international NGOs, development projects, and media sectors. Skilled in content creation, stakeholder engagement, and campaign management, with a passion for using storytelling to drive social change and amplify marginalized voices.',
  experience: [
    {
      id: 'exp-psi',
      jobTitle: 'COMMUNICATIONS MANAGER',
      company: 'PSI Ethiopia – USAID Transform WASH Activity',
      location: 'Addis Ababa, Ethiopia',
      startDate: 'Feb 2023',
      endDate: 'Mar 2024',
      current: false,
      description: 'Developed and implemented 8+ communications strategies across digital, print, and event platforms.\nAuthored 10+ case stories and articles, drawing on direct field visits and stakeholder interviews.\nCollaborated with government ministries and technical working groups to align communications with national strategies.\nServed as Chairperson for the National SBC Alliance, representing PSI Ethiopia in national coordination efforts alongside BBC Media Action and the Ministry of Health.',
      bullets: []
    },
    {
      id: 'exp-ge',
      jobTitle: 'COVAX MEDIA MANAGER',
      company: 'Girl Effect (Seconded to Ethiopian Ministry of Health)',
      location: 'Addis Ababa, Ethiopia',
      startDate: 'Nov 2022',
      endDate: 'Jan 2023',
      current: false,
      description: 'Designed 5+ media strategies and KPIs to enhance COVID-19 vaccination uptake.\nFacilitated public listening sessions, collecting 200+ community feedback responses to inform messaging.\nCreated advocacy videos, success stories, and infographics to support immunization campaigns.\nWorked directly with the Ministry of Health’s Expanded Programme on Immunization and PR teams.',
      bullets: []
    },
    {
      id: 'exp-wa',
      jobTitle: 'COMMUNICATIONS & CAMPAIGNS SPECIALIST',
      company: 'WaterAid Ethiopia',
      location: 'Addis Ababa, Ethiopia',
      startDate: 'Jul 2021',
      endDate: 'Nov 2022',
      current: false,
      description: 'Developed press releases, social media content, and articles, enhancing WaterAid’s visibility to thousands.\nDocumented lessons from 20+ projects, disseminating insights through publications, webinars, and workshops.\nManaged WaterAid Ethiopia’s presence at Dereja Annual Career Expo, connecting with 1,300+ youth, collecting 450+ CVs, and growing WaterAid’s newsletter subscriber base by 50+.\nSpearheaded the production of a climate change documentary aligned with WaterAid’s COP27 advocacy campaign.\nProject lead for the development and relaunch of WaterAid Ethiopia’s website.\nServed as Chief Editor, reviving and publishing WaterAid Ethiopia’s newsletter, contributing articles to regional editions.',
      bullets: []
    },
    {
      id: 'exp-wkw',
      jobTitle: 'CONTENT DEVELOPMENT LEAD',
      company: 'Whiz Kids Workshop',
      location: 'Addis Ababa, Ethiopia',
      startDate: 'Oct 2019',
      endDate: 'Jun 2021',
      current: false,
      description: 'Managed creative development for 10+ donor-funded projects (USAID, World Bank, Deutsche Welle).\nWrote and reviewed 30+ educational scripts, ensuring cultural relevance and audience alignment.\nProject Lead for Easy Read UN Convention (Amharic), managing designers, animators, and disability experts to produce accessible materials.',
      bullets: []
    },
    {
      id: 'exp-kana',
      jobTitle: 'SCRIPTWRITER & TRANSLATOR',
      company: 'BeMedia / Kana TV',
      location: 'Addis Ababa, Ethiopia',
      startDate: 'Jul 2016',
      endDate: 'Oct 2019',
      current: false,
      description: 'Wrote and edited 10+ scripts for the Yegna TV drama series, produced by Girl Effect and aimed at empowering Ethiopian girls.\nTranslated and edited 100+ final scripts, ensuring cultural and editorial accuracy.\nCollaborated with directors and producers in 20+ creative planning sessions to enhance storytelling.',
      bullets: []
    }
  ],
  education: [
    {
      id: 'edu-lse',
      school: 'London School of Economics',
      degree: 'MSc',
      fieldOfStudy: 'Media, Communication & Development',
      startDate: '2024',
      endDate: 'Present',
      description: 'Focused on strategic communication and the role of media in influencing public discourse and development outcomes.'
    },
    {
      id: 'edu-ngu',
      school: 'New Generation University',
      degree: 'MA',
      fieldOfStudy: 'Global Studies & International Relations',
      startDate: '2022',
      endDate: '2024',
      description: 'Specialized in global diplomacy, international relations, and cross-cultural communication.'
    },
    {
      id: 'edu-haw',
      school: 'Hawassa University',
      degree: 'BA',
      fieldOfStudy: 'Psychology',
      startDate: '2012',
      endDate: '2015',
      description: 'Built strong analytical and research skills with a focus on human behavior and social psychology.'
    }
  ],
  skills: [
    { category: 'Expertise', skills: ['Strategic Communications & Campaigns', 'Content Creation & Copywriting', 'Stakeholder Engagement & Partnerships', 'Media Relations & Public Relations', 'Social Media & Digital Marketing', 'Documentation & Reporting'] }
  ],
  projects: [
    {
      id: 'pub-irc',
      name: 'IRC WASH Contributor Profile',
      description: 'Published 5 stories focused on water, sanitation, and hygiene, highlighting community impact and sector innovations.',
      technologies: 'WASH Sector',
      link: 'View profile',
      bullets: []
    },
    {
      id: 'pub-avessa',
      name: 'Avessa Magazine Contributor Profile',
      description: 'Published 5 articles covering social issues, personal reflections, and global development themes.',
      technologies: 'Editorial',
      link: 'View profile',
      bullets: []
    },
    {
      id: 'pub-linkedin',
      name: 'Yours Sincerely: Bi-weekly Opinion Series',
      description: 'Personal LinkedIn series exploring topics including gender, relationships, peace, and development.',
      technologies: 'LinkedIn Content',
      link: 'View series',
      bullets: []
    },
    {
      id: 'pub-lse',
      name: 'LSE Africa Summit Blog Contributor',
      description: 'Published “Reclaiming the Pen: Owning Our Stories as African Women,” exploring representation through a feminist African lens.',
      technologies: 'Academic Writing',
      link: 'Read article',
      bullets: []
    }
  ],
  languages: [
    { id: 'lang-1', name: 'Amharic', level: 'Native' },
    { id: 'lang-2', name: 'English', level: 'IELTS Overall Score: 8' }
  ],
  volunteering: [
    {
      id: 'vol-1',
      role: 'Volunteer Staff',
      organization: 'Red Cross Society',
      location: 'Addis Ababa',
      startDate: '2015',
      endDate: '2016',
      current: false,
      description: 'Assisted in community outreach and first aid training programs for local schools.'
    }
  ],
  lastUpdated: new Date()
};

const initialState: ResumeState = {
  resume: initialResume,
  selectedTemplateId: 'exec-01',
  isLoading: false,
  currentStep: 0,
};

export const ResumeStore = signalStore(
  { providedIn: 'root' },
  withState(initialState),
  withMethods((store, storageService = inject(StorageService)) => ({
    updatePersonalInfo(info: Partial<PersonalInfo>) {
      patchState(store, (state) => {
        const newState = {
          ...state.resume,
          personalInfo: { ...state.resume.personalInfo, ...info },
          lastUpdated: new Date()
        };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },
    updateSummary(summary: string) {
      patchState(store, (state) => {
        const newState = { ...state.resume, summary, lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },

    // --- Experience ---
    addExperience(exp: Experience) {
      patchState(store, (state) => {
        const newState = { ...state.resume, experience: [...state.resume.experience, exp], lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },
    updateExperience(id: string, exp: Partial<Experience>) {
      patchState(store, (state) => {
        const newState = { ...state.resume, experience: state.resume.experience.map((e) => e.id === id ? { ...e, ...exp } : e), lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },
    removeExperience(id: string) {
      patchState(store, (state) => {
        const newState = { ...state.resume, experience: state.resume.experience.filter((e) => e.id !== id), lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },

    // --- Education ---
    addEducation(edu: any) {
      patchState(store, (state) => {
        const newState = { ...state.resume, education: [...state.resume.education, edu], lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },
    updateEducation(id: string, edu: any) {
      patchState(store, (state) => {
        const newState = { ...state.resume, education: state.resume.education.map((e: any) => e.id === id ? { ...e, ...edu } : e), lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },
    removeEducation(id: string) {
      patchState(store, (state) => {
        const newState = { ...state.resume, education: state.resume.education.filter((e: any) => e.id !== id), lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },

    // --- Skills (categorized) ---
    addSkillCategory(cat: SkillCategory) {
      patchState(store, (state) => {
        const newState = { ...state.resume, skills: [...(state.resume.skills || []), cat], lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },
    updateSkillCategory(index: number, cat: Partial<SkillCategory>) {
      patchState(store, (state) => {
        const updated = (state.resume.skills || []).map((s, i) => i === index ? { ...s, ...cat } : s);
        const newState = { ...state.resume, skills: updated, lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },
    removeSkillCategory(index: number) {
      patchState(store, (state) => {
        const newState = { ...state.resume, skills: (state.resume.skills || []).filter((_, i) => i !== index), lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },

    // --- Projects ---
    addProject(p: Project) {
      patchState(store, (state) => {
        const newState = { ...state.resume, projects: [...(state.resume.projects || []), p], lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },
    updateProject(id: string, p: Partial<Project>) {
      patchState(store, (state) => {
        const newState = { ...state.resume, projects: (state.resume.projects || []).map((proj) => proj.id === id ? { ...proj, ...p } : proj), lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },
    removeProject(id: string) {
      patchState(store, (state) => {
        const newState = { ...state.resume, projects: (state.resume.projects || []).filter((p) => p.id !== id), lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },

    // --- Languages ---
    addLanguage(lang: Language) {
      patchState(store, (state) => {
        const newState = { ...state.resume, languages: [...(state.resume.languages || []), lang], lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },
    updateLanguage(id: string, lang: Partial<Language>) {
      patchState(store, (state) => {
        const newState = { ...state.resume, languages: (state.resume.languages || []).map((l) => l.id === id ? { ...l, ...lang } : l), lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },
    removeLanguage(id: string) {
      patchState(store, (state) => {
        const newState = { ...state.resume, languages: (state.resume.languages || []).filter((l) => l.id !== id), lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },

    // --- Certifications ---
    addCertification(cert: Certification) {
      patchState(store, (state) => {
        const newState = { ...state.resume, certifications: [...(state.resume.certifications || []), cert], lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },
    updateCertification(id: string, cert: Partial<Certification>) {
      patchState(store, (state) => {
        const newState = { ...state.resume, certifications: (state.resume.certifications || []).map((c) => c.id === id ? { ...c, ...cert } : c), lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },
    removeCertification(id: string) {
      patchState(store, (state) => {
        const newState = { ...state.resume, certifications: (state.resume.certifications || []).filter((c) => c.id !== id), lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },

    // --- Volunteering & Activities ---
    addVolunteering(vol: Volunteering) {
      patchState(store, (state) => {
        const newState = { ...state.resume, volunteering: [...(state.resume.volunteering || []), vol], lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },
    updateVolunteering(id: string, vol: Partial<Volunteering>) {
      patchState(store, (state) => {
        const newState = { ...state.resume, volunteering: (state.resume.volunteering || []).map((v) => v.id === id ? { ...v, ...vol } : v), lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },
    removeVolunteering(id: string) {
      patchState(store, (state) => {
        const newState = { ...state.resume, volunteering: (state.resume.volunteering || []).filter((v) => v.id !== id), lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },

    // --- Meta fields ---
    updateEuropassDetails(details: any) {
      patchState(store, (state) => {
        const newState = { ...state.resume, ...details, lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },
    setStep(step: number) { patchState(store, { currentStep: step }); },
    setTemplate(templateId: string) { patchState(store, { selectedTemplateId: templateId }); },
    setLoading(isLoading: boolean) { patchState(store, { isLoading }); },
    loadResume(resume: Resume) { patchState(store, { resume, selectedTemplateId: 'euro-01' }); },

    // Legacy compat
    addSkill(skill: any) {
      patchState(store, (state) => {
        const catIdx = (state.resume.skills || []).findIndex(c => c.category === 'Technical');
        let skills: SkillCategory[];
        if (catIdx >= 0) {
          skills = state.resume.skills.map((c, i) => i === catIdx ? { ...c, skills: [...c.skills, skill.name || ''] } : c);
        } else {
          skills = [...(state.resume.skills || []), { category: 'Technical', skills: [skill.name || ''] }];
        }
        const newState = { ...state.resume, skills, lastUpdated: new Date() };
        storageService.saveCurrentResume(newState);
        return { resume: newState };
      });
    },
    updateSkill(oldName: string, patch: any) {},
    removeSkill(name: string) {}
  })),
  withHooks({
    onInit(store) {}
  })
);
