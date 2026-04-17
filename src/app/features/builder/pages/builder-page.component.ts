import { Component, inject, signal, computed, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DomSanitizer, SafeHtml } from '@angular/platform-browser';
import { ResumeStore } from '../store/resume.store';
import { AiService } from '../../../core/services/ai.service';
import { EuropassPreviewComponent } from '../../templates/europass/europass-preview.component';
import { ExecutivePreviewComponent } from '../../templates/executive/executive-preview.component';
import { AiChatComponent } from '../../ai-chat/ai-chat.component';
@Component({
  selector: 'app-builder-page',
  standalone: true,
  imports: [CommonModule, EuropassPreviewComponent, ExecutivePreviewComponent, AiChatComponent],
  template: `
    <div class="builder-layout" [class.is-exporting]="isExporting" [class.preview-mode]="viewMode() === 'preview'" [class.ai-minimized]="aiMinimized()">
      <!-- STICKY TOP HEADER (MOBILE) -->
      <div class="mobile-sticky-header">
        <!-- MOBILE VIEW TOGGLE -->
        <div class="mobile-view-tabs">
          <button [class.active]="viewMode() === 'edit'" (click)="onViewModeChange('edit')">
            <svg style="width:16px;height:16px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
            Edit
          </button>
          <button [class.active]="viewMode() === 'preview'" (click)="onViewModeChange('preview')">
            <svg style="width:16px;height:16px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
            Preview
          </button>
        </div>
      </div>

      <!-- WORKSPACE NAV (STEPS) -->
      <aside class="workspace-steps">
        <div class="steps-list">
          @for (step of steps; track step.index) {
            <button
              class="step-btn"
              [class.active]="store.currentStep() === step.index"
              (click)="onStepClick(step.index)"
            >
              <span class="step-icon" [innerHTML]="step.safeIcon"></span>
              <span class="step-name">{{ step.label }}</span>
            </button>
          }
        </div>
      </aside>

      <!-- FORM SECTION -->
      <main class="form-section">
        <header class="form-header">
          <div class="h-left">
            <h2>{{ steps[store.currentStep()].label }}</h2>
            <p class="h-sub">Complete the details below.</p>
          </div>
          <div class="h-right">
             <button class="btn-saas btn-saas-outline" (click)="prev()" [disabled]="store.currentStep() === 0">Prev</button>
             <button class="btn-saas btn-saas-primary" (click)="next()" [disabled]="store.currentStep() === steps.length - 1">Next</button>
          </div>
        </header>

        <div class="form-content">
          <div class="card fade-in">
             <!-- Steps content... (omitted for brevity, assume same as before) -->
             @if (store.currentStep() === 0) {
               <div class="input-group-grid">
                 <div class="photo-uploader">
                    <div class="p-preview" [style.background-image]="'url(' + (store.resume().personalInfo.photo || '') + ')'">
                      @if (!store.resume().personalInfo.photo) {
                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                      }
                    </div>
                   <div class="p-actions">
                     <input type="file" #fileInput hidden (change)="onFileSelected($event)" accept="image/*">
                     <button class="btn-saas btn-saas-outline btn-sm" (click)="fileInput.click()">Upload Photo</button>
                     @if (store.resume().personalInfo.photo) {
                       <button class="btn-saas btn-saas-outline btn-sm" (click)="removePhoto()">Remove</button>
                     }
                   </div>
                 </div>
                 <div class="field"><label>Full Name</label><input type="text" class="input-saas" placeholder="e.g. John Doe" [value]="store.resume().personalInfo.fullName" (input)="store.updatePersonalInfo({ fullName: $any($event.target).value })"></div>
                 <div class="field"><label>Job Title</label><input type="text" class="input-saas" placeholder="e.g. Senior Software Engineer" [value]="store.resume().personalInfo.jobTitle || ''" (input)="store.updatePersonalInfo({ jobTitle: $any($event.target).value })"></div>
                 <div class="field"><label>Email</label><input type="email" class="input-saas" placeholder="e.g. john.doe@example.com" [value]="store.resume().personalInfo.email" (input)="store.updatePersonalInfo({ email: $any($event.target).value })"></div>
                 <div class="field"><label>Phone</label><input type="text" class="input-saas" placeholder="e.g. +1 (555) 000-0000" [value]="store.resume().personalInfo.phone" (input)="store.updatePersonalInfo({ phone: $any($event.target).value })"></div>
               </div>
             }
             @if (store.currentStep() === 1) {
               <div class="field"><label>Summary</label><textarea class="input-saas" rows="6" placeholder="Briefly describe your career goals and what you bring to the table..." [value]="store.resume().summary" (input)="store.updateSummary($any($event.target).value)"></textarea></div>
             }
             @if (store.currentStep() === 2) {
               <div class="list-area">
                 <button class="btn-saas btn-saas-outline w-full mb-4" (click)="addExperience()">+ Add Experience</button>
                 @for (exp of store.resume().experience; track exp.id) {
                   <div class="item-card">
                     <button class="del-btn" (click)="store.removeExperience(exp.id)">✕</button>
                     <div class="input-grid">
                       <div class="field"><label>Position</label><input class="input-saas" placeholder="e.g. Software Engineer" [value]="exp.jobTitle" (input)="store.updateExperience(exp.id, { jobTitle: $any($event.target).value })"></div>
                       <div class="field"><label>Company</label><input class="input-saas" placeholder="e.g. Google" [value]="exp.company" (input)="store.updateExperience(exp.id, { company: $any($event.target).value })"></div>
                       <div class="field"><label>Location</label><input class="input-saas" placeholder="e.g. Mountain View, CA" [value]="exp.location" (input)="store.updateExperience(exp.id, { location: $any($event.target).value })"></div>
                       <div class="field"><label>Start Date</label><input class="input-saas" [value]="exp.startDate" (input)="store.updateExperience(exp.id, { startDate: $any($event.target).value })" placeholder="e.g. Jan 2020"></div>
                       <div class="field"><label>End Date</label><input class="input-saas" [value]="exp.endDate" (input)="store.updateExperience(exp.id, { endDate: $any($event.target).value })" [disabled]="exp.current" placeholder="e.g. Present"></div>
                       <div class="field" style="display:flex; align-items:center; gap:8px; padding-top:24px">
                         <input type="checkbox" [id]="'curr-' + exp.id" [checked]="exp.current" (change)="store.updateExperience(exp.id, { current: $any($event.target).checked })">
                         <label [for]="'curr-' + exp.id" style="margin:0">Currently Work Here</label>
                       </div>
                        <div class="field full" style="margin-top: 0.5rem;"><label>Description / Achievements (One per line)</label>
                          <textarea class="input-saas" rows="4" [value]="exp.description" (input)="store.updateExperience(exp.id, { description: $any($event.target).value })" placeholder="• Led development of X, resulting in Y% improvement...&#10;• Collaborated with team members to achieve Z..."></textarea>
                        </div>
                     </div>
                   </div>
                 }
               </div>
             }
             @if (store.currentStep() === 3) {
               <div class="list-area">
                 <button class="btn-saas btn-saas-outline w-full mb-4" (click)="addEducation()">+ Add Education</button>
                 @for (edu of store.resume().education; track edu.id) {
                   <div class="item-card">
                     <button class="del-btn" (click)="store.removeEducation(edu.id)">✕</button>
                     <div class="input-grid">
                       <div class="field"><label>Degree / Certificate</label><input class="input-saas" [value]="edu.degree" (input)="store.updateEducation(edu.id, { degree: $any($event.target).value })" placeholder="e.g. Bachelor of Science in Computer Science"></div>
                       <div class="field"><label>University / School</label><input class="input-saas" [value]="edu.school" (input)="store.updateEducation(edu.id, { school: $any($event.target).value })" placeholder="e.g. Stanford University"></div>
                       <div class="field"><label>Field of Study</label><input class="input-saas" [value]="edu.fieldOfStudy" (input)="store.updateEducation(edu.id, { fieldOfStudy: $any($event.target).value })" placeholder="e.g. Computer Science"></div>
                       <div class="field"><label>Start Date</label><input class="input-saas" [value]="edu.startDate" (input)="store.updateEducation(edu.id, { startDate: $any($event.target).value })" placeholder="e.g. 2016"></div>
                       <div class="field"><label>End Date</label><input class="input-saas" [value]="edu.endDate" (input)="store.updateEducation(edu.id, { endDate: $any($event.target).value })" placeholder="e.g. 2020"></div>
                       <div class="field full"><label>Description (Optional)</label>
                         <textarea class="input-saas" rows="3" [value]="edu.description" (input)="store.updateEducation(edu.id, { description: $any($event.target).value })" placeholder="Relevant coursework, honors, or extracurricular activities..."></textarea>
                       </div>
                     </div>
                   </div>
                 }
               </div>
             }
             @if (store.currentStep() === 4) {
               <div class="list-area">
                 <button class="btn-saas btn-saas-outline w-full mb-4" (click)="addSkillCategory()">+ Add Skills</button>
                 @for (cat of store.resume().skills; track $index) {
                   <div class="item-card">
                     <button class="del-btn" (click)="store.removeSkillCategory($index)">✕</button>
                     <div class="field"><label>Category</label><input class="input-saas" placeholder="e.g. Languages / Technologies" [value]="cat.category" (input)="store.updateSkillCategory($index, { category: $any($event.target).value })"></div>
                     <div class="field"><label>Skills</label><input class="input-saas" placeholder="e.g. JavaScript, TypeScript, Python" [value]="cat.skills.join(', ')" (input)="onSkillsInput($index, $event)"></div>
                   </div>
                 }
               </div>
             }
             @if (store.currentStep() === 5) {
               <div class="list-area">
                 <button class="btn-saas btn-saas-outline w-full mb-4" (click)="addProject()">+ Add Project</button>
                 @for (proj of store.resume().projects; track proj.id) {
                   <div class="item-card">
                     <button class="del-btn" (click)="store.removeProject(proj.id)">✕</button>
                     <div class="field"><label>Project Name</label><input class="input-saas" placeholder="e.g. Personal Portfolio" [value]="proj.name" (input)="store.updateProject(proj.id, { name: $any($event.target).value })"></div>
                     <div class="field"><label>Technologies</label><input class="input-saas" placeholder="e.g. React, Node.js, AWS" [value]="proj.technologies" (input)="store.updateProject(proj.id, { technologies: $any($event.target).value })"></div>
                     <div class="field"><label>Description</label><textarea class="input-saas" rows="3" placeholder="Briefly describe the project and your role..." [value]="proj.description" (input)="store.updateProject(proj.id, { description: $any($event.target).value })"></textarea></div>
                   </div>
                 }
               </div>
             }
             @if (store.currentStep() === 6) {
               <div class="list-area">
                 <button class="btn-saas btn-saas-outline w-full mb-4" (click)="addLanguage()">+ Add Language</button>
                 @for (lang of store.resume().languages; track lang.id) {
                   <div class="item-card">
                     <button class="del-btn" (click)="store.removeLanguage(lang.id)">✕</button>
                     <div class="field"><label>Language</label><input class="input-saas" placeholder="e.g. English" [value]="lang.name" (input)="store.updateLanguage(lang.id, { name: $any($event.target).value })"></div>
                     <div class="field"><label>Proficiency</label><input class="input-saas" placeholder="e.g. Native / Bilingual" [value]="lang.level" (input)="store.updateLanguage(lang.id, { level: $any($event.target).value })"></div>
                   </div>
                 }
               </div>
             }
             @if (store.currentStep() === 7) {
               <div class="list-area">
                 <button class="btn-saas btn-saas-outline w-full mb-4" (click)="addCertification()">+ Add Certification</button>
                 @for (cert of store.resume().certifications; track cert.id) {
                   <div class="item-card">
                     <button class="del-btn" (click)="store.removeCertification(cert.id)">✕</button>
                     <div class="field"><label>Certificate Name</label><input class="input-saas" placeholder="e.g. AWS Solutions Architect" [value]="cert.name" (input)="store.updateCertification(cert.id, { name: $any($event.target).value })"></div>
                     <div class="field"><label>Issuer</label><input class="input-saas" placeholder="e.g. Amazon Web Services" [value]="cert.issuer" (input)="store.updateCertification(cert.id, { issuer: $any($event.target).value })"></div>
                   </div>
                 }
               </div>
             }
          </div>
        </div>
      </main>

      <!-- PREVIEW SECTION -->
      <section class="preview-section">
        <div class="preview-toolbar">
          <div class="doc-status">
             <span class="status-dot"></span>
             <span>Continuous Print Layout</span>
          </div>
          <button class="btn-saas btn-saas-primary btn-sm" (click)="exportToPdf()" [disabled]="isExporting">
             {{ isExporting ? 'Exporting...' : 'Download PDF' }}
          </button>
        </div>
        
        <div class="preview-canvas">
          <div class="a4-document-editor continuous-scroll">
             @if (store.selectedTemplateId() === 'exec-01') {
                <app-executive-preview [isExporting]="isExporting"></app-executive-preview>
             } @else {
                <app-europass-preview [isExporting]="isExporting"></app-europass-preview>
             }
          </div>
        </div>
      </section>

      <!-- AI ASSISTANT OVERLAY (Managed here for visibility logic) -->
      @if (viewMode() === 'edit') {
        <app-ai-chat class="floating-ai" [minimized]="aiMinimized()" (toggle)="aiMinimized.set(!aiMinimized())"></app-ai-chat>
      }
    </div>
  `,
  styles: [`
    .builder-layout { 
      display: flex; height: 100vh; background: var(--bg-surface); overflow: hidden; 
      transition: padding 0.3s ease;
    }
    .workspace-steps { 
      width: 200px;
      border-right: 1px solid var(--border-light); background: var(--bg-card); padding: 1.5rem 0.5rem; overflow-y: auto; 
      flex-shrink: 0;
    }
    .steps-list { display: flex; flex-direction: column; gap: 0.5rem; }
    .step-btn { 
      display: flex; align-items: center; gap: 0.75rem; padding: 0.75rem 1rem; 
      border: none; background: none; cursor: pointer; border-radius: 12px; 
      text-align: left; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .step-btn:hover { background: var(--bg-hover); }
    .step-btn.active { background: var(--color-primary-soft); }
    .step-icon { 
      display: flex; align-items: center; justify-content: center;
      width: 20px; height: 20px; color: var(--text-muted); transition: color 0.2s;
    }
    .step-btn.active .step-icon { color: var(--color-primary); }
    .step-name { font-size: 0.85rem; font-weight: 600; color: var(--text-muted); transition: color 0.2s; }
    .step-btn.active .step-name { color: var(--color-primary); }
    
    .item-card { 
      background: var(--bg-card); border: 1px solid var(--border-light); border-radius: 12px; 
      padding: 1.5rem; margin-bottom: 1.5rem; position: relative; 
      transition: all 0.3s ease; box-shadow: var(--shadow-sm);
    }
    .item-card:hover { border-color: var(--color-primary); box-shadow: var(--shadow-md); }
    .del-btn { 
      position: absolute; top: 0.75rem; right: 0.75rem; 
      width: 28px; height: 28px; border-radius: 50%;
      background: #fee2e2; color: #ef4444; border: none;
      display: flex; align-items: center; justify-content: center;
      cursor: pointer; transition: all 0.2s; z-index: 5;
    }
    .del-btn:hover { background: #ef4444; color: white; transform: scale(1.1); }
    :host-context(.dark) .del-btn { background: rgba(239, 68, 68, 0.1); }
    :host-context(.dark) .del-btn:hover { background: #ef4444; }
    
    .mobile-sticky-header { display: none; }
    .mobile-view-tabs { display: none; }

    .form-section { flex: 1; display: flex; flex-direction: column; min-width: 0; background: var(--bg-surface); }
    .form-header { padding: 1.5rem 2rem; border-bottom: 1px solid var(--border-light); background: var(--bg-card); display: flex; justify-content: space-between; align-items: center; }
    .form-header h2 { color: var(--text-heading); }
    .h-sub { color: var(--text-muted); }
    
    .form-content { flex: 1; overflow-y: auto; padding: 2rem; scroll-behavior: smooth; }
    .card { background: var(--bg-card); border: 1px solid var(--border-light); border-radius: 16px; padding: 2rem; box-shadow: var(--shadow-sm); }
    .field { margin-bottom: 1.5rem; display: flex; flex-direction: column; gap: 0.5rem; }
    .field label { font-size: 0.75rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.025em; }
    .input-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; }
    .field.full { grid-column: span 2; }
    .input-group-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; }

    .preview-section { flex: 1; display: flex; flex-direction: column; background: var(--bg-card); border-left: 1px solid var(--border-light); position: relative; min-width: 0; }
    .preview-toolbar { padding: 1rem 1.5rem; background: var(--bg-card); border-bottom: 1px solid var(--border-light); display: flex; justify-content: space-between; align-items: center; }
    .doc-status span { color: var(--text-body); }
    
    .preview-canvas { 
      flex: 1; 
      overflow-y: auto; 
      padding: 3rem 1.5rem; 
      display: block; 
      background: var(--bg-canvas); 
      -webkit-overflow-scrolling: touch;
    }
    .a4-document-editor { 
      width: fit-content; 
      margin: 0 auto;
      box-shadow: 0 20px 50px rgba(0,0,0,0.15); 
      border-radius: 4px; 
      background: white;
    }
    
    .photo-uploader { grid-column: span 2; display: flex; align-items: center; gap: 1.5rem; border-bottom: 1px solid var(--border-subtle); padding-bottom: 1.5rem; margin-bottom: 0.5rem; }
    .p-preview { width: 80px; height: 80px; border-radius: 50%; background: var(--bg-surface); background-size: cover; background-position: center; display: flex; align-items: center; justify-content: center; border: 2px dashed var(--border-light); overflow: hidden; }
    .p-preview svg { color: var(--text-muted); opacity: 0.6; }

    @media (max-width: 1024px) {
      .builder-layout { flex-direction: column; overflow-y: auto; height: auto; min-height: 100vh; }
      .mobile-sticky-header {
        display: block; position: sticky; top: 0; z-index: 50;
        background: var(--bg-card); border-bottom: 1px solid var(--border-light);
        box-shadow: var(--shadow-md);
      }
      .mobile-view-tabs { display: flex; border-bottom: 1px solid var(--border-subtle); }
      .mobile-view-tabs button { 
        flex: 1; padding: 0.85rem; border: none; background: none; 
        font-weight: 700; font-size: 0.8rem; color: var(--text-muted);
        border-bottom: 3px solid transparent;
        display: flex; align-items: center; justify-content: center; gap: 6px;
      }
      .mobile-view-tabs button.active { color: var(--color-primary); border-bottom-color: var(--color-primary); background: var(--color-primary-soft); }

      .workspace-steps { 
        width: 100%; border-right: none; border-bottom: none;
        padding: 0.5rem; height: auto; background: var(--bg-card);
        position: sticky; top: 48px; z-index: 45;
      }
      .steps-list { 
        flex-direction: row; overflow-x: auto; padding: 0.25rem 0.5rem; gap: 0.5rem;
        -webkit-overflow-scrolling: touch; scrollbar-width: none;
      }
      .steps-list::-webkit-scrollbar { display: none; }
      .step-btn { 
        white-space: nowrap; flex-shrink: 0; padding: 0.5rem 0.75rem; 
        flex-direction: column; gap: 4px; border-radius: 12px;
        min-width: 80px; justify-content: center; align-items: center;
        background: var(--bg-card); border: 1px solid var(--border-subtle);
      }
      .step-btn.active { border-color: var(--color-primary); background: var(--color-primary-soft); }
      .step-name { font-size: 0.6rem; text-align: center; font-weight: 700; }
      .step-icon { width: 18px; height: 18px; }

      .builder-layout { flex-direction: column; overflow-y: auto; height: auto; min-height: 100vh; }
      
      .form-section, .preview-section { display: none; }
      .builder-layout:not(.preview-mode) .form-section { display: flex; flex: none; }
      .builder-layout.preview-mode .preview-section { display: flex; width: 100%; flex: none; }

      .form-header { 
        padding: 1.25rem;
        flex-direction: row;
        flex-wrap: wrap;
        gap: 1rem;
        align-items: center;
        background: var(--bg-card);
      }
      .form-header .h-left { flex: 1; min-width: 150px; }
      .form-header h2 { font-size: 1.25rem; }
      .form-header .h-right { display: flex; gap: 0.5rem; }
      .form-header .btn-saas { padding: 0.5rem 1rem; font-size: 0.8rem; }

      .form-content { padding: 1.25rem; overflow-y: visible; flex: none; }
      .card { border-radius: 12px; padding: 1.5rem; }
      .photo-uploader { flex-direction: column; text-align: center; padding-bottom: 2rem; }
      .input-grid, .input-group-grid { grid-template-columns: 1fr; gap: 1.25rem; }
      .field.full { grid-column: span 1; }
      .preview-canvas { 
        padding: 1rem 0.5rem; 
        background: var(--bg-canvas); 
        width: 100%; 
        overflow-y: visible;
        display: block;
      }
      .a4-document-editor { 
        width: 100%;
        transform: scale(0.95);
        transform-origin: top center;
        margin: 0;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
      }
      .floating-ai {
        bottom: 1.5rem;
        z-index: 1000;
      }
    }
  `]
})
export class BuilderPageComponent implements OnInit {
  protected readonly store = inject(ResumeStore);
  private readonly aiService = inject(AiService);
  private readonly sanitizer = inject(DomSanitizer);
  protected readonly viewMode = signal<'edit' | 'preview'>('edit');
  protected readonly aiMinimized = signal(false);

