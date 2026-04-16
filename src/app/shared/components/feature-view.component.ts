import { Component, Input, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-feature-view',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="feature-container fade-in">
      <div class="feature-card">
        <div class="icon-orb">
          <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
        </div>
        <h1>{{ displayTitle }}</h1>
        <p>This module is currently being optimized for your professional profile.</p>
        <div class="status-badge">Optimization in Progress</div>
      </div>
    </div>
  `,
  styles: [`
    .feature-container {
      height: 100%;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 3rem;
      background: var(--bg-surface);
    }
    .feature-card {
      background: #FFFFFF;
      border: 1px solid var(--border-light);
      border-radius: var(--radius-lg);
      padding: 5rem 3rem;
      text-align: center;
      max-width: 500px;
      box-shadow: var(--shadow-premium);
    }
    .icon-orb {
      width: 100px; height: 100px;
      margin: 0 auto 2rem;
      background: var(--color-primary-soft);
      color: var(--color-primary);
      border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
    }
    h1 { font-size: 1.75rem; color: var(--text-heading); margin-bottom: 1rem; }
    p { color: var(--text-muted); font-size: 1rem; margin-bottom: 2rem; line-height: 1.6; }
    .status-badge {
      display: inline-block;
      padding: 6px 12px;
      background: var(--bg-surface);
      border: 1px solid var(--border-light);
      border-radius: 99px;
      font-size: 0.75rem;
      font-weight: 700;
      color: var(--text-muted);
      text-transform: uppercase;
      letter-spacing: 0.05em;
    }
    .fade-in { animation: fadeIn 0.5s ease-out forwards; }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
  `]
})
export class FeatureViewComponent implements OnInit {
  private readonly route = inject(ActivatedRoute);
  
  @Input() title: string = '';
  protected displayTitle: string = '';

  ngOnInit() {
    this.displayTitle = this.title || this.route.snapshot.data['title'] || 'New Module';
  }
}
