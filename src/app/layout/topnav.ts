import { Component, inject } from '@angular/core';
import { RouterLink, Router } from '@angular/router';
import { AuthService } from '../core/services/auth.service';
import { ThemeService } from '../core/services/theme.service';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-topnav',
  standalone: true,
  template: `
    <header class="top-header">
      <div class="header-left">
        <div class="search-container">
          <span class="search-icon">
             <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
          </span>
          <input type="text" placeholder="Search templates, help, or files..." class="search-input">
        </div>
      </div>

      <div class="header-right">
        <button class="icon-btn" (click)="theme.toggleTheme()" [title]="theme.isDarkMode() ? 'Switch to Light' : 'Switch to Dark'">
          @if (theme.isDarkMode()) {
            <!-- Sun Icon -->
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line><line x1="1" y1="12" x2="3" y2="12"></line><line x1="21" y1="12" x2="23" y2="12"></line><line x1="4.22" y1="18.36" x2="5.64" y2="16.93"></line><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line></svg>
          } @else {
            <!-- Moon Icon -->
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg>
          }
        </button>

        <button class="icon-btn">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg>
        </button>
        
        <div class="user-profile" (click)="logout()">
          <span class="initials">{{ auth.currentUser()?.name?.charAt(0) || 'U' }}</span>
          <div class="profile-info">
            <span class="p-name">{{ auth.currentUser()?.name }}</span>
            <span class="p-role">Verified User</span>
          </div>
        </div>
      </div>
    </header>
  `,
  styles: [`
    .top-header {
      height: 64px;
      padding: 0 2rem;
      background: var(--bg-main);
      border-bottom: 1px solid var(--border-light);
      display: flex;
      align-items: center;
      justify-content: space-between;
      z-index: 50;
    }

    .header-left { flex: 1; max-width: 600px; }
    .search-container {
      position: relative;
      width: 100%;
      max-width: 400px;
    }
    .search-icon {
      position: absolute;
      left: 12px;
      top: 50%;
      transform: translateY(-50%);
      color: var(--text-muted);
    }
    .search-input {
      width: 100%;
      padding: 0.5rem 1rem 0.5rem 2.5rem;
      background: var(--bg-surface);
      border: 1px solid transparent;
      border-radius: var(--radius-md);
      font-size: 0.85rem;
      color: var(--text-heading);
      transition: var(--transition-base);
    }
    .search-input:focus {
      background: #ffffff;
      border-color: var(--border-active);
      box-shadow: var(--shadow-sm);
      outline: none;
    }

    .header-right {
      display: flex;
      align-items: center;
      gap: 1.5rem;
    }

    .icon-btn {
      background: none;
      border: none;
      color: var(--text-body);
      cursor: pointer;
      display: flex; align-items: center; justify-content: center;
      padding: 0.5rem;
      border-radius: 50%;
      transition: var(--transition-base);
    }
    .icon-btn:hover { background: var(--bg-surface); }

    .user-profile {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      cursor: pointer;
      padding: 0.25rem 0.5rem;
      border-radius: var(--radius-md);
      transition: var(--transition-base);
    }
    .user-profile:hover { background: var(--bg-surface); }

    .initials {
      width: 32px; height: 32px;
      background: var(--color-primary);
      color: #fff;
      border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      font-weight: 700; font-size: 0.8rem;
    }
    .profile-info { display: flex; flex-direction: column; }
    .p-name { font-size: 0.85rem; font-weight: 600; color: var(--text-heading); line-height: 1.2; }
    .p-role { font-size: 0.7rem; color: var(--text-muted); }
  `]
})
export class TopNavComponent {
  protected readonly auth = inject(AuthService);
  protected readonly theme = inject(ThemeService);
  private readonly router = inject(Router);

  logout() {
    this.auth.logout();
    this.router.navigate(['/']);
  }
}
