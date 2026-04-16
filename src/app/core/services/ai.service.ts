import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AiService {
  private readonly http = inject(HttpClient);

  /**
   * Mock implementation of resume section improvement.
   * In a real app, this would call an LLM API (OpenAI, Grok, etc.)
   */
  improveSection(text: string, context: string): Observable<string> {
    // Simulating API latency
    return of(this.mockImprovement(text, context)).pipe(delay(1000));
  }

  private mockImprovement(text: string, context: string): string {
    if (text.toLowerCase().includes('led the development')) {
      return 'Spearheaded the development of a high-scale cloud-native platform, achieving a 30% increase in deployment efficiency and reducing infrastructure costs by 15%.';
    }
    return text.length > 5 ? text : `Professional excellence in ${context} with a focus on metrics and results.`;
  }

  getSuggestions(resumeTitle: string): Observable<string[]> {
    return of([
      `Add keywords for ${resumeTitle} roles.`,
      'Include quantifiable metrics in your experience.',
      'Highlight specific tech stack used in your projects.'
    ]).pipe(delay(800));
  }

  /**
   * Improves resume content specifically for Europass standards.
   */
  improveForEuropass(text: string): Observable<string> {
    const prompt = EUROPASS_SYSTEM_PROMPT;
    // In a real implementation: return this.http.post<string>('/api/ai/improve', { text, prompt });
    return of(this.mockEuropassImprovement(text)).pipe(delay(1500));
  }

  private mockEuropassImprovement(text: string): string {
    return text;
  }
}

export const EUROPASS_SYSTEM_PROMPT = `
You are an expert HR consultant specializing in the European Job Market and official Europass CV standards.
Your task is to rewrite resume work experience and education descriptions into the "Europass Standard" style.

STRICT RULES:
1. USE ACTION VERBS: Start each bullet point with a strong, past-tense action verb (e.g., Developed, Orchestrated, Implemented).
2. BE CONCISE: Use short, punchy bullet points. No long paragraphs.
3. FOCUS ON ACHIEVEMENTS: Always include quantifiable results when possible (e.g., "Increased sales by 20%", "Managed a team of 10").
4. FORMAL LANGUAGE: Use British English (e.g., "Organised" instead of "Organized").
5. CEFR COMPLIANCE: When dealing with languages, strictly use A1, A2, B1, B2, C1, C2 levels.
6. NO BUZZWORDS: Avoid empty buzzwords like "Passionate" or "Hardworking". Focus on job-related skills.

OUTPUT FORMAT:
- Return only the improved text.
- Use bullet points (*) for lists.
- Keep the tone highly professional and neutral.
`;
