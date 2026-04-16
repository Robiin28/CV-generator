import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ResumeTemplate } from '../../core/services/template.service';

@Component({
  selector: 'app-template-card',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="template-card" [class.active]="isSelected" (click)="select.emit()">
      <!-- Miniature CV Preview (Europass style) -->
      <div class="template-preview">
        <div class="mini-cv" [ngClass]="template.id === 'euro-01' ? 'euro' : 'exec'">
          @if (template.id === 'euro-01') {
            <div class="mini-header">
              <div class="mini-stars">★★★★★★</div>
              <span class="mini-wordmark">europass</span>
            </div>
            <div class="mini-body">
              <div class="mini-section euro-section">
                <div class="mini-label"></div>
                <div class="mini-content">
                  <div class="mini-name-bar"></div>
                  <div class="mini-line short"></div>
                </div>
              </div>
              <div class="mini-section euro-section">
                <div class="mini-label"></div>
                <div class="mini-content">
                  <div class="mini-line medium"></div>
                  <div class="mini-line long"></div>
                </div>
              </div>
            </div>
            <div class="mini-footer"></div>
          } @else {
            <div class="exec-mini-header">
              <div class="mini-name-bar exec-centered-name"></div>
              <div class="mini-line short exec-centered-title"></div>
              <div class="mini-line shortest exec-contact"></div>
            </div>
            <div class="exec-mini-divider"></div>
            <div class="exec-mini-body">
              <div class="mini-line medium"></div>
              <div class="mini-line long"></div>
              <div class="mini-line short"></div>
              
              <div class="exec-mini-divider"></div>
              <div class="mini-line shortest center"></div>
              <div class="mini-line medium margin-top"></div>
              <div class="mini-line long"></div>
            </div>
          }
        </div>

        <div class="overlay">
          <button class="select-btn">Select Template →</button>
        </div>

        @if (isSelected) {
          <div class="selected-badge">✓ Selected</div>
        }
      </div>

      <div class="template-info">
        <div class="info-header">
          <h3>{{ template.name }}</h3>
          <span class="eu-badge">🇪🇺 EU Standard</span>
        </div>
        <p>{{ template.description }}</p>
        <div class="template-tags">
          <span class="tag">Europass</span>
          <span class="tag">ATS-Safe</span>
          <span class="tag">2–3 Pages</span>
          <span class="tag">PDF Ready</span>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .template-card {
      cursor: pointer;
      border-radius: 16px;
      overflow: hidden;
      background: var(--bg-secondary);
      border: 2px solid var(--glass-border);
      transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .template-card:hover { transform: translateY(-5px); box-shadow: 0 20px 40px rgba(0,0,0,0.3); border-color: #0e4194; }
    .template-card.active { border-color: #0e4194; box-shadow: 0 0 0 3px rgba(14, 65, 148, 0.25); }

    /* Mini CV preview */
    .template-preview {
      height: 260px;
      position: relative;
      background: #d8dee4;
      display: flex;
      align-items: center;
      justify-content: center;
      overflow: hidden;
    }

    .mini-cv {
      width: 72%;
      background: #fff;
      box-shadow: 0 4px 20px rgba(0,0,0,0.25);
      border-radius: 2px;
      overflow: hidden;
      transform: scale(1);
      transition: transform 0.25s;
    }
    .template-card:hover .mini-cv { transform: scale(1.03); }

    .mini-header {
      background: #0e4194;
      padding: 5px 8px;
      display: flex;
      align-items: center;
      gap: 5px;
    }
    .mini-stars { color: #FFD700; font-size: 4px; letter-spacing: 1px; }
    .mini-wordmark { color: #fff; font-size: 7px; font-weight: 800; font-style: italic; }

    .mini-body { padding: 5px 6px; }
    .mini-section {
      display: grid;
      grid-template-columns: 22px 1fr;
      gap: 4px;
      margin-bottom: 5px;
      border-bottom: 0.5px solid #eee;
      padding-bottom: 4px;
    }
    .mini-section:last-child { border-bottom: none; }
    .mini-label {
      background: rgba(14, 65, 148, 0.12);
      border-radius: 1px;
      border-right: 1.5px solid #0e4194;
    }
    .mini-content { display: flex; flex-direction: column; gap: 2px; padding: 2px 0; }
    .mini-name-bar { height: 5px; background: #0e4194; border-radius: 1px; width: 70%; margin-bottom: 2px; }
    .mini-line { height: 2.5px; background: #d1d5db; border-radius: 1px; }
    .mini-line.long    { width: 90%; }
    .mini-line.medium  { width: 70%; }
    .mini-line.short   { width: 50%; }
    .mini-line.shortest{ width: 35%; }
    .mini-line.center  { margin: 0 auto; }
    .margin-top { margin-top: 2px; }

    .mini-footer { background: #f5f7fa; border-top: 1.5px solid #0e4194; height: 6px; }

    /* Executive Mini Styles */
    .exec-mini-header { display: flex; flex-direction: column; align-items: center; gap: 3px; padding: 6px; }
    .exec-centered-name { width: 60%; background: #000; height: 6px; margin: 0; }
    .exec-centered-title { width: 40%; background: #333; height: 4px; }
    .exec-contact { width: 50%; background: #666; height: 2px; }
    
    .exec-mini-divider { height: 1.5px; background: #000; width: 100%; margin: 2px 0; }
    
    .exec-mini-body { padding: 4px 8px; display: flex; flex-direction: column; gap: 3px; }

    .overlay {
      position: absolute;
      inset: 0;
      background: rgba(14, 65, 148, 0.82);
      display: flex;
      align-items: center;
      justify-content: center;
      opacity: 0;
      transition: opacity 0.2s;
      backdrop-filter: blur(2px);
    }
    .template-card:hover .overlay { opacity: 1; }
    .select-btn {
      background: #fff;
      color: #0e4194;
      border: none;
      padding: 0.6rem 1.4rem;
      border-radius: 8px;
      font-weight: 800;
      font-size: 0.875rem;
      cursor: pointer;
      letter-spacing: 0.01em;
    }

    .selected-badge {
      position: absolute;
      top: 12px;
      right: 12px;
      background: #0e4194;
      color: #fff;
      font-size: 0.72rem;
      font-weight: 700;
      padding: 0.3rem 0.75rem;
      border-radius: 99px;
    }

    /* Info section */
    .template-info { padding: 1.25rem 1.25rem 1rem; }
    .info-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem; }
    .info-header h3 { font-size: 1.05rem; font-weight: 700; margin: 0; }
    .eu-badge { font-size: 0.7rem; font-weight: 700; color: #0e4194; background: rgba(14,65,148,0.1); padding: 0.2rem 0.6rem; border-radius: 99px; }
    .template-info p { font-size: 0.82rem; color: var(--text-secondary); margin: 0 0 0.85rem; line-height: 1.5; }

    .template-tags { display: flex; flex-wrap: wrap; gap: 0.4rem; }
    .tag { font-size: 0.68rem; font-weight: 600; padding: 0.2rem 0.55rem; border-radius: 4px; background: var(--bg-tertiary); color: var(--text-muted); border: 1px solid var(--glass-border); }
  `]
})
export class TemplateCardComponent {
  @Input({ required: true }) template!: ResumeTemplate;
  @Input() isSelected = false;
  @Output() select = new EventEmitter<void>();
}
