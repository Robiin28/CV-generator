import { Component, Input, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ResumeStore } from '../../builder/store/resume.store';

@Component({
  selector: 'app-europass-preview',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="cv-document-paged" [class.is-exporting]="isExporting">
      <div class="cv-content-wrapper">
        <!-- HEADER sits ABOVE the grid-layout to stay clean -->
        <header class="cv-header">
          <div class="cv-header-left">
            <h1 class="cv-name">{{ store.resume().personalInfo.fullName || 'YOUR NAME' }}</h1>
            <p class="cv-title" *ngIf="store.resume().personalInfo.jobTitle">{{ store.resume().personalInfo.jobTitle }}</p>
          </div>
          
          <div class="cv-header-right-group">
            <div class="cv-header-right">
              <div class="cv-contact-item" *ngIf="store.resume().personalInfo.email">
                <svg class="contact-icon" viewBox="0 0 24 24"><path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/></svg> 
                {{ store.resume().personalInfo.email }}
              </div>
              <div class="cv-contact-item" *ngIf="store.resume().personalInfo.phone">
                <svg class="contact-icon" viewBox="0 0 24 24"><path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/></svg> 
                {{ store.resume().personalInfo.phone }}
              </div>
              <div class="cv-contact-item" *ngIf="store.resume().personalInfo.location">
                <svg class="contact-icon" viewBox="0 0 24 24"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5a2.5 2.5 0 0 1 0-5 2.5 2.5 0 0 1 0 5z"/></svg> 
                {{ store.resume().personalInfo.location }}
              </div>
              <div class="cv-contact-item" *ngIf="store.resume().personalInfo.linkedin">
                <svg class="contact-icon" viewBox="0 0 24 24"><path d="M19 3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14m-.5 15.5v-5.3a2.7 2.7 0 0 0-2.7-2.7c-1.2 0-2.3.7-2.6 1.1V10.2H10v8.3h3.2v-4.4c0-.2 0-.5.1-.7.2-.5.5-.9 1-.9.7 0 1 .5 1 1.3v4.7h3.2M6.7 8.7a1.6 1.6 0 1 0 0-3.2 1.6 1.6 0 0 0 0 3.2m1.6 10.3V10.2H5.1v8.8h3.2z"/></svg> 
                <a [href]="store.resume().personalInfo.linkedin" target="_blank">{{ (store.resume().personalInfo.linkedin || '').replace('https://', '').replace('www.', '') }}</a>
              </div>
              <div class="cv-contact-item" *ngIf="store.resume().personalInfo.github">
                <svg class="contact-icon" viewBox="0 0 24 24"><path d="M12 2A10 10 0 0 0 2 12c0 4.42 2.87 8.17 6.84 9.5.5.08.66-.23.66-.5v-1.69c-2.77.6-3.36-1.34-3.36-1.34-.46-1.16-1.11-1.47-1.11-1.47-.91-.62.07-.6.07-.6 1 .07 1.53 1.03 1.53 1.03.87 1.52 2.34 1.07 2.91.83.09-.65.35-1.09.63-1.34-2.22-.25-4.55-1.11-4.55-4.92 0-1.11.38-2 1.03-2.71-.1-.25-.45-1.29.1-2.64 0 0 .84-.27 2.75 1.02.79-.22 1.63-.33 2.47-.33.83 0 1.67.11 2.47.33 1.91-1.29 2.75-1.02 2.75-1.02.55 1.35.2 2.39.1 2.64.65.71 1.03 1.6 1.03 2.71 0 3.82-2.34 4.66-4.57 4.91.36.31.69.92.69 1.85V21c0 .27.16.59.67.5C19.14 20.16 22 16.42 22 12A10 10 0 0 0 12 2z"/></svg> 
                <a [href]="store.resume().personalInfo.github" target="_blank">{{ (store.resume().personalInfo.github || '').replace('https://', '').replace('www.', '') }}</a>
              </div>
              <div class="cv-contact-item" *ngIf="store.resume().personalInfo.website">
                <svg class="contact-icon" viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 17.93c-3.95-.49-7-3.85-7-7.93 0-.62.08-1.21.21-1.79L9 15v1c0 1.1.9 2 2 2v1.93zm6.9-2.54c-.26-.81-1-1.39-1.9-1.39h-1v-3c0-.55-.45-1-1-1H8v-2h2c.55 0 1-.45 1-1V7h2c1.1 0 2-.9 2-2v-.41c2.93 1.19 5 4.06 5 7.41 0 2.08-.8 3.97-2.1 5.39z"/></svg> 
                <a [href]="store.resume().personalInfo.website" target="_blank">{{ (store.resume().personalInfo.website || '').replace('https://', '').replace('www.', '') }}</a>
              </div>
            </div>
            <!-- PROFILE PHOTO -->
            <div class="cv-photo-container" *ngIf="store.resume().personalInfo.photo">
              <img [src]="store.resume().personalInfo.photo" class="cv-photo">
            </div>
          </div>
        </header>

        <!-- MAIN GRID STARTS HERE -->
        <div class="grid-layout">
          <!-- SUMMARY -->
          <ng-container *ngIf="store.resume().summary">
            <div class="cv-section-label">
              <svg class="section-icon" viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
              ABOUT ME
            </div>
            <div class="cv-section-content">
              <p class="cv-summary-text">{{ store.resume().summary }}</p>
            </div>
          </ng-container>
          
          <!-- WORK EXPERIENCE -->
          <ng-container *ngIf="filteredExperience.length > 0">
            <div class="cv-section-label">
              <svg class="section-icon" viewBox="0 0 24 24"><path d="M20 6h-4V4c0-1.11-.89-2-2-2h-4c-1.11 0-2 .89-2 2v2H4c-1.11 0-1.99.89-1.99 2L2 19c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V8c0-1.11-.89-2-2-2zm-6 0h-4V4h4v2z"/></svg>
              EXPERIENCE
            </div>
            <div class="cv-section-content">
              <ng-container *ngFor="let exp of filteredExperience">
                <span class="cv-date">{{ exp.startDate }} - {{ exp.current ? 'Present' : exp.endDate }}</span>
                <div class="cv-entry-info">
                  <h3 class="cv-entry-title">{{ exp.jobTitle }}</h3>
                  <div class="cv-entry-subtitle">{{ exp.company }}</div>
                  <div class="cv-entry-description" *ngIf="exp.description">
                    <ul class="europass-bullets">
                       <li *ngFor="let bullet of exp.description.split('\n')">{{ bullet }}</li>
                    </ul>
                  </div>
                </div>
              </ng-container>
            </div>
          </ng-container>

          <!-- EDUCATION -->
          <ng-container *ngIf="filteredEducation.length > 0">
            <div class="cv-section-label">
              <svg class="section-icon" viewBox="0 0 24 24"><path d="M5 13.18v4L12 21l7-3.82v-4L12 17l-7-3.82zM12 3L1 9l11 6 9-4.91V17h2V9L12 3z"/></svg>
              EDUCATION
            </div>
            <div class="cv-section-content">
              <ng-container *ngFor="let edu of filteredEducation">
                <span class="cv-date">{{ edu.startDate }} - {{ edu.endDate }}</span>
                <div class="cv-entry-info">
                  <h3 class="cv-entry-title">{{ edu.degree }}{{ edu.fieldOfStudy ? ' ' + edu.fieldOfStudy : '' }}</h3>
                  <div class="cv-entry-subtitle">{{ edu.school }}</div>
                  <div class="cv-entry-description" *ngIf="edu.description">{{ edu.description }}</div>
                </div>
              </ng-container>
            </div>
          </ng-container>

          <!-- SKILLS -->
        <ng-container *ngIf="filteredSkills.length > 0">
          <div class="cv-section-label">
            <svg class="section-icon" viewBox="0 0 24 24"><path d="M11 21h-1l1-7H7.5c-.88 0-.33-.75-.31-.78C8.48 10.94 10.42 7.54 13.01 3h1l-1 7h3.5c.66 0 .3.41.28.45C15.89 12.04 13.95 15.44 11.36 20c-.5.88-1.54.55-1.54.55z"/></svg>
            DIGITAL SKILLS
          </div>
          <div class="cv-section-content">
            <div class="cv-skill-wrapper">
              <div *ngFor="let skVal of filteredSkills" class="cv-skill-entry">
                <div class="cv-skill-cat">{{ skVal.category }}</div>
                <div class="cv-skills-list">
                  <span class="cv-skill-tag" *ngFor="let s of skVal.skills">{{ s }}</span>
                </div>
              </div>
            </div>
          </div>
        </ng-container>

          <!-- LANGUAGE -->
        <ng-container *ngIf="filteredLanguages.length > 0">
          <div class="cv-section-label">
            <svg class="section-icon" viewBox="0 0 24 24"><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zm6.93 6h-2.95c-.32-1.25-.78-2.45-1.38-3.56 1.84.63 3.37 1.91 4.33 3.56zM12 4.04c.83 1.2 1.48 2.53 1.91 3.96h-3.82c.43-1.43 1.08-2.76 1.91-3.96zM4.26 14C4.1 13.36 4 12.69 4 12s.1-1.36.26-2h3.38c-.08.66-.14 1.32-.14 2 0 .68.06 1.34.14 2H4.26zm.82 2h2.95c.32 1.25.78 2.45 1.38 3.56-1.84-.63-3.37-1.91-4.33-3.56zm2.95-8H5.08c.96-1.65 2.49-2.93 4.33-3.56C8.81 5.55 8.35 6.75 8.03 8zM12 19.96c-.83-1.2-1.48-2.53-1.91-3.96h3.82c-.43 1.43-1.08 2.76-1.91 3.96zM14.34 14H9.66c-.09-.66-.16-1.32-.16-2 0-.68.07-1.35.16-2h4.68c.09.65.16 1.32.16 2 0 .68-.07 1.34-.16 2zm.25 5.56c.6-1.11 1.06-2.31 1.38-3.56h2.95c-.96 1.65-2.49 2.93-4.33 3.56zM16.36 14c.08-.66.14-1.32.14-2 0-.68-.06-1.34-.14-2h3.38c.16.64.26 1.31.26 2s-.1 1.36-.26 2h-3.38z"/></svg>
            LANGUAGES
          </div>
          <div class="cv-section-content">
            <div class="cv-lang-wrapper">
              <div class="cv-lang-grid">
                 <div class="cv-lang-item" *ngFor="let lang of filteredLanguages">
                   <span class="cv-lang-name">{{ lang.name }}</span>
                   <span class="cv-lang-level">{{ lang.level }}</span>
                 </div>
              </div>
            </div>
          </div>
        </ng-container>
        </div><!-- END GRID-LAYOUT -->
      </div>
    </div>
  `,
  styleUrls: ['./europass-preview.component.css']
})
export class EuropassPreviewComponent {
  protected readonly store = inject(ResumeStore);

  @Input() isExporting = false;

  get filteredExperience() {
    return this.store.resume().experience || [];
  }

  get filteredEducation() {
    return this.store.resume().education || [];
  }

  get filteredSkills() {
    return this.store.resume().skills || [];
  }

  get filteredProjects() {
    return this.store.resume().projects || [];
  }

  get filteredLanguages() {
    return this.store.resume().languages || [];
  }

  get filteredCertifications() {
    return this.store.resume().certifications || [];
  }
}
