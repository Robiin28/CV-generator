import { Component, inject, signal } from '@angular/core';
import { RouterLink, Router } from '@angular/router';
import { AuthService } from '../core/services/auth.service';
import { ThemeService } from '../core/services/theme.service';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-topnav',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <header class="top-header">
      <div class="header-inner">
        <div class="header-left">
          <div class="brand" routerLink="/">
            <div class="logo-box">RF</div>
            <span class="logo-text">ResumeForge</span>
          </div>
          
          @if (!auth.isAuthenticated()) {
            <div class="nav-links desktop-only">
              <a href="#features">Features</a>
              <a routerLink="/templates">Templates</a>
              <a href="#pricing">Pricing</a>
              <a href="#faq">FAQ</a>
            </div>
          } @else {
            <div class="search-container desktop-only">
              <span class="search-icon">
                 <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
              </span>
              <input type="text" placeholder="Search..." class="search-input">
            </div>
          }
        </div>

        <div class="header-right">
          @if (auth.isAuthenticated()) {
            <button class="icon-btn" (click)="theme.toggleTheme()">
              @if (theme.isDarkMode()) {
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line><line x1="1" y1="12" x2="3" y2="12"></line><line x1="21" y1="12" x2="23" y2="12"></line><line x1="4.22" y1="18.36" x2="5.64" y2="16.93"></line><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line></svg>
              } @else {
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg>
              }
            </button>

            <div class="user-profile">
              <span class="initials">{{ auth.currentUser()?.name?.charAt(0) || 'U' }}</span>
              <div class="profile-info">
                <span class="p-name">{{ auth.currentUser()?.name }}</span>
                <span class="p-role">Verified User</span>
              </div>
            </div>

            <button class="logout-btn" (click)="logout()" title="Logout">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                <polyline points="16 17 21 12 16 7"></polyline>
                <line x1="21" y1="12" x2="9" y2="12"></line>
              </svg>
              <span>Log Out</span>
            </button>
          } @else {
            <div class="auth-links">
              <button class="icon-btn guest-theme" (click)="theme.toggleTheme()">
                @if (theme.isDarkMode()) {
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="5"></circle></svg>
                } @else {
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg>
                }
              </button>
              <button class="btn-login desktop-only" routerLink="/login">Log In</button>
              <button class="btn-join" routerLink="/register">Get Started</button>
              
              <button class="menu-toggle mobile-only" (click)="isMenuOpen.set(!isMenuOpen())">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>
              </button>
            </div>
          }
        </div>
      </div>

      @if (!auth.isAuthenticated() && isMenuOpen()) {
        <div class="mobile-menu" (click)="isMenuOpen.set(false)">
          <a href="#features">Features</a>
          <a routerLink="/templates">Templates</a>
          <a href="#pricing">Pricing</a>
          <a href="#faq">FAQ</a>
          <div class="divider"></div>
          <a routerLink="/login">Log In</a>
        </div>
      }
    </header>
  `,
  styles: [`
    .top-header {
      height: 72px;
      width: 100%;
      background-color: var(--bg-main);
      backdrop-filter: blur(12px);
      -webkit-backdrop-filter: blur(12px);
      border-bottom: 1px solid var(--border-light);
      position: sticky;
      top: 0;
      z-index: 1000;
      display: flex;
      justify-content: center;
      transition: all 0.2s ease;
    }

    /* Subtle transparency when theme is supported */
    .top-header {
      background-color: color-mix(in srgb, var(--bg-main), transparent 5%);
    }

    .header-inner {
      width: 100%;
      max-width: 1280px;
      padding: 0 2rem;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .header-left { display: flex; align-items: center; gap: 3rem; }
    
    .brand { display: flex; align-items: center; gap: 10px; cursor: pointer; }
    .logo-box { 
      background: var(--text-heading); color: var(--bg-main); width: 32px; height: 32px; 
      border-radius: 6px; display: flex; align-items: center; justify-content: center; 
      font-weight: 800; font-size: 0.75rem;
    }
    .logo-text { font-size: 1.1rem; font-weight: 700; color: var(--text-heading); letter-spacing: -0.02em; }

    .nav-links { display: flex; gap: 1.5rem; align-items: center; }
    .nav-links a { 
      text-decoration: none; color: var(--text-muted); font-weight: 600; font-size: 0.85rem; 
      transition: color 0.2s;
    }
    .nav-links a:hover { color: var(--color-primary); }

    .search-container {
      position: relative;
      width: 250px;
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
      border: 1px solid var(--border-light);
      border-radius: 99px;
      font-size: 0.8rem;
      color: var(--text-heading);
      transition: all 0.2s;
    }
    .search-input:focus { background: var(--bg-main); border-color: var(--color-primary); outline: none; box-shadow: 0 0 0 3px var(--color-primary-soft); }

    .header-right {
      display: flex;
      align-items: center;
      gap: 1.5rem;
    }

    .auth-links { display: flex; align-items: center; gap: 1rem; }
    .btn-login { background: none; border: none; font-weight: 600; font-size: 0.85rem; color: var(--text-body); cursor: pointer; padding: 0.5rem 1rem; }
    .btn-join { background: var(--text-heading); color: var(--bg-main); border: none; padding: 0.6rem 1.5rem; border-radius: 99px; font-weight: 700; font-size: 0.85rem; cursor: pointer; transition: all 0.2s; }
    .btn-join:hover { filter: brightness(0.9); transform: translateY(-1px); }

    .icon-btn {
      background: none;
      border: none;
      color: var(--text-body);
      cursor: pointer;
      display: flex; align-items: center; justify-content: center;
      padding: 0.5rem;
      border-radius: 50%;
      transition: all 0.2s;
    }
    .icon-btn:hover { background: var(--bg-surface); }

    .user-profile {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      padding: 0 0.5rem;
      border-right: 1px solid var(--border-light);
    }
    
    .logout-btn {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      background: rgba(220, 38, 38, 0.08);
      color: #ef4444;
      border: 1px solid rgba(220, 38, 38, 0.15);
      padding: 0.5rem 1rem;
      border-radius: 99px;
      font-weight: 700;
      font-size: 0.75rem;
      cursor: pointer;
      transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .logout-btn:hover { background: #ef4444; color: #fff; transform: translateY(-1px); box-shadow: 0 4px 12px rgba(239, 68, 68, 0.2); }

    :host-context(.dark) .logout-btn {
      background: #ffffff;
      color: #ef4444;
      border-color: #ffffff;
    }
    :host-context(.dark) .logout-btn:hover {
      background: #ef4444;
      color: #ffffff;
      border-color: #ef4444;
    }

    .initials {
      width: 32px; height: 32px;
      background: #000000;
      color: #ffffff;
      border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      font-weight: 800; font-size: 0.85rem;
      border: 2px solid var(--bg-main);
      box-shadow: var(--shadow-sm);
      transition: all 0.2s ease;
    }

    :host-context(.dark) .initials {
      background: #ffffff;
      color: #000000;
    }
    .profile-info { display: flex; flex-direction: column; }
    .p-name { font-size: 0.85rem; font-weight: 600; color: var(--text-heading); line-height: 1.2; }
    .p-role { font-size: 0.65rem; color: var(--text-muted); }

    .menu-toggle { background: none; border: none; color: var(--text-heading); cursor: pointer; }

    .mobile-menu {
      position: absolute; top: 72px; left: 0; width: 100%; 
      background: var(--bg-main);
      border-bottom: 1px solid var(--border-light); padding: 1.5rem;
      display: flex; flex-direction: column; gap: 1rem;
      box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
    }
    .mobile-menu a { text-decoration: none; color: var(--text-heading); font-weight: 600; padding: 0.75rem 0; border-bottom: 1px solid var(--border-light); }
    .mobile-menu .divider { height: 1px; background: var(--border-light); margin: 0.5rem 0; }

    .desktop-only { display: flex; }
    .mobile-only { display: none; }

    @media (max-width: 1024px) {
      .header-left { gap: 1rem; }
      .desktop-only { display: none; }
      .mobile-only { display: block; }
      .header-right { gap: 0.5rem; }
      .profile-info { display: none; }
      .logout-btn span { display: none; }
      .logout-btn { padding: 0.5rem; }
    }
  `]
})
export class TopNavComponent {
  protected readonly auth = inject(AuthService);
  protected readonly theme = inject(ThemeService);
  private readonly router = inject(Router);
  protected readonly isMenuOpen = signal(false);

  logout() {
    this.auth.logout();
    this.router.navigate(['/']);
  }
}
