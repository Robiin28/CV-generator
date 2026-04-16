import { Component, inject, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ResumeStore } from '../store/resume.store';
import { AiService } from '../../../core/services/ai.service';
import { EuropassPreviewComponent } from '../../templates/europass/europass-preview.component';
import { ExecutivePreviewComponent } from '../../templates/executive/executive-preview.component';
@Component({
  selector: 'app-builder-page',
  standalone: true,
  imports: [CommonModule, EuropassPreviewComponent, ExecutivePreviewComponent],
  template: `
    <div class="builder-layout" [class.is-exporting]="isExporting">
      <!-- WORKSPACE NAV (STEPS) -->
      <aside class="workspace-steps">
        <div class="steps-list">
          @for (step of steps; track step.index) {
            <button
              class="step-btn"
              [class.active]="store.currentStep() === step.index"
              (click)="store.setStep(step.index)"
            >
              <div class="step-dot"></div>
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
                     @if (!store.resume().personalInfo.photo) { <span>👤</span> }
                   </div>
                   <div class="p-actions">
                     <input type="file" #fileInput hidden (change)="onFileSelected($event)" accept="image/*">
                     <button class="btn-saas btn-saas-outline btn-sm" (click)="fileInput.click()">Upload Photo</button>
                     @if (store.resume().personalInfo.photo) {
                       <button class="btn-saas btn-saas-outline btn-sm" (click)="removePhoto()">Remove</button>
                     }
                   </div>
                 </div>
                 <div class="field"><label>Full Name</label><input type="text" class="input-saas" [value]="store.resume().personalInfo.fullName" (input)="store.updatePersonalInfo({ fullName: $any($event.target).value })"></div>
                 <div class="field"><label>Job Title</label><input type="text" class="input-saas" [value]="store.resume().personalInfo.jobTitle || ''" (input)="store.updatePersonalInfo({ jobTitle: $any($event.target).value })"></div>
                 <div class="field"><label>Email</label><input type="email" class="input-saas" [value]="store.resume().personalInfo.email" (input)="store.updatePersonalInfo({ email: $any($event.target).value })"></div>
                 <div class="field"><label>Phone</label><input type="text" class="input-saas" [value]="store.resume().personalInfo.phone" (input)="store.updatePersonalInfo({ phone: $any($event.target).value })"></div>
               </div>
             }
             @if (store.currentStep() === 1) {
               <div class="field"><label>Summary</label><textarea class="input-saas" rows="6" [value]="store.resume().summary" (input)="store.updateSummary($any($event.target).value)"></textarea></div>
             }
             @if (store.currentStep() === 2) {
               <div class="list-area">
                 <button class="btn-saas btn-saas-outline w-full mb-4" (click)="addExperience()">+ Add Experience</button>
                 @for (exp of store.resume().experience; track exp.id) {
                   <div class="item-card">
                     <button class="del-btn" (click)="store.removeExperience(exp.id)">✕</button>
                     <div class="input-grid">
                       <div class="field"><label>Position</label><input class="input-saas" [value]="exp.jobTitle" (input)="store.updateExperience(exp.id, { jobTitle: $any($event.target).value })"></div>
                       <div class="field"><label>Company</label><input class="input-saas" [value]="exp.company" (input)="store.updateExperience(exp.id, { company: $any($event.target).value })"></div>
                       <div class="field"><label>Location</label><input class="input-saas" [value]="exp.location" (input)="store.updateExperience(exp.id, { location: $any($event.target).value })"></div>
                       <div class="field"><label>Start Date</label><input class="input-saas" [value]="exp.startDate" (input)="store.updateExperience(exp.id, { startDate: $any($event.target).value })" placeholder="e.g. June 2020"></div>
                       <div class="field"><label>End Date</label><input class="input-saas" [value]="exp.endDate" (input)="store.updateExperience(exp.id, { endDate: $any($event.target).value })" [disabled]="exp.current" placeholder="e.g. Present"></div>
                       <div class="field" style="display:flex; align-items:center; gap:8px; padding-top:24px">
                         <input type="checkbox" [id]="'curr-' + exp.id" [checked]="exp.current" (change)="store.updateExperience(exp.id, { current: $any($event.target).checked })">
                         <label [for]="'curr-' + exp.id" style="margin:0">Currently Work Here</label>
                       </div>
                       <div class="field full"><label>Description / Achievements (One per line)</label>
                         <textarea class="input-saas" rows="4" [value]="exp.description" (input)="store.updateExperience(exp.id, { description: $any($event.target).value })" placeholder="• Achieved X using Y..."></textarea>
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
                       <div class="field"><label>Degree / Certificate</label><input class="input-saas" [value]="edu.degree" (input)="store.updateEducation(edu.id, { degree: $any($event.target).value })" placeholder="e.g. Master of Science"></div>
                       <div class="field"><label>University / School</label><input class="input-saas" [value]="edu.school" (input)="store.updateEducation(edu.id, { school: $any($event.target).value })" placeholder="e.g. London School of Economics"></div>
                       <div class="field"><label>Field of Study</label><input class="input-saas" [value]="edu.fieldOfStudy" (input)="store.updateEducation(edu.id, { fieldOfStudy: $any($event.target).value })" placeholder="e.g. Media & Communications"></div>
                       <div class="field"><label>Start Date</label><input class="input-saas" [value]="edu.startDate" (input)="store.updateEducation(edu.id, { startDate: $any($event.target).value })" placeholder="e.g. 2024"></div>
                       <div class="field"><label>End Date</label><input class="input-saas" [value]="edu.endDate" (input)="store.updateEducation(edu.id, { endDate: $any($event.target).value })" placeholder="e.g. Present"></div>
                       <div class="field full"><label>Description (Optional)</label>
                         <textarea class="input-saas" rows="3" [value]="edu.description" (input)="store.updateEducation(edu.id, { description: $any($event.target).value })" placeholder="Focused on strategic communication..."></textarea>
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
                     <div class="field"><label>Category</label><input class="input-saas" [value]="cat.category" (input)="store.updateSkillCategory($index, { category: $any($event.target).value })"></div>
                     <div class="field"><label>Skills</label><input class="input-saas" [value]="cat.skills.join(', ')" (input)="onSkillsInput($index, $event)"></div>
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
                     <div class="field"><label>Project Name</label><input class="input-saas" [value]="proj.name" (input)="store.updateProject(proj.id, { name: $any($event.target).value })"></div>
                     <div class="field"><label>Technologies</label><input class="input-saas" [value]="proj.technologies" (input)="store.updateProject(proj.id, { technologies: $any($event.target).value })"></div>
                     <div class="field"><label>Description</label><textarea class="input-saas" rows="3" [value]="proj.description" (input)="store.updateProject(proj.id, { description: $any($event.target).value })"></textarea></div>
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
                     <div class="field"><label>Language</label><input class="input-saas" [value]="lang.name" (input)="store.updateLanguage(lang.id, { name: $any($event.target).value })"></div>
                     <div class="field"><label>Proficiency</label><input class="input-saas" [value]="lang.level" (input)="store.updateLanguage(lang.id, { level: $any($event.target).value })"></div>
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
                     <div class="field"><label>Certificate Name</label><input class="input-saas" [value]="cert.name" (input)="store.updateCertification(cert.id, { name: $any($event.target).value })"></div>
                     <div class="field"><label>Issuer</label><input class="input-saas" [value]="cert.issuer" (input)="store.updateCertification(cert.id, { issuer: $any($event.target).value })"></div>
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
    </div>
  `,
  styles: [`
    .builder-layout { display: flex; height: 100%; background: #f8fafc; }
    .workspace-steps { width: 220px; border-right: 1px solid #e2e8f0; background: #fff; padding: 2rem 1rem; }
    .steps-list { display: flex; flex-direction: column; gap: 0.5rem; }
    .step-btn { display: flex; align-items: center; gap: 0.75rem; padding: 0.75rem 1rem; border: none; background: none; cursor: pointer; border-radius: 8px; text-align: left; }
    .step-btn.active { background: #eff6ff; }
    .step-dot { width: 6px; height: 6px; border-radius: 50%; background: #e2e8f0; }
    .step-btn.active .step-dot { background: #3b82f6; }
    .step-name { font-size: 0.85rem; font-weight: 600; color: #64748b; }
    .step-btn.active .step-name { color: #3b82f6; }

    .form-section { flex: 1; display: flex; flex-direction: column; max-width: 700px; }
    .form-header { padding: 1.5rem 2rem; border-bottom: 1px solid #e2e8f0; background: #fff; display: flex; justify-content: space-between; }
    .form-content { flex: 1; overflow-y: auto; padding: 2rem; }
    .card { background: #fff; border: 1px solid #e2e8f0; border-radius: 12px; padding: 1.5rem; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
    .field { margin-bottom: 1.25rem; display: flex; flex-direction: column; gap: 0.5rem; }
    .field label { font-size: 0.75rem; font-weight: 700; color: #475569; }
    .input-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
    .field.full { grid-column: span 2; }
    .input-group-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }

    .preview-section { flex: 1; display: flex; flex-direction: column; background: #fff; border-left: 1px solid #e2e8f0; position: relative; }
    .preview-toolbar { padding: 0.75rem 1.5rem; background: #fff; border-bottom: 1px solid #f1f5f9; display: flex; justify-content: space-between; align-items: center; }
    .preview-canvas { flex: 1; overflow-y: auto; padding: 0; display: flex; justify-content: center; background: #fff; }
    .a4-document-editor { display: flex; flex-direction: column; gap: 0; align-items: center; width: 100%; background: #fff; }
    
    .photo-uploader { grid-column: span 2; display: flex; align-items: center; gap: 1rem; border-bottom: 1px solid #f1f5f9; padding-bottom: 1rem; margin-bottom: 0.5rem; }
    .p-preview { width: 60px; height: 60px; border-radius: 50%; background: #f1f5f9; background-size: cover; background-position: center; display: flex; align-items: center; justify-content: center; }
  `]
})
export class BuilderPageComponent {
  protected readonly store = inject(ResumeStore);
  private readonly aiService = inject(AiService);

  readonly steps = [
    { index: 0, label: 'Personal Info', icon: '👤' },
    { index: 1, label: 'Summary', icon: '📑' },
    { index: 2, label: 'Experience', icon: '💼' },
    { index: 3, label: 'Education', icon: '🎓' },
    { index: 4, label: 'Skills', icon: '⚡' },
    { index: 5, label: 'Projects', icon: '🚀' },
    { index: 6, label: 'Languages', icon: '🌐' },
    { index: 7, label: 'Certs', icon: '🏅' },
  ];

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
