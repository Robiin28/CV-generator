import { Component, Input, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ResumeStore } from '../../builder/store/resume.store';

@Component({
  selector: 'app-internship-preview',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="intern-document" [class.is-exporting]="isExporting">
      <div class="intern-layout">
        <!-- SIDEBAR -->
        <aside class="intern-sidebar">
          <div class="intern-photo" *ngIf="store.resume().personalInfo.photo">
            <img [src]="store.resume().personalInfo.photo">
          </div>
          
          <div class="sidebar-section">
            <h3 class="sidebar-title">Contact</h3>
            <div class="sidebar-content">
              <p *ngIf="store.resume().personalInfo.email"><strong>Email:</strong><br>{{ store.resume().personalInfo.email }}</p>
              <p *ngIf="store.resume().personalInfo.phone"><strong>Phone:</strong><br>{{ store.resume().personalInfo.phone }}</p>
              <p *ngIf="store.resume().personalInfo.location"><strong>Location:</strong><br>{{ store.resume().personalInfo.location }}</p>
              <p *ngIf="store.resume().personalInfo.linkedin"><strong>LinkedIn:</strong><br>{{ (store.resume().personalInfo.linkedin || '').replace('https://', '') }}</p>
              <p *ngIf="store.resume().personalInfo.github"><strong>GitHub:</strong><br>{{ (store.resume().personalInfo.github || '').replace('https://', '') }}</p>
            </div>
          </div>

          <div class="sidebar-section" *ngIf="filteredSkills.length > 0">
            <h3 class="sidebar-title">Skills</h3>
            <div class="sidebar-content">
              <div *ngFor="let cat of filteredSkills" class="skill-cat">
                <span class="cat-name">{{ cat.category }}</span>
                <div class="skill-tags">
                  <span *ngFor="let skill of cat.skills" class="skill-tag">{{ skill }}</span>
                </div>
              </div>
            </div>
          </div>

          <div class="sidebar-section" *ngIf="filteredLanguages.length > 0">
            <h3 class="sidebar-title">Languages</h3>
            <div class="sidebar-content">
              <div *ngFor="let lang of filteredLanguages" class="lang-item">
                <span>{{ lang.name }}</span> — <em>{{ lang.level }}</em>
              </div>
            </div>
          </div>
        </aside>

        <!-- MAIN CONTENT -->
        <main class="intern-main">
          <header class="intern-header">
            <h1>{{ store.resume().personalInfo.fullName || 'YOUR NAME' }}</h1>
            <p class="header-job-title">{{ (store.resume().personalInfo.jobTitle || 'Aspiring Professional') | uppercase }}</p>
          </header>

          <section class="main-section" *ngIf="store.resume().summary">
            <h2 class="section-title">Objective</h2>
            <p class="summary-text">{{ store.resume().summary }}</p>
          </section>

          <section class="main-section" *ngIf="filteredEducation.length > 0">
            <h2 class="section-title">Education</h2>
            <div class="entry" *ngFor="let edu of filteredEducation">
              <div class="entry-header">
                <h3 class="entry-title">{{ edu.degree }} in {{ edu.fieldOfStudy }}</h3>
                <span class="entry-date">{{ edu.startDate }} — {{ edu.endDate }}</span>
              </div>
              <p class="entry-subtitle">{{ edu.school }}</p>
              <p class="entry-desc" *ngIf="edu.description">{{ edu.description }}</p>
            </div>
          </section>

          <section class="main-section" *ngIf="filteredProjects.length > 0">
            <h2 class="section-title">Academic & Personal Projects</h2>
            <div class="entry" *ngFor="let proj of filteredProjects">
              <div class="entry-header">
                <h3 class="entry-title">{{ proj.name }}</h3>
              </div>
              <p class="entry-subtitle">{{ proj.technologies }}</p>
              <p class="entry-desc">{{ proj.description }}</p>
            </div>
          </section>

          <section class="main-section" *ngIf="filteredVolunteering.length > 0">
            <h2 class="section-title">Volunteering & Activities</h2>
            <div class="entry" *ngFor="let vol of filteredVolunteering">
              <div class="entry-header">
                <h3 class="entry-title">{{ vol.role }}</h3>
                <span class="entry-date">{{ vol.startDate }} — {{ vol.current ? 'Present' : vol.endDate }}</span>
              </div>
              <p class="entry-subtitle">{{ vol.organization }} | {{ vol.location }}</p>
              <p class="entry-desc">{{ vol.description }}</p>
            </div>
          </section>

          <section class="main-section" *ngIf="filteredExperience.length > 0">
            <h2 class="section-title">Work Experience</h2>
            <div class="entry" *ngFor="let exp of filteredExperience">
              <div class="entry-header">
                <h3 class="entry-title">{{ exp.jobTitle }}</h3>
                <span class="entry-date">{{ exp.startDate }} — {{ exp.current ? 'Present' : exp.endDate }}</span>
              </div>
              <p class="entry-subtitle">{{ exp.company }} | {{ exp.location }}</p>
              <div class="entry-desc" *ngIf="exp.description">
                <ul class="clean-bullets">
                  <li *ngFor="let bullet of exp.description.split('\n')">{{ bullet }}</li>
                </ul>
              </div>
            </div>
          </section>
        </main>
      </div>
    </div>
  `,
  styles: [`
    .intern-document {
      width: 210mm; min-height: 297mm; background: white; color: #334155; font-family: 'Open Sans', sans-serif;
    }
    .intern-layout { display: flex; min-height: 297mm; }
    
    .intern-sidebar {
      width: 33%; background: #f8fafc; border-right: 1px solid #e2e8f0; padding: 40px 30px;
    }
    .intern-photo { width: 120px; height: 120px; border-radius: 20px; overflow: hidden; margin-bottom: 30px; border: 4px solid white; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
    .intern-photo img { width: 100%; height: 100%; object-fit: cover; }
    
    .sidebar-section { margin-bottom: 35px; }
    .sidebar-title { font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.1em; color: #1e293b; border-bottom: 2px solid #38bdf8; padding-bottom: 8px; margin-bottom: 15px; font-weight: 800; }
    .sidebar-content { font-size: 0.85rem; line-height: 1.6; }
    .sidebar-content p { margin-bottom: 12px; word-break: break-all; }
    
    .skill-cat { margin-bottom: 15px; }
    .cat-name { display: block; font-weight: 700; font-size: 0.8rem; margin-bottom: 8px; color: #64748b; }
    .skill-tags { display: flex; flex-wrap: wrap; gap: 6px; }
    .skill-tag { background: white; border: 1px solid #e2e8f0; padding: 4px 10px; border-radius: 6px; font-size: 0.75rem; color: #475569; }
    
    .intern-main { flex: 1; padding: 50px 45px; }
    .intern-header { margin-bottom: 40px; }
    .intern-header h1 { font-size: 2.8rem; font-weight: 800; color: #0f172a; margin-bottom: 8px; line-height: 1; }
    .header-job-title { font-size: 1rem; font-weight: 600; color: #38bdf8; letter-spacing: 0.15em; }
    
    .main-section { margin-bottom: 35px; }
    .section-title { font-size: 1.2rem; font-weight: 800; color: #1e293b; margin-bottom: 18px; display: flex; align-items: center; gap: 12px; }
    .section-title::after { content: ''; height: 2px; flex: 1; background: #f1f5f9; }
    
    .entry { margin-bottom: 20px; }
    .entry-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 4px; }
    .entry-title { font-size: 1rem; font-weight: 700; color: #1e293b; }
    .entry-date { font-size: 0.85rem; color: #64748b; font-weight: 600; white-space: nowrap; }
    .entry-subtitle { font-size: 0.9rem; font-weight: 600; color: #475569; margin-bottom: 6px; }
    .entry-desc { font-size: 0.85rem; line-height: 1.6; color: #475569; text-align: justify; }
    
    .clean-bullets { padding-left: 18px; margin: 0; }
    .clean-bullets li { margin-bottom: 4px; }
    
    .summary-text { font-size: 0.9rem; line-height: 1.6; color: #475569; }

    @media print {
      .intern-document { box-shadow: none; }
      .intern-sidebar { -webkit-print-color-adjust: exact; }
    }
  `]
})
export class InternshipPreviewComponent {
  protected readonly store = inject(ResumeStore);
  @Input() isExporting = false;

  get filteredExperience() { return this.store.resume().experience || []; }
  get filteredEducation() { return this.store.resume().education || []; }
  get filteredSkills() { return this.store.resume().skills || []; }
  get filteredProjects() { return this.store.resume().projects || []; }
  get filteredLanguages() { return this.store.resume().languages || []; }
  get filteredVolunteering() { return this.store.resume().volunteering || []; }
}
