import { Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { TemplateService, ResumeTemplate } from '../../core/services/template.service';
import { TemplateCardComponent } from './template-card.component';
import { ResumeStore } from '../builder/store/resume.store';

@Component({
  selector: 'app-template-gallery',
  standalone: true,
  imports: [CommonModule, TemplateCardComponent],
  template: `
    <div class="gallery-hero fade-in">
      <div class="hero-content">
        <h1 class="font-display">Professional <span class="gradient-teal">CV Templates</span></h1>
        <p>Expertly designed layouts that beat the 6-second recruiter test. Select a starting point and build your career story.</p>
        
        <div class="filter-bar glass">
          @for (cat of categories; track cat) {
            <button 
              class="filter-btn" 
              [class.active]="activeCategory() === cat"
              (click)="activeCategory.set(cat)"
            >
              {{ cat }}
            </button>
          }
        </div>
      </div>
    </div>

    <div class="gallery-container">
      <div class="template-grid">
        @for (template of filteredTemplates; track template.id) {
          <app-template-card
            [template]="template"
            [isSelected]="store.selectedTemplateId() === template.id"
            (select)="selectAndProceed(template.id)"
          ></app-template-card>
        }
      </div>
    </div>
  `,
  styles: [`
    .gallery-hero { 
      padding: 6rem 2rem; 
      background: radial-gradient(circle at 10% 20%, rgba(45, 212, 191, 0.05) 0%, rgba(255, 255, 255, 0) 40%),
                  radial-gradient(circle at 90% 80%, rgba(45, 212, 191, 0.05) 0%, rgba(255, 255, 255, 0) 40%);
      text-align: center; 
    }
    .hero-content { max-width: 800px; margin: 0 auto; }
    .gallery-hero h1 { font-size: 3.5rem; margin-bottom: 1.5rem; line-height: 1.1; }
    .gallery-hero p { font-size: 1.15rem; color: var(--text-secondary); margin-bottom: 3rem; line-height: 1.6; }
    
    .gallery-container { padding: 4rem; max-width: 1400px; margin: 0 auto; }
    
    .filter-bar {
      display: inline-flex; padding: 0.4rem; border-radius: 99px; gap: 0.4rem; background: #fff; border: 1px solid var(--border-color);
    }
    .filter-btn {
      padding: 0.6rem 1.8rem; border-radius: 99px; border: none; background: transparent;
      color: var(--text-secondary); font-weight: 700; font-size: 0.8rem; cursor: pointer; transition: all 0.3s ease;
      text-transform: uppercase; letter-spacing: 0.05em;
    }
    .filter-btn:hover { color: var(--text-primary); }
    .filter-btn.active { background: var(--primary-teal); color: #000; box-shadow: 0 4px 12px rgba(45, 212, 191, 0.3); }
    
    .template-grid {
      display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 3rem;
    }

    @media (max-width: 768px) {
      .nav-content { padding: 0 1.5rem; }
      .gallery-hero { padding: 4rem 1.5rem; }
      .gallery-hero h1 { font-size: 2.5rem; }
      .gallery-container { padding: 2rem 1.5rem; }
      .template-grid { grid-template-columns: 1fr; gap: 2rem; }
    }
  `]
})
export class TemplateGalleryComponent {
  private readonly templateService = inject(TemplateService);
  protected readonly router = inject(Router);
  protected readonly store = inject(ResumeStore);
  
  protected readonly categories = ['All', 'European', 'Professional'];
  protected readonly activeCategory = signal('All');
  
  protected get filteredTemplates(): ResumeTemplate[] {
    const templates = this.templateService.getTemplates()();
    if (this.activeCategory() === 'All') return templates;
    return templates.filter(t => t.category === this.activeCategory());
  }

  selectAndProceed(templateId: string) {
    this.store.setTemplate(templateId);
    this.router.navigate(['/builder']);
  }
}
