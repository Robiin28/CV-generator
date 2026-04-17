import { Component, inject, signal } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../core/services/auth.service';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="auth-container fade-in">
      <div class="bg-glow teal"></div>
      
      <div class="auth-card glass">
        <header class="auth-header">
          <h1 class="font-display">Create Account</h1>
          <p>Start your journey with ResumeForge AI today</p>
        </header>

        <form (submit)="onSubmit($event)" class="auth-form">
          <div class="input-group">
            <label>Full Name</label>
            <input type="text" placeholder="John Doe" #name required>
          </div>

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

          <button type="submit" class="btn-primary w-full">Get Started</button>
        </form>

        <footer class="auth-footer">
          <p>Already have an account? <a routerLink="/login">Sign in</a></p>
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
    .bg-glow { position: absolute; width: 600px; height: 600px; background: #00f5d4; border-radius: 50%; filter: blur(120px); opacity: 0.1; z-index: 0; }
    
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
    @media (max-width: 480px) {
      .auth-container { padding: 1rem; }
      .auth-card { padding: 2rem 1.5rem; border-radius: 16px; }
      .auth-header h1 { font-size: 1.75rem; }
    }
  `]
})
export class RegisterComponent {
  private readonly authService = inject(AuthService);
  private readonly router = inject(Router);
  
  protected readonly error = signal<string | null>(null);

  onSubmit(event: Event) {
    event.preventDefault();
    const name = (event.target as any).querySelector('input[type="text"]').value;
    const email = (event.target as any).querySelector('input[type="email"]').value;
    const password = (event.target as any).querySelector('input[type="password"]').value;
    
    if (this.authService.register(email, name)) {
      this.router.navigate(['/dashboard']);
    } else {
      this.error.set('Registration failed. Please try again.');
    }
  }
}
