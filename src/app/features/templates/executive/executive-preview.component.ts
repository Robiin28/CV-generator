import { Component, Input, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ResumeStore } from '../../builder/store/resume.store';

@Component({
  selector: 'app-executive-preview',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="exec-document" [class.is-exporting]="isExporting">
      <div class="exec-content-wrapper">
        <!-- HEADER -->
        <header class="exec-header">
          <h1 class="exec-name">{{ store.resume().personalInfo.fullName || 'YOUR NAME' }}</h1>
          <p class="exec-title" *ngIf="store.resume().personalInfo.jobTitle">{{ store.resume().personalInfo.jobTitle | uppercase }}</p>
          
          <div class="exec-contact-grid">
            <div class="exec-contact-row" *ngIf="store.resume().personalInfo.phone || store.resume().personalInfo.email">
              <span *ngIf="store.resume().personalInfo.phone" class="contact-item">
                <strong>Phone:</strong> {{ store.resume().personalInfo.phone }}
              </span>
              <span class="sep" *ngIf="store.resume().personalInfo.phone && store.resume().personalInfo.email">|</span>
              <span *ngIf="store.resume().personalInfo.email" class="contact-item">
                <strong>Email:</strong> {{ store.resume().personalInfo.email }}
              </span>
            </div>
            
            <div class="exec-contact-row" *ngIf="store.resume().personalInfo.linkedin || store.resume().personalInfo.website">
              <span *ngIf="store.resume().personalInfo.linkedin" class="contact-item">
                <strong>LinkedIn:</strong> <a [href]="store.resume().personalInfo.linkedin" target="_blank">{{ (store.resume().personalInfo.linkedin || '').replace('https://', '').replace('www.', '') }}</a>
              </span>
              <span class="sep" *ngIf="store.resume().personalInfo.linkedin && store.resume().personalInfo.website">|</span>
              <span *ngIf="store.resume().personalInfo.website" class="contact-item">
                <strong>Portfolio:</strong> <a [href]="store.resume().personalInfo.website" target="_blank">{{ (store.resume().personalInfo.website || '').replace('https://', '').replace('www.', '') }}</a>
              </span>
            </div>
          </div>
        </header>

        <div class="section-divider-main"></div>

        <!-- SUMMARY -->
        <section class="exec-section" *ngIf="store.resume().summary">
          <p class="exec-summary-text">{{ store.resume().summary }}</p>
        </section>

        <!-- EDUCATION -->
        <section class="exec-section" *ngIf="filteredEducation.length > 0">
          <div class="section-header-centered">
            <div class="line"></div>
            <h2 class="exec-heading">EDUCATION</h2>
            <div class="line"></div>
          </div>
          
          <div class="exec-item" *ngFor="let edu of filteredEducation">
            <h3 class="exec-item-title-bold">{{ edu.degree }}{{ edu.fieldOfStudy ? ' ' + edu.fieldOfStudy : '' }}</h3>
            <div class="exec-item-subtitle-regular">
              {{ edu.school }} | {{ edu.startDate }} – {{ edu.endDate }}
            </div>
            <ul class="exec-bullets" *ngIf="edu.description && edu.description.trim()">
              <li *ngFor="let bullet of edu.description.split('\n')">{{ bullet }}</li>
            </ul>
          </div>
        </section>

        <!-- EXPERIENCE -->
        <section class="exec-section" *ngIf="filteredExperience.length > 0">
          <div class="section-header-centered">
            <div class="line"></div>
            <h2 class="exec-heading">PROFESSIONAL EXPERIENCE</h2>
            <div class="line"></div>
          </div>
          
          <div class="exec-item" *ngFor="let exp of filteredExperience">
            <h3 class="exec-job-title-caps">{{ exp.jobTitle }}</h3>
            <div class="exec-item-subheader-bold-italic">
              {{ exp.company }} | {{ exp.startDate }} – {{ exp.current ? 'Present' : exp.endDate }}
            </div>
            <ul class="exec-bullets" *ngIf="exp.description">
              <li *ngFor="let bullet of exp.description.split('\n')">{{ bullet }}</li>
            </ul>
          </div>
        </section>

        <!-- SKILLS & LANGUAGES -->
        <section class="exec-section" *ngIf="filteredSkills.length > 0 || filteredLanguages.length > 0">
          <div class="section-header-centered">
            <div class="line"></div>
            <h2 class="exec-heading">SKILLS AND LANGUAGES</h2>
            <div class="line"></div>
          </div>
          
          <div class="exec-grid-2col">
            <div class="grid-column" *ngIf="filteredSkills.length > 0">
              <h4 class="grid-label">SKILLS</h4>
              <ul class="grid-list">
                <li *ngFor="let cat of filteredSkills">
                  <strong>{{ cat.category }}:</strong> {{ cat.skills.join(', ') }}
                </li>
              </ul>
            </div>
            <div class="grid-column" *ngIf="filteredLanguages.length > 0">
              <h4 class="grid-label">LANGUAGES</h4>
              <ul class="grid-list">
                <li *ngFor="let lang of filteredLanguages">
                  <strong>{{ lang.name }}</strong> ({{ lang.level }})
                </li>
              </ul>
            </div>
          </div>
        </section>

        <!-- PROJECTS & PUBLICATIONS -->
        <section class="exec-section" *ngIf="filteredProjects.length > 0">
          <div class="section-header-centered">
            <div class="line"></div>
            <h2 class="exec-heading">PROJECTS & PUBLICATIONS</h2>
            <div class="line"></div>
          </div>
          
          <div class="exec-item" *ngFor="let proj of filteredProjects">
            <div class="project-line">
              <strong>{{ proj.name }}</strong>: {{ proj.description }}
              <a href="#" class="blue-link" (click)="$event.preventDefault()">View profile</a>
            </div>
          </div>
        </section>

        <!-- CERTIFICATIONS -->
        <section class="exec-section" *ngIf="filteredCertifications.length > 0">
          <div class="section-header-centered">
            <div class="line"></div>
            <h2 class="exec-heading">CERTIFICATIONS</h2>
            <div class="line"></div>
          </div>
          
          <div class="exec-item" *ngFor="let cert of filteredCertifications">
            <h3 class="exec-item-title-bold">{{ cert.name }}</h3>
            <div class="exec-item-subtitle-regular">
              <strong>{{ cert.issuer }}</strong> | {{ cert.date }}
            </div>
          </div>
        </section>
      </div>
    </div>
  `,
  styleUrls: ['./executive-preview.component.css']
})
export class ExecutivePreviewComponent {
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
