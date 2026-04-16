import { Injectable, signal } from '@angular/core';

export interface ResumeTemplate {
  id: string;
  name: string;
  category: 'Modern' | 'Professional' | 'Creative' | 'ATS-Friendly' | 'European';
  thumbnailUrl: string;
  description: string;
}

@Injectable({
  providedIn: 'root'
})
export class TemplateService {
  private readonly templates = signal<ResumeTemplate[]>([
    {
      id: 'euro-01',
      name: 'EuroCV',
      category: 'European',
      thumbnailUrl: 'assets/templates/europass.png',
      description: 'The official high-fidelity Europass format, optimized for applications across Europe.'
    },
    {
      id: 'exec-01',
      name: 'Executive Clean',
      category: 'Professional',
      thumbnailUrl: 'assets/templates/europass.png',
      description: 'A striking, minimalist, single-column design perfect for modern executive applications.'
    }
  ]);

  getTemplates() {
    return this.templates.asReadonly();
  }

  getTemplateById(id: string) {
    return this.templates().find(t => t.id === id);
  }
}
