import { Component, inject, signal } from '@angular/core';
import { AiService } from '../../core/services/ai.service';

@Component({
  selector: 'app-ai-chat',
  standalone: true,
  template: `
    <div class="ai-chat-panel glass fade-in">
      <div class="chat-header">
        <span class="sparkle-icon">✨</span>
        <span>AI Assistant</span>
      </div>
      <div class="chat-message">
        <p>{{ message() }}</p>
      </div>
      <div class="chat-input-container">
        <input type="text" placeholder="Ask AI to help..." (keyup.enter)="onAsk($any($event.target).value); $any($event.target).value = ''">
      </div>
    </div>
  `,
  styles: [`
    .ai-chat-panel {
      position: fixed;
      bottom: 2rem;
      left: 220px;
      width: 320px;
      border-radius: 16px;
      display: flex;
      flex-direction: column;
      box-shadow: var(--shadow-lg);
      z-index: 1000;
    }
    .chat-header { padding: 1rem; border-bottom: 1px solid var(--border-color); display: flex; align-items: center; gap: 0.75rem; font-weight: 600; }
    .chat-message { padding: 1.5rem; font-size: 0.9rem; max-height: 200px; overflow-y: auto; }
    .chat-message p { line-height: 1.6; }
    .chat-input-container { padding: 1rem; padding-top: 0; }
    .chat-input-container input { width: 100%; background: var(--bg-tertiary); border: 1px solid var(--glass-border); border-radius: 8px; padding: 0.75rem 1rem; color: var(--text-primary); font-size: 0.85rem; }
    .chat-input-container input:focus { outline: none; border-color: var(--primary-teal); }
  `]
})
export class AiChatComponent {
  private readonly aiService = inject(AiService);
  protected readonly message = signal('I rewrote your bullets and added keywords for the **Software Engineer** role at Google.');

  onAsk(query: string) {
    this.message.set('Thinking...');
    this.aiService.getSuggestions(query).subscribe(suggestions => {
      this.message.set(suggestions[0]);
    });
  }
}
