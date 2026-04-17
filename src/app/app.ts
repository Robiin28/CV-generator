import { Component, inject, computed } from '@angular/core';
import { RouterOutlet, Router } from '@angular/router';
import { TopNavComponent } from './layout/topnav';
import { SidebarComponent } from './layout/sidebar';
import { ThemeService } from './core/services/theme.service';
import { AuthService } from './core/services/auth.service';
import { toSignal } from '@angular/core/rxjs-interop';
import { map } from 'rxjs';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, TopNavComponent, SidebarComponent],
  template: `
    <div class="app-shell" [class.dark]="theme.isDarkMode()">
      <!-- FIXED LEFT SIDEBAR (Conditional) -->
      @if (!shouldHideSidebar()) {
        <app-sidebar></app-sidebar>
      }
      
      <div class="main-viewport">
        <!-- TOP NAVIGATION (Conditional) -->
        @if (!hideTopnav()) {
          <app-topnav></app-topnav>
        }
        
        <div class="content-container">
          <router-outlet></router-outlet>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .app-shell {
      display: flex;
      height: 100dvh;
      width: 100%;
      overflow: hidden;
      background-color: var(--bg-main);
    }
    
    .main-viewport {
      flex: 1;
      display: flex;
      flex-direction: column;
      height: 100%;
      min-width: 0; /* Prevents flex items from overflowing */
      overflow: hidden;
    }
    
    .content-container {
      flex: 1;
      overflow-y: auto;
      background-color: var(--bg-surface);
      position: relative;
    }

    @media (max-width: 1024px) {
      .app-shell { flex-direction: column; }
    }
  `]
})
export class App {
  protected readonly theme = inject(ThemeService);
  protected readonly auth = inject(AuthService);
  private readonly router = inject(Router);
  private readonly url = toSignal(this.router.events.pipe(map(() => this.router.url)));
  
  protected readonly shouldHideSidebar = computed(() => {
    const currentUrl = this.url();
    if (!currentUrl) return true;

    // 1. Landing and Auth pages NEVER show the global sidebar
    const alwaysHiddenPaths = ['/', '/login', '/register'];
    if (alwaysHiddenPaths.some(path => currentUrl === path || currentUrl.startsWith(path + '?')) || currentUrl.startsWith('/#')) {
      return true;
    }

    // 2. Templates and Builder only show sidebar IF logged in
    const focusPaths = ['/templates', '/builder'];
    if (focusPaths.some(path => currentUrl.startsWith(path))) {
      return !this.auth.isAuthenticated();
    }

    // 3. Dashboard and all other internal routes always show sidebar
    return false;
  });

  protected readonly hideTopnav = computed(() => {
    const currentUrl = this.url();
    if (!currentUrl) return true;
    // Topnav is ONLY hidden on auth pages; kept on landing, templates, builder, and dashboard
    const topnavHiddenPaths = ['/login', '/register'];
    return topnavHiddenPaths.some(path => currentUrl === path || currentUrl.startsWith(path + '?'));
  });
}