  steps: any[] = [
    { index: 0, label: 'Personal Info', icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>' },
    { index: 1, label: 'Summary', icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>' },
    { index: 2, label: 'Experience', icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path></svg>' },
    { index: 3, label: 'Education', icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 9 3 12 0v-5"></path></svg>' },
    { index: 4, label: 'Skills', icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>' },
    { index: 5, label: 'Projects', icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>' },
    { index: 6, label: 'Languages', icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="2" y1="12" x2="22" y2="12"></line><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path></svg>' },
    { index: 7, label: 'Certs', icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="7"></circle><polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"></polyline></svg>' },
  ];

  ngOnInit() {
    this.steps = this.steps.map(s => ({
      ...s,
      safeIcon: this.sanitizer.bypassSecurityTrustHtml(s.icon)
    }));
  }

  onViewModeChange(mode: 'edit' | 'preview') {
    this.viewMode.set(mode);
    window.scrollTo({ top: 0, behavior: 'instant' });
  }

  onStepClick(index: number) {
    this.store.setStep(index);
    this.onViewModeChange('edit');
  }

  // Paged JS layout engine safely removed in favor of Continuous Native CSS Printing

  onFileSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e: any) => this.store.updatePersonalInfo({ photo: e.target.result });
      reader.readAsDataURL(file);
    }
  }
  removePhoto() { this.store.updatePersonalInfo({ photo: '' }); }

  addExperience() {
    const id = crypto.randomUUID();
    this.store.addExperience({ id, jobTitle: 'New Position', company: 'Company Name', location: '', startDate: '2023', endDate: 'Present', current: true, description: '', bullets: [] });
  }
  addEducation() {
    const id = crypto.randomUUID();
    this.store.addEducation({ id, school: 'University', degree: 'Degree', fieldOfStudy: '', startDate: '', endDate: '', gpa: '' });
  }
  addSkillCategory() { this.store.addSkillCategory({ category: 'Category', skills: [] }); }
  addProject() { this.store.addProject({ id: crypto.randomUUID(), name: '', description: '', technologies: '', bullets: [] }); }
  addLanguage() { this.store.addLanguage({ id: crypto.randomUUID(), name: '', level: '' }); }
  addCertification() { this.store.addCertification({ id: crypto.randomUUID(), name: '', issuer: '', date: '' }); }

  onSkillsInput(index: number, event: any) {
    const skills = event.target.value.split(',').map((s: string) => s.trim()).filter((s: string) => s);
    this.store.updateSkillCategory(index, { skills });
  }

  improve(text: string) {
    if (!text) return;
    this.aiService.improveSection(text, 'Resume Section').subscribe(improved => {
      // For now show as alert, in real app would be a modal
      alert('AI Suggestion:\n\n' + improved);
    });
  }

  isExporting = false;
  async exportToPdf() {
    this.isExporting = true;
    try {
      const element = document.querySelector('.continuous-scroll');
      if (!element) return;
      await new Promise(r => setTimeout(r, 100));

      const opt = {
        margin: [5, 7, 10, 7],
        filename: this.store.resume().personalInfo.fullName.replace(/\s+/g, '_') + '_Professional_CV.pdf',
        image: { type: 'jpeg', quality: 1.0 },
        html2canvas: { 
          scale: 3, 
          useCORS: true, 
          letterRendering: true, 
          backgroundColor: '#ffffff',
          logging: false
        },
        jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' },
        pagebreak: { mode: ['css', 'legacy'] }
      };

      await (window as any).html2pdf().set(opt).from(element).save();
    } catch (e) {
      console.error(e);
    } finally {
      this.isExporting = false;
    }
  }

  next() { if (this.store.currentStep() < this.steps.length - 1) this.store.setStep(this.store.currentStep() + 1); }
  prev() { if (this.store.currentStep() > 0) this.store.setStep(this.store.currentStep() - 1); }
}
