import { Component, inject } from '@angular/core';
import { ResumeStore } from '../features/builder/store/resume.store';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `
    <aside class="sidebar">
      <div class="sidebar-top">
        <div class="brand">
          <div class="brand-square">F</div>
          <span class="brand-name">ResumeForge</span>
        </div>

        <nav class="nav-links">
          @for (item of menuItems; track item.label) {
            <a 
              class="nav-item" 
              [routerLink]="item.route" 
              routerLinkActive="active"
              [routerLinkActiveOptions]="{exact: item.exact}"
            >
              <span class="nav-icon" [innerHTML]="item.icon"></span>
              <span class="nav-label">{{ item.label }}</span>
            </a>
          }
        </nav>
      </div>

    </aside>
  `,
  styles: [`
    :host { display: block; height: 100%; }
    .sidebar {
      width: 250px;
      height: 100%;
      background-color: var(--bg-sidebar);
      color: var(--text-on-navy);
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      padding: 2rem 1rem;
    }

    .brand {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      padding: 0 0.5rem 2.5rem;
    }
    .brand-square {
      width: 32px; height: 32px;
      background: #000000;
      color: #FFFFFF;
      border-radius: 6px;
      display: flex; align-items: center; justify-content: center;
      font-weight: 800; font-size: 0.9rem;
    }
    .brand-name {
      font-size: 1.1rem;
      font-weight: 700;
      letter-spacing: -0.02em;
    }

    .nav-links { display: flex; flex-direction: column; gap: 0.25rem; }
    .nav-item {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      padding: 0.75rem 1rem;
      border-radius: var(--radius-md);
      color: rgba(255, 255, 255, 0.7);
      cursor: pointer;
      text-decoration: none;
      transition: var(--transition-base);
    }
    .nav-item:hover { background: rgba(255, 255, 255, 0.05); color: #fff; }
    .nav-item.active { background: rgba(255, 255, 255, 0.1); color: #fff; }
    
    .nav-icon { 
      display: flex; align-items: center; justify-content: center;
      width: 20px; height: 20px; opacity: 0.8;
    }
    .nav-label { font-size: 0.875rem; font-weight: 500; }

    .sidebar-bottom { padding: 0 0.5rem; }
    .pro-badge {
      background: rgba(255, 255, 255, 0.05);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: var(--radius-lg);
      padding: 1rem;
      display: flex;
      align-items: flex-start;
      gap: 0.75rem;
      cursor: pointer;
    }
    .pro-icon { color: #FCD34D; font-size: 1.2rem; }
    .pro-text strong { display: block; font-size: 0.8rem; margin-bottom: 2px; }
    .pro-text p { font-size: 0.65rem; opacity: 0.6; margin: 0; }
    @media (max-width: 1024px) {
      :host { display: none; }
      .sidebar { display: none; }
    }
  `]
})
export class SidebarComponent {
  protected readonly store = inject(ResumeStore);
  
  protected readonly menuItems = [
    { label: 'Dashboard', route: '/dashboard', exact: true, icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>' },
    { label: 'AI Builder', route: '/builder', exact: false, icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83"></path></svg>' },
    { label: 'Templates', route: '/templates', exact: false, icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9h18v10a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V9Z"></path><path d="M3 9V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v4"></path></svg>' },
    { label: 'My CVs', route: '/my-cvs', exact: false, icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>' },
    { label: 'Analytics', route: '/analytics', exact: false, icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg>' },
    { label: 'Settings', route: '/settings', exact: false, icon: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg>' }
  ];
}
