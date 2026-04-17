import { Component, inject, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { StorageService } from '../../core/services/storage.service';
import { Resume } from '../../core/models/resume.model';
import { ResumeStore } from '../builder/store/resume.store';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="dashboard-shell fade-in">
      <header class="dash-header">
        <div class="header-text">
          <h1>Resume Dashboard</h1>
          <p>Welcome back. You have {{ resumes().length }} active resumes in your workspace.</p>
        </div>
        <button class="btn-saas btn-saas-primary" (click)="createNew()">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
          Create New Resume
        </button>
      </header>

      <section class="resume-section">
        <div class="section-label">Recently Modified</div>
        <div class="resume-grid">
          @for (resume of resumes(); track resume.id) {
            <div class="resume-item-card">
              <div class="card-preview">
                <div class="skeleton-doc">
                   <div class="skel-row full"></div>
                   <div class="skel-row mid"></div>
                   <div class="skel-row short"></div>
                </div>
              </div>
              <div class="card-meta">
                 <div class="meta-content">
                   <h3>{{ resume.title || 'Untitled Resume' }}</h3>
                   <span>Last updated {{ resume.lastUpdated | date:'mediumDate' }}</span>
                 </div>
                 <div class="meta-actions">
                   <button class="action-btn" (click)="editResume(resume)" title="Edit Resume">
                     <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                   </button>
                   <button class="action-btn delete" (click)="deleteResume(resume.id)" title="Delete">
                     <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                   </button>
                 </div>
              </div>
            </div>
          } @empty {
            <div class="empty-workspace">
              <div class="empty-icon-box">📂</div>
              <h3>Your workspace is empty</h3>
              <p>Get started by creating your first high-impact professional resume.</p>
              <button class="btn-saas btn-saas-primary" (click)="createNew()">Create Resume</button>
            </div>
          }
        </div>
      </section>
    </div>
  `,
  styles: [`
    .dashboard-shell { padding: 3rem; max-width: 1200px; margin: 0 auto; }
    
    .dash-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 3rem; }
    .header-text h1 { font-size: 2rem; margin-bottom: 0.5rem; color: var(--text-heading); }
    .header-text p { color: var(--text-muted); font-size: 0.95rem; }

    .btn-saas { display: flex; align-items: center; gap: 8px; }

    .resume-section { margin-top: 2rem; }
    .section-label { font-size: 0.75rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 1.5rem; }

    .resume-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 2rem; }
    
    .resume-item-card {
      background: var(--bg-card);
      border: 1px solid var(--border-light);
      border-radius: var(--radius-lg);
      overflow: hidden;
      transition: var(--transition-base);
      display: flex;
      flex-direction: column;
      box-shadow: var(--shadow-sm);
    }
    .resume-item-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-premium); border-color: var(--color-primary); }

    .card-preview {
      height: 180px;
      background: var(--bg-surface);
      border-bottom: 1px solid var(--border-light);
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 2rem;
    }
    .skeleton-doc { width: 100%; height: 100%; display: flex; flex-direction: column; gap: 12px; }
    .skel-row { background: var(--border-light); height: 8px; border-radius: 4px; opacity: 0.5; }
    .skel-row.full { width: 90%; }
    .skel-row.mid { width: 60%; }
    .skel-row.short { width: 40%; }

    .card-meta { padding: 1.25rem; display: flex; justify-content: space-between; align-items: center; }
    .meta-content h3 { font-size: 1rem; font-weight: 700; color: var(--text-heading); margin-bottom: 0.25rem; }
    .meta-content span { font-size: 0.75rem; color: var(--text-muted); }

    .meta-actions { display: flex; gap: 0.5rem; }
    .action-btn {
      width: 36px; height: 36px;
      border-radius: var(--radius-md);
      border: 1px solid var(--border-light);
      background: var(--bg-card);
      color: var(--text-body);
      display: flex; align-items: center; justify-content: center;
      cursor: pointer;
      transition: var(--transition-base);
    }
    .action-btn:hover { border-color: var(--color-primary); color: var(--color-primary); background: var(--color-primary-soft); }
    .action-btn.delete:hover { border-color: #EF4444; color: #EF4444; background: rgba(239, 68, 68, 0.1); }

    .empty-workspace { grid-column: 1 / -1; text-align: center; padding: 6rem 2rem; background: var(--bg-card); border: 1px dashed var(--border-light); border-radius: var(--radius-lg); }
    .empty-icon-box { font-size: 3rem; margin-bottom: 1.5rem; opacity: 0.4; }
    .empty-workspace h3 { font-size: 1.5rem; color: var(--text-heading); margin-bottom: 0.75rem; }
    .empty-workspace p { color: var(--text-muted); margin-bottom: 2rem; max-width: 400px; margin-left: auto; margin-right: auto; }

    .fade-in { animation: fadeIn 0.5s ease-out forwards; }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

    @media (max-width: 768px) {
      .dashboard-shell { padding: 1.5rem; }
      .dash-header { flex-direction: column; align-items: flex-start; gap: 1.5rem; margin-bottom: 2rem; }
      .dash-header button { width: 100%; justify-content: center; }
      .resume-grid { grid-template-columns: 1fr; }
    }
  `]
})
export class DashboardComponent implements OnInit {
  private readonly storageService = inject(StorageService);
  private readonly store = inject(ResumeStore);
  private readonly router = inject(Router);
  
  protected readonly resumes = signal<Resume[]>([]);

  ngOnInit() {
    this.loadResumes();
  }

  loadResumes() {
    this.resumes.set(this.storageService.getResumes());
  }

  editResume(resume: Resume) {
    this.store.loadResume(resume);
    this.router.navigate(['/builder']);
  }

  deleteResume(id: string) {
    if (confirm('Are you sure you want to delete this resume?')) {
      this.storageService.deleteResume(id);
      this.loadResumes();
    }
  }

  createNew() {
    const id = Math.random().toString(36).substring(7);
    const newResume: Resume = {
      id,
      title: 'New Resume',
      personalInfo: { fullName: '', email: '', phone: '', location: '' },
      summary: '',
      experience: [],
      education: [],
      skills: [],
      lastUpdated: new Date()
    };
    this.storageService.saveCurrentResume(newResume);
    this.store.loadResume(newResume);
    this.router.navigate(['/builder']);
  }
}
