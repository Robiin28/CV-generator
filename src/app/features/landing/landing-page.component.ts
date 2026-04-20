import { Component, inject, signal } from '@angular/core';
import { RouterLink } from '@angular/router';
import { ThemeService } from '../../core/services/theme.service';

@Component({
  selector: 'app-landing-page',
  standalone: true,
  imports: [RouterLink],
  template: `
    <div class="landing-container">
      <!-- Visual Background Texture -->
      <div class="dot-grid"></div>

      <!-- HERO SECTION -->
      <section class="hero-section fade-in">
        <h1 class="hero-title font-display">
          Land Your Next Role 3x Faster with <br>
          <span class="gradient-teal">ResumeForge AI</span>
        </h1>
        <p class="hero-subtitle">
          Build a professional, ATS-optimized resume in minutes. Choose from elegant templates,
          fill in your details, and export a polished PDF — no design skills needed.
        </p>
        
        <div class="hero-actions">
          <button class="btn-primary" routerLink="/builder">Build Your Resume — It's Free</button>
          <button class="btn-secondary" routerLink="/templates">Explore Templates</button>
        </div>

        <div class="hero-preview">
          <div class="preview-browser-bar">
            <span class="dot red"></span>
            <span class="dot yellow"></span>
            <span class="dot green"></span>
            <div class="url-bar">resumeforge.ai/builder</div>
          </div>
          <div class="preview-body">
            <!-- LEFT: App Sidebar Mock -->
            <div class="preview-sidebar">
              <div class="ps-logo"></div>
              <div class="ps-nav-item active"></div>
              <div class="ps-nav-item"></div>
              <div class="ps-nav-item"></div>
              <div class="ps-nav-item"></div>
            </div>
            <!-- CENTER: Form Panel -->
            <div class="preview-form">
              <div class="pf-section-label"></div>
              <div class="pf-input"></div>
              <div class="pf-input short"></div>
              <div class="pf-section-label" style="margin-top: 1rem"></div>
              <div class="pf-input"></div>
              <div class="pf-input mid"></div>
              <div class="pf-input"></div>
              <div class="pf-section-label" style="margin-top: 1rem"></div>
              <div class="pf-input"></div>
              <div class="pf-input short"></div>
              <div class="pf-input mid"></div>
              <div class="pf-input"></div>
            </div>
            <!-- RIGHT: Resume Preview -->
            <div class="preview-cv">
              <div class="cv-name-block"></div>
              <div class="cv-subtitle-block"></div>
              <div class="cv-contact-row">
                <div class="cv-dot"></div>
                <div class="cv-dot"></div>
                <div class="cv-dot"></div>
              </div>
              <div class="cv-divider"></div>
              <div class="cv-section-head"></div>
              <div class="cv-line long"></div>
              <div class="cv-line mid"></div>
              <div class="cv-line short"></div>
              <div class="cv-line mid"></div>
              <div class="cv-section-head" style="margin-top:0.75rem"></div>
              <div class="cv-line long"></div>
              <div class="cv-line mid"></div>
              <div class="cv-line short"></div>
              <div class="cv-section-head" style="margin-top:0.75rem"></div>
              <div class="cv-line long"></div>
              <div class="cv-line mid"></div>
            </div>
          </div>
        </div>
      </section>

      <!-- FEATURES HIGHLIGHTS BAR -->
      <section class="metrics-bar">
        <div class="metrics-inner">
          <div class="metric-item">
            <div class="metric-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"></path></svg></div>
            <div class="metric-text">
              <span class="metric-value">ATS Optimized</span>
              <span class="metric-label">Industry Standard Templates</span>
            </div>
          </div>
          <div class="metric-divider"></div>
          <div class="metric-item">
            <div class="metric-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg></div>
            <div class="metric-text">
              <span class="metric-value">PDF Engine</span>
              <span class="metric-label">High-Fidelity Exports</span>
            </div>
          </div>
          <div class="metric-divider"></div>
          <div class="metric-item">
            <div class="metric-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2L2 7l10 5 10-5-10-5z"></path><path d="M12 22V12"></path><path d="M2 17l10 5 10-5"></path></svg></div>
            <div class="metric-text">
              <span class="metric-value">AI writing</span>
              <span class="metric-label">Professional Case Study</span>
            </div>
          </div>
        </div>
      </section>

      <!-- HOW IT WORKS -->
      <section class="narrative-section" id="features">
        <div class="narrative-content">
          <h2 class="section-tag">What We Offer</h2>
          <h3 class="narrative-title">A smarter way to build your resume.</h3>
          <p class="narrative-text">
            ResumeForge combines clean, professional templates with AI-assisted writing tools.
            Focus on your experience — we handle the formatting, structure, and export.
          </p>
        </div>
      </section>

      <!-- HOW IT WORKS -->
      <section class="workflow-section">
        <div class="narrative-content">
          <h2 class="section-tag centered">The Process</h2>
          <h3 class="narrative-title centered">Create your resume in <span class="gradient-teal">3 simple steps</span></h3>
        </div>
        <div class="workflow-grid">
          <div class="workflow-step-card">
            <div class="step-badge">01</div>
            <h4>Choose Template</h4>
            <p>Pick from a curated set of clean, professional templates designed for maximum ATS performance.</p>
          </div>
          <div class="workflow-step-card">
            <div class="step-badge">02</div>
            <h4>Fill Details</h4>
            <p>Use our guided builder to add your data. Our AI helps you craft high-impact bullet points instantly.</p>
          </div>
          <div class="workflow-step-card">
            <div class="step-badge">03</div>
            <h4>Export & Apply</h4>
            <p>Download your polished, multi-page PDF with a single click. No design skills or tools required.</p>
          </div>
        </div>
      </section>

      <section class="pricing-section" id="pricing">
        <div class="pricing-header section-fade-in">
          <h2 class="section-tag">Flexible Pricing</h2>
          <h3 class="narrative-title">Simple, transparent, <span class="gradient-teal">built for you</span>.</h3>
        </div>
        
        <div class="pricing-grid">
          <!-- CARD 1 -->
          <div class="pricing-card card">
            <div class="p-tier">Standard</div>
            <div class="p-price">$0 <span>/ life</span></div>
            <p class="p-desc">Perfect for a quick, professional resume to get you started.</p>
            <ul class="p-features">
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Official Europass Layout</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Clean modern format</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> ATS-compatible structure</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Standard PDF Export</li>
            </ul>
            <button class="btn-card-secondary" routerLink="/builder">Get Started</button>
          </div>

          <!-- CARD 2 (POPULAR) -->
          <div class="pricing-card card popular">
            <div class="popular-tag">Most Popular</div>
            <div class="p-tier">Pro AI</div>
            <div class="p-price">Free <span>Beta</span></div>
            <p class="p-desc">Unlock full AI potential with predictive writing and live previews.</p>
            <ul class="p-features">
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Step-by-step form wizard</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Premium AI suggestions</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Multi-page PDF Export</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> One-click PDF export</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Priority AI Processing</li>
            </ul>
            <button class="btn-saas-primary" style="width: 100%" routerLink="/builder">Get Started</button>
          </div>

          <!-- CARD 3 -->
          <div class="pricing-card card">
            <div class="p-tier">Elite</div>
            <div class="p-price">Soon <span>/ pro</span></div>
            <p class="p-desc">Custom branding and multiple resume versions for power users.</p>
            <ul class="p-features">
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Unlimited Resumes</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Custom Templates</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Career Dashboard</li>
              <li><svg class="check" viewBox="0 0 24 24"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg> Priority Support</li>
            </ul>
            <button class="btn-card-secondary" routerLink="/register">Join Waitlist</button>
          </div>
        </div>
      </section>

      <!-- FAQ SECTION -->
      <section class="faq-section" id="faq">
        <div class="narrative-content">
          <h2 class="section-tag">Common Questions</h2>
          <h3 class="narrative-title">What you need to know</h3>
          
          <div class="faq-grid">
            <div class="faq-card glass">
              <div class="faq-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"></path><line x1="12" y1="17" x2="12.01" y2="17"></line></svg></div>
              <div class="faq-content">
                <h4>Is the CV builder really free?</h4>
                <p>Yes. You can build and preview your resume completely free. Sign up to save your progress and export to PDF.</p>
              </div>
            </div>
            <div class="faq-card glass">
              <div class="faq-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg></div>
              <div class="faq-content">
                <h4>Are the templates ATS-friendly?</h4>
                <p>Yes. Our templates use clean, structured formatting that is readable by Applicant Tracking Systems used by major employers.</p>
              </div>
            </div>
            <div class="faq-card glass">
              <div class="faq-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg></div>
              <div class="faq-content">
                <h4>Can I export my resume as a PDF?</h4>
                <p>Absolutely. Once you're done, export a high-quality PDF directly from the builder with a single click.</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <footer class="footer">
        <div class="footer-grid">
          <div class="footer-brand">
            <div class="brand">
              <div class="logo-box font-display">RF</div>
              <span class="logo-text font-display">ResumeForge</span>
            </div>
            <p>A free, open-source CV builder. Build your resume in minutes and export a polished PDF.</p>
          </div>
          <div class="footer-links">
            <div class="link-group">
              <h5>Product</h5>
              <a routerLink="/templates">Templates</a>
              <a routerLink="/builder">AI Builder</a>
              <a href="#faq">FAQ</a>
            </div>
            <div class="link-group">
              <h5>Account</h5>
              <a routerLink="/login">Log In</a>
              <a routerLink="/register">Sign Up</a>
            </div>
          </div>
        </div>
        <div class="footer-bottom">
          <p>&copy; 2026 ResumeForge. Professional Resume Intelligence.</p>
        </div>
      </footer>
    </div>
  `,
  styleUrls: ['./landing-page.component.css']
})
export class LandingPageComponent {
  protected readonly theme = inject(ThemeService);
  protected readonly isMenuOpen = signal(false);

  toggleMenu() { this.isMenuOpen.set(!this.isMenuOpen()); }
}
