import { Component, inject, signal } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../core/services/auth.service';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="auth-container fade-in">
      <div class="bg-glow blue"></div>
      
      <div class="auth-card glass">
        <header class="auth-header">
          <h1 class="font-display">Welcome Back</h1>
          <p>Login to your ResumeForge AI account</p>
        </header>

        <form (submit)="onSubmit($event)" class="auth-form">
          <div class="input-group">
            <label>Email Address</label>
            <input type="email" placeholder="name@company.com" #email required>
          </div>
          
          <div class="input-group">
            <label>Password</label>
            <input type="password" placeholder="••••••••" #password required>
          </div>

          @if (error()) {
            <p class="error-msg">{{ error() }}</p>
          }

          <button type="submit" class="btn-primary w-full">Sign In</button>
        </form>

        <footer class="auth-footer">
          <p>Don't have an account? <a routerLink="/register">Sign up</a></p>
        </footer>
      </div>
    </div>
  `,
  styles: [`
    .auth-container {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background: #050811;
      position: relative;
      overflow: hidden;
      padding: 2rem;
    }
    .bg-glow { position: absolute; width: 600px; height: 600px; background: #1e3a8a; border-radius: 50%; filter: blur(120px); opacity: 0.1; z-index: 0; }
    
    .auth-card {
      width: 100%;
      max-width: 420px;
      padding: 3rem;
      border-radius: 24px;
      z-index: 1;
    }
    
    .auth-header { text-align: center; margin-bottom: 2.5rem; }
    .auth-header h1 { font-size: 2rem; margin-bottom: 0.5rem; }
    .auth-header p { color: var(--text-secondary); font-size: 0.9rem; }
    
    .auth-form { display: flex; flex-direction: column; gap: 1.5rem; }
    .input-group { display: flex; flex-direction: column; gap: 0.5rem; }
    .input-group label { font-size: 0.8rem; font-weight: 600; color: var(--text-secondary); }
    .input-group input { width: 100%; background: var(--bg-primary); border: 1px solid var(--border-color); border-radius: 8px; padding: 0.75rem 1rem; color: var(--text-primary); }
    .input-group input:focus { border-color: var(--primary-teal); outline: none; }
    
    .error-msg { color: #ff6b6b; font-size: 0.85rem; text-align: center; margin: 0; }
    .w-full { width: 100%; }
    
    .auth-footer { margin-top: 2rem; text-align: center; font-size: 0.9rem; color: var(--text-secondary); }
    .auth-footer a { color: var(--primary-teal); font-weight: 600; text-decoration: none; }
  `]
})
export class LoginComponent {
  private readonly authService = inject(AuthService);
  private readonly router = inject(Router);
  
  protected readonly error = signal<string | null>(null);

  onSubmit(event: Event) {
    event.preventDefault();
    const email = (event.target as any).querySelector('input[type="email"]').value;
    const password = (event.target as any).querySelector('input[type="password"]').value;
    
    if (this.authService.login(email, password)) {
      this.router.navigate(['/dashboard']);
    } else {
      this.error.set('Invalid credentials. Please try again.');
    }
  }
}
