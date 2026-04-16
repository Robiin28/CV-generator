import { Component, inject } from '@angular/core';
import { ResumeStore } from '../builder/store/resume.store';

@Component({
  selector: 'app-preview',
  standalone: true,
  template: `
    <section class="preview-area">
      <div class="preview-header">
        <div class="ats-badge glass">
          <span class="sparkle-icon">✨</span> ATS Score: 92%
        </div>
      </div>
      
      <div 
        class="resume-sheet" 
        id="resume-sheet"
        [class]="store.selectedTemplateId()"
      >
        @if (store.selectedTemplateId() === 'euro-01') {
          <!-- Europass Specific Layout -->
          <div class="euro-layout">
            <aside class="euro-sidebar">
              <div class="euro-photo">
                <div class="photo-placeholder">
                  <span>👤</span>
                </div>
              </div>
              
              <div class="euro-side-info">
                <h3>CONTACT</h3>
                <div class="info-item">
                  <span class="icon">📍</span>
                  <p>{{ store.resume().personalInfo.location || 'Location' }}</p>
                </div>
                <div class="info-item">
                  <span class="icon">📞</span>
                  <p>{{ store.resume().personalInfo.phone || 'Phone' }}</p>
                </div>
                <div class="info-item">
                  <span class="icon">✉️</span>
                  <p>{{ store.resume().personalInfo.email || 'Email' }}</p>
                </div>
              </div>

              <div class="euro-side-info">
                <h3>SKILLS</h3>
                <div class="skills-list">
                  @for (cat of store.resume().skills; track cat.category) {
                    @for (skill of cat.skills; track skill) {
                      <div class="euro-skill">
                        <span>{{ skill }}</span>
                        <div class="skill-bar"><div class="fill" [style.width.%]="80"></div></div>
                      </div>
                    }
                  }
                </div>
              </div>
            </aside>
            
            <main class="euro-main">
              <header class="euro-header">
                <h1>{{ store.resume().personalInfo.fullName || 'Your Name' }}</h1>
                <div class="header-divider"></div>
              </header>

              @if (store.resume().summary) {
                <section class="euro-section">
                  <h2><span class="icon">📝</span> PROFESSIONAL SUMMARY</h2>
                  <p>{{ store.resume().summary }}</p>
                </section>
              }

              <section class="euro-section">
                <h2><span class="icon">💼</span> WORK EXPERIENCE</h2>
                @for (exp of store.resume().experience; track exp.id) {
                  <div class="euro-item">
                    <div class="item-meta">
                      <span class="date">{{ exp.startDate }} — {{ exp.current ? 'Present' : exp.endDate }}</span>
                      <span class="loc">{{ exp.location }}</span>
                    </div>
                    <div class="item-content">
                      <h3>{{ exp.jobTitle }}</h3>
                      <h4 class="company">{{ exp.company }}</h4>
                      <p>{{ exp.description }}</p>
                    </div>
                  </div>
                }
              </section>

              <section class="euro-section">
                <h2><span class="icon">🎓</span> EDUCATION</h2>
                @for (edu of store.resume().education; track edu.id) {
                  <div class="euro-item">
                    <div class="item-meta">
                      <span class="date">{{ edu.startDate }} — {{ edu.endDate }}</span>
                    </div>
                    <div class="item-content">
                      <h3>{{ edu.degree }}</h3>
                      <h4 class="company">{{ edu.school }}</h4>
                    </div>
                  </div>
                }
              </section>
            </main>
          </div>
        } @else {
          <!-- Default Single Column Layouts -->
          <div class="resume-header">
            <h3 class="font-display">{{ store.resume().personalInfo.fullName || 'Your Name' }}</h3>
            <p>
              {{ store.resume().personalInfo.location }} 
              @if (store.resume().personalInfo.phone) { • {{ store.resume().personalInfo.phone }} }
              @if (store.resume().personalInfo.email) { • {{ store.resume().personalInfo.email }} }
            </p>
          </div>
          
          @if (store.resume().summary) {
            <div class="resume-section">
              <h4 class="font-display">Summary</h4>
              <div class="section-line"></div>
              <p>{{ store.resume().summary }}</p>
            </div>
          }
          
          <div class="resume-section">
            <h4 class="font-display">Work Experience</h4>
            <div class="section-line"></div>
            @for (exp of store.resume().experience; track exp.id) {
              <div class="exp-item">
                <div class="exp-header">
                  <strong>{{ exp.jobTitle || 'Job Title' }}</strong>
                  <span>{{ exp.startDate }} - {{ exp.current ? 'Present' : exp.endDate }}</span>
                </div>
                <p class="company">{{ exp.company || 'Company Name' }}</p>
                <p class="description">{{ exp.description }}</p>
              </div>
            } @empty {
              <p class="empty-text">Add your experience to see it here.</p>
            }
          </div>

          <div class="resume-section">
            <h4 class="font-display">Education</h4>
            <div class="section-line"></div>
            @for (edu of store.resume().education; track edu.id) {
              <div class="exp-item">
                <div class="exp-header">
                  <strong>{{ edu.school || 'School/University' }}</strong>
                  <span>{{ edu.startDate }} - {{ edu.endDate }}</span>
                </div>
                <p class="company">{{ edu.degree }}{{ edu.fieldOfStudy ? ' in ' + edu.fieldOfStudy : '' }}</p>
              </div>
            } @empty {
              <p class="empty-text">Add your education details.</p>
            }
          </div>

          <div class="resume-section">
            <h4 class="font-display">Skills</h4>
            <div class="section-line"></div>
            <div class="skills-grid">
              @for (cat of store.resume().skills; track cat.category) {
                @for (skill of cat.skills; track skill) {
                  <span class="skill-pill">{{ skill }}</span>
                }
              } @empty {
                <p class="empty-text">Add your technical skills.</p>
              }
            </div>
          </div>
        }
      </div>
    </section>
  `,
  styles: [`
    .preview-area { padding: 2rem; height: 100%; overflow-y: auto; background: var(--bg-tertiary); display: flex; flex-direction: column; align-items: center; }
    .preview-header { width: 100%; max-width: 650px; display: flex; justify-content: flex-end; margin-bottom: 1.5rem; }
    .ats-badge { display: flex; align-items: center; gap: 0.5rem; padding: 0.5rem 1rem; border-radius: 99px; font-size: 0.8rem; font-weight: 600; }
    
    .resume-sheet {
      width: 100%;
      max-width: 800px;
      min-height: 1000px;
      background: #fff;
      color: #1a1a1a;
      border-radius: 4px;
      padding: 3rem;
      box-shadow: 0 20px 40px rgba(0,0,0,0.4);
      transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
    }

    /* --- Template: euro-01 (Modern Europass) --- */
    .euro-01 { padding: 0 !important; font-family: 'Outfit', sans-serif; display: flex; }
    .euro-layout { display: grid; grid-template-columns: 280px 1fr; min-height: 1000px; }
    
    .euro-sidebar { background: #f4f7f9; border-right: 1px solid #e1e8ed; padding: 2.5rem 1.5rem; }
    .euro-photo { width: 150px; height: 150px; margin: 0 auto 2.5rem; background: #fff; border: 4px solid #fff; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); overflow: hidden; display: flex; align-items: center; justify-content: center; }
    .photo-placeholder { font-size: 4rem; color: #cbd5e0; }
    
    .euro-side-info { margin-bottom: 2.5rem; }
    .euro-side-info h3 { font-size: 0.75rem; color: #004494; font-weight: 800; letter-spacing: 0.1em; margin-bottom: 1rem; border-bottom: 1px solid #cbd5e0; padding-bottom: 0.5rem; }
    .info-item { display: flex; gap: 0.75rem; margin-bottom: 0.75rem; align-items: flex-start; }
    .info-item .icon { font-size: 1rem; opacity: 0.7; }
    .info-item p { font-size: 0.85rem; color: #4a5568; line-height: 1.4; }
    
    .euro-skill { margin-bottom: 1rem; }
    .euro-skill span { font-size: 0.8rem; color: #2d3748; display: block; margin-bottom: 0.4rem; }
    .skill-bar { height: 6px; background: #e2e8f0; border-radius: 3px; overflow: hidden; }
    .skill-bar .fill { height: 100%; background: #004494; border-radius: 3px; }

    .euro-main { padding: 3rem; background: #fff; }
    .euro-header h1 { font-size: 2.5rem; color: #004494; font-weight: 900; line-height: 1.1; margin-bottom: 1.5rem; }
    .header-divider { height: 4px; width: 60px; background: #004494; }
    
    .euro-section { margin-top: 2.5rem; }
    .euro-section h2 { font-size: 1rem; color: #004494; font-weight: 800; display: flex; align-items: center; gap: 0.75rem; margin-bottom: 1.25rem; }
    .euro-section p { font-size: 0.95rem; line-height: 1.6; color: #2d3748; }
    
    .euro-item { display: grid; grid-template-columns: 140px 1fr; gap: 1.5rem; margin-bottom: 1.5rem; }
    .item-meta { display: flex; flex-direction: column; gap: 0.25rem; }
    .item-meta .date { font-size: 0.8rem; font-weight: 700; color: #4a5568; }
    .item-meta .loc { font-size: 0.75rem; color: #718096; }
    .item-content h3 { font-size: 1rem; font-weight: 800; color: #1a202c; }
    .item-content .company { font-size: 0.9rem; color: #004494; font-weight: 600; margin-bottom: 0.5rem; }
    .item-content p { font-size: 0.85rem; color: #4a5568; }

    /* --- Existing Templates --- */
    .modern-01 { font-family: 'Inter', sans-serif; }
    .modern-01 .resume-header { border-bottom: 3px solid #000; padding-bottom: 2rem; margin-bottom: 2rem; }
    .modern-01 .resume-header h3 { font-size: 2.5rem; letter-spacing: -0.05em; font-weight: 800; }
    .modern-01 .resume-section h4 { color: #000; font-weight: 800; border: none; font-size: 1rem; }

    .prof-01 { font-family: 'Crimson Text', serif; }
    .prof-01 .resume-header { text-align: center; border-bottom: 1px solid #ccc; }
    .prof-01 .resume-header h3 { font-family: serif; text-transform: uppercase; letter-spacing: 0.2rem; }
    .prof-01 .resume-section h4 { text-align: center; border-bottom: 2px double #999; padding-bottom: 4px; }

    /* Common Shared Styles */
    .resume-header { padding-bottom: 1.5rem; margin-bottom: 1.5rem; }
    .resume-header h3 { font-size: 2rem; margin-bottom: 0.25rem; }
    .resume-header p { color: #666; font-size: 0.9rem; }
    .resume-section { margin-bottom: 2rem; }
    .resume-section h4 { font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.1em; color: #333; margin-bottom: 0.5rem; }
    .section-line { height: 1px; background: #eee; margin-bottom: 1rem; }
    .exp-item { margin-bottom: 1.5rem; }
    .exp-header { display: flex; justify-content: space-between; margin-bottom: 0.25rem; }
    .company { font-weight: 500; color: #555; margin-bottom: 0.5rem; }
    .description { font-size: 0.85rem; color: #444; line-height: 1.5; margin-top: 0.5rem; }
    .skills-grid { display: flex; flex-wrap: wrap; gap: 0.5rem; }
    .skill-pill { background: #f0f0f0; padding: 4px 12px; border-radius: 4px; font-size: 0.8rem; font-weight: 500; color: #333; }
    .empty-text { color: #aaa; font-style: italic; font-size: 0.9rem; }
  `]
})
export class PreviewComponent {
  protected readonly store = inject(ResumeStore);
}

