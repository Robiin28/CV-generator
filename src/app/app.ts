import { Component, inject, computed } from '@angular/core';
import { RouterOutlet, Router } from '@angular/router';
import { TopNavComponent } from './layout/topnav';
import { SidebarComponent } from './layout/sidebar';
import { AiChatComponent } from './features/ai-chat/ai-chat.component';
import { ThemeService } from './core/services/theme.service';
import { toSignal } from '@angular/core/rxjs-interop';
import { map } from 'rxjs';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, TopNavComponent, SidebarComponent, AiChatComponent],
  template: `
    <div class="app-shell" [class.dark]="theme.isDarkMode()">
      <!-- FIXED LEFT SIDEBAR (Conditional) -->
      @if (!isPublicPage()) {
        <app-sidebar></app-sidebar>
      }
      
      <div class="main-viewport">
        <!-- TOP NAVIGATION (Conditional) -->
        @if (!isPublicPage()) {
          <app-topnav></app-topnav>
        }
        
        <div class="content-container">
          <router-outlet></router-outlet>
        </div>
      </div>

      <!-- AI ASSISTANT (FLOATING OR INTEGRATED) -->
      @if (isBuilderView()) {
        <app-ai-chat></app-ai-chat>
      }
    </div>
  `,
  styles: [`
    .app-shell {
      display: flex;
      height: 100vh;
      width: 100vw;
      overflow: hidden;
      background-color: var(--bg-main);
    }
    
    .main-viewport {
      flex: 1;
      display: flex;
      flex-direction: column;
      height: 100%;
      overflow: hidden;
    }
    
    .content-container {
      flex: 1;
      overflow-y: auto; /* Changed from hidden — allows landing page to scroll */
      background-color: var(--bg-surface);
    }
  `]
})
export class App {
  protected readonly theme = inject(ThemeService);
  private readonly router = inject(Router);
  private readonly url = toSignal(this.router.events.pipe(map(() => this.router.url)));
  
  protected readonly isBuilderView = computed(() => this.url()?.startsWith('/builder'));
  
  protected readonly isPublicPage = computed(() => {
    const currentUrl = this.url();
    if (!currentUrl) return true;
    // All public-facing routes — no dashboard sidebar/topnav
    const publicPaths = ['/', '/login', '/register', '/templates'];
    return (
      publicPaths.some(path => currentUrl === path || currentUrl.startsWith(path + '?')) ||
      currentUrl.startsWith('/#') // anchor links on the landing page (e.g. /#pricing, /#features)
    );
  });
}
