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
    <div class="gallery-container fade-in">
      <header class="gallery-header">
        <h1 class="font-display">Select a <span class="gradient-teal">Template</span></h1>
        <p>Choose the perfect design to showcase your professional story.</p>
        
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
      </header>
      
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
    .gallery-container { padding: 3rem; max-width: 1200px; margin: 0 auto; }
    .gallery-header { margin-bottom: 3rem; text-align: center; }
    .gallery-header h1 { font-size: 2.5rem; margin-bottom: 0.5rem; }
    .gallery-header p { color: var(--text-secondary); margin-bottom: 2rem; }
    
    .filter-bar {
      display: inline-flex;
      padding: 0.5rem;
      border-radius: 99px;
      gap: 0.5rem;
    }
    .filter-btn {
      padding: 0.5rem 1.5rem;
      border-radius: 99px;
      border: none;
      background: transparent;
      color: var(--text-secondary);
      font-weight: 600;
      font-size: 0.85rem;
      cursor: pointer;
      transition: var(--transition-fast);
    }
    .filter-btn:hover { color: var(--text-primary); }
    .filter-btn.active { background: var(--primary-teal); color: #000; }
    
    .template-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 2rem;
    }
  `]
})
export class TemplateGalleryComponent {
  private readonly templateService = inject(TemplateService);
  private readonly router = inject(Router);
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
