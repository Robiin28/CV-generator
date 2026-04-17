import { Component, inject, signal, Output, EventEmitter, Input } from '@angular/core';
import { AiService } from '../../core/services/ai.service';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-ai-chat',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="ai-chat-panel fade-in" [class.is-minimized]="minimized">
      @if (minimized) {
        <button class="ai-trigger-btn" (click)="toggle.emit()" title="Ask AI Assistant">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <path d="M15 14c.2-1 .7-1.7 1.5-2.5 1-.9 1.5-2.2 1.5-3.5A6 6 0 0 0 6 8c0 1 .2 2.2 1.5 3.5.7.7 1.3 1.5 1.5 2.5"></path>
            <path d="M9 18h6"></path>
            <path d="M10 22h4"></path>
          </svg>
        </button>
      } @else {
        <div class="chat-header">
          <div class="h-left">
            <span class="sparkle-icon">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m12 3-1.912 5.813a2 2 0 0 1-1.275 1.275L3 12l5.813 1.912a2 2 0 0 1 1.275 1.275L12 21l1.912-5.813a2 2 0 0 1 1.275-1.275L21 12l-5.813-1.912a2 2 0 0 1-1.275-1.275L12 3Z"></path></svg>
            </span>
            <span>AI Assistant</span>
          </div>
          <button class="close-btn" (click)="toggle.emit()" title="Minimize">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
          </button>
        </div>
        
        <div class="chat-message">
          <p>{{ message() }}</p>
        </div>
        
        <div class="chat-input-container">
          <input type="text" placeholder="How can I help you today?" (keyup.enter)="onAsk($any($event.target).value); $any($event.target).value = ''">
        </div>
      }
    </div>
  `,
  styles: [`
    .ai-chat-panel {
      position: fixed;
      bottom: 2rem;
      left: 270px;
      width: 350px;
      background: var(--bg-card);
      border: 1px solid var(--border-light);
      border-radius: 20px;
      display: flex;
      flex-direction: column;
      box-shadow: var(--shadow-premium);
      z-index: 1100;
      transition: all 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
      overflow: hidden;
      backdrop-filter: blur(12px);
    }

    .is-minimized {
      width: 48px;
      height: 48px;
      padding: 0;
      border-radius: 50%;
      left: 270px;
      bottom: 2rem;
      border: 2px solid var(--color-primary);
      box-shadow: 0 10px 20px rgba(59, 130, 246, 0.4);
    }

    .ai-trigger-btn {
      width: 100%;
      height: 100%;
      background: var(--color-primary);
      color: #fff;
      border: none;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      transition: all 0.2s;
    }
    .ai-trigger-btn:hover { transform: scale(1.1) rotate(5deg); background: #2563eb; }

    .chat-header { 
      padding: 1rem 1.25rem; 
      border-bottom: 1px solid var(--border-light); 
      display: flex; 
      align-items: center; 
      justify-content: space-between;
      gap: 0.75rem; 
      font-weight: 700; 
      background: var(--bg-hover);
      color: var(--text-heading);
    }
    .h-left { display: flex; align-items: center; gap: 0.75rem; }
    .sparkle-icon { color: var(--color-primary); }
    
    .close-btn { 
      background: none; border: none; padding: 4px; 
      color: var(--text-muted); cursor: pointer; border-radius: 6px;
      display: flex; align-items: center; justify-content: center;
      transition: all 0.2s;
    }
    .close-btn:hover { background: rgba(0,0,0,0.05); color: #ef4444; }
    
    .chat-message { padding: 1.5rem; font-size: 0.9rem; max-height: 250px; overflow-y: auto; color: var(--text-body); }
    .chat-message p { line-height: 1.6; }
    
    .chat-input-container { padding: 1rem; padding-top: 0.5rem; }
    .chat-input-container input { 
      width: 100%; 
      background: var(--input-bg); 
      border: 1px solid var(--border-light); 
      border-radius: 12px; 
      padding: 0.8rem 1rem; 
      color: var(--text-heading); 
      font-size: 0.85rem; 
      transition: all 0.2s;
    }
    .chat-input-container input:focus { outline: none; border-color: var(--color-primary); box-shadow: 0 0 0 3px var(--color-primary-soft); }

    @media (max-width: 1024px) {
      .ai-chat-panel {
        left: unset;
        right: 1.25rem;
        width: 320px;
        bottom: 1.25rem;
      }
      .is-minimized {
        left: unset;
        right: 1.25rem;
        bottom: 1.25rem;
        width: 44px;
        height: 44px;
      }
    }
  `]
})
export class AiChatComponent {
  private readonly aiService = inject(AiService);
  protected readonly message = signal('I rewrote your bullets and added keywords for the **Software Engineer** role at Google.');
  
  @Input() minimized = false;
  @Output() toggle = new EventEmitter<void>();

  onAsk(query: string) {
    this.message.set('Thinking...');
    this.aiService.getSuggestions(query).subscribe(suggestions => {
      this.message.set(suggestions[0]);
    });
  }
}
